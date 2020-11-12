#!/usr/bin/bash -f
~/dev-newton/scripts/ReplaceFileList.sh "|.*|" "" ${1} | cat -A | sort | ~/dev-newton/scripts/ReplaceFileList.sh "0x[0x|0-9|a-f|A-F]*" "" | ~/dev-newton/scripts/ReplaceFileList.sh "[0-9]" "" | ~/dev-newton/scripts/ReplaceFileList.sh " Duplicate=, In=sec," "" | sort |uniq -c | sort -r
