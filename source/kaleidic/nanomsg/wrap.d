module kaleidic.nanomsg.wrap;
import kaleidic.nanomsg.bindings;

import std.stdio;
import std.conv;
import std.string;

enum NanoSocketOptions
{
    linger = NN.LINGER,
    sendBuffer = NN.SNDBUF,
    receiveBuffer = NN.RCVBUF,
    sendTimeOut = NN.SNDTIMEO,
    receiveTimeOut = NN.RCVTIMEO,
    reconnectInterval = NN.RECONNECT_IVL,
    reconnectIntervalMax = NN.RECONNECT_IVL_MAX,
    sendPriority = NN.SNDPRIO,
    receivePriority = NN.RCVPRIO,
    receiveFD = NN.RCVFD,
    domain = NN.DOMAIN,
    protocol = NN.PROTOCOL,
    ip4Only = NN.IPV4ONLY,
    socketName = NN.SOCKET_NAME,
    receiveMaxSize = NN.RCVMAXSIZE,
}

struct NanoMessage
{
    // default constructor no longer allowed
    // so this() must always be called with specific
    // arguments.  defaults used to be:
    // param1=AF_SP, param2=NN_REP
    // probably better this way anyway

    char *url;
    int sock=-1;
    char* buf = null;
    bool isShutDown=true;
    int eid=-1;

    @disable this(this);

    void createSocket(int param1,int param2)
    {
        import std.exception:enforce;
        this.sock = nn_socket(param1,param2);
        enforce(sock >= 0,"cannot create nanomsg socket for modes "~ to!string(param1) ~ " "~ to!string(param2)~"\n"~errorMessage()~"\n");
        isShutDown = false;
    }

    ~this()
    {
        import std.stdio;

        writefln("nanomsg destructor running!!!");
        /*
        if (!isShutDown)
            this.shutdown(); */
        if(sock>-1)
            nn_close(sock);
        sock=-1;
        eid=-1;
    }
}

string errorMessage()
{
    return nn_strerror(nn_errno()).fromStringz.idup;
}

auto surl(ref NanoMessage nano)
{
    return nano.url.fromStringz;
}

auto ref bind(ref NanoMessage nano, string surl)
{
    writefln("* binding to: %s",surl);
    nano.open(surl,true);
    return nano;
}
auto ref connect(ref NanoMessage nano, string surl)
{
    nano.open(surl,false);
    return nano;
}

auto ref open(ref NanoMessage nano,string surl, bool bind=true)
{
    import std.exception:enforce;
    enforce(nano.sock>=0,"cannot create nanomsg socket for "~surl~": "~errorMessage());
    if (bind)
        nano.eid = nn_bind(nano.sock,toStringz(surl));
    else
        nano.eid = nn_connect(nano.sock,toStringz(surl));
    writefln("* eid = %s for %s to: %s",nano.eid,bind?"bind":"connect",surl);
    enforce(nano.eid >= 0,"nanomsg did not " ~ (bind?"bind":"connect")~" to new socket for "~surl~": "~errorMessage());
    return nano;
}
ubyte[] receive(ref NanoMessage nano, int flags, bool pubsub=false)
{
    ubyte[] recvbytes;
    nano.buf=null;
    //consider returning as sized array without copy
    auto numbytes = nn_recv(nano.sock,&nano.buf,NN_MSG,flags);
    scope(exit)
    {
        if(nano.buf !is null)
            nn_freemsg(nano.buf);
        nano.buf=null;
    }
    if (numbytes >= 0)
    {
        recvbytes.length=numbytes+1;
        foreach(i;0..numbytes)
        {
            recvbytes[i]=nano.buf[i];
        }
        return recvbytes;
    }
    else
    {
        if(pubsub)
            return [];  // TO DO FIX ME - distinguish between error and no message for me
        else
            throw new Exception("nanomsg encountered an error whilst trying to receive a message for "~to!string(nano.url) ~ " error:"~ errorMessage());
    }
    assert(0);
}

string receiveAsString(ref NanoMessage nano, int flags=0, bool pubSub=false)
{
    return to!string(cast(char[])nano.receive(flags,pubSub));
}

int send(ref NanoMessage nano, char* mybuf, size_t numbytes, bool nonBlocking=false)
{
    return nn_send(nano.sock,mybuf,numbytes,nonBlocking?NN_DONTWAIT:0).errcheck("send(char*)");
}

int send(ref NanoMessage nano, ubyte[] mybuf, bool nonBlocking=false)
{
    return nn_send(nano.sock,cast(char*)mybuf.ptr,cast(int)(mybuf.length),nonBlocking?NN_DONTWAIT:0).errcheck("send(ubyte[])");
}

int send(ref NanoMessage nano, string mybuf, bool nonBlocking=false)
{
    return nn_send(nano.sock,mybuf.ptr,mybuf.length+1,nonBlocking?NN_DONTWAIT:0).errcheck("send(string mybuf)");
}

auto ref setOpt(ref NanoMessage nano,int level, int option, string stringVal)
{
    nn_setsockopt(nano.sock,level,option,stringVal.toStringz,stringVal.length);
    return nano;
}

auto ref setOpt(T)(ref NanoMessage nano, int level, int option, T* optval)
{
    nn_setsockopt(nano.sock,level,option,optval,(optval).size);
    return nano;
}

auto ref getOpt(ref NanoMessage nano, int level, int option, void* optval, size_t *optvallen)
{
    nn_getsockopt(nano.sock,level,option,optval,optvallen);
    return nano;
}
auto ref close(ref NanoMessage nano)
{
    if(nano.sock!=-1)
        errcheck(nn_close(nano.sock),"close()");
    nano.sock=-1;
    nano.eid=-1;
    return nano;
}

int sendMessage(ref NanoMessage nano,const nn_msghdr* msghdr, int flags)
{
    return nn_sendmsg(nano.sock,msghdr,flags);
}

int receiveMessage(ref NanoMessage nano, nn_msghdr* msghdr, int flags)
{
    return nn_recvmsg(nano.sock,msghdr,flags).errcheck("receiveMessage");
}

bool canReceive(ref NanoMessage nano)
{
    nn_pollfd  pfd;
    pfd.fd = nano.sock;
    pfd.events = NN_POLLIN | NN_POLLOUT;
    auto rc = nn_poll(&pfd, 1, 100);
    return false;
//      if (res==-1)
   //     throw new Exception("unable to check socket readiness status - res=" ~ to!string(res) ~ "errno=" ~ to!string(nn_errno()));
//    writefln("* returning can rx: %s", pfd.revents);
//    return (pfd.revents & NN_POLLIN)!=0;
}

bool canSend(ref NanoMessage nano)
{
    import std.exception:enforce;
    nn_pollfd pfd;
    pfd.fd=nano.sock;
    pfd.events=NN_POLLOUT;
    auto res=nn_poll(&pfd,1,2000);
    enforce(res!=-1,"nanomsg: unable to check socket readiness status- "~errorMessage());
    return(pfd.revents&& NN_POLLOUT)!=0;
}

void freeMessage(ref NanoMessage nano)
{
    if (nano.buf)
        nn_freemsg(nano.buf);
    nano.buf=null;
}

auto ref shutdown(ref NanoMessage nano)
{
    if (nano.buf)
        nn_freemsg(nano.buf);

    if(nano.eid>-1)
    {
        auto ret=nn_shutdown(nano.sock,nano.eid); // we should check this value and throw exception if need be
    }
    nano.eid=-1;
    nano.sock=-1;
    nano.isShutDown=true;
    return nano;
}

private int errcheck(int retval, string caller="")
{
    import std.exception:enforce;
    enforce(retval!=-1,"nanomsg error"~caller~": " ~ errorMessage());
    return retval;
}
