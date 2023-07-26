#! /bin/bash
# Author: Murali Meesala <murali.meesala@gmail.com>
# Principal Systems Engineer
# Script Name: jenkins-backup.sh
# Version: 1.0
# Functionality: This will take Jenkins home path, backup path and gcs bucket information as input and take the backup of jenkins jobs and its configurations and then it will generate .tgz file. Also, it will clean up the local backup file as well as previous day backup file from GCS
# Usage: ./jenkins-backup.sh <JENKINS_HOME> <BACKUP_LOCATION> <GCS_BUCKET>"
#		echo "Eg: ./jenkins-backup.sh /var/lib/jenkins /data gs://mmeesala-test"
# Dependency: Jenkins home, backup path and GCS bucket information.


JENKINS_HOME=$1
BACKUP_LOCATION=$2
GCS_BUCKET=$3
TODAYS_DATE=`date +%Y-%m-%d`
PREVIOUS_DATE=`date --date="yesterday" +%Y-%m-%d`
NO_OF_ARGS=$#

function cleanup-old-backups() {
	# Cleaning backup file from local filesystem
	rm -f ${BACKUP_LOCATION}/`hostname -f`-${CURRENT_DATE}-backup.tgz
	# Cleaning previous day backup file from GCS
	gsutil rm ${GCS_BUCKET}/jenkins-backup/`hostname -f`-${PREVIOUS_DATE}-backup.tgz
}

function take_backup() {
cd ${JENKINS_HOME}

# Taking backup
tar cvzf ${BACKUP_LOCATION}/`hostname -f`-`date +%Y-%m-%d`-backup.tgz jobs/*/config.xml jenkins.yaml config.xml credentials.xml
if [ $? == 0 ]
then
	echo "Backup successfull. Backup located in ${BACKUP_LOCATION}/`hostname -f`-${TODAYS_DATE}-backup.tgz"
else
	echo "Backup failed!.... with exit status - $?"
fi


}

function dump_backup_to_GCS() {
	#cd ${BACKUP_LOCATION}
	# Copying to GCS bucket
        gsutil -m cp ${BACKUP_LOCATION}/`hostname -f`-${TODAYS_DATE}-backup.tgz ${GCS_BUCKET}/jenkins-backups/
	if [ $? == 0 ]
	then
		echo "Dump to GCS_BACKUP successfull, GCS Backup location : ${GCS_BUCKET}/jenkins-backups/`hostname -f`-${TODAYS_DATE}-backup.tgz"
		cleanup-old-backups
	else
		echo "Dump to GCS_BUCKET failed!... with exit status $? "
	fi
}

function usage_check() {
	if [ $NO_OF_ARGS == 3 ]
	then
		echo "Usage check - Passed"
	else
		echo "Invalid # of arguments!... == $NO_OF_ARGS"
		echo "Usage: ./jenkins-backup.sh <JENKINS_HOME> <BACKUP_LOCATION> <GCS_BUCKET>"
		echo "Eg: ./jenkins-backup.sh /var/lib/jenkins /data gs://mmeesala-test"
		exit
	fi
}

usage_check
take_backup
dump_backup_to_GCS
