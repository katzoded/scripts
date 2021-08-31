set DEST_FILE_NAME=%2\%1
set SS_FILE_NAME=%2\%1
set ROOT_PATH=%3
set SSDIR=x:\%4
set SSPASS=%5
set EXTRA_REGEXP=%6

set SS_FILE_NAME=%SS_FILE_NAME:okatz\=%
set SS_FILE_NAME=%SS_FILE_NAME:D:\Dev\EmbeddedDev=$%
set SS_FILE_NAME=%SS_FILE_NAME:S:\Dev\EmbeddedDev=$%
set SS_FILE_NAME=%SS_FILE_NAME:\A7=%
set SS_FILE_NAME=%SS_FILE_NAME:\=/%
rem set SS_FILE_NAME=%SS_FILE_NAME:%EXTRA_REGEXP%

mkdir c:\temp\ss-compare

Pushd c:\temp\ss-compare
ss.exe get -Y%USERNAME%,%SSPASS% %SS_FILE_NAME% -GL. -GWA
popd

"C:\Program Files (x86)\Beyond Compare 2\BC2.exe" "%2\%1" "c:\temp\ss-compare\%1"

