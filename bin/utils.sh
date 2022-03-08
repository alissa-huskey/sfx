#!/usr/bin/env bash
#
#

FX_VERSION=0.1.0

# exit with an error message
abort() {
  error "${@}"
  exit 1
}

# for user errors -- print error, print usage, and exit
oops() {
  printf "\e[31mError\e[0m %s\n\n" "${*}"
  usage
  exit 2
}

# print error message
error() {
  printf "\e[31mError\e[0m %s\n" "${*}"
}

# print error message if in debug mode
debug() {
  is_verbose || return
  printf "\e[33mdebug>\e[0m %s\n" "${*}"
}

is_verbose() {
  [[ -n ${verbose} ]]
}

valid_8() {
  [[ "$1" == "8" ]] && return 1
  [[ "$1" =~ ^[0-9]+$ ]] && [[ $1 -le 9 ]]
}

valid_16() {
  [[ "$1" =~ ^[0-9]+$ ]] && [[ $1 -lt 16 ]]
}

valid_256() {
  [[ "$1" =~ ^[0-9]+$ ]] && [[ $1 -le 255 ]]
}

valid_hex() {
  local string="${1}"
  [[ "$string" =~ ^[a-zA-Z0-9]+$ ]] && [[ ${#string} =~ ^[3684]$ ]]
}

valid_percent() {
  [[ "$1" =~ ^[0-9.]*$ ]] || return 1
  [[ $(bc <<< "$1 >= 0 && $1 <= 1") == 1 ]]
}

valid_code() {
  local code=$1

  [[ ${#code} =~ ^[123]$ ]] || return 1
  [[ $code =~ ^[349]?[012345679]$ ]] || [[ $code =~ ^10[012345679]$ ]]
}

valid_color() {
  printf "%s\n" "${colors[@]}" bright light | grep -xq $1
}

valid_style() {
  printf "%s\n" "${styles[@]}" | grep -xq $1
}

valid_name() {
  valid_color $1 || valid_style $1
}

# usage: print_color [-n] STYLE=0|7 VARIENT=3|9 COLOR=1-9 [PREFIX="bright|light "]
#
# examples:
#
# $ print_color 0 3 4         # fg normal blue
# $ print_color 7 9 5         # bg bright magenta
#
print_color() {
  local sep=$'\n' style varient color prefix
  local layer code name display

  if [[ $1 == "-n" ]]; then
    sep=" "
    shift
  fi

  style=$1 varient=$2 color=$3 prefix="$4"

  [[ $style =~ ^[07]$ ]] || abort "Invalid style: '${style}' (ok: 0=normal, 7=invert)"
  [[ $varient =~ ^[39]$ ]] || abort "Invalid varient '${varient}' (ok: 3=normal, 9=bright)"
  [[ $color =~ ^[012345679]$ ]] || abort "Invalid color '${color}' (ok: 0-9 except 8)"

  layer=$varient                   # fg / bg
  if [[ $style -eq 7 ]]; then
    case $varient in
      3) layer=4  ;;
      9) layer=10 ;;
    esac
  fi

  name="${prefix}${colors[$color]}"              # color name
  code="${varient}${color}"
  display="${layer}${color}"

  printf "\e[%d;%dm[%s:%3s]\e[0m%s" $style $code "$name" $display "$sep"
}

bash_ok() {
  local need=${1:-4} version
  version=$(/usr/bin/env bash -c 'echo ${BASH_VERSINFO[0]}')

  [[ ${version} -ge ${need} ]]
}

init() {
  local i key=0 suffix=0
  local -a prefixes=( 3 9 )

  colors=(black red green yellow blue magenta cyan white skip default)
  styles=(default bold dim italic underline blink skip invert hidden strike)

  # map name -> code
  i=0
  for c in "${colors[@]}"; do
    color_map+=( [$c]=$((i++)) )
  done

  # map name -> code
  i=0
  for s in "${styles[@]}"; do
    style_map+=( [$s]=$((i++)) )
  done

  # map 0-16 -> code
  for i in {0..16} ; do
    [[ $suffix -eq 8 ]] && suffix=9

    prefix=${prefixes[$key]}
    code="${prefix}${suffix}"

    ansi_map+=( ${code} )

    if [ $(( (i+1) % 9)) -eq 0 ]; then
      suffix=0
      key=1
    fi

    : $(( suffix++ ))
  done
}

# convert a series of rgb values to a hex string
#
# usage: rgb_to_hex R G B [A]
#
# examples:
#
# $ rgb_to_hex 255 255 255
# #ffffff
# $ rgb_to_hex 0 0 0
# #000000
#
rgb_to_hex() {
  local string="#" code

  while [[ $# -gt 0 ]]; do
    valid_256 $1 || oops "Invalid RGB value: '$1'"

    code=$(printf %x $1)
    [[ ${#code} -eq 1 ]] && code="${code}${code}"
    string="${string}${code}"
    shift
  done

  echo $string
}

# convert a hex string to a series of rgb values
#
# usage: hex_to_rgb HEX

# examples:
#
# $ hex_to_rgb ffffff
# 255 255 255
# $ hex_to_rgb fff
# 255 255 255
# $ hex_to_rgb '#ffffff'
# 255 255 255
#
hex_to_rgb() {
  local string len=2 code value silent

  if [[ "$1" == "-s" ]]; then
    silent=true
    shift
  fi

  string="${1###}"

  rgb=""  # not local so that it can be used by calling functions

  valid_hex "${string}" || oops "Invalid hex code: '$(printf "%q" "${1}")'"

  # get one character at a time for 3 or 4 digit codes
  [[ ${#string} =~ ^[34]$ ]] && len=1

  while [[ ${#string} -gt 0 ]]; do
    # get the first 1-2 characters
    code="${string:0:$len}"

    # expand for 3 digit codes
    [[ ${#code} -eq 1 ]] && code="${code}${code}"

    # get the decimal value for this code
    #    the { ; } is to redirect stderr for parsing
    #    errors that result from invalid hex codes
    value=$({ echo $((16#$code)) ; } 2> /dev/null)

    # if the above failed, then $value will be empty so exit
    [[ -z "$value" ]]  && oops "Not a valid hex code: '${1}' ('${code}')"

    # append to rgb string
    rgb="${rgb}${rgb:+ }$value"

    # remove characters from the string
    string="${string:$len}"
  done

  [[ -n $silent ]] || echo $rgb
}

# convert a series of RGB values in percentages to decimal rgb values
#
# usage percent_to_rgb R G B [A]
#
# example:
# $ percent_to_rgb 1 0.51372170448303223 0.45018774271011353
# 255 130 114
#
percent_to_rgb() {
  local value rgb

  while [[ $# -gt 0 ]]; do
    valid_percent "$1" || oops "Invalid RGB percent value: '$1' (ok: 0-1)"

    value=$(bc <<< "$1*255")

    # append to rgb string
    rgb="${rgb}${rgb:+ }${value%%.*}"

    shift
  done

  echo $rgb
}

# strips the options from args
# relies on command being defined in main
options() {
  local arg

  for arg in $@; do
    case "$arg" in
      "$command")     :                       ;;
      -h|--help|help) docs ; exit             ;;
      -v|--verbose)   verbose=true            ;;
      *)              args+=( "$arg" )        ;;
    esac
  done
}

# call main if the script is being executed, but not if it's sourced
#
#    determined by if the executing script is not the same as the
#    script that sourced utils.sh
#
# depends on
#
# - me set to ${BASH_SOURCE[0]} by sourcing script
#
# usage: run_cmd ${1:+"$@"}
#
run_cmd() {
  local runner="$0"

  if [[ ${runner} == "$me" ]]; then
    main ${1:+"$@"}
  fi

}

