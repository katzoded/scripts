#!/usr/bin/sh 

~/dev-newton/scripts/ReplaceFileList.sh ".* " | ~/dev-newton/scripts/ReplaceFileList.sh "\(.*\)" "scp \1 okatz@172.29.14.106:/$(pwd)/\1" | ~/dev-newton/scripts/ReplaceFileList.sh "Oded.Katz" "okatz"
