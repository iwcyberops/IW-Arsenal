#!/usr/bin/env bash

# Word/Character Analyzer - v1


if [ $# -eq 0 ]; then
	echo "No Arguments! Usage ./script_name file_name"
	exit 1
fi
num=0
char=0
symbol=0
space=0
other=0

if [ $# -eq 1 ] && [ -f "$1" ]; then
	while IFS= read -r -n1 c; do
		case "$c" in
			[0-9])
				((num++))
				;;
			[a-zA-Z])
				((char++))
				;;
			[\!\@\#\$\%\^\&\*\:\;\"\'\<\>\?\.\,\/\-\=\+\_\`\~\\\|\[\]])
				((symbol++))
				;;
			" ")
				((space++))
				;;
			*)
				((other++))
				;;
		esac 
	done < "$1"
	printf "\033[1;32m-------------------------------------------\033[0m\n"
	printf "\033[1;36m%-12s %d\033[0m\n" "Lines:" "$(wc -l < "$1")"
	printf "\033[1;36m%-12s %d\033[0m\n" "Words:" "$(wc -w < "$1")"
	printf "\033[1;36m%-12s %d\033[0m\n" "Letters:" "$char"
	printf "\033[1;36m%-12s %d\033[0m\n" "Numbers:" "$num"
	printf "\033[1;36m%-12s %d\033[0m\n" "Symbols:" "$symbol"
	printf "\033[1;36m%-12s %d\033[0m\n" "Spaces:" "$space"
	printf "\033[1;36m%-12s %d\033[0m\n" "Others:" "$other"
	printf "\033[1;32m-------------------------------------------\033[0m\n"
else
	printf "\033[1;31m----------------------\033[0m\n"
	printf "\033[1;31mFile Not Found!\033[0m\n"
	printf "\033[1;31m----------------------\033[0m\n"
	exit 1
fi

# Completed!
# IW Cyber Ops
