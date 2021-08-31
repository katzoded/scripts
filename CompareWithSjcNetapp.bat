set FileName=%1
set FileName=%FileName:D:\Dev\CS\git=q:\okatz%
set FileName=%FileName:D:\Dev-newton\git=q:\okatz%
if ("%FileName%"=="%1") then
	set FileName=%FileName:D:\Dev\CS=q:\okatz%
	set FileName=%FileName:D:\Dev-newton=q:\okatz%
end
set FileName=%FileName:\gen\=\%
"C:\Program Files\Beyond Compare 4\BCompare.exe" "%1" "%FILENAME%"
