#!/usr/bin/env bats

load 'helper'

@test "fx-show --rgb R G B" {
  run ${bin}/fx-show --rgb 255 255 255
  assert_success
  assert_output --partial "255 255 255"
}

@test "fx-show --color COLOR" {
  run ${bin}/fx-show --color blue
  assert_success
  assert_output --partial "blue: 34"
}

@test "fx-show --style STYLE" {
  run ${bin}/fx-show --style bold
  assert_success
  assert_output --partial "bold"
}

@test "fx-show --8 NUMBER" {
  run ${bin}/fx-show --8 4
  assert_success
  assert_output --partial "bright blue: 94"
}

@test "fx-show --16 NUMBER" {
  run ${bin}/fx-show --16 14
  assert_success
  assert_output --partial "bright cyan: 96"
}

@test "fx-show --256 NUMBER" {
  run ${bin}/fx-show --256 222
  assert_success
  assert_output --partial "222"
}

@test "fx-show --hex CODE" {
  run ${bin}/fx-show --hex 'fff'
  assert_success

# TODO: this should show '#ffffff" instaed of '255 255 255'
#       (see next test)
  assert_output --partial "255 255 255"
}

@test "fx-show --hex CODE" {
  skip "TODO: fix"
  run ${bin}/fx-show --hex 'fff'

  assert_success
  assert_output --partial "#ffffff"
}

@test "fx-show --code NUMBER" {
  run ${bin}/fx-show --code 31
  assert_success
  assert_output --partial "31"
}

@test "[user-error] fx-show --rgb INVALID..." {
  run ${bin}/fx-show --rgb x y z
  assert_failure 2
  assert_output --partial "Invalid RGB value: x y z"
}

@test "[user-error] fx-show --color INVALID" {
  skip  "TODO: fix"
  run ${bin}/fx-show --color purple

  assert_failure 2
  assert_output --partial "Invalid color: 'purple'"
}

@test "[user-error] fx-show --style STYLE" {
  skip "TODO: fix"
  run ${bin}/fx-show --style super

  assert_failure 2
  assert_output --partial "Invalid style: 'super'"
}

@test "[user-error] fx-show --8 INVALID" {
  skip "TODO: fix"
  run ${bin}/fx-show --8 10
  assert_failure 2
  assert_output --partial "Invalid color: '10'"
}

@test "[user-error] fx-show --16 INVALID" {
  skip "TODO: fix"
  run ${bin}/fx-show --16 14

  assert_failure 2
  assert_output --partial "Invalid color: '14'"
}

@test "[user-error] fx-show --256 INVALID-NUMBER" {
  skip "TODO: fix"
  run ${bin}/fx-show --256 300
  assert_failure 2
  assert_output --partial "Invalid 256 color: '222'"
}

@test "[user-error] fx-show --256 INVALID" {
  skip "TODO: fix"
  run ${bin}/fx-show --256 xxx
  assert_failure 2
  assert_output --partial "Invalid 256 color: 'xxx'"
}

@test "[user-error] fx-show --hex INVALID" {
  run ${bin}/fx-show --hex 'xxx'
  assert_failure 2
  assert_output --partial "Not a valid hex code: 'xxx'"
}

@test "[user-error] fx-show --code INVALID-NUM" {
  skip "TODO: fix"
  run ${bin}/fx-show --code 902
  assert_failure 2
  assert_output --partial "Invalid escape code number: '902'"
}

@test "[user-error] fx-show --code INVALID" {
  skip "TODO: fix"
  run ${bin}/fx-show --code xxx
  assert_failure 2
  assert_output --partial "Invalid escape code number: 'xxx'"
}

@test "[user-error] fx-show INVALID" {
  run ${bin}/fx-show silver
  assert_failure 2
  assert_output --partial "Unable to determine FORMAT format for value(s): 'silver'"
}

@test "fx-show R G B" {
  run ${bin}/fx-show 255 255 255
  assert_success
  assert_output --partial "255 255 255"
}

@test "fx-show COLOR" {
  run ${bin}/fx-show --color blue
  assert_success
  assert_output --partial "blue: 34"
}

@test "fx-show bright COLOR" {
  run ${bin}/fx-show bright blue
  assert_success
  assert_output --partial "bright blue: 94"
}

@test "fx-show STYLE" {
  run ${bin}/fx-show bold
  assert_success
  assert_output --partial "bold"
}

@test "fx-show NUMBER (0-8)" {
  run ${bin}/fx-show 8
  assert_success
  assert_output --partial "[38;5;8;m8"
  refute_output --partial "blue: 34"
}

@test "fx-show NUMBER (0-16)" {
  run ${bin}/fx-show 14
  assert_success
  assert_output --partial "[38;5;14;m14"
  refute_output --partial "bright cyan: 96"
}

@test "fx-show NUMBER (0-255)" {
  run ${bin}/fx-show 222
  assert_success
  assert_output --partial "[38;5;222;m222"
}

@test "fx-show HEX" {
  run ${bin}/fx-show 'fff'
  assert_success

# TODO: this should show '#ffffff" instaed of '255 255 255'
  assert_output --partial "255 255 255"
}

@test "fx-show --code NUMBER" {
  run ${bin}/fx-show --code 31
  assert_success
  assert_output --partial "31"
}

@test "fx-show --help" {
  run ${bin}/fx-show --help
  assert_success
  assert_output --partial "fx show -- show a color or style"
}

@test "fx-show --verbose FORMAT VALUE..." {
  run ${bin}/fx-show --verbose --color red
  assert_success
  assert_output --regexp "debug>.* showing color by name: red"
}

@test "fx-show FORMAT --verbose VALUE..." {
  run ${bin}/fx-show --color --verbose red
  assert_success
  assert_output --regexp "debug>.* showing color by name: red"
}

@test "fx-show FORMAT VALUE... --verbose" {
  run ${bin}/fx-show --color red --verbose
  assert_success
  assert_output --regexp "debug>.* showing color by name: red"
}

@test "[user-error] fx-show FORMAT" {
  skip "TODO: fix"
  for format in rgb color style 8 16 256 hex code; do
    run ${bin}/fx-show --$format
    assert_failure 2
  done
}

@test "[user-error] fx-show" {
  run ${bin}/fx-show
  assert_failure 2
  assert_output --partial "Missing required argument"
  assert_output --partial "usage: fx show"
}

@test "[user-error] fx-show INVALID" {
  run ${bin}/fx-show --xxx
  assert_failure 2
  assert_output --partial "Unrecognized argument: '--xxx'"
}
