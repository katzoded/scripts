#!/usr/bin/bash -x

export HOME_DIR1=${1//\\/\\\\}

export HOME_DIR2=${2//\\/\\\\}

export CHECKOUT_HOME_DIR=${3//\//\\\/}

export CHECKOUT_FILENAME=$4

export COMPARE_COMMAND='"C:\\Program Files (x86)\\Beyond Compare 2\\BC2.exe"'



echo "s/$CHECKOUT_HOME_DIR\(.*\)/call $COMPARE_COMMAND $HOME_DIR1\1 $HOME_DIR2\1/g" > /tmp/${USER}Compare.sed

sed -f /tmp/${USER}Compare.sed $3/$4 > $3/Compare.bat

rm /tmp/${USER}Compare.sed



