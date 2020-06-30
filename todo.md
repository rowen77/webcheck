* email
* only send email if > 10 sec
* make the 5 sec sleep a param
* create the pingtest.log if it doesn't exist
* add the email params at the top of the file
* make the target email address an input param
* make it accept a list of target email addresses
* if the web is down check a local ip address
* make that an optional switch
* make the local ip a user param
* get the local gateway ip with /sbin/ip route | awk '/default/ { print $3 }'
* add a help
* add a man
* make it a service (crontab)
* github
* put the params in a config file in /etc
* check if email is posible
* error if the email isn't configured properly
* somehow send a local LAN notification when connection goes down
* check out the final script on https://unix.stackexchange.com/questions/190513/shell-scripting-proper-way-to-check-for-internet-connectivity

