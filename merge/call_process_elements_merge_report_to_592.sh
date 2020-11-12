#!/bin/bash

/home/mayank/scripts/start_script

to_release="5.9.2"

rm -fr /home/mayank/all_write/*


cd /vobs



# kp_snowy.vws
# kam_5.8.2.vws
# 5.8.2/latest to 5.9.2 merge - x86 and call processing

from_release="5.8.2"
filename_common=$from_release"_to_"$to_release"_COMMON.txt"
filename_vikings=$from_release"_to_"$to_release"_VIKINGS.txt"
filename_thirdparty=$from_release"_to_"$to_release"_THIRDPARTY.txt"
filename_ems=$from_release"_to_"$to_release"_EMS.txt"

/home/mayank/scripts/concise_output "Generating merge report from mayank_5.8.2_dv common"
cleartool findmerge ./common -ftag mayank_5.8.2_dv -print >/home/mayank/all_write/$filename_common 2>&1
/home/mayank/scripts/concise_output "Generating merge report from mayank_5.8.2_dv vikings"
cleartool findmerge ./vikings -ftag mayank_5.8.2_dv -print >/home/mayank/all_write/$filename_vikings 2>&1
/home/mayank/scripts/concise_output "Generating merge report from mayank_snowy_dv ems"
cleartool findmerge ./ems -ftag mayank_snowy_dv -print >/home/mayank/all_write/$filename_ems 2>&1
# cleartool findmerge ./thirdparty -ftag kam_5.8.2 -print >/home/kpatil/merge_reports/5.8.2_to_5.9.2_THIRDPARTY.txt 2>&1

#exit 0;

from_release="590_20"
filename_common=$from_release"_to_"$to_release"_COMMON.txt"
filename_vikings=$from_release"_to_"$to_release"_VIKINGS.txt"
filename_thirdparty=$from_release"_to_"$to_release"_THIRDPARTY.txt"
filename_ems=$from_release"_to_"$to_release"_EMS.txt"


# kp_590_20_snowy.vws
# kp_5.9.0.20_main.vws
#------------------- 5.9.0.20 patch branch to 5.9.2 - x86 and call processing ----------------------
/home/mayank/scripts/concise_output "Generating merge report from mayank_5.9.0.20_main_dv common"
cleartool findmerge ./common -ftag mayank_5.9.0.20_main_dv -print >/home/mayank/all_write/$filename_common 2>&1
/home/mayank/scripts/concise_output "Generating merge report from mayank_5.9.0.20_main_dv vikings"
cleartool findmerge ./vikings -ftag mayank_5.9.0.20_main_dv -print >/home/mayank/all_write/$filename_vikings 2>&1
/home/mayank/scripts/concise_output "Generating merge report from mayank_5.9.0.20_main_dv thirdparty"
cleartool findmerge ./thirdparty -ftag mayank_5.9.0.20_main_dv -print >/home/mayank/all_write/$filename_thirdparty 2>&1
/home/mayank/scripts/concise_output "Generating merge report from mayank_590_20_snowy_dv ems"
cleartool findmerge ./ems -ftag mayank_590_20_snowy_dv -print >/home/mayank/all_write/$filename_ems 2>&1

from_release="5.9.1"
filename_common=$from_release"_to_"$to_release"_COMMON.txt"
filename_vikings=$from_release"_to_"$to_release"_VIKINGS.txt"
filename_thirdparty=$from_release"_to_"$to_release"_THIRDPARTY.txt"
filename_ems=$from_release"_to_"$to_release"_EMS.txt"


# 5.9.1 to 5.9.2 merge - x86 and call processing
/home/mayank/scripts/concise_output "Generating merge report from mayank_5.9_dv common"
cleartool findmerge ./common -ftag mayank_5.9_dv -print >/home/mayank/all_write/$filename_common 2>&1
/home/mayank/scripts/concise_output "Generating merge report from mayank_5.9_dv vikings"
cleartool findmerge ./vikings -ftag mayank_5.9_dv -print >/home/mayank/all_write/$filename_vikings 2>&1
/home/mayank/scripts/concise_output "Generating merge report from mayank_5.9_dv thirdparty"
cleartool findmerge ./thirdparty -ftag mayank_5.9_dv -print >/home/mayank/all_write/$filename_thirdparty 2>&1
/home/mayank/scripts/concise_output "Generating merge report from mayank_5.9_snowy_dv ems"
cleartool findmerge ./ems -ftag mayank_5.9_snowy_dv -print >/home/mayank/all_write/$filename_ems 2>&1

#exit 0;

from_release="5.9.2_1patch"
filename_common=$from_release"_to_"$to_release"_COMMON.txt"
filename_vikings=$from_release"_to_"$to_release"_VIKINGS.txt"
filename_thirdparty=$from_release"_to_"$to_release"_THIRDPARTY.txt"
filename_ems=$from_release"_to_"$to_release"_EMS.txt"


# 5.9.2 patches into 5.9.2.main
/home/mayank/scripts/concise_output "Generating merge report from mayank_592_1_patch_dv common"
cleartool findmerge ./common -ftag mayank_592_1_patch_dv -print >/home/mayank/all_write/$filename_common 2>&1
/home/mayank/scripts/concise_output "Generating merge report from mayank_592_1_patch_dv vikings"
cleartool findmerge ./vikings -ftag mayank_592_1_patch_dv -print >/home/mayank/all_write/$filename_vikings 2>&1
/home/mayank/scripts/concise_output "Generating merge report from mayank_592_1_patch_dv thirdparty"
cleartool findmerge ./thirdparty -ftag mayank_592_1_patch_dv -print >/home/mayank/all_write/$filename_thirdparty 2>&1
/home/mayank/scripts/concise_output "Generating merge report from mayank_592_1_patch_dv ems"
cleartool findmerge ./ems -ftag mayank_592_1_patch_dv -print >/home/mayank/all_write/$filename_ems 2>&1

#exit 0;

from_release="5.9.2_10patch"
filename_common=$from_release"_to_"$to_release"_COMMON.txt"
filename_vikings=$from_release"_to_"$to_release"_VIKINGS.txt"
filename_thirdparty=$from_release"_to_"$to_release"_THIRDPARTY.txt"
filename_ems=$from_release"_to_"$to_release"_EMS.txt"


/home/mayank/scripts/concise_output "Generating merge report from mayank_592_10_patch_dv common"
cleartool findmerge ./common -ftag mayank_592_10_patch_dv -print >/home/mayank/all_write/$filename_common 2>&1
/home/mayank/scripts/concise_output "Generating merge report from mayank_592_10_patch_dv vikings"
cleartool findmerge ./vikings -ftag mayank_592_10_patch_dv -print >/home/mayank/all_write/$filename_vikings 2>&1
/home/mayank/scripts/concise_output "Generating merge report from mayank_592_10_patch_dv thirdparty"
cleartool findmerge ./thirdparty -ftag mayank_592_10_patch_dv -print >/home/mayank/all_write/$filename_thirdparty 2>&1
/home/mayank/scripts/concise_output "Generating merge report from mayank_592_10_patch_dv ems"
cleartool findmerge ./ems -ftag mayank_592_10_patch_dv -print >/home/mayank/all_write/$filename_ems 2>&1

#exit 0;

from_release="5.9.2_20patch"
filename_common=$from_release"_to_"$to_release"_COMMON.txt"
filename_vikings=$from_release"_to_"$to_release"_VIKINGS.txt"
filename_thirdparty=$from_release"_to_"$to_release"_THIRDPARTY.txt"
filename_ems=$from_release"_to_"$to_release"_EMS.txt"


/home/mayank/scripts/concise_output "Generating merge report from mayank_592_20_patch_dv common"
cleartool findmerge ./common -ftag mayank_592_20_patch_dv -print >/home/mayank/all_write/$filename_common 2>&1
/home/mayank/scripts/concise_output "Generating merge report from mayank_592_20_patch_dv vikings"
cleartool findmerge ./vikings -ftag mayank_592_20_patch_dv -print >/home/mayank/all_write/$filename_vikings 2>&1
/home/mayank/scripts/concise_output "Generating merge report from mayank_592_20_patch_dv thirdparty"
cleartool findmerge ./thirdparty -ftag mayank_592_20_patch_dv -print >/home/mayank/all_write/$filename_thirdparty 2>&1
/home/mayank/scripts/concise_output "Generating merge report from mayank_592_20_patch_dv ems"
cleartool findmerge ./ems -ftag mayank_592_20_patch_dv -print >/home/mayank/all_write/$filename_ems 2>&1




#exit 0;

from_release="5.9.2_30patch"
filename_common=$from_release"_to_"$to_release"_COMMON.txt"
filename_vikings=$from_release"_to_"$to_release"_VIKINGS.txt"
filename_thirdparty=$from_release"_to_"$to_release"_THIRDPARTY.txt"
filename_ems=$from_release"_to_"$to_release"_EMS.txt"

/home/mayank/scripts/concise_output "Generating merge report from mayank_592_30_patch_dv common"
cleartool findmerge ./common -ftag mayank_592_30_patch_dv -print >/home/mayank/all_write/$filename_common 2>&1
/home/mayank/scripts/concise_output "Generating merge report from mayank_592_30_patch_dv vikings"
cleartool findmerge ./vikings -ftag mayank_592_30_patch_dv -print >/home/mayank/all_write/$filename_vikings 2>&1
/home/mayank/scripts/concise_output "Generating merge report from mayank_592_30_patch_dv thirdparty"
cleartool findmerge ./thirdparty -ftag mayank_592_30_patch_dv -print >/home/mayank/all_write/$filename_thirdparty 2>&1
/home/mayank/scripts/concise_output "Generating merge report from mayank_592_30_patch_dv ems"
cleartool findmerge ./ems -ftag mayank_592_30_patch_dv -print >/home/mayank/all_write/$filename_ems 2>&1


#592 main

from_release="5.9.2"
filename_common=$from_release"_to_"$to_release"_COMMON.txt"
filename_vikings=$from_release"_to_"$to_release"_VIKINGS.txt"
filename_thirdparty=$from_release"_to_"$to_release"_THIRDPARTY.txt"
filename_ems=$from_release"_to_"$to_release"_EMS.txt"

#/home/mayank/scripts/concise_output "Generating merge report from mayank_592_dv common"
#cleartool findmerge ./common -ftag mayank_592_dv -print >/home/mayank/all_write/$filename_common 2>&1
#/home/mayank/scripts/concise_output "Generating merge report from mayank_592_dv vikings"
#cleartool findmerge ./vikings -ftag mayank_592_dv -print >/home/mayank/all_write/$filename_vikings 2>&1
#/home/mayank/scripts/concise_output "Generating merge report from mayank_592_dv thirdparty"
#cleartool findmerge ./thirdparty -ftag mayank_592_dv -print >/home/mayank/all_write/$filename_thirdparty 2>&1
#/home/mayank/scripts/concise_output "Generating merge report from mayank_592_dv ems"
#cleartool findmerge ./ems -ftag mayank_592_dv -print >/home/mayank/all_write/$filename_ems 2>&1

/home/mayank/scripts/end_script


#exit

#cleartool findmerge ./common -ftag kp_5.9.0.20_main  -print >/home/kpatil/merge_reports/590_20_main_TO_591_COMMON.txt 2>&1
#cleartool findmerge ./vikings -ftag kp_5.9.0.20_main  -print  >/home/kpatil/merge_reports/590_20_main_TO_591_VIKINGS.txt 2>&1
#cleartool findmerge ./ems -ftag kp_5.9.0.20_main  -print  >/home/kpatil/merge_reports/590_20_main_TO_591_EMS.txt 2>&1
#cleartool findmerge ./thirdparty -ftag kp_5.9.0.20_main  -print  >/home/kpatil/merge_reports/590_20_main_TO_591_THIRDPARTY.txt 2>&1
exit 0;

#cleartool findmerge ./common -ftag kam_5.8.2 -print >/home/kpatil/merge_reports/582_to_5.9_main_COMMON.txt 2>&1
#cleartool findmerge ./vikings -ftag kam_5.8.2 -print >/home/kpatil/merge_reports/582_to_5.9_main_VIKINGS.txt 2>&1
#cleartool findmerge ./ems -ftag kam_5.8.2 -print >/home/kpatil/merge_reports/582_to_5.9_main_EMS.txt 2>&1
#cleartool findmerge ./thirdparty -ftag kam_5.8.2 -print >/home/kpatil/merge_reports/582_to_5.9_main_THIRDPARTY.txt 2>&1
exit 0;

#cleartool findmerge ./common -ftag kp_590_20_snowy -print >/home/kpatil/merge_reports/590_20_snowy_TO_591_snowy_COMMON.txt 2>&1
#cleartool findmerge ./vikings -ftag kp_590_20_snowy -print >/home/kpatil/merge_reports/590_20_snowy_TO_591_snowy_VIKINGS.txt 2>&1
#cleartool findmerge ./ems -ftag kp_590_20_snowy -print >/home/kpatil/merge_reports/590_20_snowy_TO_591_snowy_EMS.txt 2>&1
#cleartool findmerge ./thirdparty -ftag kp_590_20_snowy -print >/home/kpatil/merge_reports/590_20_snowy_TO_591_snowy_THIRDPARTY.txt 2>&1
exit 0;


#cleartool findmerge ./common -ftag kp_582_30_patch -print >/home/kpatil/merge_reports/582_30patch_to_582_common.txt 2>&1
#cleartool findmerge ./vikings -ftag kp_582_30_patch -print >/home/kpatil/merge_reports/582_30patch_to_582_vikings.txt 2>&1
#cleartool findmerge ./ems -ftag kp_582_30_patch -print >/home/kpatil/merge_reports/582_30patch_to_582_ems.txt 2>&1
#cleartool findmerge ./thirdparty -ftag kp_582_30_patch -print >/home/kpatil/merge_reports/582_30patch_to_582_thirdparty.txt 2>&1


# kp_582_43_patch
#cleartool findmerge ./common -ftag kp_582_43_patch -print >/home/kpatil/merge_reports/582_43patch_to_582_common.txt 2>&1
#cleartool findmerge ./vikings -ftag kp_582_43_patch -print >/home/kpatil/merge_reports/582_43patch_to_582_vikings.txt 2>&1
#cleartool findmerge ./ems -ftag kp_582_43_patch -print >/home/kpatil/merge_reports/582_43patch_to_582_ems.txt 2>&1
#cleartool findmerge ./thirdparty -ftag kp_582_43_patch -print >/home/kpatil/merge_reports/582_43patch_to_582_thirdparty.txt 2>&1


# kp_582_44_patch
#cleartool findmerge ./common -ftag kp_582_44_patch -print >/home/kpatil/merge_reports/582_44patch_to_582_common.txt 2>&1
#cleartool findmerge ./vikings -ftag kp_582_44_patch -print >/home/kpatil/merge_reports/582_44patch_to_582_vikings.txt 2>&1
#cleartool findmerge ./ems -ftag kp_582_44_patch -print >/home/kpatil/merge_reports/582_44patch_to_582_ems.txt 2>&1
#cleartool findmerge ./thirdparty -ftag kp_582_44_patch -print >/home/kpatil/merge_reports/582_44patch_to_582_thirdparty.txt 2>&1


exit 0;

#cleartool findmerge ./ems -ftag kp_snowy -print >/home/kpatil/merge_reports/582_snowy_to_5.9_snowy_EMS.txt 2>&1
#cleartool findmerge ./common -ftag kp_snowy -print >/home/kpatil/merge_reports/582_snowy_to_5.9_snowy_COMMON.txt 2>&1
#cleartool findmerge ./vikings -ftag kp_snowy -print >/home/kpatil/merge_reports/582_snowy_to_5.9_snowy_VIKINGS.txt 2>&1
#cleartool findmerge ./thirdparty -ftag kp_snowy -print >/home/kpatil/merge_reports/582_snowy_to_5.9_snowy_THIRDPARTY.txt 2>&1

exit 0

exit 

#cleartool findmerge ./common -ftag kam_5.8.2 -print >/home/kpatil/merge_reports/582_Main_to_Snowy_COMMON.txt 2>&1
#cleartool findmerge ./vikings -ftag kam_5.8.2 -print >/home/kpatil/merge_reports/582_Main_to_Snowy_VIKINGS.txt 2>&1
#cleartool findmerge ./thirdparty -ftag kam_5.8.2 -print >/home/kpatil/merge_reports/582_Main_to_Snowy_THIRDPARTY.txt 2>&1

exit


#cleartool findmerge ./common -ftag kp_582_20_patch -print >/home/kpatil/merge_reports/582_20patch_to_582_common.txt 2>&1
#cleartool findmerge ./vikings -ftag kp_582_20_patch -print >/home/kpatil/merge_reports/582_20patch_to_582_vikings.txt 2>&1
#cleartool findmerge ./ems -ftag kp_582_20_patch -print >/home/kpatil/merge_reports/582_20patch_to_582_ems.txt 2>&1
#cleartool findmerge ./thirdparty -ftag kp_582_20_patch -print >/home/kpatil/merge_reports/582_20patch_to_582_thirdparty.txt 2>&1


exit 

exit 0

#cleartool findmerge ./common -ftag kp_57a_sj -print >/home/kpatil/merge_reports/57a_to_582_common.txt 2>&1
#cleartool findmerge ./vikings -ftag kp_57a_sj -print >/home/kpatil/merge_reports/57a_to_582_vikings.txt 2>&1
#cleartool findmerge ./ems -ftag kp_57a_sj -print >/home/kpatil/merge_reports/57a_to_582_ems.txt 2>&1
#cleartool findmerge ./thirdparty -ftag kp_57a_sj -print >/home/kpatil/merge_reports/57a_to_582_thirdparty.txt 2>&1

#cleartool findmerge ./common -ftag kp_5710_60 -print >/home/kpatil/merge_reports/5710_60_patch_to_582_common.txt 2>&1
#cleartool findmerge ./vikings -ftag kp_5710_60 -print >/home/kpatil/merge_reports/5710_60_patch_to_582_vikings.txt 2>&1
#cleartool findmerge ./ems -ftag kp_5710_60 -print >/home/kpatil/merge_reports/5710_60_patch_to_582_ems.txt 2>&1
#cleartool findmerge ./thirdparty -ftag kp_5710_60 -print >/home/kpatil/merge_reports/5710_60_patch_to_582_thirdparty.txt 2>&1

#cleartool findmerge ./common -ftag kpatil_shasta -print >/home/kpatil/merge_reports/merge_from_581_to_582_common.txt 2>&1
#cleartool findmerge ./vikings -ftag kpatil_shasta -print >/home/kpatil/merge_reports/merge_from_581_to_582_vikings.txt 2>&1
#cleartool findmerge ./ems -ftag kpatil_shasta -print >/home/kpatil/merge_reports/merge_from_581_to_582_ems.txt 2>&1
#cleartool findmerge ./thirdparty -ftag kpatil_shasta -print >/home/kpatil/merge_reports/merge_from_581_to_582_thirdparty.txt 2>&1


#cleartool findmerge ./common -ftag kp_5710_60 -print >/home/kpatil/mrep_frm_5710_60_common.txt 2>&1
#cleartool findmerge ./vikings -ftag kp_5710_60 -print >/home/kpatil/mrep_frm_5710_60_vikings.txt 2>&1
#cleartool findmerge ./ems -ftag kp_5710_60 -print >/home/kpatil/mrep_frm_5710_60_ems.txt 2>&1
#cleartool findmerge ./thirdparty -ftag kp_5710_60 -print >/home/kpatil/mrep_frm_5710_60_thirdparty.txt 2>&1


#cleartool findmerge ./common -ftag kp_5.8.0 -print >/home/kpatil/merge_report_from_580_common.txt 2>&1
#cleartool findmerge ./vikings -ftag kp_5.8.0 -print >/home/kpatil/merge_report_from_580_vikings.txt 2>&1
#cleartool findmerge ./ems -ftag kp_5.8.0 -print >/home/kpatil/merge_report_from_580_ems.txt 2>&1
#cleartool findmerge ./thirdparty -ftag kp_5.8.0 -print >/home/kpatil/merge_report_from_580_thirdparty.txt 2>&1


#cleartool findmerge ./common -ftag kpatil_shasta -print >/home/kpatil/merge_reports/581_20_to_5822_common.txt 2>&1
#cleartool findmerge ./vikings -ftag kpatil_shasta -print >/home/kpatil/merge_reports/581_20_to_5822_vikings.txt 2>&1
#cleartool findmerge ./ems -ftag kpatil_shasta -print >/home/kpatil/merge_reports/581_20_to_5822_ems.txt 2>&1
#cleartool findmerge ./thirdparty -ftag kpatil_shasta -print >/home/kpatil/merge_reports/581_20_to_5822_thirdparty.txt 2>&1


