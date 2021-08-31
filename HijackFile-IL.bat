set FileName=%1
set BaseFolder=%2
set FileName=%FileName:D:\Dev\CS=~\dev-newton%
set FileName=%FileName:s:\okatz=~\dev-newton%
set FileName=%FileName:\=/%
set BaseFolder=%BaseFolder:D:\Dev\CS=~\dev-newton%
set BaseFolder=%BaseFolder:\=/%
rem C:\Cygwin\bin\ssh.exe okatz@172.29.14.111 "chmod o+wr,g+wr,u+wr %FileName%; echo %FileName% >> %BaseFolder%/checkout.log"
title Hijack file %FileName%
C:\Cygwin\bin\ssh.exe okatz@172.29.14.111 "~/dev-newton/scripts/sourceinsight/ChangeModeOnlyAddToHijackList.sh %FileName% %BaseFolder%"