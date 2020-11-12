#!/usr/bin/tcsh
echo cleartool find ./common -name \'\*\' -ver \'lbtype\(${1}\) \&\& ! lbtype\(${2}\)\' -print
echo cleartool find ./vikings -name \'\*\' -ver \'lbtype\(${1}\) \&\& ! lbtype\(${2}\)\' -print
echo cleartool find ./thirdparty -name \'\*\' -ver \'lbtype\(${1}\) \&\& ! lbtype\(${2}\)\' -print
echo cleartool find ./ems -name \'\*\' -ver \'lbtype\(${1}\) \&\& ! lbtype\(${2}\)\' -print
