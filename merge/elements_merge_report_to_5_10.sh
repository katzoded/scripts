#!/bin/bash





to_release="5.10.0.1"



rm -fr /home/mayank/all_write/*





cd /vobs



echo -n "Did you set 5.10.0.1 dynamic view [Y/N]: "

read confirmation



if [ "$confirmation" == "N" ]; then

    echo "Set correct 5.10.0.1 dynamic view before running merge reports"

    exit;

fi



if [ "$confirmation" == "n" ]; then

    echo "Set correct 5.10.0.1 dynamic view before running merge reports"

    exit;

fi



/home/mayank/scripts/start_script



from_release="5.9.2"

filename_common=$from_release"_to_"$to_release"_COMMON.txt"

filename_vikings=$from_release"_to_"$to_release"_VIKINGS.txt"

filename_thirdparty=$from_release"_to_"$to_release"_THIRDPARTY.txt"

filename_ems=$from_release"_to_"$to_release"_EMS.txt"



/home/mayank/scripts/concise_output "Generating merge report from mayank_592_dv common"

cleartool findmerge ./common -ftag mayank_592_dv -print >/home/mayank/all_write/$filename_common 2>&1

/home/mayank/scripts/concise_output "Generating merge report from mayank_592_dv vikings"

cleartool findmerge ./vikings -ftag mayank_592_dv -print >/home/mayank/all_write/$filename_vikings 2>&1

/home/mayank/scripts/concise_output "Generating merge report from mayank_592_dv thirdparty"

cleartool findmerge ./thirdparty -ftag mayank_592_dv -print >/home/mayank/all_write/$filename_thirdparty 2>&1

/home/mayank/scripts/concise_output "Generating merge report from mayank_592_dv ems"

cleartool findmerge ./ems -ftag mayank_592_dv -print >/home/mayank/all_write/$filename_ems 2>&1





/home/mayank/scripts/end_script



