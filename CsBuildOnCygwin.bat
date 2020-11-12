set MODULE_NAME=%1
set BASE_FOLDER=%2
set BASE_FOLDER=%BASE_FOLDER:D:\Dev\CS=/cygdrive/d/Dev/CS%
set BASE_FOLDER=%BASE_FOLDER:\=/%
title Build On cygwin %MODULE_NAME% for release %BASE_FOLDER%

set PATH=c:\Cygwin\home\okatz\work\utils;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Windows\SUA\common\;C:\Windows\SUA\usr\lib\ 
set EXEC_EXT=.exe
C:\Cygwin\bin\ssh.exe 127.0.0.1 "/cygdrive/d/Dev/CS/scripts/sourceinsight/build.sh %MODULE_NAME% %BASE_FOLDER% %BIN_SRC_NAME% %BIN_DST_NAME% %TESTBED_IP%; exit"
