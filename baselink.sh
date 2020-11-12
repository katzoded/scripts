#!/usr/bin/bash -f

echo cd ${1}

cd ${1}



rm -f ./cmi_cmi_versions_alloctable*.cc

echo "#include \"cmi_cmi_versions.h\"" >  cmi_cmi_versions_alloctable.cc

l=`echo ${2} | tr "\"" " "`

#echo cat ${l}

cat ${l} > combined.list

#cat combined.list > combined.list.tmp



~/scripts/ReplaceFileList.sh " " "" combined.list | sort | uniq > combined.list.tmp



echo "cmi_cmi_versions_alloctable.cc" > ~/scripts/new_cmi_tmp_cc.mk



while read cmi ;

do 

    if [ "${cmi}" != "" ]; then

    	grep ${cmi} /tmp/cmi.full.list >> ~/scripts/new_cmi_tmp.mk

    	grep ${cmi} /tmp/cmi_headers.list > cmi_cmi_versions_header_link.tmp

    	res=`grep ${cmi}.v /tmp/cmi_headers_ver.list`

    	if [ "${res}" != "" ]; then 

        	echo ${cmi} >> cmi_cmi_versions_link.tmp

            echo "#include \"cmi_cmi_versions.h\"" >  cmi_cmi_versions_alloctable_${cmi}.cc

            ~/scripts/ReplaceFileList.sh "common/cmi/src/\(.*\)" "\#include \"\1\"" cmi_cmi_versions_header_link.tmp >> cmi_cmi_versions_alloctable_${cmi}.cc

            echo "" >>  cmi_cmi_versions_alloctable_${cmi}.cc 

            echo "void FillCmiCmiVersionTable_${cmi}(CMI_CMI_Versions_LinkVersionNode *TheLinkNodes)\\{\\#include \"cmi_cmi_versions_${cmi}.v\" \\}" | tr "\\\\" "\n" >> cmi_cmi_versions_alloctable_${cmi}.cc 

            echo "cmi_cmi_versions_alloctable_${cmi}.cc " >> ~/scripts/new_cmi_tmp_cc.mk

        fi

    fi

done < combined.list.tmp



echo "" >>  cmi_cmi_versions_alloctable.cc

~/scripts/ReplaceFileList.sh "\(.*\)" "void FillCmiCmiVersionTable_\1(CMI_CMI_Versions_LinkVersionNode \*TheLinkNodes);" cmi_cmi_versions_link.tmp | tr "\\\\" "\n" >> cmi_cmi_versions_alloctable.cc

echo "void AddBaseAllocPtrTable(CMI_CMI_Versions_LinkVersionNode *TheLinkNodes);" >>  cmi_cmi_versions_alloctable.cc



echo "" >>  cmi_cmi_versions_alloctable.cc



if [ "${3}" != "base/src" ]; then

	echo "void CMI_CMI_Versions::AllocateCclVersionAllocPtrTable()" >>  cmi_cmi_versions_alloctable.cc

else

	echo "void AddBaseAllocPtrTable(CMI_CMI_Versions_LinkVersionNode *TheLinkNodes)" >>  cmi_cmi_versions_alloctable.cc

fi



echo "{" >>  cmi_cmi_versions_alloctable.cc

if [ "${3}" != "base/src" ]; then

    if [ "${3}" != "standalone/src" ]; then

    	echo "  AddBaseAllocPtrTable(TheLinkNodes);" >>  cmi_cmi_versions_alloctable.cc

    fi

fi



~/scripts/ReplaceFileList.sh "\(.*\)" "   FillCmiCmiVersionTable_\1(TheLinkNodes);" cmi_cmi_versions_link.tmp >> cmi_cmi_versions_alloctable.cc

echo "}" >>  cmi_cmi_versions_alloctable.cc

echo "" >>  cmi_cmi_versions_alloctable.cc



#if [ "${3}" == "base/src" ]; then

#    echo "" >>  cmi_cmi_versions_alloctable.cc

#   	echo "void CMI_CMI_Versions::AllocateCclVersionAllocPtrTable()" >>  cmi_cmi_versions_alloctable.cc

#    echo "{" >>  cmi_cmi_versions_alloctable.cc

#   	echo "  AddBaseAllocPtrTable(TheLinkNodes);" >>  cmi_cmi_versions_alloctable.cc

#    echo "}" >>  cmi_cmi_versions_alloctable.cc

#    echo "" >>  cmi_cmi_versions_alloctable.cc

#fi



rm cmi_cmi_versions_header_link.tmp

rm cmi_cmi_versions_link.tmp

rm combined.list.tmp

rm combined.list

cd -



