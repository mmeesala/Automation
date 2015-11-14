#! /usr/bin/perl
# Author: Murali Meesala, <murali.meesala@ge.com>
# Sr. Bigdata Engineer and DevOps
# Script :check_HDFS_health.pl
# Version : v1.0
# Functionality : This is a Nagios plugin which can alert about HDFS health and blocks.
# Dependency : Kerberos keytab, if the cluster is kerborized.
# Usage: ./check_HDFS_health.pl

`echo "dkgdkjd" | kinit murali`;
`hadoop dfsadmin -report | head -12 > dfsadmin_report.txt`;

chomp($URB=`cat dfsadmin_report.txt| grep "Under replicated blocks:" | awk '{ print \$4 }'`);
chomp($BWCR=`cat dfsadmin_report.txt| grep "Blocks with corrupt replicas:" | awk '{ print \$5 }'`);
chomp($MB=`cat dfsadmin_report.txt| grep "Missing blocks:" | awk '{ print \$3 }'`);

`rm -rf dfsadmin_report.txt`;

if ( ( $URB > 50 ) || ( $BWCR > 50) || ( $MB > 50 )) 
{
 print "CRITICAL: Looks like there might be more than 50 Under Replicated blocks or 50 Blocks with corrupted blocks or 50 Missing blocks, Please Fix it ASAP!";
 exit 2;
}
elsif ( ( $URB > 0 ) || ( $BWCR > 0) || ( $MB > 0 )) 
{
  print "WARNING: Looks like there might be more than 50 Under Replicated blocks or 50 Blocks with corrupted blocks or 50 Missing blocks!";
  exit 1;
}
else
{
 print "OK: Everythings looks good. Your HDFS Rocks!";
 exit 0;
}
