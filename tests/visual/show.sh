#!/usr/bin/env bash

main() {
  local args reply

  todo=( \
    "--help" \
    "--rgb 255 255 255" \
    "--color cyan" \
    "--style bold" \
    "--8 5" \
    "--16 12" \
    "--256 11" \
    "--hex 005fff" \
    "--code 31" \
  )

  for args in "${todo[@]}"; do
    clear
    echo fx-show ${args}
    hr

    fx-show ${args}

    hr -
    read -p "Press any key to continue." -r reply

    [[ $reply == "q" ]] && exit
  done
}

main

