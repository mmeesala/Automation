#!/usr/bin/python3
# Author: Murali Meesala <murali.meesala@gmail.com>
# Principal Systems Engineer
# Script: dir-scanner.py
# Version: 1.0
# Functionality: It will take input as absolute dir name and scans all its directories and sub-directories and print the files whose size is morethan 500 MB.
# Dependencies: 'humanize' python module # pip install humanize

import os
from humanize import naturalsize

dirname = input("Enter absolute path to scan: ")
#dirname=('/Users/mmeesala')
for relpath,dirs,files in os.walk(dirname):
	for file in files:
		filepath = os.path.join(dirname,relpath,file)
		if (os.path.getsize(filepath) > 500000000):  # Checking if filesize is greater than 500 MB ;
			print(filepath, 'file size is ', naturalsize(os.path.getsize(filepath)))  # only printing the files greater than 500 MB
