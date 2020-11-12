#!/bin/ksh

apex_file='/home/mayank/'

#
#  Initialization
#
initialize()
{

tmp_dir=/tmp

def_oracle_base=/u01/app/oracle
def_oracle_home=$def_oracle_base/product/11.2.0
oracle_base=${ORACLE_BASE:-$def_oracle_base}
oracle_home=${ORACLE_HOME:-$def_oracle_home}
oracle_sid=$ORACLE_SID

apex_owner=APEX_040000

tmp_dir=/tmp
oracle_base=$ORACLE_BASE
oracle_host=$(/bin/hostname)

} # end initialize

#
#  Install APEX Applications
#
create_apex_apps()
{
    echo 'create_apex_apps'
    echo $apex_file
$oracle_home/bin/sqlplus <<!EOF!
    whenever sqlerror exit sql.sqlcode
    connect / as sysdba
    whenever sqlerror continue
    spool /tmp/apx_compile.out

    ALTER SESSION SET CURRENT_SCHEMA = $apex_owner;

    @ $apex_file

    exit
!EOF!
retstat=$?
if [ $retstat -ne 0 ];  then
    echo "Error occurred in connecting to database when creating applications."
    exit 4
fi

} # end create_apex_apps

#
#  Main line
#
initialize $*
apex_file=/home/mayank/$1
create_apex_apps
echo Imported $1
