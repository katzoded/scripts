set FileName=%1
set BaseFolder=%2
set FileName=%FileName:D:\Dev\CS=~/dev-newton%
set FileName=%FileName:D:\dev-newton=~/dev-newton%
set FileName=%FileName:\=/%
set BaseFolder=%BaseFolder:D:\Dev\CS=~/dev-newton%
set BaseFolder=%BaseFolder:D:\dev-newton=~/dev-newton%
set BaseFolder=%BaseFolder:\=/%
title change local file mode %FileName% 
rem C:\Cygwin\bin\ssh.exe okatz@ "chmod o+wr,g+wr,u+wr %FileName%; echo %FileName% >> %BaseFolder%/checkout.log"
C:\Cygwin\bin\ssh.exe okatz@127.0.0.1 "/cygdrive/d/Dev/scripts/sourceinsight/ChangeModeAndAddToCheckoutList.sh %FileName% %BaseFolder%"
