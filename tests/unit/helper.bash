#!/usr/bin/env bash

for lib in support assert; do
  load $(brew --prefix bats-$lib)/lib/bats-$lib/load.bash
done

rootdir="$( cd -P "${BATS_TEST_DIRNAME}/../.." && echo "$PWD" )"

load "${rootdir}/tests/helper.bash"
