#!/bin/sh
# Author: Murali Meesala
# Sr. Bigdata Architect
# Script: PermChange_755.sh

LINES=`/usr/bin/wc -l report.txt | /usr/bin/cut -d" " -f1`
#echo "Count - $LINES"

if [ $LINES > 9 ]; then

	for FILE in `cat report.txt | grep ^/`
	do
		echo "Changing $FILE permissions to 755..." 
		chmod 755 $FILE
		#echo "---DONE!"
	done
	echo "Done..!"
else
	echo "Nothing needs to be changed...!"
fi
