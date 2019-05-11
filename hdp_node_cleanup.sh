#! /bin/bash
# Author: Murali Meesala <murali.meesala@gmail.com>
# Script: hdp_node_cleanup.sh
# Version: 1.0
# Dependencies: No
# Usage: ./hdp_node_cleanup.sh
# Functionality: It will cleanup the hdp and ambari installation and its files/dir.

# Stop/kill all the processes run by hdfs user
ps -u hdfs | grep -v PID | awk '{ print $1}' | xargs kill

# Run HostCleanup.py script
python /usr/lib/python2.6/site-packages/ambari_agent/HostCleanup.py --silent --skip=users

# Remove all hadoop packageson all nodes
yum -y remove hive\* oozie\* pig\* zookeeper\* tez\* hbase\* ranger\* knox\* storm\* accumulo\* falcon\* ambari-metrics-hadoop-sink smartsense-hst slider* ambari-metrics-monitor spark* ambari-infra-solr-client

# Stop and erase Ambari agent
ambari-agent stop
yum -y erase ambari-agent

# Remove and cleanup ambari and hdp repos
rm -rf /etc/yum.repos.d/ambari* /etc/yum.repos.d/HDP* /etc/yum.repos.d/hdp*
yum clean all

# Remove log folders
for logname in ambari-agent ambari-metrics-grafana ambari-metrics-monitor ambari-server falcon flume hadoop hadoop-mapreduce hadoop-yarn hive hive-hcatalog hive2 hst knox oozie solr zookeeper spark spark2
do
        rm -rf /var/log/${logname}
done

# Remove Hadoop folders
rm -rf /hadoop/*
rm -rf /hdfs/hadoop
rm -rf /hdfs/lost+found
rm -rf /hdfs/var
rm -rf /local/opt/hadoop
rm -rf /tmp/hadoop
rm -rf /usr/bin/hadoop
rm -rf /usr/hdp
rm -rf /var/hadoop /data1/* /data2/* /data3/* /data4/* /data5/* /data6/*

# Remove config folders

for configdir in ambari-agent ambari-metrics-grafana ambari-server ams-hbase falcon flume hadoop hadoop-httpfs hbase hive hive-hcatalog hive-webhcat hive2 hst knox livy mahout oozie phoenix pig ranger-admin ranger-usersync spark2 spark tez tez_hive2 zookeeper
do
        rm -rf /etc/${configdir}
done

# Remove PIDs on hdp services
for pidfile in ambari-agent ambari-metrics-grafana ambari-server falcon flume hadoop hadoop-mapreduce hadoop-yarn hbase hive hive-hcatalog hive2 hst knox oozie webhcat zookeeper spark spark2
do
        rm -rf /var/run/${pidfile}
done


# Remove lib folders of hdp services
for libdir in ambari-agent ambari-infra-solr-client ambari-metrics-hadoop-sink ambari-metrics-kafka-sink ambari-server-backups ams-hbase ambari-agent ambari-metrics-grafana flume hadoop-hdfs hadoop-mapreduce hadoop-yarn hive2 knox smartsense storm
do
        rm -rf /usr/lib/${libdir}
done

# Clean tmp folder
rm -rf /var/tmp/*

# Remove symbolic links
cd /usr/bin
for file in accumulo atlas-start atlas-stop beeline falcon flume-ng hbase hcat hdfs hive hiveserver2 kafka mahout mapred oozie oozied.sh phoenix-psql phoenix-queryserver phoenix-sqlline phoenix-sqlline-thin pig python-wrap ranger-admin ranger-admin-start ranger-admin-stop ranger-kms ranger-usersync ranger-usersync-start ranger-usersync-stop slider sqoop sqoop-codegen sqoop-create-hive-table sqoop-eval sqoop-export sqoop-help sqoop-import sqoop-import-all-tables sqoop-job sqoop-list-databases sqoop-list-tables sqoop-merge sqoop-metastore sqoop-version  storm storm-slider worker-lanucher yarn zookeeper-client zookeeper-server zookeeper-server-cleanup
do
        rm -rf ${file}
done

# Remove HDP service users
for user in accumulo ambari-qa ams falcon flume hbase hcat hdfs hive kafka knox mapred oozie ranger spark spark2 sqoop storm tez yarn zeppelin zookeeper
do
        userdel -r $user
done

# Remove any files owned by ambari or hdp services
find / -name *ambari* | xargs rm -rf
find / -name *accumulo* | xargs rm -rf
find / -name *atlas* |xargs rm -rf
find / -name *beeline* | xargs rm -rf
find / -name *falcon*| xargs rm -rf
find / -name *flume*| xargs rm -rf
find / -name *hadoop*| xargs rm -rf
find / -name *hbase*| xargs rm -rf
find / -name *hcat*| xargs rm -rf
find / -name *hdfs*| xargs rm -rf
find / -name *hdp*| xargs rm -rf
find / -name *hive*| xargs rm -rf
find / -name *hiveserver2*| xargs rm -rf
find / -name *kafka*| xargs rm -rf
find / -name *mahout*| xargs rm -rf
find / -name *mapred*| xargs rm -rf
find / -name *oozie*| xargs rm -rf
find / -name *phoenix*| xargs rm -rf
find / -name *pig*| xargs rm -rf
find / -name *ranger*| xargs rm -rf
find / -name *slider*| xargs rm -rf
find / -name *sqoop*| xargs rm -rf
find / -name *storm*| xargs rm -rf
find / -name *yarn*| xargs rm -rf
find / -name *zookeeper*| xargs rm -rf
