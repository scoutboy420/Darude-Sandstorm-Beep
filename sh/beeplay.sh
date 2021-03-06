#!/bin/sh

# helper functions 

print_usage() 
{
    # Print script usage

    cat <<EOF
Usage: $0 [-d] SHEET

    -d, --default           use the default terminal bell instead of play
    SHEET                   path to the sheet file
EOF
}

# parse args

function='note_play'

for arg in "$@"; do
    case $arg in
        -d|--default) function='' ;;
        -h|--help) print_usage; exit;;
        *) set -- "$@" "$arg" ;;  # Leave positional arguments
    esac
    shift
done

# get script directory, works in most simple cases
scriptdir="$(dirname -- "$0")"

# import library functions
# shellcheck disable=SC1090
. "$scriptdir/beeplaylib.sh"

# awk is responsible for reading whatever was passed and piping it to beeplay
# if nothing or '-' is passed then awk reads from stdin
# system("") is used to flush output after each line so beeplay can read it immediately
# NF ignores empty lines
awk 'NF { print $0; system("")}' "$@" | emit_sheet | beeplay $function