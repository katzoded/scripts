set BASE_FOLDER=%1.build
set ScriptFolder=%2
set SERVER=%3

set BASE_FOLDER=%BASE_FOLDER:D:\Dev\CS=~\dev-newton%
set BASE_FOLDER=%BASE_FOLDER:\=/%

set ScriptFolder=%ScriptFolder:D:\Dev\CS=~\dev-newton%
set ScriptFolder=%ScriptFolder:\=/%
set ScriptFolder=%ScriptFolder:%BASE_FOLDER%=%

title Build On Santana %ScriptFolder% for release %BASE_FOLDER%
C:\Cygwin\bin\ssh.exe okatz@%SERVER% "cd %BASE_FOLDER%/%ScriptFolder%;  time gmake -j 10; exit"
