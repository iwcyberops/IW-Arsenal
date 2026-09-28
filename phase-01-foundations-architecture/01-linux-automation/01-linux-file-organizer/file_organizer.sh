#!/usr/bin/env bash

#Linux File Organizer Script

shopt -s nullglob

path=${1:-~/Downloads}


if [ ! -d "$path" ]; then
	printf '%s\n' "$path is not a Valid Directory"
	exit 1
fi

files=("$path"/*)

if [ ${#files[@]} -eq 0 ]; then
  echo "----------------------------------"
	printf "Your Given Directory is Empty!"
  echo "----------------------------------"
	exit 1
elif [ -z "$(find "$path" -maxdepth 1 ! -type d)" ]; then
  echo "-------------------------------------------------------------"
	printf "Your Directory Contains only Sub-Directories/No Files."
  echo "-------------------------------------------------------------"
	exit 1
elif [ ! -z "$(find "$path" -maxdepth 1 -type f)" ]; then
	printf "Arranging Your Files....."
	sleep 1s;
	find "$path" -maxdepth 1 -type f -print0 | while IFS= read -r -d '' file; do
		shopt -s nocasematch
		case "$file" in
			*.txt|*.pdf|*.doc|*.docx|*.md|*.odt|*.rtf|*.xls|*.xlsx|*.ppt)
				mkdir -p "$path/Documents"
				mv "$file" "$path/Documents"
				;;
			*.jpg|*.png|*.jpeg|*.bmp|*.webp|*.svg|*.gif|*.avif)
				mkdir -p "$path/Pictures"
				mv "$file" "$path/Pictures"
				;;
			*.mp4|*.mov|*.mpeg|*.mkv|*.webm|*.avi|*.wmv)
				mkdir -p "$path/Videos"
				mv "$file" "$path/Videos"
				;;
			*.mp3|*.wav|*.aiff|*.flac|*.alac|*.aac|*.ogg|*.m4a|*.m4b)
				mkdir -p "$path/Audios"
				mv "$file" "$path/Audios"
				;;
			*.zip|*.zipx|*.rar|*.7z|*.tar|*.tar.gz|*.tgz|*.gz|*.jar|*.bz2|*.xz|*.iso|*.img)
				mkdir -p "$path/Archives"
				mv "$file" "$path/Archives"
				;;
			*.c|*.h|*.cpp|*.hpp|*.java|*.py|*.rb|*.php|*.js|*.ts|*.html|*.css|*.sql|*.ada|*.adb|*.ads|*.asm|*.rs|*.go|*.swift|*.kt|*.sh|*.bash)
				mkdir -p "$path/Code"
				mv "$file" "$path/Code"
				;;
			*)
				mkdir -p "$path/Others"
				mv "$file" "$path/Others"
		esac
		shopt -u nocasematch
	done
fi

echo "--------------------------------"
printf "File's Arrangement Completed!"
echo "--------------------------------"


#Completed!
