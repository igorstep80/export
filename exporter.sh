#!/bin/bash
list="b07 b08"
ip=$(/sbin/ip -o -4 addr list eno1 | awk '{print $4}' | cut -d/ -f1)
for word in $list; do # <-- $list is not in double quotes
  docker stop e$word $word
  docker rm   e$word $word
  sh run_$word.sh
  if [[ "$word" =~ ^s ]]; then port=96${word:(-2)};fi
  if [[ "$word" =~ ^a ]]; then port=97${word:(-2)};fi
  if [[ "$word" =~ ^b ]]; then port=98${word:(-2)};fi
  docker run -d --restart unless-stopped --link=$word --name=e$word -p $ip:$port:9651 -e STORJ_HOST_ADDRESS=$word anclrii/storj-exporter:1.0.13
done
