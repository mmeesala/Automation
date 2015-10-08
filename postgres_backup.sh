#! /bin/bash
# Author: Murali Meesala.
# Script Name: postgres_backup.sh
# Version : v1.0
# Functionality : Backup postgres database
# Usage:  sudo /root/scripts/postgres_backup.sh "/usr/bin/pg_dumpall" " -p 10432 " "/data/Backups/" "/Backups/`hostname`/Postgres/"
#

syntax()
{
  echo "$0 arg1 arg2 arg3 arg4"
  echo "  arg1 - FULL path of PGDUMP  i.e:  /usr/bin/pgdump"
  echo "  arg2 - port wher postgres runs.  i.e: \" -p 5042 \" "
  echo "  arg3 - BACKUP_PATH of dir backup will be dump into.  i.e: /data/Backups"
  echo "  arg4 - HADOOP_BACKUP_PATH of dir backup will be dump into.  i.e: /Backups/`hostname`/Postgres/"
  exit
}


PORT=" -p 10432 "
PG_DUMP="/usr/bin/pg_dumpall"
PG_DUMP=$1
PORT=$2
BACKUP_PATH=$3
HADOOP_BACKUP_PATH=$4
BACKUP_PATH="/data/Backups/"
HADOOP_BACKUP_PATH="/Backups/`hostname`/Postgres/"

rm -rf /tmp/report.txt

if [[ $# -ne 4 ]]; then
  syntax
fi
#sudo su - postgres -c "$PG_DUMP $PORT  > /data/Backups/`hostname`_`date +%m-%d-%Y`.dump | gzip -c  > /data/Backups/`hostname`_`date +%m-%d-%Y`.dump.gz "
sudo su - postgres -c "$PG_DUMP $PORT  | gzip -c  > /data/Backups/`hostname`_`date +%m-%d-%Y`.dump.gz "

if [ $? -eq 0 ]
then
        echo "Postgres Backup is SUCCESSFUL" >> /tmp/report.txt
else
        echo "PWP Postgres Backup - FAILED!" >> /tmp/report.txt
fi

