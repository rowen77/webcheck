# List Of Things To Do
## To Do
* make the github repo work on dev branch by default
* add a --help switch
* test it on something other than a raspberry pi
* add a man page
* make it a service (crontab)
* put the params in a config file in /etc
* check if email is possible (msmtp/mailutils dependencies)
* warning if the email address isn't configured properly
* error on email fail
* work out how to send a local LAN notification when connection goes down
* create a installer "package" using github

## Done
### 2020-07-01
* make the target email address a command line argument
* allow email to be an optional parameter
* accept a list of comma separated email addresses

### 2020-06-30
* convert the github repo to ssh from https
* make the 5 sec sleep a param
* send email when web down
* put params and data into the email subject line
* only send email if downtime >= threshold
* add the email params at the top of the file
* get the local gateway ip
* don't send email if a local ip address is also unreachable

### 2020-06-29
* add to a github repo and use VSC

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
