set DEST_FILE_NAME=%1
set SS_FILE_NAME=%1
set ROOT_PATH=%3
set SSDIR=\\172.29.1.220\archive\%4
set SSPASS=%5

set SS_FILE_NAME=%SS_FILE_NAME:D:\Dev\EmbeddedDev=$%
set SS_FILE_NAME=%SS_FILE_NAME:\A7=%
set SS_FILE_NAME=%SS_FILE_NAME:\=/%
Pushd %2
"C:\Program Files (x86)\Microsoft Visual Studio\Common\VSS\win32\ss.exe" undocheckout -Y%USERNAME%,%SSPASS% %SS_FILE_NAME% -GL. -GWA
popd


