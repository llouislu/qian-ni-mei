#!/bin/bash
# =========================================================
# 签你妹
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
# Please fill your account confidential between quotation marks.
# Example:
# user="larsenlouis"
# password="12345678"

# ----------------------------------------------
# ----Your account confidential starts here-----
user=""
password=""
# ----Your account confidential ends here-------
# ----------------------------------------------

# ---!!!!DO NOT MODIFY THE FOLLOWING LINES!!!!---
timestamp=$(date +%s)

# get php session

curl "http://www.zimuzu.tv/user/login/" -c session-$timestamp.txt

sleep 1s

# post login info with the session and get user cookie

curl "http://www.zimuzu.tv/user/login/ajaxlogin" -b session-$timestamp.txt --data "account=$user&password=$password&remember=0&back_url=" -c usercookie-$timestamp.txt

sleep 5s

# goto user sign page

curl "http://www.zimuzu.tv/user/sign" -b usercookie-$timestamp.txt

sleep 20s

# sign with the user cookie

curl "http://www.zimuzu.tv/user/sign/dosign" -b usercookie-$timestamp.txt

# clean up cookies
rm -rf session-$timestamp.txt
rm -rf usercookie-$timestamp.txt