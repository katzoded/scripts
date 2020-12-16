set DEST_FILE_NAME=%1
set SS_FILE_NAME=%1
set ROOT_PATH=%3
set SSDIR=x:\%4
set SSPASS=%5

set SS_FILE_NAME=%SS_FILE_NAME:okatz\=%
set SS_FILE_NAME=%SS_FILE_NAME:D:\Dev\EmbeddedDev=$%
set SS_FILE_NAME=%SS_FILE_NAME:S:\Dev\EmbeddedDev=$%
set SS_FILE_NAME=%SS_FILE_NAME:\A7=%
set SS_FILE_NAME=%SS_FILE_NAME:\=/%
Pushd %2
ss.exe undocheckout -Y%USERNAME%,%SSPASS% %SS_FILE_NAME% -GL. -GWA
popd


