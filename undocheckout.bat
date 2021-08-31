set FileName=%1
set BaseFolder=%2
set LocalServer=%3
set RemoteServer=%4
set ScriptFileName=~/dev-newton/scripts/sourceinsight/UnCheckout-UnCheckoutOnGalaxyAndCopy.sh

set FileName=%FileName:D:\Dev\CS=~\dev-newton%
set FileName=%FileName:D:\dev-newton=~\dev-newton%
set FileName=%FileName:s:\okatz=~\dev-newton%
set FileName=%FileName:\=/%
set BaseFolder=%BaseFolder:D:\Dev\CS=~\dev-newton%
set BaseFolder=%BaseFolder:D:\dev-newton=~\dev-newton%
set BaseFolder=%BaseFolder:\=/%
title undo checkout %FileName%

IF "%LocalServer%" == "" set LocalServer=172.29.14.111
IF "%RemoteServer%" == "" SET RemoteServer=farmer

IF "%RemoteServer%" == "%LocalServer%" set FileName=%FileName:/dev-newton=%
IF "%RemoteServer%" == "%LocalServer%" set BaseFolder=%BaseFolder:/dev-newton=%
IF "%RemoteServer%" == "%LocalServer%" set ScriptFileName=%ScriptFileName:/dev-newton=%

C:\Cygwin\bin\ssh.exe okatz@%LocalServer% "%ScriptFileName% %FileName% %BaseFolder% %RemoteServer%"
