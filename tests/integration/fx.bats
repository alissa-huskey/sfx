#!/usr/bin/env bats

load 'helper'

@test "fx" {
  run ${bin}/fx -v

  assert_success
  assert_output --regexp "debug>.* cmd: list"
}

@test "fx list" {
  run ${bin}/fx list -v --help

  assert_success
  assert_line --regexp "debug>.* cmd: list"
  assert_line --partial "fx list -- list styles and colors"
}

@test "fx get" {
  run ${bin}/fx get -v --help

  assert_success
  assert_line --regexp "debug>.* cmd: get"
  assert_line --partial "fx get -- get the true color for a 256 color"
}

@test "fx show" {
  run ${bin}/fx show -v --help

  assert_success
  assert_line --regexp "debug>.* cmd: show"
  assert_line --partial "fx show -- show a color or style"
}

@test "fx convert" {
  run ${bin}/fx convert -v --help

  assert_success
  assert_line --regexp "debug>.* cmd: convert"
  assert_line --partial "fx convert -- convert different color formats"
}

@test "fx --help" {
  run ${bin}/fx --help

  assert_success
  assert_output --partial "fx -- a simple utility to print available styles and colors"
}

@test "fx --version" {
  run ${bin}/fx --version

  assert_success
  assert_output --regexp "fx version [0-9]+[.][0-9]+[.][0-9]+"
}
