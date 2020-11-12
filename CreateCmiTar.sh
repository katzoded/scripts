find . -name "cm[ip]_*" | grep -v ".\cmi[ip]" | ~/scripts/ReplaceFileList.sh "\(.*\)" "tar rvf cmi.tar \1" |sh
gzip cmi.tar
