import std.stdio;
import std.datetime;
import core.thread;
import nano;
import std.string:toStringz;

enum SERVER ="server";
enum CLIENT ="client";

string date ()
{
  return Clock.currTime.toSimpleString();
}

int server (string surl)
{
  auto url=surl.toStringz;
  int sock = nn_socket (AF_SP, NN_PUB);
  assert (sock >= 0);
  assert (nn_bind (sock, url) >= 0);
  while (1)
  {
      auto d = date();
      int sz_d = cast(int)d.length+1;
      writefln("SERVER: PUBLISHING DATE %s", d);
      int bytes = nn_send(sock, d.toStringz, sz_d, 0);
      assert (bytes == sz_d);
      Thread.sleep( dur!("seconds")( 1 ) );
  }
  return nn_shutdown (sock, 0);
}

int client (string surl, string sname)
{
  auto url=surl.toStringz;
  auto name=sname.toStringz;
  int sock = nn_socket (AF_SP, NN_SUB);
  assert (sock >= 0);
  // TODO learn more about publishing/subscribe keys
  assert (nn_setsockopt(sock, NN_SUB, NN_SUB_SUBSCRIBE, "".toStringz, 0) >= 0);
  assert (nn_connect (sock, url) >= 0);
  while (1)
    {
      char *buf = cast(char*)0;
      int bytes = nn_recv (sock, &buf, NN_MSG, 0);
      assert (bytes >= 0);
      printf ("CLIENT (%s): RECEIVED %s\n", name, buf);
      nn_freemsg (buf);
    }
  return nn_shutdown (sock, 0);
}

int main (string[] argv)
{
  if (argv.length>=2)
    if (SERVER==argv[1])
      return server (argv[2]);
  if (argv.length>=3)
    if (CLIENT==argv[1])
      return client (argv[2], argv[3]);
  writefln("Usage: pubsub %s|%s <URL> <ARG> ...",SERVER, CLIENT);
  return 1;
}
