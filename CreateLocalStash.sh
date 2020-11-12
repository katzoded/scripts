#!/usr/bin/sh 



 git status --porcelain | ~/dev-newton/scripts/ReplaceFileList.sh ".* " | ~/dev-newton/scripts/ReplaceFileList.sh "/" "\\\\" | ~/dev-newton/scripts/ReplaceFileList.sh "\(.*\)" "xcopy.exe ..\\\\okatz_bn4k\\\\\1 ..\\\\Stash-${1}\\\\\1"  

