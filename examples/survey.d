import std.stdio;
import std.datetime;
import std.conv;
import core.thread;
import nano;
import std.string:toStringz;

enum SERVER ="server";
enum CLIENT ="client";
enum DATE  = "DATE";

string date ()
{
  return Clock.currTime.toSimpleString();
}

int server (string surl)
{
  auto url=surl.toStringz;
  int sock = nn_socket (AF_SP, NN_SURVEYOR);
  assert (sock >= 0);
  assert (nn_bind (sock, url) >= 0);
  Thread.sleep( dur!("seconds")( 1 ) ); // wait for connections
  int sz_d = cast(int)DATE.length+1;
  writefln("SERVER: SENDING DATE SURVEY REQUEST");
  int bytes = nn_send (sock, DATE.toStringz, sz_d, 0);
  assert (bytes == sz_d);
  while (1)
    {
      char *buf = cast(char*)0;
      int nubytes = nn_recv (sock, &buf, NN_MSG, 0);
      if (nubytes == ETIMEDOUT) break;
      if (nubytes >= 0)
      {
        writefln("SERVER: RECEIVED \"%s\" SURVEY RESPONSE", to!string(buf));
        nn_freemsg (buf);
      }
    }
  return nn_shutdown (sock, 0);
}

int client(string surl,string sname)
{
  auto url=surl.toStringz;
  auto name=sname.toStringz;
  int sock = nn_socket (AF_SP, NN_RESPONDENT);
  assert (sock >= 0);
  assert (nn_connect (sock, url) >= 0);
  while (1)
    {
      char *buf = cast(char*)0;
      int bytes = nn_recv (sock, &buf, NN_MSG, 0);
      if (bytes >= 0)
        {
          writefln("CLIENT (%s): RECEIVED \"%s\" SURVEY REQUEST", to!string(name), to!string(buf));
          nn_freemsg (buf);
          string d = date();
          int sz_d = cast(int)d.length+1;
          writefln("CLIENT (%s): SENDING DATE SURVEY RESPONSE", to!string(name));
          int nubytes = nn_send (sock, d.toStringz, sz_d, 0);
          assert (nubytes == sz_d);
        }
    }
  return nn_shutdown (sock, 0);
}

int main (string[] argv)
{
  if (argv.length>=2)
    if (argv[1]==SERVER)
      return server (argv[2]);
  if (argv.length>=3)
    if (argv[1]==CLIENT)
      return client(argv[2], argv[3]);
  writefln("Usage: survey %s|%s <URL> <ARG> ...",SERVER, CLIENT);
  return 1;
}
