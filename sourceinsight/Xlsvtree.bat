rem echo off
set FileName=%1
set BaseFolder=%2
set FileName=%FileName:D:\Dev\CS=~\dev-newton%
set FileName=%FileName:D:\dev-newton=~\dev-newton%
set FileName=%FileName:s:\okatz=~\dev-newton%
set FileName=%FileName:\=/%
set BaseFolder=%BaseFolder:D:\Dev\CS=~\dev-newton%
set BaseFolder=%BaseFolder:D:\dev-newton=~\dev-newton%
set BaseFolder=%BaseFolder:\=/%
set BaseFolder=%BaseFolder:dev-newton=%
set FileName=%FileName:dev-newton=%
echo %FileName%

C:\Cygwin\bin\ssh.exe galaxy "setenv DISPLAY galaxy:1; cd %BaseFolder%; xlsvtree %FileName%;"
rem C:\Cygwin\bin\ssh.exe galaxy "setenv DISPLAY 10.0.2.101; cd %BaseFolder%; xlsvtree %FileName%;"

