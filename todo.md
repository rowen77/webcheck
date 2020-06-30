## To Do
* make the github repo work on dev branch by default
* convert the github repo to ssh from https
* make the 5 sec sleep a param
* send email when web down
* only send email if > 10 sec
* add the email params at the top of the file
* make the target email address an command line argument
* make it accept a list of comma separated email addresses
* don't send email if a local ip address is also unreachable
* make the local ip check an optional switch
* make the local ip check a command line arg
* get the local gateway ip with /sbin/ip route | awk '/default/ { print $3 }'
* add a --help switch
* add a man page
* make it a service (crontab)
* put the params in a config file in /etc
* check if email is possible (msmtp/mailutils dependencies)
* warning if the email address isn't configured properly
* error on email fail
* work out how to send a local LAN notification when connection goes down
* create a installer "package" from github

## Done
### 2020-06-28
* Don't log every network check
### 2020-06-27
* Detect network down events
* output to log
* Recognise network recovery events
* Parameterise logfile location and target host
* create the logfile if it doesn't exist
* Timestamps in log
* Measure/report outage and downtime
* add to a github repo and use VSC

