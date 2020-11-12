set FileName=%1
set BaseFolder=%2
set FileName=%FileName:D:\Dev\CS=~\dev-newton%
set FileName=%FileName:s:\okatz=~\dev-newton%
set FileName=%FileName:\=/%
set BaseFolder=%BaseFolder:D:\Dev\CS=~\dev-newton%
set BaseFolder=%BaseFolder:\=/%
rem C:\Cygwin\bin\ssh.exe okatz@santana "chmod o+wr,g+wr,u+wr %FileName%; echo %FileName% >> %BaseFolder%/checkout.log"
C:\Cygwin\bin\ssh.exe okatz@santana "~/dev-newton/scripts/sourceinsight/ChangeModeAndAddToCheckoutList.sh %FileName% %BaseFolder%"