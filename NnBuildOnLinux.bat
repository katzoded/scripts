set MODULE_NAME=%1
set BASE_FOLDER=%2
set BIN_SRC_NAME=%3
set BIN_DST_NAME=%4
set TESTBED_IP=%

set BASE_FOLDER=%BASE_FOLDER:D:\Dev\CS=~\%
set BASE_FOLDER=%BASE_FOLDER:\=/%

title Build On Linux %MODULE_NAME% for release %BASE_FOLDER%
C:\Cygwin\bin\ssh.exe okatz@farmer "~/scripts/sourceinsight/bnbuild.sh %MODULE_NAME% %BASE_FOLDER% %BIN_SRC_NAME% %BIN_DST_NAME% %TESTBED_IP%; exit"