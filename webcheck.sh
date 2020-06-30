#!/bin/bash

# Author: R Owen (@largeduck)
# Description: Check web connection and alert user of outages
# Requirements: install msmtp and mailutils and configure your smtp server (sudo nano /etc/msmtprc)
# Usage: Run it with ./webcheck.sh &

# Settings
log=~/.webcheck.log                 # log file
targetSite=8.8.8.8                  # site to check connection (ip address or hostname)
checkInterval=5                     # seconds between each comms checks
emailThreshold=15                   # minimum seconds of downtime before emai is sent
recipient=richardowenx@gmail.com    # email recipient

# Initialise some variables
down=false
up=false
alert=false

echo "---------------------------------------------" >> $log
echo "$(date +'%Y-%m-%d %T') :  webcheck started" >> $log

while (true)
 do
    # Test the internet connection (1 quiet ping with a 2 sec timeout)
    if ping -q -c 1 -W 2 $targetSite >/dev/null; then

      # If we were DOWN before then record the interruption end time and mark comms UP
      if ($down) then
        end=$(date +%T)
        endEpoch=$(date +%s)
        echo "$(date +'%Y-%m-%d %T') :  End of interuption [$end]" >> $log
        up=true
        down=false
        alert=true
      else
        if !($up) then
          echo "$(date +'%Y-%m-%d %T') :  Connection UP" >> $log
          up=true
        fi
      fi
    else
      echo "$(date +'%Y-%m-%d %T') :  Connection DOWN" >> $log

      # If we were UP before then record the interruption start time and mark comms DOWN
      if ($up) then
        start=$(date +%T)
        startEpoch=$(date +%s)
        echo "$(date +'%Y-%m-%d %T') :  Start of interuption [$start]" >> $log
        up=false
        down=true
      fi

    fi

    if ($alert) then
      downtime=$(($endEpoch-$startEpoch))
      echo "$(date +'%Y-%m-%d %T') :  Connection was down for $downtime seconds between $start and $end" >> $log
      echo "$(date +'%Y-%m-%d %T') :  Connection back UP" >> $log

      if [ $downtime -ge $emailThreshold ]
      then
        echo "$(date +'%Y-%m-%d %T') :  Sending email to $recipient" >> $log
        subject="Connection down for $downtime seconds from $start to $end"
        mail -s $subject -aFrom:Webcheck\<webcheck@pi\> $recipient <<< ''
      else
        echo "$(date +'%Y-%m-%d %T') :  Not sending email as downtime is below threshold [$emailThreshold]" >> $log
      fi

      alert=false
    fi

    sleep $checkInterval
 done
