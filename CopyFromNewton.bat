echo off

set FileName=%1
set FileName=%FileName:D:\Dev\CS=s:\okatz%

echo "perform copy %FileName% to"
echo "%1"

set /p Response="Are you sure about copying [Y/any]" 
echo on

if NOT "%Response%" == "Y" goto end

title copy %1 for newton %FileName%
copy %FILENAME% %1

:end