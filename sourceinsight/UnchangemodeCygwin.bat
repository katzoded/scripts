set FileName=%1
set BaseFolder=%2
set FileName=%FileName:D:\Dev=/cygdrive/d/Dev%
set FileName=%FileName:\=/%
set BaseFolder=%BaseFolder:D:\Dev=/cygdrive/d/Dev%
set BaseFolder=%BaseFolder:\=/%
rem C:\Cygwin\bin\ssh.exe okatz@santana "chmod o+wr,g+wr,u+wr %FileName%; echo %FileName% >> %BaseFolder%/checkout.log"
C:\Cygwin\bin\ssh.exe okatz@127.0.0.1 "/cygdrive/d/Dev/scripts/sourceinsight/ChangeModeAndAddToCheckoutList.sh %FileName% %BaseFolder%"