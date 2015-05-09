#!/bin/bash
# =========================================================
# 签你妹 for desktop
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
# /path/to/qian-ni-mei-desktop.sh "username" "password"
# example:
# ./qian-ni-mei-desktop.sh "larsenlouis" "12345678"


# ---!!!!DO NOT MODIFY THE FOLLOWING LINES!!!!---

# Json query function
# Credit cjus https://gist.github.com/cjus/1047794
# Adaptation larsenlouis
function jsonq() {
	# argument 1: json input;
	# argument 2: query (status or info);
	[[ $# != 2 ]] && echo "bad argument(s)." && exit 2
    temp=`echo $json | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $2`
	echo $(echo ${temp##*|} |cut -d':' -f2)

    #original output
    #echo ${temp##*|}
}

function unicode() {
	[[ $# != 1 ]] && echo "bad argument(s)." && exit 2
	text=$(echo $1 |sed 's,u,\\u,g' | sed 's/ //g')
	if [ "$text" == "" ]; then
			return 0
		else
			echo -n "ZiMuZu.tv also says: "
			echo -e $text
	fi
}
# example:
# json = '{"status":1,"info":"","data":false}'
# jsonq $json "status"|"info"|"data"
# output "1" | "" | "false"

function err_handle() {
	[[ $# != 1 ]] && echo "bad argument(s)." && exit 2
	# $1 is timestamp;
	rm -rf session-$timestamp.txt
	rm -rf usercookie-$timestamp.txt
	echo "Terminated with error(s)!"
}

# argument check:
# argument 1 is username
# argument 2 is password
[[ $# != 2 ]] && echo "bad arguments! qian-ni-mei-desktop.sh \"username\" \"password\"" && exit 1

user=$1
password=$2

# echo session start time
echo -e "\n======================================================"
echo -n "签你妹 session starts at "
echo $(date +'%Y-%m-%d %H:%M:%S UTC%z')

timestamp=$(date +%s)
err=0

# get php session
echo "Requesting login page...."
curl -s "http://www.zimuzu.tv/user/login/" -c session-$timestamp.txt > /dev/null

sleep 1s

# post login info with the session and get user cookie
echo "Sending your account confidential..."
echo "Server response to your login info: 0=failed, 1=succeeded"
json=$(curl -s "http://www.zimuzu.tv/user/login/ajaxlogin" -b session-$timestamp.txt --data "account=$user&password=$password&remember=0&back_url=" -c usercookie-$timestamp.txt)
result=$(jsonq $json "status")
echo $result
if [ "$result" == "0" ]; then
	echo "Failed to login. Please check your account confidential!" && let err=err+1 && err_handle $timestamp && exit $err
fi
unicode "$(jsonq $json "info")"
echo "Please wait for 5 seconds as page-rediect simulation..."
sleep 5s

# goto user sign page
echo "Requesting user home page..."
curl -s "http://www.zimuzu.tv/user/sign" -b usercookie-$timestamp.txt > /dev/null
echo "Please wait for 20 seconds as js-button-timer simulation..."
sleep 20s

# sign with the user cookie
echo "Sending your sign request..."
echo "Server response to your sign: 0=failed, 1=successed"
json=$(curl -s "http://www.zimuzu.tv/user/sign/dosign" -b usercookie-$timestamp.txt)
result=$(jsonq $json "status")
echo $result
if [ "$result" == "0" ]; then
	echo "Failed to sign. Oh, God forbid you to do this!" && let err=err+1 && err_handle $timestamp && exit $err
fi
unicode "$(jsonq $json "info")"

# clean up cookies
echo "Cleaning up cookies..."
rm -rf session-$timestamp.txt
rm -rf usercookie-$timestamp.txt

echo "Done!"
# echo session start time
echo -n "签你妹 session ends at "
echo $(date +'%Y-%m-%d %H:%M:%S UTC%z')
echo -e "======================================================\n"