#!/usr/bin/env bats

load 'helper'

@test "fx-list 16" {
  run ${bindir}/fx-list 16
  assert_success
  assert_output --partial "[yellow: 33]"

  refute_output --partial "[bold:1]"
  refute_output --partial "[7;38;5;255m255"
  refute_output --partial "[0;38;5;255m255"
}

@test "fx-list 256" {
  run ${bindir}/fx-list 256

  assert_success
  assert_output --partial "[0;38;5;255m255"

  refute_output --partial "[yellow: 33]"
  refute_output --partial "[bold:1]"
  refute_output --partial "[7;38;5;255m255"
}

@test "fx-list 256" {
  run ${bindir}/fx-list 256 --fg

  assert_success
  assert_output --partial "[0;38;5;255m255"

  refute_output --partial "[yellow: 33]"
  refute_output --partial "[bold:1]"
  refute_output --partial "[7;38;5;255m255"
}

@test "fx-list 256 --bg" {
  run ${bindir}/fx-list 256 --bg

  assert_success
  assert_output --partial "[7;38;5;249m249"

  refute_output --partial "[yellow: 33]"
  refute_output --partial "[bold:1]"
}

@test "fx-list styles" {
  run ${bindir}/fx-list styles

  assert_success
  assert_output --partial "[bold:1]"

  refute_output --partial "[0;38;5;255m255"
  refute_output --partial "[yellow: 33]"
  refute_output --partial "[7;38;5;255m255"
}

@test "fx-list all" {
  run ${bindir}/fx-list all

  assert_success
  assert_output --partial "[bold:1]"
  assert_output --partial "[0;38;5;255m255"
  assert_output --partial "[yellow: 33]"
  assert_output --partial "[7;38;5;255m255"
}

@test "fx-list --verbose" {
  run ${bindir}/fx-list --verbose

  assert_success
  assert_output --regexp "debug>.* colors_256()"
  assert_output --partial "[0;38;5;255m255"
}

@test "fx-list --verbose CMD" {
  run ${bindir}/fx-list --verbose 256

  assert_success
  assert_output --regexp "debug>.* colors_256()"
  assert_output --partial "[0;38;5;255m255"
}

@test "fx-list CMD --verbose" {
  run ${bindir}/fx-list 256 --verbose

  assert_success
  assert_output --regexp "debug>.* colors_256()"
  assert_output --partial "[0;38;5;255m255"
}

@test "fx-list --help" {
  run ${bindir}/fx-list --help

  assert_success
  assert_output --partial "fx list -- list styles and colors"
}

@test "[user-error] fx-list INVALID" {
  run ${bindir}/fx-list hello

  assert_failure 2
  assert_output --partial "Invalid argument: 'hello'"
  assert_output --partial "usage: fx list"
}

@test "[user-error] fx-list 256 INVALID" {
  run ${bindir}/fx-list 256 --hello

  assert_failure 2
  assert_output --partial "Invalid 256 color option: '--hello'"
  assert_output --partial "usage: fx list"
}
