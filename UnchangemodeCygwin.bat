set BaseFolder=%1
set BaseFolder=%BaseFolder:D:\Dev=/cygdrive/d/Dev%
set BaseFolder=%BaseFolder:\=/%
title change local file mode %FileName% 
rem C:\Cygwin\bin\ssh.exe okatz@santana "chmod o+wr,g+wr,u+wr %FileName%; echo %FileName% >> %BaseFolder%/checkout.log"
C:\Cygwin\bin\ssh.exe 127.0.0.1 "/cygdrive/d/Dev/CS/scripts/sourceinsight/UnChangeModeAndAddToCheckoutList.sh %BaseFolder%"