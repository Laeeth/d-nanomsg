import kaleidic.nanomsg.nano;
import std.stdio;
import std.conv;
import std.string:toStringz;

enum NODE0 ="node0";
enum NODE1 ="node1";

int node0 (string xurl)
{
  int sock = nn_socket (AF_SP, NN_PULL);
  auto url=xurl.toStringz;
  assert(sock >= 0);
  assert(nn_bind (sock, url) >= 0);
  while (1)
    {
      char* buf = cast(char*)0;
      int bytes = nn_recv (sock, &buf, NN_MSG, 0);
      assert (bytes >= 0);
      writefln("NODE0: RECEIVED %s bytes: \"%s\"", bytes,to!string(buf));
      nn_freemsg (buf);
    }
    return 0;
}

int node1 (string url, string msg)
{
  int sz_msg = cast(int)msg.length + 1; // '\0' too
  int sock = nn_socket (AF_SP, NN_PUSH);
  assert(sock >= 0);
  assert(nn_connect(sock, url.toStringz) >= 0);
  writefln("NODE1: SENDING \"%s\"", msg);
  int bytes = nn_send(sock, msg.toStringz, sz_msg, 0);
  assert(bytes == sz_msg);
  return nn_shutdown(sock, 0);
}

int main (string[] argv)
{
  if (argv.length>1)
  {
    if (NODE0==argv[1])
      return node0(argv[2]);
    else if (argv.length>2)
      if (NODE1==argv[1])
        return node1(argv[2], argv[3]);
  } else
  {
    writefln("Usage: pipeline %s|%s <URL> <ARG> ...'",NODE0, NODE1);
    return 1;
  }
  return 0;
}
