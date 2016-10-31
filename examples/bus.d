import kaleidic.nanomsg.bindings;
import std.stdio;
import std.datetime;
import std.conv;
import core.thread;
import std.string:toStringz;


int node (string[] argv)
{
  int sock = nn_socket (AF_SP, NN_BUS);
  assert (sock >= 0);
  assert (nn_bind (sock, argv[2].toStringz) >= 0);
  Thread.sleep( dur!("seconds")( 1 ) ); // wait for connections
  if (argv.length>=3)
    {
      foreach(x; 3..argv.length)
        assert (nn_connect (sock, argv[x].toStringz) >= 0);
    }
  Thread.sleep( dur!("seconds")( 1 ) ); // wait for connections
  int to = 100;
  assert (nn_setsockopt (sock, NN_SOL_SOCKET, NN.RCVTIMEO, &to, to.sizeof) >= 0);
  // SEND
  int sz_n = cast(int)argv[1].length+1; // '\0' too
  writefln("%s: SENDING '%s' ONTO BUS", argv[1], argv[2]);
  int send = nn_send (sock, argv[1].toStringz, sz_n, 0);
  assert (send == sz_n);
  while (1)
    {
      // RECV
      char* buf = cast(char*)0;
      int recv = nn_recv (sock, &buf, NN_MSG, 0);
      if (recv >= 0)
        {
          writefln("%s: RECEIVED '%s' FROM BUS",argv[1],buf.to!string);
          nn_freemsg (buf);
        }
    }
  return nn_shutdown (sock, 0);
}

string tostring(char* buf) // weird behaviour so broke this out to a function
{
  return to!string(buf);
}
int main (string[] argv)
{
  if (argv.length>= 3) node(argv);
  else
    {
      writefln("Usage: bus <NODE_NAME> <URL> <URL> ...");
      return 1;
    }
  return 0;
}
