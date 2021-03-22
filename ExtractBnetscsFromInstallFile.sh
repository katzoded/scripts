

export BNET_INSTALL_FILE=${1}

tar tvf ${BNET_INSTALL_FILE} \
| grep "rpm" \
| awk '{print $6}' \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\(.*\)" "tar xvf ${BNET_INSTALL_FILE} \1; rpm2cpio \1 | cpio -tv | grep 'bin/bnetscs' | awk '{print \\\\$9}' | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh '\\\\(.*\\\\)' 'rpm2cpio \1 | cpio -idmv \\\\1'" | sh | sh
