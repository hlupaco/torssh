#!/bin/bash

#$1 ... 'user@host'

prepare_only=""
while getopts ':p' opt ; do
  case "${opt}" in
    p)
      prepare_only="y"
      ;;
    \?)
      echo "Wrong option: ${opt}"
      exit 1
      ;;
  esac
done

shift $((OPTIND-1))

if [ "$#" -lt 1 ] ; then
  echo "Usage: $0 -p options user@host commands"
fi

temp_fp=$(mktemp)

arg_act="$1"
ssh_opts=""

while echo "${arg_act}" | grep -v '@' ; do
  ssh_opts+="${arg_act} "
  shift
  arg_act="$1"
done

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

if [ "${prepare_only}" = "y" ] ; then
  echo "${temp_fp}"
  exit 0
fi

eval "ssh -F ${temp_fp} ${ssh_opts} ${user}@torhost $@"

rm "${temp_fp}"
