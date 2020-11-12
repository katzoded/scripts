grep Service.*\.cc ${1} | ~/dev-newton/scripts/ReplaceFileList.sh "\(\[.*\]\).*, \(.*\)" "\2\\\\n\1"

