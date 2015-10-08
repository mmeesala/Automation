#!/bin/bash
#-----------------------------------------------------------------------------
# HDFS - Backup HDFS Logs.
# Implemented on : 10 Aug 2015.
# Implemented by : Murali Meesala <murali.meesala@ge.com>
#-----------------------------------------------------------------------------
DAY=`/bin/date +%Y%m%d`

#-----------------------------------------------------------------------------
# HDM1
#-----------------------------------------------------------------------------
ssh -t hdm1 "sudo -u gpadmin sh -c 'echo "gpadmin" | /usr/bin/kinit > /dev/null 2>&1 '; 
sudo -u gpadmin hadoop fs -mkdir -p /apps/idc/HadoopLogs_Backups/$DAY/hdm1/hadoop-hdfs;
sudo -u gpadmin hadoop fs -copyFromLocal /data/var/log/gphd/hadoop-hdfs/*.gz /apps/idc/HadoopLogs_Backups/$DAY/hdm1/hadoop-hdfs/;
gzip /data/var/log/gphd/hive/hive.log.*;
sudo -u gpadmin hadoop fs -mkdir -p /apps/idc/HadoopLogs_Backups/$DAY/hdm1/hive;
sudo -u gpadmin hadoop fs -copyFromLocal /data/var/log/gphd/hive/*.gz /apps/idc/HadoopLogs_Backups/$DAY/hdm1/hive/;
gzip /data/var/log/gphd/oozie/oozie.log-*; gzip /data/var/log/gphd/oozie/oozie-instrumentation.log.*;
sudo -u gpadmin hadoop fs -mkdir -p /apps/idc/HadoopLogs_Backups/$DAY/hdm1/oozie/;
sudo -u gpadmin hadoop fs -copyFromLocal /data/var/log/gphd/oozie/*.gz /apps/idc/HadoopLogs_Backups/$DAY/hdm1/oozie/;
sudo -u gpadmin hadoop fs -mkdir -p /apps/idc/HadoopLogs_Backups/$DAY/hdm1/zookeeper;
sudo -u gpadmin hadoop fs -copyFromLocal /data/var/log/gphd/zookeeper/*.gz /apps/idc/HadoopLogs_Backups/$DAY/hdm1/zookeeper/;
sudo -u gpadmin hadoop fs -mkdir -p /apps/idc/HadoopLogs_Backups/$DAY/hdm1/flume;
sudo -u gpadmin hadoop fs -copyFromLocal /data/var/log/gphd/flume-*.gz /apps/idc/HadoopLogs_Backups/$DAY/hdm1/flume/;
" 

#-----------------------------------------------------------------------------
# HDM2
#-----------------------------------------------------------------------------
ssh -t hdm2 "sudo -u gpadmin sh -c 'echo "gpadmin" | /usr/bin/kinit > /dev/null 2>&1 ';
sudo -u gpadmin hadoop fs -mkdir -p /apps/idc/HadoopLogs_Backups/$DAY/hdm2/hadoop-hdfs;
sudo -u gpadmin hadoop fs -copyFromLocal /data/var/log/gphd/hadoop-hdfs/*.gz /apps/idc/HadoopLogs_Backups/$DAY/hdm2/hadoop-hdfs/;
sudo -u gpadmin hadoop fs -mkdir -p /apps/idc/HadoopLogs_Backups/$DAY/hdm2/zookeeper;
sudo -u gpadmin hadoop fs -copyFromLocal /data/var/log/gphd/zookeeper/*.gz /apps/idc/HadoopLogs_Backups/$DAY/hdm2/zookeeper/;
"

#-----------------------------------------------------------------------------
# HDM3
#-----------------------------------------------------------------------------
ssh -t hdm3 "sudo -u gpadmin sh -c 'echo "gpadmin" | /usr/bin/kinit > /dev/null 2>&1 ';
sudo -u gpadmin hadoop fs -mkdir -p /apps/idc/HadoopLogs_Backups/$DAY/hdm3/hadoop-mapreduce;
sudo -u gpadmin hadoop fs -copyFromLocal /data/var/log/gphd/hadoop-mapreduce/*.gz /apps/idc/HadoopLogs_Backups/$DAY/hdm3/hadoop-mapreduce/;
sudo -u gpadmin hadoop fs -mkdir -p /apps/idc/HadoopLogs_Backups/$DAY/hdm3/hadoop-yarn;
sudo -u gpadmin hadoop fs -copyFromLocal /data/var/log/gphd/hadoop-yarn/*.gz /apps/idc/HadoopLogs_Backups/$DAY/hdm3/hadoop-yarn/;
sudo -u gpadmin hadoop fs -mkdir -p /apps/idc/HadoopLogs_Backups/$DAY/hdm3/zookeeper;
sudo -u gpadmin hadoop fs -copyFromLocal /data/var/log/gphd/zookeeper/*.gz /apps/idc/HadoopLogs_Backups/$DAY/hdm3/zookeeper/;
"

#-----------------------------------------------------------------------------
# HDM4
#-----------------------------------------------------------------------------
ssh -t hdm4 "sudo -u gpadmin sh -c 'echo "gpadmin" | /usr/bin/kinit > /dev/null 2>&1 ';
sudo -u gpadmin hadoop fs -mkdir -p /apps/idc/HadoopLogs_Backups/$DAY/hdm4/hbase;
sudo -u gpadmin hadoop fs -copyFromLocal /data/var/log/gphd/hbase/*.gz /apps/idc/HadoopLogs_Backups/$DAY/hdm4/hbase/;
"

#-----------------------------------------------------------------------------
# Worker / Data Nodes
#-----------------------------------------------------------------------------
for num in {1..28}; 
do 
ssh -t hdw$num "sudo -u gpadmin sh -c 'echo "gpadmin" | /usr/bin/kinit > /dev/null 2>&1 '; 
sudo -u gpadmin hadoop fs -mkdir -p /apps/idc/HadoopLogs_Backups/$DAY/hdw$num/hadoop-hdfs;
sudo -u gpadmin hadoop fs -copyFromLocal /data/var/log/gphd/hadoop-hdfs/hdfs/*.gz /apps/idc/HadoopLogs_Backups/$DAY/hdw$num/hadoop-hdfs/;
sudo -u gpadmin hadoop fs -mkdir -p /apps/idc/HadoopLogs_Backups/$DAY/hdw$num/hadoop-yarn;
sudo -u gpadmin hadoop fs -copyFromLocal /data/var/log/gphd/hadoop-yarn/*.gz /apps/idc/HadoopLogs_Backups/$DAY/hdw$num/hadoop-yarn/;
sudo -u gpadmin hadoop fs -mkdir -p /apps/idc/HadoopLogs_Backups/$DAY/hdw$num/hbase;
sudo -u gpadmin hadoop fs -copyFromLocal /data/var/log/gphd/hbase/*.gz /apps/idc/HadoopLogs_Backups/$DAY/hdw$num/hbase/;
"
done


for num in {27 28 29 30 31 32 33 44}; 
do 
ssh -t etl$num "sudo -u gpadmin sh -c 'echo "gpadmin" | /usr/bin/kinit > /dev/null 2>&1 '; 
sudo -u gpadmin hadoop fs -mkdir -p /apps/idc/HadoopLogs_Backups/$DAY/etl$num/hadoop-hdfs;
sudo -u gpadmin hadoop fs -copyFromLocal /data/var/log/gphd/hadoop-hdfs/hdfs/*.gz /apps/idc/HadoopLogs_Backups/$DAY/etl$num/hadoop-hdfs/;
sudo -u gpadmin hadoop fs -mkdir -p /apps/idc/HadoopLogs_Backups/$DAY/etl$num/hadoop-yarn;
sudo -u gpadmin hadoop fs -copyFromLocal /data/var/log/gphd/hadoop-yarn/*.gz /apps/idc/HadoopLogs_Backups/$DAY/etl$num/hadoop-yarn/;
sudo -u gpadmin hadoop fs -mkdir -p /apps/idc/HadoopLogs_Backups/$DAY/etl$num/hbase;
sudo -u gpadmin hadoop fs -copyFromLocal /data/var/log/gphd/hbase/*.gz /apps/idc/HadoopLogs_Backups/$DAY/etl$num/hbase/;
"
done
