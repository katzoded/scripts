set BASE_FOLDER=%1
set SERVER=%2
set COMMAND=%3

echo set ScriptFolder=%%ScriptFolder:%BASE_FOLDER%=%% >c:\temp\temp.bat
call c:\temp\temp.bat
rem del c:\temp\temp.bat

set BASE_FOLDER=%BASE_FOLDER:D:\Dev\CS=~\%
set BASE_FOLDER=%BASE_FOLDER:D:\dev-newton=~\%
set BASE_FOLDER=%BASE_FOLDER:\git=%
set BASE_FOLDER=%BASE_FOLDER:\=/%
set ScriptFolder=%ScriptFolder:\=/%
set COMMAND=%COMMAND:\"=%

title Build On %SERVER% %ScriptFolder% for release %BASE_FOLDER%
C:\Cygwin\bin\ssh.exe okatz@%SERVER% "cd %BASE_FOLDER%;%COMMAND%"

