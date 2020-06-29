#!/bin/bash

################################
# USER PARAMETERS

log=~/.pinglog
target=google.com
################################

# Initialise some variables
down=false
up=false
alert=false

echo "---------------------------------------------" >> $log
echo "$(date +'%Y-%m-%d %T') :  pingtest started" >> $log

while (true)
 do
    # Test the internet connection (1 quiet ping with a 2 sec timeout)
    if ping -q -c 1 -W 2 $target >/dev/null; then

      # If we were DOWN before then record the interruption end time and mark comms UP
      if ($down) then
        end=$(date +%T)
        endEpoch=$(date +%s)
        echo "$(date +'%Y-%m-%d %T') :  end of interuption [$end]" >> $log
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
        echo "$(date +'%Y-%m-%d %T') :  start of interuption [$start]" >> $log
        up=false
        down=true
      fi

    fi

    if ($alert) then
      downtime=$(($endEpoch-$startEpoch))
      echo "$(date +'%Y-%m-%d %T') :  Connection was down for $downtime seconds between $start and $end" >> $log
      echo "$(date +'%Y-%m-%d %T') :  Connection back UP" >> $log
      alert=false
    fi
    sleep 5
 done

