import std.stdio;
import core.thread;
import std.conv;
import kaleidic.nanomsg.nano;

enum NODE0 ="node0";
enum NODE1 ="node1";

int send_name(int sock, string name)
{
  writefln("%s: SENDING \"%s\"\n", name, name);
  int sz_n = cast(int)name.length+ 1; // '\0' too
  return nn_send (sock, cast(char*)name, sz_n, 0);
}

int recv_name(int sock, string name)
{
  char *buf = cast(char*)0;
  int result = nn_recv (sock, &buf, NN_MSG, 0);
  if (result > 0)
    {
      writefln("%s: RECEIVED \"%s\"\n", name, to!string(buf));
      nn_freemsg (buf);
    }
  return result;
}

void send_recv(int sock, string name)
{
  int to = 100;
  assert (nn_setsockopt (sock, NN_SOL_SOCKET, NN.RCVTIMEO, &to, to.sizeof) >= 0);
  while(1)
    {
      recv_name(sock, name);
      Thread.sleep( dur!("seconds")( 1 ) );
      send_name(sock, name);
    }
}

int node0(string url)
{
  int sock = nn_socket (AF_SP, NN_PAIR);
  assert (sock >= 0);
  assert (nn_bind (sock,cast(char*) url) >= 0);
  send_recv(sock, NODE0);
  return nn_shutdown (sock, 0);
}

int node1(string url)
{
  int sock = nn_socket (AF_SP, NN_PAIR);
  assert (sock >= 0);
  assert (nn_connect (sock, cast(char*)url) >= 0);
  send_recv(sock, NODE1);
  return nn_shutdown (sock, 0);
}

int main(string[] argv)
{
  if (argv.length>1)
    if (NODE0==argv[1])
      return node0(argv[2]);
  if (argv.length>1)
    if (NODE1==argv[1])
      return node1(argv[2]);
  writefln("Usage: pair %s|%s <URL> <ARG> ...",NODE0, NODE1);
  return 1;
}