set FileName=%1
set BASE_FOLDER=%2
set FILE_BASE_FOLDER=%3

set BASE_FOLDER=%BASE_FOLDER:D:\Dev\CS=~\dev-newton%
set BASE_FOLDER=%BASE_FOLDER:\=/%

set FILE_BASE_FOLDER=%FILE_BASE_FOLDER:D:\Dev\CS=~\dev-newton%
set FILE_BASE_FOLDER=%FILE_BASE_FOLDER:\=/%

title lib Build only on Solaris %FILE_BASE_FOLDER% %FileName% for release %BASE_FOLDER%

c:\cygwin\bin\ssh.exe okatz@172.29.14.111 "~/scripts/sourceinsight/direct_compile.sh %FileName% %BASE_FOLDER% %FILE_BASE_FOLDER%"
