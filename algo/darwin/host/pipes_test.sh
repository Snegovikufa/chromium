#! /usr/bin/env sh

while true
do
  read -p 'Please input a line of text: ' input
  echo ${input} > ./out/in_pipe
  echo 'Read from out_pipe: '
  cat ./out/out_pipe
  echo
  echo
done
