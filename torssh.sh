#!/bin/bash

#$1 ... 'user@host'

if [ "$#" -lt 1 ] ; then
  echo "Usage: $0 user@host commands"
fi

temp_fp=$(mktemp)

user=$(echo "$1" | cut -d'@' -f1)
host=$(echo "$1" | cut -d'@' -f2 | cut -d' ' -f1)
shift

echo '
Host torhost
  HostName '"${host}"'
  CheckHostIP no
  Compression yes
  Protocol 2
  ProxyCommand connect -4 -S localhost:9050 $(tor-resolve %h localhost:9050) %p
' > ${temp_fp}

eval "ssh -F ${temp_fp} ${user}@torhost $@"

rm "${temp_fp}"
