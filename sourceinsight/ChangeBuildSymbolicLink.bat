set BASE_FOLDER=%1
set ScriptFolder=%2
set SERVER=%3
set Prefix=%4
set Version=%5

echo set ScriptFolder=%%ScriptFolder:%BASE_FOLDER%=%% >c:\temp\temp.bat
call c:\temp\temp.bat
rem del c:\temp\temp.bat

set BASE_FOLDER=%BASE_FOLDER:D:\dev-newton\=%
set BASE_FOLDER=%BASE_FOLDER:D:\Dev\CS\=%
set BASE_FOLDER=%BASE_FOLDER:git\=%
set BASE_FOLDER=%BASE_FOLDER:\=/%
set ScriptFolder=%ScriptFolder:\=/%

IF "%Version%" NEQ "" SET Version=.%Version%

title Build On %SERVER% %ScriptFolder% for release %BASE_FOLDER%
C:\Cygwin\bin\ssh.exe okatz@%SERVER% "rm ~/%BASE_FOLDER%.build; ln -s ~/%BASE_FOLDER%.build.%Prefix%%Version% ~/%BASE_FOLDER%.build; exit"
