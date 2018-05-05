# DISCLAIMER
I write this script with pure intentions where some services could be blocking you from connecting after a lot of administration work due to a large number of connection, which is damn annoying.
This happens to me commonly when administering AWS instances and running scripts on them.

This utility is NOT meant to be used for any kind of abuse or exploit and I reject having any responsibility should you decide to do so.

# torssh
SSH to host over tor in case of badly set spam detector

Script workflow:

1) First create a temporary tor config in a tempfile

2) Call ssh with specifying that tempfile

Tor config contains:
```
Host tor
  HostName _host_
  CheckHostIP no
  Compression yes
  Protocol 2
  ProxyCommand connect -4 -S localhost:9050 $(tor-resolve %h localhost:9050) %p
```
