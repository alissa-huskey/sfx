#!/usr/bin/env bats

load 'helper'

@test "fx-show --help" {
  run ${bindir}/fx-show --help
  assert_success
  assert_output --partial "fx show -- show a color or style"
}


@test "fx-show --rgb R G B" {
  run ${bindir}/fx-show --rgb 255 255 255
  assert_success
  assert_output --partial "255 255 255"
}

@test "fx-show --color COLOR" {
  run ${bindir}/fx-show --color blue
  assert_success
  assert_output --partial "blue: 34"
}

@test "fx-show --style STYLE" {
  run ${bindir}/fx-show --style bold
  assert_success
  assert_output --partial "bold"
}

@test "fx-show --8 NUMBER" {
  run ${bindir}/fx-show --8 4
  assert_success
  assert_output --partial "bright blue: 94"
}

@test "fx-show --16 NUMBER" {
  run ${bindir}/fx-show --16 14
  assert_success
  assert_output --partial "bright cyan: 96"
}

@test "fx-show --256 NUMBER" {
  run ${bindir}/fx-show --256 222
  assert_success
  assert_output --partial "222"
}

@test "fx-show --hex CODE" {
  run ${bindir}/fx-show --hex 'fff'

  assert_success
  assert_output --partial "fff"
}

@test "fx-show --code NUMBER" {
  run ${bindir}/fx-show --code 31
  assert_success
  assert_output --partial "31"
}

@test "[user-error] fx-show --rgb INVALID..." {
  run ${bindir}/fx-show --rgb x y z
  assert_failure 2
  assert_output --partial "Invalid RGB value: x y z"
}

@test "[user-error] fx-show --color INVALID" {
  skip  "TODO: fix"
  run ${bindir}/fx-show --color purple

  assert_failure 2
  assert_output --partial "Invalid color: 'purple'"
}

@test "[user-error] fx-show --style STYLE" {
  skip "TODO: fix"
  run ${bindir}/fx-show --style super

  assert_failure 2
  assert_output --partial "Invalid style: 'super'"
}

@test "[user-error] fx-show --8 INVALID" {
  skip "TODO: fix"
  run ${bindir}/fx-show --8 10
  assert_failure 2
  assert_output --partial "Invalid color: '10'"
}

@test "[user-error] fx-show --16 INVALID" {
  skip "TODO: fix"
  run ${bindir}/fx-show --16 14

  assert_failure 2
  assert_output --partial "Invalid color: '14'"
}

@test "[user-error] fx-show --256 INVALID-NUMBER" {
  skip "TODO: fix"
  run ${bindir}/fx-show --256 300
  assert_failure 2
  assert_output --partial "Invalid 256 color: '222'"
}

@test "[user-error] fx-show --256 INVALID" {
  skip "TODO: fix"
  run ${bindir}/fx-show --256 xxx
  assert_failure 2
  assert_output --partial "Invalid 256 color: 'xxx'"
}

@test "[user-error] fx-show --hex INVALID" {
  run ${bindir}/fx-show --hex 'xxx'
  assert_failure 2
  assert_output --partial "Not a valid hex code: 'xxx'"
}

@test "[user-error] fx-show --code INVALID-NUM" {
  skip "TODO: fix"
  run ${bindir}/fx-show --code 902
  assert_failure 2
  assert_output --partial "Invalid escape code number: '902'"
}

@test "[user-error] fx-show --code INVALID" {
  skip "TODO: fix"
  run ${bindir}/fx-show --code xxx
  assert_failure 2
  assert_output --partial "Invalid escape code number: 'xxx'"
}

@test "[user-error] fx-show INVALID" {
  run ${bindir}/fx-show silver
  assert_failure 2
  assert_output --partial "Unable to determine FORMAT format for value(s): 'silver'"
}

@test "fx-show R G B" {
  run ${bindir}/fx-show 255 255 255
  assert_success
  assert_output --partial "255 255 255"
}

@test "fx-show COLOR" {
  run ${bindir}/fx-show --color blue
  assert_success
  assert_output --partial "blue: 34"
}

@test "fx-show bright COLOR" {
  run ${bindir}/fx-show bright blue
  assert_success
  assert_output --partial "bright blue: 94"
}

@test "fx-show STYLE" {
  run ${bindir}/fx-show bold
  assert_success
  assert_output --partial "bold"
}

@test "fx-show NUMBER (0-8)" {
  run ${bindir}/fx-show 8
  assert_success
  assert_output --partial "[38;5;8m 8"
  refute_output --partial "blue: 34"
}

@test "fx-show NUMBER (0-16)" {
  run ${bindir}/fx-show 14
  assert_success
  assert_output --partial "[38;5;14m 14"
  refute_output --partial "bright cyan: 96"
}

@test "fx-show NUMBER (0-255)" {
  run ${bindir}/fx-show 222
  assert_success
  assert_output --partial "[38;5;222m 222"
}

@test "fx-show HEX" {
  run ${bindir}/fx-show 'fff'
  assert_success

  assert_output --partial "fff"
}

@test "fx-show --code NUMBER" {
  run ${bindir}/fx-show --code 31
  assert_success
  assert_output --partial "31"
}

@test "fx-show --verbose FORMAT VALUE..." {
  run ${bindir}/fx-show --verbose --color red
  assert_success
  assert_output --regexp "debug>.* showing color by name: red"
}

@test "fx-show FORMAT --verbose VALUE..." {
  run ${bindir}/fx-show --color --verbose red
  assert_success
  assert_output --regexp "debug>.* showing color by name: red"
}

@test "fx-show FORMAT VALUE... --verbose" {
  run ${bindir}/fx-show --color red --verbose
  assert_success
  assert_output --regexp "debug>.* showing color by name: red"
}

@test "[user-error] fx-show FORMAT" {
  skip "TODO: fix"
  for format in rgb color style 8 16 256 hex code; do
    run ${bindir}/fx-show --$format
    assert_failure 2
  done
}

@test "[user-error] fx-show" {
  run ${bindir}/fx-show
  assert_failure 2
  assert_output --partial "Missing required argument"
  assert_output --partial "usage: fx show"
}

@test "[user-error] fx-show INVALID" {
  run ${bindir}/fx-show --xxx
  assert_failure 2
  assert_output --partial "Unrecognized argument: '--xxx'"
}
