set FileName=%1
set BASE_FOLDER=%2
set FILE_BASE_FOLDER=%3

set BASE_FOLDER=%BASE_FOLDER:D:\Dev\CS=~\dev-newton%
set BASE_FOLDER=%BASE_FOLDER:\=/%

set FILE_BASE_FOLDER=%FILE_BASE_FOLDER:D:\Dev\CS=~\dev-newton%
set FILE_BASE_FOLDER=%FILE_BASE_FOLDER:\=/%

title lib Build only on Cygwin %FILE_BASE_FOLDER% %FileName% for release %BASE_FOLDER%

c:\cygwin\bin\ssh.exe okatz@127.0.0.1 "~/scripts/sourceinsight/direct_compile.sh %FileName% %BASE_FOLDER% %FILE_BASE_FOLDER%"
