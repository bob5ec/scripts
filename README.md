scripts
=======
* websitecheck is a script which checks a website for changes and notifies you via mail if it changes.

* check_command.sh is a shell script which limites the access for a remote ssh connections.
This can be used for remote plugin execution of icinga or nagios monitoring scripts. You
just have to put the following lines to the host you want to monitor:

/home/icinga/.ssh/authorized_keys: 
command="/etc/icinga/check_command.sh",no-pty,no-port-forwarding,no-X11-forwarding,no-agent-forwarding <publickey> 
