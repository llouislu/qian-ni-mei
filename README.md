# 签你妹
Auto-check attendance for http://www.zimuzu.tv

by: larsenlouis

https://github.com/larsenlouis

##Requirement:
1. Bash(the Bourne shell), or a compatible shell
2. cURL

##CAUTION:
Your account confidential will be stored in **PLAIN TEXT**!

Please store this script in somewhere you trust!

##GUIDE:
Please fill your account confidential between quotation marks.

Example:

    user="larsenlouis"
    password="12345678"

#Known Issues
1. Unformatted outputs.
2. Single login session limitaion on the server side, which fails to keep the session in your actual browser.
3. No cron or run itself in a time-based loop. Furthur development has been intended.