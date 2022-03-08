#!/usr/bin/env bash

main() {
  local args reply

  export PAGER=cat

  for args in --help "" 16 styles 256 "256 --bg" all; do
    clear
    echo fx-list ${args}
    hr

    fx-list ${args}
    read -p "Press any key to continue." -r reply

    [[ $reply == "q" ]] && exit
  done
}

main
