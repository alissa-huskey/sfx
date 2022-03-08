#!/usr/bin/env bats

load 'helper'

@test "fx-convert --to-hex R G B" {
  run ${bindir}/fx-convert --to-hex 255 255 255
  assert_success
  assert_output "#ffffff"
}

@test "fx-convert --to-rgb HEX (3)" {
  run ${bindir}/fx-convert --to-rgb 'fff'
  assert_success
  assert_output "255 255 255"
}

@test "fx-convert --to-rgb HEX (4)" {
  run ${bindir}/fx-convert --to-rgb 'ffff'
  assert_success
  assert_output "255 255 255 255"
}

@test "fx-convert --to-rgb HEX (6)" {
  run ${bindir}/fx-convert --to-rgb 'ffffff'
  assert_success
  assert_output "255 255 255"
}

@test "fx-convert --to-rgb HEX (8)" {
  run ${bindir}/fx-convert --to-rgb 'ffffffff'
  assert_success
  assert_output "255 255 255 255"
}

@test "fx-convert --to-rgb #HEX" {
  run ${bindir}/fx-convert --to-rgb '#ffffff'
  assert_success
  assert_output "255 255 255"
}

@test "fx-convert --to-dec R G B" {
  run ${bindir}/fx-convert --to-dec 0.5 0.5 1
  assert_success
  assert_output "127 127 255"
}

@test "[user-error] fx-convert --to-hex INVALID..." {
  run ${bindir}/fx-convert --to-hex 300
  assert_failure 2
  assert_output --partial "Invalid RGB value: '300'"
}

@test "[user-error] fx-convert --to-rgb INVALID" {
  run ${bindir}/fx-convert --to-rgb 'xxx'
  assert_failure 2
  assert_output --partial "Not a valid hex code: 'xxx'"
}

@test "[user-error] fx-convert --to-dec INVALID-NUM" {
  skip "TODO: fix"
  run ${bindir}/fx-convert --to-dec 3 5 7
  assert_failure 2
  assert_output --partial "Invalid RGB percent value: '3'"
}

@test "[user-error] fx-convert --to-dec INVALID" {
  run ${bindir}/fx-convert --to-dec xxx
  assert_failure 2
  assert_output --partial "Not a valid argument: 'xxx'"
}

@test "[user-error] fx-convert" {
  run ${bindir}/fx-convert
  assert_failure 2
  assert_output --partial "What would you like to convert?"
}

@test "[user-error] fx-convert INVALID-FORMAT" {
  run ${bindir}/fx-convert --xxx
  assert_failure 2
  assert_output --partial "Unrecognized FORMAT"
}

@test "[user-error] fx-convert VALUE" {
  run ${bindir}/fx-convert xxx
  assert_failure 2
  assert_output --partial "Missing required FORMAT"
}

@test "fx-convert --help" {
  run ${bindir}/fx-convert --help
  assert_success
  assert_output --partial "fx convert -- convert different color formats"
}

@test "fx-convert --verbose FORMAT VALUE" {
  run ${bindir}/fx-convert --verbose --to-rgb fff
  assert_success
  assert_output --regexp "debug>.* hex_to_rgb"
  assert_output --partial "255 255 255"
}

@test "fx-convert FORMAT --verbose VALUE" {
  run ${bindir}/fx-convert --to-rgb --verbose fff
  assert_success
  assert_output --regexp "debug>.* hex_to_rgb"
  assert_output --partial "255 255 255"
}

@test "fx-convert FORMAT VALUE --verbose" {
  run ${bindir}/fx-convert --to-rgb fff --verbose
  assert_success
  assert_output --regexp "debug>.* hex_to_rgb"
  assert_output --partial "255 255 255"
}
