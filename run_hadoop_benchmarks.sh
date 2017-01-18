#! /bin/bash
# Author: Murali Meesala
# Script: run_hadoop_benchmarks.sh
# Dependency: 'hdfs' user on EDGE node
# Usage: ./run_hadoop_benchmarks.sh

hadoop fs -mkdir -p /user/hdfs/benchmarks
CLUSTER_REPORT="dc1prod_benchmarks_report.txt"
NAMESERVICE="dc1prodns" 
CLUSTER="DC1PROD"
JAR_LOC="/opt/cloudera/parcels/CDH-5.8.2-1.cdh5.8.2.p0.3/lib/hadoop-mapreduce/"
cd $JAR_LOC

echo "HADOOP BENCHMARKS REPORT for $CLUSTER" > $CLUSTER_REPORT
echo "------------------------------------------" >> $CLUSTER_REPORT

# Teragen for 1TB Dataset with 1Rep and default mappers
echo "Teragen for 1TB Dataset with 1Rep and default mappers :  " >> $CLUSTER_REPORT
hadoop jar hadoop-mapreduce-examples.jar teragen -Ddfs.replication=1 10000000000 hdfs://$NAMESERVICE/user/hdfs/benchmarks/terasort-in-1r-defmappers  >> $CLUSTER_REPORT 
echo "------------------------------------------" >> $CLUSTER_REPORT

# Teragen for 1TB Dataset with 1Rep and 414 mappers
echo "Teragen for 1TB Dataset with 1Rep and 414 mappers: " >> $CLUSTER_REPORT
hadoop jar hadoop-mapreduce-examples.jar teragen -Dmapred.map.tasks=414 -Ddfs.replication=1 10000000000 hdfs://$NAMESERVICE/user/hdfs/benchmarks/terasort-in-1r-414mappers >> $CLUSTER_REPORT
echo "------------------------------------------" >> $CLUSTER_REPORT

# Teragen for 1TB Dataset with 3Rep and default mappers
echo "Teragen for 1TB Dataset with 3Rep and default mappers : " >> $CLUSTER_REPORT
hadoop jar hadoop-mapreduce-examples.jar teragen -Ddfs.replication=3 10000000000 hdfs://$NAMESERVICE/user/hdfs/benchmarks/terasort-in-3r-defmappers >> $CLUSTER_REPORT
echo "------------------------------------------" >> $CLUSTER_REPORT

# Teragen for 1TB Dataset with 3Rep and 414 mappers
echo " Teragen for 1TB Dataset with 3Rep and 414 mappers : " >> $CLUSTER_REPORT
hadoop jar hadoop-mapreduce-examples.jar teragen -Dmapred.map.tasks=414 -Ddfs.replication=3 10000000000 hdfs://$NAMESERVICE/user/hdfs/benchmarks/terasort-in-3r-414mappers >> $CLUSTER_REPORT
echo "------------------------------------------" >> $CLUSTER_REPORT

# Terasort for 1TB Dataset with 1Rep and default mappers
echo "Terasort for 1TB Dataset with 1Rep and default mappers : " >> $CLUSTER_REPORT
hadoop jar hadoop-mapreduce-examples.jar terasort -Dmapreduce.terasort.output.replication=1 hdfs://$NAMESERVICE/user/hdfs/benchmarks/terasort-in-1r-defmappers hdfs://$NAMESERVICE/user/hdfs/benchmarks/terasort-out-1r-defmappers >> $CLUSTER_REPORT
echo "------------------------------------------" >> $CLUSTER_REPORT

# Terasort for 1TB Dataset with 1Rep and 414 mappers
echo "Terasort for 1TB Dataset with 1Rep and 414 mappers : " >> $CLUSTER_REPORT
hadoop jar hadoop-mapreduce-examples.jar terasort -Dmapred.map.tasks=414 -Dmapreduce.terasort.output.replication=1 hdfs://$NAMESERVICE/user/hdfs/benchmarks/terasort-in-1r-414mappers hdfs://$NAMESERVICE/user/hdfs/benchmarks/terasort-out-1r-414mappers >> $CLUSTER_REPORT
echo "------------------------------------------" >> $CLUSTER_REPORT

# Terasort for 1TB Dataset with 3Rep and default mappers
echo "Terasort for 1TB Dataset with 3Rep and default mappers : " >> $CLUSTER_REPORT
hadoop jar hadoop-mapreduce-examples.jar terasort -Dmapreduce.terasort.output.replication=3 hdfs://$NAMESERVICE/user/hdfs/benchmarks/terasort-in-3r-defmappers hdfs://$NAMESERVICE/user/hdfs/benchmarks/terasort-out-3r-defmappers >> $CLUSTER_REPORT
echo "------------------------------------------" >> $CLUSTER_REPORT

# Terasort for 1TB Dataset with 3Rep and 414 mappers
echo "Terasort for 1TB Dataset with 3Rep and 414 mappers : " >> $CLUSTER_REPORT
hadoop jar hadoop-mapreduce-examples.jar terasort -Dmapred.map.tasks=414 -Dmapreduce.terasort.output.replication=3 hdfs://$NAMESERVICE/user/hdfs/benchmarks/terasort-in-3r-414mappers hdfs://$NAMESERVICE/user/hdfs/benchmarks/terasort-out-3r-414mappers >> $CLUSTER_REPORT
echo "------------------------------------------" >> $CLUSTER_REPORT

echo "COMPLETED" >> $CLUSTER_REPORT
