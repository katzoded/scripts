#!/bin/sh -f



./baselink.sh "${1}/${2}" "${3}" "${2}";



./ReplaceFileList.sh "\(.*\)" "@srcdir@/${2}/\1 \\\\" new_cmi_tmp_cc.mk >> new_cmi_tmp.mk



sort new_cmi_tmp.mk > new_cmi_tmp.mk.sort

./ReplaceFileList.sh "common/cmi\(.*\)" "@builddir@\1 \\\\" new_cmi_tmp.mk.sort >> new_cmi.mk

#./ReplaceFileList.sh "\-\-\-\-\-\-(.*\)" "@srcdir@/${2}/\1 \\\\" new_cmi_tmp.mk >> new_cmi.mk

rm new_cmi_tmp.mk



