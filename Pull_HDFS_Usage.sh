#! /bin/bash
# Author : Murali Meesala, <murali.meesala@gmail.com>
# Script :
# Version :v1.0
# Functioanlity : It gets the HDFS Usage at User and Group Level in the Hadoop cluster.
#

HDFS_PATHS="/apps /backups /benchmarks /data /dev /etl  /hive /mapred  /user /xd /yarn"
hadoop fs -ls $HDFS_PATHS | grep -v "Found" | awk '{ print $3,$4,$8}' > HDFS_Aggregate.txt
cat HDFS_Aggregate.txt | awk '{ print $1 }' | sort | uniq > uniq_users.txt
cat HDFS_Aggregate.txt | awk '{ print $2 }' | sort | uniq > uniq_groups.txt

#echo "HDFS Group Usage: " > GUsage.txt
for i in `cat uniq_groups.txt`; do printf "$i:"; cat HDFS_Aggregate.txt | grep $i | awk '{ print $3}' | xargs hadoop fs -du  |  awk '{sum+=$1} END { printf "%0.2f GB\n",sum/(1024^3)}'; done > GUsage.txt

#echo "HDFS User Usage:" > UUsage.txt
for i in `cat uniq_users.txt`; do printf "$i:"; cat HDFS_Aggregate.txt | grep $i | awk '{ print $3}' | xargs hadoop fs -du  |  awk '{sum+=$1} END { printf "%0.2f GB\n",sum/(1024^3)}'; done > UUsage.txt

echo "Consolidated Report @ `date` - Hadoop Cluster " > Report.txt
echo "Scanned HDFS paths : $HDFS_PATHS" >>Report.txt
echo "----------------------------------------------------" >> Report.txt

echo "HDFS Usage at User Level:-" >> Report.txt
cat UUsage.txt | grep -v "0.00" | sort -rn -t':' -k2 >> Report.txt
echo "----------------------------------------------------" >> Report.txt
echo "HDFS Usage at Group Level:-" >> Report.txt
cat GUsage.txt | grep -v "0.00" | sort -rn -t':' -k2 >> Report.txt
echo "----------------------------------------------------" >> Report.txt
echo "Thank you," >> Report.txt
echo "DataLake Team." >> Report.txt
mail -s "HDFS Usage - Hadoop Cluster" murali.meesala@gmail.com < Report.txt 

rm -rf HDFS_Aggregate.txt  uniq_users.txt  uniq_groups.txt Report.txt  GUsage.txt UUsage.txt
