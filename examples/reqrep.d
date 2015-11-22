import std.stdio;
import std.conv;
import std.datetime;
import core.thread;
import nano;

string date ()
{
  return Clock.currTime.toSimpleString();
}

enum NODE0="node0";
enum NODE1="node1";
enum DATE="DATE";

int node0(string surl)
{
  char* url=cast(char*)surl;
  int sz_date = cast(int)DATE.length+1;
  int sock = nn_socket (AF_SP, NN_REP);
  assert (sock >= 0);
  assert (nn_bind (sock, url) >= 0);
  while (1)
    {
      char *buf = cast(char*)0;
      int bytes = nn_recv(sock, &buf, NN_MSG, 0);
      assert (bytes >= 0);
      if (to!string(buf)==DATE)
      {
          writefln("NODE0: RECEIVED DATE REQUEST");
          auto d=date();
          int sz_d = cast(int)d.length + 1; // '\0' too
          writefln("NODE0: SENDING DATE %s", d);
          bytes = nn_send (sock, cast(char*)d, sz_d, 0);
          assert (bytes == sz_d);
        }
      nn_freemsg (buf);
    }
  return nn_shutdown (sock, 0);
}


int node1 (string url)
{
  int sz_date = cast(int)DATE.length+1;
  char *buf = cast(char*)0;
  int bytes = -1;
  int sock = nn_socket (AF_SP, NN_REQ);
  assert (sock >= 0);
  assert (nn_connect (sock, cast(char*)url) >= 0);
  writefln("NODE1: SENDING DATE REQUEST %s", DATE);
  bytes = nn_send (sock, cast(char*)DATE, sz_date, 0);
  assert (bytes == sz_date);
  bytes = nn_recv (sock, &buf, NN_MSG, 0);
  assert (bytes >= 0);
  writefln("NODE1: RECEIVED DATE %s", to!string(buf), bytes);
  nn_freemsg (buf);
  return nn_shutdown (sock, 0);
}

 
int main(string[] argv)
{
  if (argv.length>1)
    if (argv[1]==NODE0)
      return node0(argv[2]);
  if (argv.length>1)
      if (argv[1]==NODE1)
        return node1(argv[2]);
   writefln("Usage: reqrep %s|%s <URL> <ARG> ...'",NODE0, NODE1);
   return 1;
}

