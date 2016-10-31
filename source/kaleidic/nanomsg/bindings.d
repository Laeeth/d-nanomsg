module kaleidic.nanomsg.bindings;


/**
    Ported to Dlang (2014,2015,2016) by Laeeth Isharc.  Caveat emptor.
*/

extern(C) @system nothrow @nogc align(1):

enum PROTO_SP = 1;
enum SP_HDR = 1;
enum NN_H_INCLUDED = 1;

/******************************************************************************/
/*  ABI versioning support.                                                   */
/******************************************************************************/

/*  Don't change this unless you know exactly what you're doing and have      */
/*  read and understand the following documents:                              */
/*  www.gnu.org/software/libtool/manual/html_node/Libtool-versioning.html     */
/*  www.gnu.org/software/libtool/manual/html_node/Updating-version-info.html  */

/*  The current interface version. */
enum
{
    NN_VERSION_CURRENT = 5,
    NN_VERSION_REVISION = 0,
    NN_VERSION_AGE = 0,
}

/******************************************************************************/
/*  Errors.                                                                   */
/******************************************************************************/

/*  A number random enough not to collide with different errno ranges on      */
/*  different OSes. The assumption is that error_t is at least 32-bit type.   */
enum
{

    NN_HAUSNUMERO=156384712,

    /*  On some platforms some standard POSIX errnos are not defined.    */
    ENOTSUP=(NN_HAUSNUMERO + 1),
    EPROTONOSUPPORT =(NN_HAUSNUMERO + 2),
    ENOBUFS =(NN_HAUSNUMERO + 3),
    ENETDOWN =(NN_HAUSNUMERO + 4),
    EADDRINUSE =(NN_HAUSNUMERO + 5),
    EADDRNOTAVAIL =(NN_HAUSNUMERO + 6),
    ECONNREFUSED =(NN_HAUSNUMERO + 7),
    EINPROGRESS =(NN_HAUSNUMERO + 8),
    ENOTSOCK =(NN_HAUSNUMERO + 9),
    EAFNOSUPPORT =(NN_HAUSNUMERO + 10),
    EPROTO =(NN_HAUSNUMERO + 11),
    EAGAIN =(NN_HAUSNUMERO + 12),
    EBADF =(NN_HAUSNUMERO + 13),
    EINVAL= (NN_HAUSNUMERO + 14),
    EMFILE =(NN_HAUSNUMERO + 15),
    EFAULT =(NN_HAUSNUMERO + 16),
    EACCESS =(NN_HAUSNUMERO + 17),
    ENETRESET =(NN_HAUSNUMERO + 18),
    ENETUNREACH =(NN_HAUSNUMERO + 19),
    EHOSTUNREACH= (NN_HAUSNUMERO + 20),
    ENOTCONN =(NN_HAUSNUMERO + 21),
    EMSGSIZE= (NN_HAUSNUMERO + 22),
    ETIMEDOUT= (NN_HAUSNUMERO + 23),
    ECONNABORTED= (NN_HAUSNUMERO + 24),
    ECONNRESET =(NN_HAUSNUMERO + 25),
    ENOPROTOOPT =(NN_HAUSNUMERO + 26),
    EISCONN =(NN_HAUSNUMERO + 27),
    NN_EISCONN_DEFINED=1,
    ESOCKTNOSUPPORT =(NN_HAUSNUMERO + 28),
    ETERM =(NN_HAUSNUMERO + 53),
    EFSM =(NN_HAUSNUMERO + 54),
}

/**
    This function retrieves the errno as it is known to the library.
     The goal of this function is to make the code 100% portable, including
    where the library is compiled with certain CRT library (on Windows) and
    linked to an application that uses different CRT library.

    Returns: the errno as it is known to the library
*/
extern (C) int nn_errno();

/**  Resolves system errors and native errors to human-readable string.
    Returns: const(char)* human-readable string
*/
extern (C) const(char)* nn_strerror (int errnum);


/**
    Returns the symbol name (e.g. "NN_REQ") and value at a specified index.
    If the index is out-of-range, returns 0 and sets errno to EINVAL
    General usage is to start at i=0 and iterate until 0 is returned.

    Params:
            i = index
            v = pointer to value

    Returns: symbol name eg "NN_REQ" and value at a specified index
*/
extern (C) char *nn_symbol (int i, int *value);

/*  Constants that are returned in `ns` member of nn_symbol_properties        */
enum NN_NS
{
    NAMESPACE =0,
    VERSION =1,
    DOMAIN =2,
    TRANSPORT= 3,
    PROTOCOL =4,
    OPTION_LEVEL= 5,
    SOCKET_OPTION= 6,
    TRANSPORT_OPTION =7,
    OPTION_TYPE =8,
    OPTION_UNIT =9,
    FLAG =10,
    ERROR =11,
    LIMIT=12,
    EVENT=13,
}
enum NN_NS_NAMESPACE = NN_NS.NAMESPACE;
enum NN_NS_VERSION = NN_NS.VERSION;
enum NN_NS_DOMAIN = NN_NS.DOMAIN;
enum NN_NS_TRANSPORT = NN_NS.TRANSPORT;
enum NN_NS_PROTOCOL = NN_NS.PROTOCOL;
enum NN_NS_OPTION_LEVEL = NN_NS.OPTION_LEVEL;
enum NN_NS_SOCKET_OPTION = NN_NS.SOCKET_OPTION;
enum NN_NS_TRANSPORT_OPTION = NN_NS.TRANSPORT_OPTION;
enum NN_NS_OPTION_TYPE = NN_NS.OPTION_TYPE;
enum NN_NS_OPTION_UNIT = NN_NS.OPTION_UNIT;
enum NN_NS_FLAG = NN_NS.FLAG;
enum NN_NS_ERROR = NN_NS.ERROR;
enum NN_NS_LIMIT = NN_NS.LIMIT;
enum NN_NS_EVENT = NN_NS.EVENT;


/**  Constants that are returned in `ns` member of nn_symbol_properties        */
enum NN_TYPE
{
    NONE=0,
    INT=1,
    STR=2,
}

enum NN_TYPE_NONE = NN_TYPE.NONE;
enum NN_TYPE_INT = NN_TYPE.INT;
enum NN_TYPE_STR = NN_TYPE.STR;

/**  Constants that are returned in `ns` member of nn_symbol_properties        */
enum NN_UNIT
{
    NONE =0,
    BYTES =1,
    MILLISECONDS =2,
    PRIORITY =3,
    BOOLEAN =4,
}
enum NN_UNIT_NONE = NN_UNIT.NONE;
enum NN_UNIT_BYTES = NN_UNIT.BYTES;
enum NN_UNIT_MILLISECONDS = NN_UNIT.MILLISECONDS;
enum NN_UNIT_PRIORITY = NN_UNIT.PRIORITY;
enum NN_UNIT_BOOLEAN = NN_UNIT.BOOLEAN;

/*  Structure that is returned from nn_symbol  */
align(1) struct nn_symbol_properties
{
    /*  The constant value  */
    int value;
    /*  The constant name  */
    const(char)* name;
    /*  The constant namespace, or zero for namespaces themselves */
    int ns;
    /*  The option type for socket option constants  */
    int type;
    /*  The unit for the option value for socket option constants  */
    int unit;
}

/*  Fills in nn_symbol_properties structure and returns it's length           */
/*  If the index is out-of-range, returns 0                                   */
/*  General usage is to start at i=0 and iterate until zero is returned.      */
extern (C) int nn_symbol_info (int i, nn_symbol_properties* buf, int buflen);

/******************************************************************************/
/*  Helper function for shutting down multi-threaded applications.            */
/******************************************************************************/
extern (C) void nn_term ();


/******************************************************************************/
/*  Zero-copy support.                                                        */
/******************************************************************************/

enum NN_MSG= cast(size_t)-1;
extern (C) void *nn_allocmsg (size_t size, int type);
extern (C) void *nn_reallocmsg (void* msg, size_t size);
extern (C) int nn_freemsg (void* msg);

/******************************************************************************/
/*  Socket definition.                                                        */
/******************************************************************************/
align(1) struct nn_iovec
{
    void* iov_base;
    size_t iov_len;
}

align(1) struct nn_msghdr
{
    nn_iovec* msg_iov;
    int msg_iovlen;
    void* msg_control;
    size_t msg_controllen;
}

align(1) struct nn_cmsghdr
{
    size_t cmsg_len;
    int cmsg_level;
    int cmsg_type;
}

/** Internal function. Not to be used directly.
    Use NN_CMSG_NEXTHDR macro instead.
*/
extern (C)  nn_cmsghdr* nn_cmsg_nexthdr_ (const(nn_msghdr)* mhdr,const(nn_cmsghdr)* cmsg);
alias NN_CMSG_ALIGN_ = (len) => (len + size_t.sizeof - 1) & cast(size_t) ~(size_t.sizeof - 1);

/* POSIX-defined msghdr manipulation. */

alias NN_CMSG_FIRSTHDR = (mhdr) => nn_cmsg_nxthdr_ (cast(nn_msghdr*) mhdr, null);

alias NN_CMSG_NXTHDR = (mhdr, cmsg) => nn_cmsg_nxthdr_ (cast(nn_msghdr*) mhdr, cast(nn_cmsghdr*) cmsg);

alias NN_CMSG_DATA = (cmsg) => cast(ubyte*) ((cast(nn_cmsghdr*) cmsg) + 1);

/* Extensions to POSIX defined by RFC 3542.                                   */

alias NN_CMSG_SPACE = (len) => (NN_CMSG_ALIGN_ (len) + NN_CMSG_ALIGN_ (nn_cmsghdr.sizeof));

alias NN_CMSG_LEN = (len) => (NN_CMSG_ALIGN_ (nn_cmsghdr.sizeof) + (len));


/*  SP address families.                                                      */
enum AF_SP = 1;
enum AF_SP_RAW = 2;

/*  Max size of an SP address.                                                */
enum NN_SOCKADDR_MAX =128;

/*  Socket option levels: Negative numbers are reserved for transports,
    positive for socket types. */
enum NN_SOL_SOCKET =0;

/*  Generic socket options (NN_SOL_SOCKET level).                             */
enum NN
{
    LINGER=1,
    SNDBUF =2,
    RCVBUF =3,
    SNDTIMEO =4,
    RCVTIMEO =5,
    RECONNECT_IVL= 6,
    RECONNECT_IVL_MAX =7,
    SNDPRIO =8,
    RCVPRIO= 9,
    SNDFD=10,
    RCVFD =11,
    DOMAIN =12,
    PROTOCOL =13,
    IPV4ONLY =14,
    SOCKET_NAME=15,
    RCVMAXSIZE=16,
}
enum NN_LINGER = NN.LINGER;
enum NN_SNDBUF = NN.SNDBUF;
enum NN_RCVBUF = NN.RCVBUF;
enum NN_SNDTIMEO = NN.SNDTIMEO;
enum NN_RCVTIMEO = NN.RCVTIMEO;
enum NN_RECONNECT_IVL = NN.RECONNECT_IVL;
enum NN_RECONNECT_IVL_MAX = NN.RECONNECT_IVL_MAX;
enum NN_SNDPRIO = NN.SNDPRIO;
enum NN_RCVPRIO = NN.RCVPRIO;
enum NN_SNDFD = NN.SNDFD;
enum NN_RCVFD = NN.RCVFD;
enum NN_DOMAIN = NN.DOMAIN;
enum NN_PROTOCOL = NN.PROTOCOL;
enum NN_IPV4ONLY = NN.IPV4ONLY;
enum NN_SOCKET_NAME = NN.SOCKET_NAME;
enum NN_RCVMAXSIZE = NN.RCVMAXSIZE;

/*  Send/recv options.                                                        */
enum NN_DONTWAIT =1;


extern (C) int nn_socket(int domain, int protocol);
extern (C) int nn_close(int s);
extern (C) int nn_setsockopt(int s, int level, int option, const(void)* optval,size_t optvallen);
extern (C) int nn_getsockopt(int s, int level, int option, void* optval,size_t* optvallen);
extern (C) int nn_bind(int s, const(char)* addr);
extern (C) int nn_connect(int s, const(char)* addr);
extern (C) int nn_shutdown(int s, int how);
extern (C) int nn_send(int s, const(void)* buf, size_t len, int flags);
extern (C) int nn_recv(int s, void* buf, size_t len, int flags);
extern (C) int nn_sendmsg(int s, nn_msghdr* msghdr, int flags);
extern (C) int nn_sendmsg(int s, const(nn_msghdr)* msghdr, int flags);
extern (C) int nn_recvmsg(int s,  nn_msghdr* msghdr, int flags);


/******************************************************************************/
/*  Socket multiplexing support.                                              */
/******************************************************************************/

enum NN_POLLIN  = 1;
enum NN_POLLOUT = 2;

align(1) struct nn_pollfd
{
    int fd;
    short events;
    short revents;
}

extern(C) int nn_poll(nn_pollfd* fds, int nfds, int timeout);

/******************************************************************************/
/*  Built-in support for devices.                                             */
/******************************************************************************/

extern(C) int nn_device(int s1, int s2);

/******************************************************************************/
/*  Built-in support for multiplexers.                                        */
/******************************************************************************/

/******************************************************************************/
/*  Built-in support for devices.                                             */
/******************************************************************************/

extern(C) int nn_tcpmuxd (int port);


enum PAIR_H_INCLUDED=1;

/**
    PAIR
*/
enum NN_PROTO_PAIR=1;
enum NN_PAIR=(NN_PROTO_PAIR * 16 + 0);

enum PIPELINE_H_INCLUDED=1;

/**
    PIPELINE
*/
enum NN_PROTO_PIPELINE=5;
enum NN_PUSH=(NN_PROTO_PIPELINE * 16 + 0);
enum NN_PULL=(NN_PROTO_PIPELINE * 16 + 1);



enum NN_PROTOCOL_INCLUDED=1;
struct nn_ctx;
enum NN_PIPE
{
    RELEASE=1,
    PARSED=2,
    IN=33987,
    OUT=33988,
}
struct nn_pipe;
struct nn_msg;

extern(C)
{
    void nn_pipe_setdata ( nn_pipe *self, void *data);
    void *nn_pipe_getdata (nn_pipe *self);
    int nn_pipe_send(nn_pipe *self,  nn_msg *msg);
    int nn_pipe_recv ( nn_pipe *self, nn_msg *msg);
    void nn_pipe_getopt ( nn_pipe *self, int level, int option,void *optval, size_t *optvallen);
}


/******************************************************************************/
/*  Base class for all socket types.                                          */
/******************************************************************************/

/*  Any combination of these events can be returned from 'events' virtual
    function. */
enum  NN_SOCKBASE_EVENT_IN=1;
enum NN_SOCKBASE_EVENT_OUT=2;

/*  To be implemented by individual socket types. */
align(1) struct nn_sockbase_vfptr
{
    extern(C) void function(nn_sockbase*) stop;
    extern(C) void function(nn_sockbase*) destroy;
    extern(C) int function(nn_sockbase*,nn_pipe*) add;
    extern(C) void function(nn_sockbase*, nn_pipe*) rm;
    extern(C) void function(nn_sockbase*, nn_pipe*) in_;
    extern(C) void function(nn_sockbase*, nn_pipe*) out_;
    extern(C) int function(nn_sockbase*) events;
    extern(C) int function(nn_sockbase*, nn_msg*) send;
    extern(C) int function(nn_sockbase*, nn_msg*) recv;
    extern(C) int function(nn_sockbase*, int level, int option,const void* optval, size_t optvallen) setopt;
    extern(C) int function(nn_sockbase*, int level, int option,void* optval, size_t *optvallen) getopt;
}

struct nn_sockbase
{
    const(nn_sockbase_vfptr)* vfptr;
     nn_sock *sock;
}

/*  Initialise the socket base class. 'hint' is the opaque value passed to the
    nn_transport's 'create' function. */
extern(C) void nn_sockbase_init ( nn_sockbase *self,const  nn_sockbase_vfptr *vfptr, void *hint);

/*  Terminate the socket base class. */
extern(C) void nn_sockbase_term ( nn_sockbase *self);

/*  Call this function when stopping is done. */
extern(C) void nn_sockbase_stopped ( nn_sockbase *self);

/*  Returns the AIO context associated with the socket. This function is
    useful when socket type implementation needs to create async objects,
    such as timers. */
extern(C) nn_ctx *nn_sockbase_getctx ( nn_sockbase *self);

/*  Retrieve a NN_SOL_SOCKET-level option. */
extern(C) int nn_sockbase_getopt (nn_sockbase* self, int option, void* optval, size_t *optvallen);

/*  Add some statitistics for socket  */
extern(C) void nn_sockbase_stat_increment (nn_sockbase* self, int name,int increment);

enum NN_STAT_CURRENT_SND_PRIORITY=401;

/******************************************************************************/
/*  The socktype class.                                                       */
/******************************************************************************/

/*  This structure defines a class factory for individual socket types. */

/*  Specifies that the socket type can be never used to receive messages. */
enum NN_SOCKTYPE_FLAG_NORECV=1;

/*  Specifies that the socket type can be never used to send messages. */
enum NN_SOCKTYPE_FLAG_NOSEND=2;

struct nn_socktype {
    int domain;
    int protocol;
    int flags;
    int function(void *hint, nn_sockbase **sockbase) create;
    int function(int socktype) ispeer;
    nn_list_item* item;
};


/**
    PUBSUB
*/
enum NN_PROTO_PUBSUB=2;
enum NN_PUB=NN_PROTO_PUBSUB * 16 + 0;
enum NN_SUB=NN_PROTO_PUBSUB * 16 + 1;
enum NN_SUB_SUBSCRIBE =1;
enum NN_SUB_UNSUBSCRIBE=2;


/**
    BUS
*/
enum NN_PROTO_BUS=7;
enum NN_BUS=(NN_PROTO_BUS * 16 + 0);

/**
    INPROC
*/
enum NN_INPROC=-1;

/**
    IPC
*/

enum NN_IPC=-2;


/**
    REQREP
*/
enum REQREP_H_INCLUDED=1;
enum NN_PROTO_REQREP = 3;

enum NN_REQ=NN_PROTO_REQREP * 16 + 0;
enum NN_REP=NN_PROTO_REQREP * 16 + 1;

enum NN_REQ_RESEND_IVL=1;

align(1) union nn_req_handle
{
    int i;
    void *ptr;
};

extern(C) int nn_req_send (int s, nn_req_handle hndl, const(void)* buf, size_t len, int flags);
extern(C) int nn_req_recv (int s, nn_req_handle *hndl, void *buf, size_t len, int flags);


/**
    TCPMUX
*/
enum NN_TCPMUX = -5;
enum NN_TCPMUX_NODELAY = 1;

/**
    WS
*/
enum NN_WS = -4;

/*  NN_WS level socket/cmsg options.  Note that only NN_WSMG_TYPE_TEXT and
    NN_WS_MSG_TYPE_BINARY messages are supported fully by this implementation.
    Attempting to set other message types is undefined.  */
enum NN_WS_MSG_TYPE = 1;

/*  WebSocket opcode constants as per RFC 6455 5.2  */
enum NN_WS_MSG_TYPE_TEXT = 0x01;
enum NN_WS_MSG_TYPE_BINARY = 0x02;

/**
    SURVEY
*/


enum SURVEY_H_INCLUDED=1;
enum NN_PROTO_SURVEY=6;

enum NN_SURVEYOR=(NN_PROTO_SURVEY * 16 + 2);
enum NN_RESPONDENT=(NN_PROTO_SURVEY * 16 + 3);

enum NN_SURVEYOR_DEADLINE=1;
enum TCP_H_INCLUDED=1;
enum NN_TCP=-3;
enum NN_TCP_NODELAY=1;
struct nn_sock;
struct nn_cp;
struct nn_ep;

struct nn_optset_vfptr
{
    extern (C) void function(nn_optset *self) destroy;
    extern (C) int function(nn_optset *self, int option, const(void)* optval,size_t optvallen) setopt;
    extern (C) int function(nn_optset *self, int option, void *optval,size_t *optvallen) getopt;
}

struct nn_optset
{
    const(nn_optset_vfptr)* vfptr;
};


struct nn_epbase_vfptr
{
    extern (C) void function(nn_epbase *) stop;
    extern (C) void function(nn_epbase *) destroy;
}

struct nn_epbase
{
    const(nn_epbase_vfptr)* vfptr;
     nn_ep *ep;
}

/*  Creates a new endpoint. 'hint' parameter is an opaque value that
    was passed to transport's bind or connect function. */

extern(C) void nn_epbase_init ( nn_epbase *self,const  nn_epbase_vfptr *vfptr, void *hint);
extern(C) void nn_epbase_stopped ( nn_epbase *self);
extern(C) void nn_epbase_term (nn_epbase *self);
extern(C) nn_ctx *nn_epbase_getctx ( nn_epbase *self);
extern(C) char *nn_epbase_getaddr ( nn_epbase *self);
extern(C) void nn_epbase_getopt ( nn_epbase *self, int level, int option,void *optval, size_t *optvallen);
extern(C) int nn_epbase_ispeer ( nn_epbase *self, int socktype);
extern(C) void nn_epbase_set_error( nn_epbase *self, int errnum);
extern(C) void nn_epbase_clear_error( nn_epbase *self);
extern(C) void nn_epbase_stat_increment(nn_epbase *self, int name, int increment);


enum NN_STAT
{
    ESTABLISHED_CONNECTIONS=101,
    ACCEPTED_CONNECTIONS    =102,
    DROPPED_CONNECTIONS     =103,
    BROKEN_CONNECTIONS      =104,
    CONNECT_ERRORS          =105,
    BIND_ERRORS             =106,
    ACCEPT_ERRORS           =107,
    CURRENT_CONNECTIONS     =201,
    INPROGRESS_CONNECTIONS  =202,
    CURRENT_EP_ERRORS       =203,
}

enum NN_PIPE_RELEASE=1;
enum NN_PIPE_PARSED=2;
enum NN_PIPE_IN=33987;
enum NN_PIPE_OUT=33988;

enum NN_PIPEBASE
{
    RELEASE=1,
    PARSED=2,
}

align(1) struct nn_pipebase_vfptr
{
    alias _send=extern(C) int function(nn_pipebase* self, nn_msg* msg);
    alias _recv=extern(C) int function(nn_pipebase* self,  nn_msg* msg);
    _send send;
    _recv recv;
}


align(1) struct nn_ep_options
{
    int sndprio;
    int rcvprio;
    int ipv4only;
}

align(1) struct nn_pipebase
{
    nn_fsm fsm;
    const nn_pipebase_vfptr* vfptr;
    ubyte state;
    ubyte instate;
    ubyte outstate;
    nn_sock *sock;
    void *data;
    nn_fsm_event IN;
    nn_fsm_event OUT;
    nn_ep_options options;
}

extern(C) void nn_pipebase_init (nn_pipebase*,const(nn_pipebase_vfptr)* vfptr, nn_epbase* epbase);
extern(C) void nn_pipebase_term ( nn_pipebase*);
extern(C) int nn_pipebase_start ( nn_pipebase*);
extern(C) void nn_pipebase_stop ( nn_pipebase*);
extern(C) void nn_pipebase_received ( nn_pipebase*);
extern(C) void nn_pipebase_sent ( nn_pipebase*);
extern(C) void nn_pipebase_getopt ( nn_pipebase* , int level, int option,void *optval, size_t *optvallen);
extern(C) int nn_pipebase_ispeer ( nn_pipebase*, int socktype);
extern(C) void nn_pipe_setdata(nn_pipe *self, void *data);
extern(C) void *nn_pipe_getdata ( nn_pipe *self);
extern(C) int nn_pipe_send ( nn_pipe *self, nn_msg *msg);
extern(C) int nn_pipe_recv ( nn_pipe *self, nn_msg *msg);
extern(C) void nn_pipe_getopt (nn_pipe *self, int level, int option, void *optval, size_t *optvallen);


align(1) struct nn_transport
{
    const(char*) name;
    int id;
    extern(C) void function() init;
    extern(C) void function() term;
    extern(C) int function(void *hint, nn_epbase **epbase) bind;
    extern(C) int function(void *hint,  nn_epbase **epbase) connect;
    extern(C) nn_optset* function() optset;
    nn_list_item item;
}

enum NN_FSM_INCLUDED=1;

align(1) struct nn_worker;

align(1) struct nn_fsm_event
{
    nn_fsm* fsm;
    int src;
    void* srcptr;
    int type;
    nn_queue_item item;
}


extern(C) void nn_fsm_event_init(nn_fsm_event *self);
extern(C) void nn_fsm_event_term(nn_fsm_event *self);
extern(C) int nn_fsm_event_active(nn_fsm_event *self);
extern(C) void nn_fsm_event_process(nn_fsm_event *self);


/*  Special source for actions. It's negative not to clash with user-defined
    sources. */
enum NN_FSM_ACTION =-2;

/*  Actions generated by fsm object. The values are negative not to clash
    with user-defined actions. */
enum NN_FSM_START=-2;
enum NN_FSM_STOP =-3;

/*  Virtual function to be implemented by the derived class to handle the
    incoming events. */
alias nn_fsm_fn = extern(C) void function(nn_fsm*, int, int, void*);

align(1) struct nn_fsm_owner
{
    int src;
    nn_fsm *fsm;
}

align(1) struct nn_fsm
{
    nn_fsm_fn fn;
    nn_fsm_fn shutdown_fn;
    int state;
    int src;
    void *srcptr;
    nn_fsm *owner;
    nn_ctx *ctx;
    nn_fsm_event stopped;
}


extern(C) void nn_fsm_init_root(nn_fsm *self, nn_fsm_fn fn,nn_fsm_fn shutdown_fn, nn_ctx* ctx);
extern(C) void nn_fsm_init(nn_fsm *, nn_fsm_fn fn,nn_fsm_fn shutdown_fn,int src, void *srcptr, nn_fsm* owner);
extern(C) void nn_fsm_term(nn_fsm *);
extern(C) int nn_fsm_isidle(nn_fsm *);
extern(C) void nn_fsm_start(nn_fsm *);
extern(C) void nn_fsm_stop(nn_fsm *);
extern(C) void nn_fsm_stopped(nn_fsm*, int type);
extern(C) void nn_fsm_stopped_noevent(nn_fsm*);
extern(C) void nn_fsm_swap_owner(nn_fsm*, nn_fsm_owner* owner);
extern(C) nn_worker* nn_fsm_choose_worker(nn_fsm*);
extern(C) void nn_fsm_action(nn_fsm*, int type);
extern(C) void nn_fsm_raise(nn_fsm*, nn_fsm_event* event, int type);
extern(C) void nn_fsm_raiseto(nn_fsm*, nn_fsm* dst, nn_fsm_event* event, int src, int type, void *srcptr);
extern(C) void nn_fsm_feed(nn_fsm*, int src, int type, void* srcptr);


enum NN_LIST_INCLUDED=1;

align(1) struct nn_list_item
{
    nn_list_item* next;
    nn_list_item* prev;
}

align(1) struct nn_list
{
    nn_list_item* first;
    nn_list_item* last;
};

/*  Undefined value for initializing a list item which is not part of a list. */
enum NN_LIST_NOTINLIST = cast(const(nn_list_item)*)-1;

/*  Use for initializing a list item statically. */
immutable typeof(NN_LIST_NOTINLIST)[2] NN_LIST_ITEM_INITIALIZER=[NN_LIST_NOTINLIST, NN_LIST_NOTINLIST];


/*  Initialise the list. */

extern(C) void nn_list_init(nn_list*);
extern(C) void nn_list_term(nn_list*);
extern(C) int nn_list_empty(nn_list*);
extern(C) nn_list_item* nn_list_begin(nn_list*);
extern(C) nn_list_item* nn_list_end(nn_list*);
extern(C) nn_list_item *nn_list_prev(nn_list*,nn_list_item*);
extern(C) nn_list_item *nn_list_next(nn_list*,nn_list_item*);
extern(C) void nn_list_insert(nn_list*, nn_list_item*, nn_list_item*);
extern(C) nn_list_item* nn_list_erase(nn_list*,nn_list_item*);
extern(C) void nn_list_item_init(nn_list_item*);
extern(C) void nn_list_item_term(nn_list_item*);
extern(C) int nn_list_item_isinlist(nn_list_item*);


enum NN_QUEUE_INCLUDED = 1;

/*  Undefined value for initialising a queue item which is not
    part of a queue. */
const(nn_queue_item)* NN_QUEUE_NOTINQUEUE=cast(const(nn_queue_item)*) -1;


/+
/*  Use for initialising a queue item statically. */
auto NN_QUEUE_ITEM_INITIALIZER()
{
    return [NN_LIST_NOTINQUEUE];
}
+/

align(1) struct nn_queue_item
{
    nn_queue_item *next;
}

align(1) struct nn_queue
{
    nn_queue_item *head;
    nn_queue_item *tail;
}

extern(C) void nn_queue_init(nn_queue*);
extern(C) void nn_queue_term(nn_queue*);
extern(C) int nn_queue_empty(nn_queue*);
extern(C) void nn_queue_push(nn_queue*, nn_queue_item*);
extern(C) nn_queue_item *nn_queue_pop( nn_queue*);
extern(C) void nn_queue_item_init(nn_queue_item*);
extern(C) void nn_queue_item_term(nn_queue_item*);
extern(C) int nn_queue_item_isinqueue(nn_queue_item*);



/*  Returns the symbol name (e.g. "NN_REQ") and value at a specified index.   */
/*  If the index is out-of-range, returns null and sets errno to EINVAL       */
/*  General usage is to start at i=0 and iterate until null is returned.      */
extern(C) const(char)* nn_symbol (int i, int *value);


/*  Associates opaque pointer to protocol-specific data with the pipe. */
extern(C) void nn_pipe_setdata (nn_pipe *self, void *data);

/*  Retrieves the opaque pointer associated with the pipe. */
extern(C) void *nn_pipe_getdata (nn_pipe* self);

/*  Send the message to the pipe. If successful, pipe takes ownership of the
    messages. */
extern(C) int nn_pipe_send (nn_pipe* self, nn_msg* msg);

/*  Receive a message from a pipe. 'msg' should not be initialised prior to
    the call. It will be initialised when the call succeeds. */
extern(C) int nn_pipe_recv (nn_pipe* self, nn_msg* msg);

/*  Get option for pipe. Mostly useful for endpoint-specific options  */
extern(C) void nn_pipe_getopt (nn_pipe* self, int level, int option, void* optval, size_t* optvallen);


/******************************************************************************/
/*  Base class for all socket types.                                          */
/******************************************************************************/

/*  Initialise the socket base class. 'hint' is the opaque value passed to the
    nn_transport's 'create' function. */
extern(C) void nn_sockbase_init (nn_sockbase* self, const(nn_sockbase_vfptr)* vfptr, void* hint);

/*  Terminate the socket base class. */
extern(C) void nn_sockbase_term (nn_sockbase* self);

/*  Call this function when stopping is done. */
extern(C) void nn_sockbase_stopped (nn_sockbase* self);

/*  Returns the AIO context associated with the socket. This function is
    useful when socket type implementation needs to create async objects,
    such as timers. */
extern(C) nn_ctx *nn_sockbase_getctx (nn_sockbase *self);

/*  Retrieve a NN_SOL_SOCKET-level option. */
extern(C) int nn_sockbase_getopt (nn_sockbase *self, int option, void *optval, size_t *optvallen);

/*  Add some statistics for socket  */
extern(C) void nn_sockbase_stat_increment (nn_sockbase *self, int name, int increment);

/*  Creates a new endpoint. 'hint' parameter is an opaque value that
    was passed to transport's bind or connect function. */
extern(C) void nn_epbase_init (nn_epbase* self, const(nn_epbase_vfptr)* vfptr, void *hint);

/*  Notify the user that stopping is done. */
extern(C) void nn_epbase_stopped (nn_epbase* self);

/*  Terminate the epbase object. */
extern(C) void nn_epbase_term (nn_epbase* self);

/*  Returns the AIO context associated with the endpoint. */
extern(C) nn_ctx *nn_epbase_getctx (nn_epbase* self);

/*  Returns the address string associated with this endpoint. */
extern(C) const(char*) nn_epbase_getaddr (nn_epbase* self);

/*  Retrieve value of a socket option. */
extern(C) void nn_epbase_getopt (nn_epbase* self, int level, int option, void *optval, size_t *optvallen);

/*  Returns 1 is the specified socket type is a valid peer for this socket,
    or 0 otherwise. */
extern(C) int nn_epbase_ispeer (nn_epbase* self, int socktype);

/*  Notifies a monitoring system the error on this endpoint  */
extern(C) void nn_epbase_set_error(nn_epbase* self, int errnum);

/*  Notifies a monitoring system that error is gone  */
extern(C) void nn_epbase_clear_error(nn_epbase* self);

/*  Increments statistics counters in the socket structure  */
extern(C) void nn_epbase_stat_increment(nn_epbase* self, int name, int increment);


enum NN_STAT_ESTABLISHED_CONNECTIONS =101;
enum NN_STAT_ACCEPTED_CONNECTIONS    =102;
enum NN_STAT_DROPPED_CONNECTIONS     =103;
enum NN_STAT_BROKEN_CONNECTIONS      =104;
enum NN_STAT_CONNECT_ERRORS          =105;
enum NN_STAT_BIND_ERRORS             =106;
enum NN_STAT_ACCEPT_ERRORS           =107;

enum NN_STAT_CURRENT_CONNECTIONS     =201;
enum NN_STAT_INPROGRESS_CONNECTIONS  =202;
enum NN_STAT_CURRENT_EP_ERRORS       =203;


/******************************************************************************/
/*  The base class for pipes.                                                 */
/******************************************************************************/

/*  Pipe represents one "connection", i.e. perfectly ordered uni- or
    bi-directional stream of messages. One endpoint can create multiple pipes
    (for example, bound TCP socket is an endpoint, individual accepted TCP
    connections are represented by pipes. */


/*  This value is returned by pipe's send and recv functions to signalise that
    more sends/recvs are not possible at the moment. From that moment on,
    the core will stop invoking the function. To re-establish the message
    flow nn_pipebase_received (respectively nn_pipebase_sent) should
    be called. */
enum NN_PIPEBASE_RELEASE=1;

/*  Specifies that received message is already split into header and body.
    This flag is used only by inproc transport to avoid merging and re-splitting
    the messages passed with a single process. */
enum NN_PIPEBASE_PARSED=2;

/*  Initialise the pipe.  */
extern(C) void nn_pipebase_init (nn_pipebase *self, const(nn_pipebase_vfptr)* vfptr, nn_epbase *epbase);

/*  Terminate the pipe. */
extern(C) void nn_pipebase_term (nn_pipebase *self);

/*  Call this function once the connection is established. */
extern(C) int nn_pipebase_start (nn_pipebase *self);

/*  Call this function once the connection is broken. */
extern(C) void nn_pipebase_stop (nn_pipebase *self);

/*  Call this function when new message was fully received. */
extern(C) void nn_pipebase_received (nn_pipebase *self);

/*  Call this function when current outgoing message was fully sent. */
extern(C) void nn_pipebase_sent (nn_pipebase *self);

/*  Retrieve value of a socket option. */
extern(C) void nn_pipebase_getopt (nn_pipebase *self, int level, int option, void *optval, size_t *optvallen);

/*  Returns 1 is the specified socket type is a valid peer for this socket,
    or 0 otherwise. */
extern(C) int nn_pipebase_ispeer (nn_pipebase *self, int socktype);


/*
    Copyright (c) 2012-2014 250bpm s.r.o.  All rights reserved.
    Copyright (c) 2013 GoPivotal, Inc.  All rights reserved.

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"),
    to deal in the Software without restriction, including without limitation
    the rights to use, copy, modify, merge, publish, distribute, sublicense,
    and/or sell copies of the Software, and to permit persons to whom
    the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included
    in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
    THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
    FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
    IN THE SOFTWARE.
*/
