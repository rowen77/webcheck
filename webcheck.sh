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
recipient=null                      # email recipient is cmd line arg (null = disable)

# Initialise some variables
down=false
up=false
alert=false


main() {
  # get the local gateway ip
  gateway=$(/sbin/ip route | awk '/default/ { print $3 }')

  echo "---------------------------------------------" >> $log
  echo "$(date +'%Y-%m-%d %T') :  $0 started" >> $log

  # Set up command line params if they exist
  if  [ $# -gt 0 ]
  then
    argList $*
    recipient=$1
  fi

  echo "$(date +'%Y-%m-%d %T') :  Gateway         [$gateway]" >> $log
  echo "$(date +'%Y-%m-%d %T') :  Email recipient [$recipient]" >> $log

  # Do all the work
  while (true)
  do
    # Test the internet connection (1 quiet ping with a 2 sec timeout)
    if ping -q -c1 -W2 $targetSite >/dev/null; then
      # The web connection is up
      handleConnectionUp
    else
      # The web connection is down
      handleConnectionDown
    fi

    # Have we triggered an alert?
    if ($alert) then
      reportOutage
      alert=false
    fi

    sleep $checkInterval
  done
}

argList() {
    for var in $*
    do
        let i=i+1
        echo "  - arg ${i}: [${var}]" >> $log
    done
#    echo "  - args: $#" >> $log
}

handleConnectionUp() {
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
}

handleConnectionDown() {
  # Test the local gateway connection (1 quiet ping with a 1 sec timeout)
  if ping -q -c1 -W1 $gateway >/dev/null; then

    # The gateway is reachable (and web is down) so we can consider recording a new outage
    echo "$(date +'%Y-%m-%d %T') :  Web connection DOWN / local gateway UP. Possible outage" >> $log

    # If we were UP before then record the interruption start time and mark comms DOWN
    if ($up) then
      start=$(date +%T)
      startEpoch=$(date +%s)
      echo "$(date +'%Y-%m-%d %T') :  Start of interuption [$start]" >> $log
      up=false
      down=true
    fi

  else
    # The gateway and the web are unreachable - do nothing as wifi is likely down
    echo "$(date +'%Y-%m-%d %T') :  Web connection DOWN / local gateway DOWN. Do not record outage" >> $log
    down=false
  fi
}

reportOutage() {
  # Put something in the log
  downtime=$(($endEpoch-$startEpoch))
  echo "$(date +'%Y-%m-%d %T') :  Connection was down for $downtime seconds between $start and $end" >> $log
  echo "$(date +'%Y-%m-%d %T') :  Connection back UP" >> $log

  # Is an email address configured?
  if [ $recipient != 'null' ]
  then

    # Has the downtime reached the email threshhold?
    if [ $downtime -ge $emailThreshold ]
    then
      # send an email
      echo "$(date +'%Y-%m-%d %T') :  Sending email to $recipient" >> $log
      mail -s "Connection down for $downtime seconds from $start to $end" -aFrom:Webcheck\<webcheck@linux\> $recipient <<< ''
    else
      echo "$(date +'%Y-%m-%d %T') :  Email not sent: downtime is below threshold [$emailThreshold]" >> $log
    fi

  else
    echo "$(date +'%Y-%m-%d %T') :  Email not sent: recipient not specified" >> $log
  fi
}

main "$@"; exit
