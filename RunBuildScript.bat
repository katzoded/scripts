set BASE_FOLDER=%1
set ScriptFolder=%2
set ScriptFileName=%3
set Server=%4
set Params=%5

set BASE_FOLDER=%BASE_FOLDER:D:\Dev\CS=~\dev-newton%
set BASE_FOLDER=%BASE_FOLDER:D:\dev-newton=~\dev-newton%
set BASE_FOLDER=%BASE_FOLDER:\=/%
set BASE_FOLDER=%BASE_FOLDER:dev-newton=%

set ScriptFolder=%ScriptFolder:D:\dev-newton=~\dev-newton%
set ScriptFolder=%ScriptFolder:D:\Dev\CS=~\dev-newton%
set ScriptFolder=%ScriptFolder:\=/%
set ScriptFolder=%ScriptFolder:dev-newton=%

title run script on %Server% script name %ScriptFileName% for release %BASE_FOLDER%

c:\cygwin\bin\ssh.exe okatz@%Server% '~/scripts/sourceinsight/PrepareAndRunScript.sh %BASE_FOLDER% %ScriptFolder% %ScriptFileName% %Params%'
