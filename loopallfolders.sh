#!/usr/bin/bash -f

rm new_cmi.mk
pushd ${2}
find common/cmi/src -name "cmp_*.cc" | grep "_v[0-9]*.cc" | sort > /tmp/cmp_ver.list
find common/cmi/src -name "cmp_*.cc" | grep -v "_v[0-9]*.cc" | sort > /tmp/cmp.list
find common/cmi/src -name "cmi_*_linkdefs.cc" | grep "_v[0-9]*_linkdefs.cc" | sort > /tmp/cmi_ver.list
find common/cmi/src -name "cmi_*_linkdefs.cc" | grep -v "_v[0-9]*_linkdefs.cc" | sort > /tmp/cmi.list
find common/cmi/src -name "cmi_*_linkdefs.h" |  sort > /tmp/cmi_headers.list
find common/tools -name "cmi_cmi_versions_*.v" |  sort > /tmp/cmi_headers_ver.list
find common/cmi/src -name "cmi_*_linkdefs.cc" | sort > /tmp/cmi.full.list 
popd
pushd ${1}
find common/cmi/src -name "cmp_*.cmp" | sort > /tmp/cmp.cmp.list
find common/cmi/src -name "cmi_*_linkdefs.cmi" | sort > /tmp/cmi.cmi.list
popd

while read entireline ;
do 
    folders=`echo $entireline | awk '{printf "%s", $1}'`
    lists=`echo $entireline | awk '{printf "%s", $2" "$3" "$4}'`
	export folder_nonewline=$(echo ${folders}| tr '\r' '/')	
	export folder_TR=$(echo ${folders}| tr '\r' 'S' | tr "[a-z]" "[A-Z]" | tr '/' '_' )
	echo "LIBCMI_${folder_TR} := \\" >> new_cmi.mk
    ./link.sh ${1}/common/cmi/ ${folder_nonewline} "${lists}"
	
	echo "" >> new_cmi.mk
done < folder.list

echo "CMI_FILES_CC := \\\\" > ./new_cmi_cmp_files.lst
./ReplaceFileList.sh "\(.*\).cmi" "@top_builddir@/\1.cc \\\\" /tmp/cmi.cmi.list >> ./new_cmi_cmp_files.lst
echo "" >> ./new_cmi_cmp_files.lst

echo "CMP_FILES_CC := \\\\" >> ./new_cmi_cmp_files.lst
./ReplaceFileList.sh "\(.*\).cmp" "@top_builddir@/\1.cc \\\\" /tmp/cmp.cmp.list >> ./new_cmi_cmp_files.lst
echo "" >> ./new_cmi_cmp_files.lst

echo "LIBCMI_CMP_VERSIONED_SRCS := \\\\" >> ./new_cmi_cmp_files.lst
./ReplaceFileList.sh "\(.*\)" "@top_builddir@/\1 \\\\" /tmp/cmp_ver.list >> ./new_cmi_cmp_files.lst
echo "" >> ./new_cmi_cmp_files.lst

rm -f /tmp/cmp_ver.list
rm -f /tmp/cmp.list
rm -f /tmp/cmi_ver.list
rm -f /tmp/cmi.list
rm -f /tmp/cmi_headers.list
rm -f /tmp/cmi_headers_ver.list
rm -f /tmp/cmi.full.list 
rm -f /tmp/cmp.cmp.list
rm -f /tmp/cmi.cmi.list
