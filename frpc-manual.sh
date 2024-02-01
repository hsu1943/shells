#!/bin/bash

FRPC_HOME="/usr/local/frp/frpc"
client="$FRPC_HOME/frpc"
conf="$FRPC_HOME/frpc.toml"
log="$FRPC_HOME/logs"

if [ "$1" = "start" ];then
  nohup $client -c $conf > "$log/nohup_frpc.log" 2>&1 &
  echo "frpc start success"
elif [ "$1" = "status" ];then
   ps aux | grep frpc |  grep -v grep | grep -v $1
   echo "frpc status success"
elif [ "$1" = "reload" ];then
  echo "frpc" `$client reload -c $conf`
elif [ "$1" = "restart" ];then
  ps aux | grep frpc | grep -v grep | grep -v $1 | awk '{print $2}' | xargs kill -9
  nohup $client -c $conf > "$log/nohup_frpc.log" 2>&1 &
  echo "frpc restart success"
elif [ "$1" = "stop" ];then
  ps aux | grep frpc | grep -v grep | grep -v $1 | awk '{print $2}' | xargs kill -9
  echo "frpc stop success"
else
  other_commands="$client $@"
  $other_commands
fi