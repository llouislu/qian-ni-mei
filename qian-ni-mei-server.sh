#!/bin/bash
# =========================================================
# 签你妹 for server
# Auto-check attendance for zimuzu.tv
# by: larsenlouis
# https://github.com/larsenlouis

# Requirement:
# 1. Bash(the Bourne shell), or a compatible shell
# 2. cURL
# =========================================================

# CAUTION:
# Your account confidential will be stored in PLAIN TEXT!
# Please store this script in somewhere you trust!

# GUIDE:
# /path/to/qian-ni-mei-server.sh "username" "password" "scheduled_time"
# time format: HHMM
# HH double digits in 24-hour format, 00-23
# MM double digits, 00-59
# examples:
# ./qian-ni-mei-server.sh "larsenlouis" "12345678" "0100"
# This means qian-ni-mei will auto-sign at localtime 01:00 everyday.

# ./qian-ni-mei-server.sh "larsenlouis" "12345678" "2250"
# This means qian-ni-mei will auto-sign at localtime 22:50 everyday.

# ---!!!!DO NOT MODIFY THE FOLLOWING LINES!!!!---

# global variables to pass return values from function.
g_hours_sleep=
g_minutes_sleep=

function cal_first_sleep_time() {
	[[ $# != 1 ]] && echo "bad argument(s)." && exit 2

	# initialize global variables
	g_hours_sleep=
	g_minutes_sleep=

	# argument 1 is scheduled time
	scheduled_time=$1

	#convert to minutes
	if [[ scheduledtime%1000 -eq 0 ]]; then
		scheduled_time=$(echo $scheduledtime | sed 's/^0//')
	fi
	let minutes_scheduled=scheduled_time%100
	let minutes_scheduled+="("scheduled_time-minutes_scheduled")"/100*60

	# get and conv current time to minutes
	timenow="$(date +'%H%M')"
	let minutes_timenow=timenow%100
	let minutes_timenow+="("timenow-minutes_timenow")"/100*60

	# pain in the butt to subtract in the 'so powerful' bash
	minutes_sleep="$((minutes_scheduled - minutes_timenow))"

	# if the diff is a negative value(the scheduled time is past), run that time tomorrow
	if [[ $minutes_sleep -lt 0 ]]; then
		# please comment the next line on github if you know a easier way to do subtract one number with a variable
		let minutes_sleep="$((minutes_scheduled - minutes_timenow))"+1440
	else
		let minutes_sleep="$((minutes_scheduled - minutes_timenow))"
	fi
	let g_minutes_sleep=minutes_sleep%60
	let	g_hours_sleep=minutes_sleep/60

}


# argument check:
# argument 1 is username
# argument 2 is password
# argument 3 is time HHMM
[[ $# != 3 ]] && echo -e "bad arguments!\nUsage:\nqian-ni-mei-server.sh \"username\" \"password\" \"scheduledtime\"" && exit 1
user=$1
password=$2
scheduledtime=$3

# check time is valid in argument 3
case $3 in
	([0-1][0-9][0-5][0-9]|[2][0-3][0-5][0-9]) : OK;;
	(*) echo "your scheduled time: '$scheduledtime' is invalid!" && exit 1;;
esac

# check if ./qian-ni-mei-desktop.sh is executable
executable="./qian-ni-mei-desktop.sh"
[[ -x !$executable ]] &&　echo "File '$exec' is required with execute permission!" && exit 1

# check if the scheduled time is past
timenow="$(date +'%H%M')"
let timediff=scheduledtime-timenow
if [[ $timediff -le 0 ]]; then
	# the scheduled tiem is past
	echo "Your scheduled time is past. Scheduled: $(echo $scheduledtime | sed -r 's/(^[0-9][0-9])(.*)/\1\:\2/') UTC"$(date '+%z')" Now: $(echo $timenow| sed -r 's/(^[0-9][0-9])(.*)/\1\:\2/') UTC"$(date '+%z')""
	while true; do
		read -p "Would you like 签你妹 to auto-sign now. (y/n)?" choice
		case "$choice" in
  			y|Y ) ./qian-ni-mei-desktop.sh "$user" "$password" && break ;;
  			n|N ) break;;
  			* ) echo "Please input y or n!";;
		esac
	done
fi

# run daily
while true; do
cal_first_sleep_time "$scheduledtime"
echo "Your scheduled time is set. Scheduled: $(echo $scheduledtime | sed -r 's/(^[0-9][0-9])(.*)/\1\:\2/') UTC"$(date '+%z')" Now: $(echo $timenow| sed -r 's/(^[0-9][0-9])(.*)/\1\:\2/') UTC"$(date '+%z')""
echo "Scheduled to sleep $g_hours_sleep hours $g_minutes_sleep minutes for the next run..."
sleep "$g_hours_sleep"h "$g_minutes_sleep"m
./qian-ni-mei-desktop.sh "$user" "$password"
# while true; do
# 	./qian-ni-mei-desktop.sh "$user" "$password"
# 	sleep 24h
done