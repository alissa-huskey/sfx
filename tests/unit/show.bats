#!/usr/bin/env bats

load 'helper'

load ${rootdir}/bin/utils.sh
load ${rootdir}/bin/fx-show

@test "print_rgb R G B" {
  run print_rgb 255 255 255

  assert_success
  assert_output --partial "38;2;255;255;255;m255 255 255"
  refute_output --partial "[7m"
}

@test "print_rgb -i R G B" {
  run print_rgb -i 255 255 255

  assert_success
  assert_output --partial "38;2;255;255;255;m255 255 255"
  assert_output --partial "[7m"
}

@test "print_rgb R G B TITLE" {
  verbose=true
  run print_rgb 255 255 255 white

  assert_success
  assert_output --partial "38;2;255;255;255;mwhite"
}

