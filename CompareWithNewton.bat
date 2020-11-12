set FileName=%1
set FileName=%FileName:D:\Dev\CS=s:\okatz%
set FileName=%FileName:D:\dev-newton=s:\okatz%
set FileName=%FileName:git\=%
set FileName=%FileName:\gen\=\%
"c:\Program Files\Beyond Compare 4\BCompare.exe" "%1" "%FILENAME%"
