#!/usr/bin/env bash

# Text to ASCII Converter - v1

if [ "$#" -eq 0 ]; then
    echo "Usage: $0 <text | file>"
    exit 1
fi


if [ "$#" -eq 1 ] && [ -f "$1" ]; then
    while IFS= read -r -n1 c; do
        printf '%d ' "'$c"
    done < "$1"
    printf '\n'

else

    text="$*"

    for ((i=0; i<${#text}; i++)); do
        c="${text:i:1}"
        printf '%d ' "'$c"
    done

    printf '\n'
fi


# Completed !
# IW Cyber Ops
