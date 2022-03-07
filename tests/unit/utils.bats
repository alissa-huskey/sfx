#!/usr/bin/env bats

load 'helper'

load ${rootdir}/bin/utils.sh

usage() { : ; }

@test "valid_256" {
  for value in 0 5 50 255; do
    run valid_256 $value
    assert_success
  done

  for value in -1 300 xxx 0.5; do
    run valid_256 $value
    assert_failure
  done
}

@test "valid_hex" {
  for value in fff ffffff ffff ffffffff; do
    run valid_hex $value
    assert_success
  done

  for value in "" ff 'hello!'; do
    run valid_hex $value
    assert_failure
  done
}

@test "valid_code" {
  for value in 1 9 32 45 93 100; do
    run valid_code $value
    assert_success
  done

  for value in -1 88 38 300 hello; do
    run valid_code $value
    assert_failure
  done
}

@test "valid_color" {
  init
  for value in black default bright; do
    run valid_color $value
    assert_success || p $value
    assert_success
  done

  for value in rose 33 ffffff ""; do
    run valid_color $value
    assert_failure || p $value
    assert_failure
  done
}

@test "valid_style" {
  init
  for value in bold dim; do
    run valid_style $value
    assert_success || p $value
    assert_success
  done

  for value in super 33 ffffff ""; do
    run valid_style $value
    assert_failure || p $value
    assert_failure
  done
}

@test "valid_name" {
  init
  for value in yellow bold bright; do
    run valid_name $value
    assert_success || p $value
    assert_success
  done

  for value in super 33 ffffff ""; do
    run valid_name $value
    assert_failure || p $value
    assert_failure
  done
}

@test "rgb_to_hex R G B" {
  run rgb_to_hex 255 255 255

  assert_success
  assert_output "#ffffff"
}

@test "rgb_to_hex INVALID.." {
  run rgb_to_hex 300

  assert_failure 2
  assert_output --partial "Invalid RGB value: '300'"
}

@test "hex_to_rgb HEX (3)" {
  run hex_to_rgb fff

  assert_success
  assert_output "255 255 255"
}

@test "hex_to_rgb HEX (4)" {
  run hex_to_rgb ffff

  assert_success
  assert_output "255 255 255 255"
}

@test "hex_to_rgb HEX (6)" {
  run hex_to_rgb ffffff

  assert_success
  assert_output "255 255 255"
}

@test "hex_to_rgb HEX (8)" {
  run hex_to_rgb ffffffff

  assert_success
  assert_output "255 255 255 255"
}

@test "hex_to_rgb #HEX" {
  run hex_to_rgb '#fff'

  assert_success
  assert_output "255 255 255"
}

@test "hex_to_rgb INVALID" {
  run hex_to_rgb 'xxx'

  assert_failure 2
  assert_output --partial "Not a valid hex code: 'xxx'"
}

@test "percent_to_rgb R G B" {
  run percent_to_rgb 0.5 0.5 1

  assert_success
  assert_output "127 127 255"
}

@test "percent_to_rgb INVALID" {
  run percent_to_rgb xx

  assert_failure 2
  assert_output --partial "Not a valid argument: 'xx'"
}

@test "print_color STYLE VARIENT COLOR" {
  init
  run print_color 0 3 7

  assert_success
  assert_output --partial "white: 37"
}

@test "print_color -n STYLE VARIENT COLOR" {
  init
  run print_color -n 0 3 7

  assert_success
  assert_output --partial "white: 37"
}

@test "print_color STYLE VARIENT COLOR PREFIX" {
  init
  run print_color 7 9 5 "bright "

  assert_success
  assert_output --partial "bright magenta:105"
}

@test "print_color INVALID-STYLE VARIENT COLOR" {
  init
  run print_color x 9 5

  assert_failure 1
  assert_output --partial "Invalid style: 'x'"
}

@test "print_color STYLE INVALID-VARIENT COLOR" {
  init
  run print_color 0 x 5

  assert_failure 1
  assert_output --partial "Invalid varient 'x'"
}

@test "print_color STYLE VARIENT INVALID-COLOR" {
  init
  run print_color 0 9 x

  assert_failure 1
  assert_output --partial "Invalid color 'x'"
}
