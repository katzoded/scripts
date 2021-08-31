echo off
set FileName=%1
set BaseFolder=%2
set FileName=%FileName:D:\Dev\CS=~\dev-newton%
set FileName=%FileName:D:\dev-newton=~\dev-newton%
set FileName=%FileName:s:\okatz=~\dev-newton%
set FileName=%FileName:\=/%
set BaseFolder=%BaseFolder:D:\Dev\CS=~\dev-newton%
set BaseFolder=%BaseFolder:D:\dev-newton=~\dev-newton%
set BaseFolder=%BaseFolder:\=/%
echo %FileName%

echo #include "%~nx1"
