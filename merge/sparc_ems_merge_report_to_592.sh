#!/bin/sh



/home/mayank/scripts/start_script



cd /vobs



/home/mayank/scripts/concise_output "Generating merge report from mayank_5.8.2_dv"



# 5.8.2 to 5.9.2 sparc EMS

cleartool findmerge ./ems -ftag mayank_5.8.2_dv -print >/home/mayank/all_write/5.8.2_to_5.9.2_SPARC_EMS.txt 2>&1



/home/mayank/scripts/concise_output "Generating merge report from mayank_5.9.0.20_main_dv"



# 5.9.0 to 5.9.2 sparc EMS

cleartool findmerge ./ems -ftag mayank_5.9.0.20_main_dv -print >/home/mayank/all_write/590_20_to_5.9.2_SPARC_EMS 2>&1



/home/mayank/scripts/concise_output "Generating merge report from mayank_5.9_dv"



# 5.9.1 to 5.9.2 sparc ems

cleartool findmerge ./ems -ftag mayank_5.9_dv -print >/home/mayank/all_write/5.9.1_to_5.9.2_SPARC_EMS.txt 2>&1



/home/mayank/scripts/end_script







