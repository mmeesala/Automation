#! /bin/bash
# Author: Murali Meesala
# Sr. Bigdata Architect.
# Script Name: PermCheck_Report.sh

DT=`date`

FILES=`find / -type f -perm 777 | grep -v "No Such File"`
TOTAL_FILES=`find / -type f -perm 777 | grep -v "No Such File"| wc -l`

DIRS=`find / -type d -perm 777 | grep -v "No Such File"`
TOTAL_DIRS=`find / -type d -perm 777 | grep -v "No Such File" | wc -l`

HN=`hostname -f`
CDT=`date`

echo "Permission Check Report from $HN" > report.txt
echo "Scan started at : $DT " >> report.txt

echo "Total Files with 777 permissions = $TOTAL_FILES" >> report.txt
echo "Files list with permissions 777 ......" >> report.txt

echo "$FILES" >> report.txt
echo "" >> report.txt

echo "Total Directories with 777 permissions = $TOTAL_DIRS" >> report.txt
echo "Directories list with permissions 777...." >> report.txt
echo "$DIRS" >> report.txt
echo "" >> report.txt
echo "Scan completed at :$CDT " >> report.txt

if [ $TOTAL_FILES -gt 0 ] && [ $TOTAL_DIRS -gt 0 ]; then
	mail -s "PERM report for $HN on $DT" mmeesala@kogentix.com < repor.txt
fi
