set BASE_FOLDER=%1
set ScriptFolder=%2
set SERVER=%3
set Prefix=%4

echo set ScriptFolder=%%ScriptFolder:%BASE_FOLDER%=%% >c:\temp\temp.bat
call c:\temp\temp.bat
rem del c:\temp\temp.bat

set BASE_FOLDER=%BASE_FOLDER:D:\dev-newton\=~/%
set BASE_FOLDER=%BASE_FOLDER:D:\Dev\CS\=~/%
set BASE_FOLDER=%BASE_FOLDER:git\=%
set BASE_FOLDER=%BASE_FOLDER:\=/%
set ScriptFolder=%ScriptFolder:\=/%

title Build On %SERVER% %ScriptFolder% for release %BASE_FOLDER%
C:\Cygwin\bin\sshpass.exe -p changeme C:\Cygwin\bin\ssh.exe -oKexAlgorithms=+diffie-hellman-group1-sha1 okatz@%SERVER% "cd %BASE_FOLDER%.build/%ScriptFolder%;  time gmake %Prefix% -j 25; exit"
