set HOME_DIR1=%1
set HOME_DIR2=%HOME_DIR1:D:\Dev\CS=s:\okatz%
set FILE_BASE_FOLDER=%HOME_DIR1:D:\Dev\CS=\home\okatz\dev-newton%
set HOME_DIR1=%HOME_DIR1:\=\\%
set HOME_DIR2=%HOME_DIR2:\=\\%
set FILE_BASE_FOLDER=%FILE_BASE_FOLDER:\=\/%
set COMPARE_COMMAND="C:\\Program Files (x86)\\Beyond Compare 2\\BC2.exe"

echo s/%FILE_BASE_FOLDER%\(.*\)/call %COMPARE_COMMAND% %HOME_DIR1%\1 %HOME_DIR2%\1/g > %1\Compare.sed
W:\TornadoNE2.2PQ3.010\host\x86-win32\bin\sed.exe -f %1\Compare.sed %HOME_DIR2%\checkout.log > %1/Compare.bat
rem del %1\Compare.sed

rem c:\cygwin\bin\ssh.exe okatz@127.0.0.1 "/cygdrive/d/Dev/CS/scripts/sourceinsight/CreateCompareScript.sh %HOME_DIR1% %HOME_DIR2% %FILE_BASE_FOLDER% checkout.log"
call %1\Compare.bat
