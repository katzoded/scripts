echo on 
set FileName=%1
set FileName=%FileName:D:\Dev\EmbeddedDev=t:\users\okatz\dev%
set FileName=%FileName:\A7=%
title copy %1 for newton %FileName%
attrib -R %FILENAME%
copy %1 %FILENAME%