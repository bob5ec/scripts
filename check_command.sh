#!/bin/bash
# v0.1 2008.11.15 SGR inspired by http://www.vertical-visions.de/2007/07/24/nagios-check_by_ssh-sicher-auf-gewunschte-befehle-beschranken/
# v0.2 2008.11.20 SGR now with regex
# v0.3 2011-01-31 Lars used as generic command execution
#
#=vars===================
# path where the check_scripts life
strCheckDir=/usr/lib/nagios/plugins

#Allowed characters for a check_command
reg="^check_[_,0-9a-z%\/[:space:]:]{2,32}$"

#Example for debug
#SSH_ORIGINAL_COMMAND="check_procs 80:90 70:120"

#=functions===================
function do_exit
{
        echo "$1"
        exit $2
}
function do_check
{
        do_exit "`$strCheckDir/$1`" $?
}
#=main=======================
if [[ ! $SSH_ORIGINAL_COMMAND =~ $reg ]]
then
#DEBUG
#        echo "$SSH_ORIGINAL_COMMAND"
        do_exit "SSH command rejected" 3
fi

#Get vars
OFS="$IFS"
IFS=" "
set -- $SSH_ORIGINAL_COMMAND
IFS="$OFS"

#if [ -z $1 ]; then
#       do_exit "The command arg not found?!" 3
#fi

#allowed checks
case "$1" in
        check_load)
                do_check "check_load -w 1.0,1.0,1.0 -c 1.5,1.5,1.5";;
        check_all_disks)
                do_check "check_disk -w '20%' -c '10%' -e";;
        check_apt)
                do_check "check_apt";;
        check_procs)
                do_check "check_procs -w 250 -c 400";;
        check_procs_zombie)
                do_check "check_procs -w 1 -c 5 -s Z";;
        *)
                do_exit "Check ($1) not allowed" 3;;
esac
