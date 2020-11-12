set FileName=%1
set FileName=%FileName:D:\Dev\CS=s:\okatz%
set FileName=%FileName:D:\dev-newton=~\dev-newton%
set FileName=%FileName:D:\Dev\CS=~\dev-newton%
set FileName=%FileName:D:\Dev\EmbeddedDev=~\dev-newton\Dev\EmbeddedDev%
set FileName=%FileName:s:\okatz=~\dev-newton%
set FileName=%FileName:\=/%

title copy %1 for newton %FileName%
rem copy %1 %FILENAME%

C:\Cygwin\bin\scp.exe %FileName% okatz@172.29.14.175:%FileName%
