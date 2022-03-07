#!/usr/bin/env bash

rootdir="$( cd -P "${BATS_TEST_DIRNAME}/../.." && echo "$PWD" )"
bin="${rootdir}/bin"

p() {
  while read -r line; do
    printf "# %s\n" "${line}" >&3
  done <<< "${@}"
}

condition() {
  if bash -c "$@" ; then
    return 0
  else
    return 1
  fi
}

assert_dir_exist() {
  [[ -d "$1" ]]
}

refute_dir_exist() {
  ! assert_dir_exist "$1"
}

assert_file_exist() {
  [[ -f "$1" ]]
}

refute_file_exist() {
  ! assert_file_exist "$1"
}

