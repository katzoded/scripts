set MODULE_NAME=%1
set BIN_SRC_NAME=%2
set BIN_DST_NAME=%3
set TESTBED_IP=%4
title Build On santana %MODULE_NAME%

set PATH=c:\Cygwin\home\okatz\work\utils;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Windows\SUA\common\;C:\Windows\SUA\usr\lib\ 
set WORK=/home/okatz/work
set EXEC_EXT=.exe

C:\Cygwin\bin\ssh.exe 127.0.0.1
