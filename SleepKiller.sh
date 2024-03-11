#!/bin/bash
logpath="/tmp/Projects/ShellOutput.log"
log() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') $1" >> $logpath
}
pid=$(grep "PID:" /tmp/Projects/ShellOutput.log | tail -n 1 | awk '{print $4}')

log 'Sleep Killer is hunting'

# Get the current hour in 24-hour format
current_hour=$(date +%H)

if [ $current_hour == 15 ]; then
    log "Killing ScriptRunner.sh to ensure is it not sleeping. It should run again straight away and disable sleep."
    echo >> $logpath
    pkill -P $pid
    sleep 3600
else
    log "I'm still thirsty for blood, but will rest for 2 seconds"
    sleep 2
fi