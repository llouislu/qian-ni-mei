# 签你妹
Auto-check attendance for http://www.zimuzu.tv

by: larsenlouis

https://github.com/larsenlouis

##Requirement
1. Bash(the Bourne shell), or a compatible shell
2. cURL

##Caution
Your account confidential will be stored in **bash history**!

Please run this script on the computer that you trust!

##Guide
###Guide for Desktop Users
/path/to/qian-ni-mei-desktop.sh "username" "password"

Example:

	chmod +x ./qian-ni-mei-desktop.sh # obtain execute permission

	./qian-ni-mei-desktop.sh "larsenlouis" "12345678"

###Guide for Server Users
/path/to/qian-ni-mei-server.sh "username" "password" "scheduled_time"

Time format: HHMM

* HH double digits in 24-hour format, 00-23

* MM double digits, 00-59

Examples:

	# First
	chmod +x ./qian-ni-mei-desktop.sh # server version needs desktop version

	# Then
	chmod +x ./qian-ni-mei-server.sh # obtain execute permission

	# Either
	./qian-ni-mei-server.sh "larsenlouis" "12345678" "0100"
	This means qian-ni-mei will auto-sign at localtime 01:00 everyday.

	# Or
	./qian-ni-mei-server.sh "larsenlouis" "12345678" "2250"
	This means qian-ni-mei will auto-sign at localtime 22:50 everyday.

Tips for server users:

1. Better run this script in `tmux` or `screen`
2. Better experience with unicode terminal display
3. Mind your timezone on your server

##Known Issues
1. Single login session limitaion on the server side, which fails to keep the session in your actual browser.
2. Unable to display unicode characters in shells such as git bash for windows.

##Changelog

	2015-05-09 20:28:16
	major update: version for server, new parameter input, better output
	2015-05-05 18:04:23
	display info from json
	2015-05-05 16:04
	better output and introduced error simple handling
	2015-05-05 10:43
	First version