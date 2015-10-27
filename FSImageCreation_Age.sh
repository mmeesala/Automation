#! /bin/bash
# Author: Murali Meesala <murali.meesala@ge.com>
# Sr. Hadoop Engineer and DevOps.
# Script Name: FSImageCreation_Age.sh
# Version: v1.0
# Functionality: It will grab the age of FSImages and plot the graphs in Ganglia for HDM1 server.
# Usage: ./FSImageCreation_Age.sh
# Scheduled via CRON for every 5 Minutes


FS_PATH="/data/hadoop/name/dfs/name/current"

i=1

for FILE in `ls -l $FS_PATH | grep fsimage | grep -v md5  | grep -v ckpt | awk '{ print $9}'`
do
	#OLD=`stat -c %Z FSImageCreation_Age.sh`
	OLD=`stat -c %Z ${FS_PATH}/${FILE}`
	NOW=`date +%s`
	(( DIFF = (NOW - OLD)/60 )) 
#	echo "This ${FILE} file is ${DIFF} Minutes old"	
	if [ $i -eq 1 ] 
	then
	
		/usr/bin/gmetric --name="FSImage_1"  --type=int32 --value=${DIFF} --units=Minutes
		i=2	
	else
		/usr/bin/gmetric --name="FSImage_2"  --type=int32 --value=${DIFF} --units=Minutes
		i=1
	fi
done
