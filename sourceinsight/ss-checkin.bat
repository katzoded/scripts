set DEST_FILE_NAME=%1
set SS_FILE_NAME=%1
set ROOT_PATH=%3
set SSDIR=x:\%4
set SSPASS=%5

set SS_FILE_NAME=%SS_FILE_NAME:D:\Dev\EmbeddedDev=$%
set SS_FILE_NAME=%SS_FILE_NAME:S:\Dev\EmbeddedDev=$%
set SS_FILE_NAME=%SS_FILE_NAME:\A7=%
rem set SS_FILE_NAME=%SS_FILE_NAME:\CMG=%
set SS_FILE_NAME=%SS_FILE_NAME:\=/%
Pushd %2
ss.exe checkin -Y%USERNAME%,%SSPASS% %SS_FILE_NAME% -GL. -GWA -C-
echo %DATE%>>%ROOT_PATH%\checkin.log
echo %DEST_FILE_NAME%>>%ROOT_PATH%\checkin.log
popd


