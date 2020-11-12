#!/usr/bin/sh 

~/dev-newton/scripts/ReplaceFileList.sh "\(.*\)" "scp \1 okatz@172.29.14.175:/$(pwd)/\1" | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "Oded.Katz" "okatz"
