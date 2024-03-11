#!/bin/bash

logpath="/tmp/Projects/ShellOutput.log"
log() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') $1" >> $logpath
}
log "PID: $$"

log "Shell script started!"
# Get the current hour in 24-hour format
current_hour=$(date +%H)
current_minute=$(date +%M)
current_minute=${current_minute#0}
current_day=$(date +%u) # 1=Monday, 2=Tuesday, ..., 7=Sunday

# source /path/to/your/python/environment/bin/activate
# log "Starting python script"
# sudo /Library/Frameworks/Python.framework/Versions/3.11/bin/python3 /Users/lucasvanderhorst/AlgoTrading/AlgorithmicTrading.py


#As soon as computer wakes, disables sleep. If run "sudo visudo" in the terminal, the sudoers file can be accessed, where 
#the password for sudo command has been disabled (or already granted when running sudo visudo)
if [ "$current_hour" == 15 ]; then
    sudo pmset disablesleep 1
    log "Sleep has been deactivated"
fi

if [ "$current_hour" == 22 ]; then
    sudo pmset disablesleep 0
    log "Sleep has been activated again"
fi

log "Checking if it is the right time to run python script"
# Check if the current hour is within the desired time range (15:30 to 22:00) on weekdays
if [ "$current_hour" -ge 15 ] && [ "$current_hour" -lt 22 ] && [ "$current_day" -ge 1 ] && [ "$current_day" -le 5 ]; then
    # Check if the current minute is a multiple of 5 (to run every 5 minutes)
    if [ "$((current_minute % 5))" == 0 ]; then
        # Run the Python script
        log "Running Python scrip AlgorithmicTrading.py"
        sudo /Library/Frameworks/Python.framework/Versions/3.11/bin/python3 /Users/lucasvanderhorst/AlgoTrading/AlgorithmicTrading.py
        log "Python script AlgorithmicTrading.py should have been run. Sleeping for 3 minutes"
        echo >> $logpath        
        sleep 180
    else 
        log "The current time is within the python's script allowed time range, but not yet at the required interval time. Sleeping for 15 seconds"
        echo >> $logpath    
        sleep 15
    fi

else
    #Make it sleep longer during the weekends
    #Sleep for some time before LaunchDaemons runs the script again. To save on power consumption
    if [ "$current_hour" -lt 15 ] || [ "$current_hour" -ge 22 ]; then
        log "The current time is outside the python's script allowed time range. Sleeping for 30 minutes"
        echo >> $logpath
        sleep 1800
    fi
fi
