# webcheck

A simple shell script to check your web connection and alert user of outages.

## Description

My home internet connection cuts out for ~2 minutes several times a week.  To save me from always
finding out the hard way I wanted a tool which would constantly monitor the web connection from
my raspberry pi and alert me immediately and/or record substantial outages by sending me emails.
If the computer loses WiFi this shouldn't trigger an outage email.

### Dependencies

```
sudo apt-get install msmtp mailutils 
```
Don't forget to configure your smtp server:
```
sudo vi /etc/msmtprc
```

### Installing

The `webcheck.sh` script can be stored anywhere.  
Don't forget to `chmod +x` the script.  
I like to store it in `~/bin` and create a symbolic link:
```
ln -s ~/bin/webcheck.sh ~/bin/webcheck
```

### Executing

Run it alone or with a recipient email address:

```
webcheck.sh &
webcheck.sh name@example.com &
```

## Help

Output will be written to `~/.webcheck.log`

## Author

Richard Owen
[@largeduck](https://twitter.com/largeduck)

## Version History

See `todo.md`

## Ackknowledgements

I took some inspiration from  
https://unix.stackexchange.com/questions/190513/shell-scripting-proper-way-to-check-for-internet-connectivity
