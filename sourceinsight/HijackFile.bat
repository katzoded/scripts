set FileName=%1
set BaseFolder=%2
rem set FileName=%FileName:D:\Dev\CS=~\dev-newton%
set FileName=%FileName:D:\Dev\CS=~\%
rem set FileName=%FileName:s:\okatz=~\dev-newton%
set FileName=%FileName:s:\okatz=~\%
set FileName=%FileName:\=/%
rem set BaseFolder=%BaseFolder:D:\Dev\CS=~\dev-newton%
set BaseFolder=%BaseFolder:D:\Dev\CS=~\%
set BaseFolder=%BaseFolder:\=/%
rem C:\Cygwin\bin\ssh.exe okatz@172.29.14.111 "chmod o+wr,g+wr,u+wr %FileName%; echo %FileName% >> %BaseFolder%/checkout.log"
C:\Cygwin\bin\ssh.exe okatz@10.2.2.92 "~/scripts/sourceinsight/ChangeModeOnlyAddToHijackList.sh %FileName% %BaseFolder%"