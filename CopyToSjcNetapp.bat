set FileName=%1
set FileName=%FileName:D:\Dev\CS=~\dev-newton%
set FileName=%FileName:D:\=~\%
set SrcFileName=%FileName:\=/%
set DstFileName=%FileName:dev-newton=%
set DstFileName=%DstFileName:\git=%
set DstFileName=%DstFileName:\=/%

title copy %1 for sjc-netapp %FileName%
rem copy %1 %FILENAME%

C:\Cygwin\bin\scp.exe %SrcFileName% okatz@10.2.2.92:%DstFileName%
