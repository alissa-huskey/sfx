#!/usr/bin/env bats

load 'helper'

@test "fx-get --hex NUMBER" {
  skip "Doesn't work in tests"
  run ${bindir}/fx-get --hex 0
  assert_success
  assert_output "#000000"
}

@test "fx-get --rgb NUMBER" {
  skip "Doesn't work in tests"
  run ${bindir}/fx-get --rgb 0
  assert_success
  assert_output "255 255 255"
}

@test "[user-error] fx-get --hex MISSING-VALUE" {
  run ${bindir}/fx-get --hex
  assert_failure 2
  assert_output --partial "What color number do you want to get?"
}

@test "[user-error] fx-get --rgb MISSING-VALUE" {
  run ${bindir}/fx-get --rgb
  assert_failure 2
  assert_output --partial "What color number do you want to get?"
}

@test "[user-error] fx-get --hex INVALID" {
  run ${bindir}/fx-get --hex 300
  assert_failure 2
  assert_output --partial "Invalid 256 color: '300'"
}

@test "[user-error] fx-get --rgb INVALID" {
  run ${bindir}/fx-get --rgb xxx
  assert_failure 2
  assert_output --partial "Invalid 256 color: 'xxx'"
}

@test "[user-error] fx-get MISSING-FORMAT VALUE" {
  run ${bindir}/fx-get fff
  assert_failure 2
  assert_output --partial "Missing required FORMAT"
}

@test "[user-error] fx-get INVALID-FORMAT" {
  run ${bindir}/fx-get --xxx
  assert_failure 2
  assert_output --partial "Unrecognized FORMAT"
}

@test "fx-get --help" {
  run ${bindir}/fx-get --help
  assert_success
  assert_output --partial "fx get -- get the true color for a 256 color"
}
