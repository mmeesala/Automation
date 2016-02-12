#!/usr/bin/perl
# Author: Murali Meesala <murali.meesala@gmail.com>
# Sr. Bigdata Architect, California.
# Functionality: It will do the capacity planning based on your inputs for Hadoop Cluster builds.

use POSIX;

( $DIALY_AVG_ING_RATE , $REP_FACTOR, $NO_OF_DISKS_PER_NODE, $DISK_CAPACITY, $PERCENTAGE_GROWTH_PER_MONTH ) = @ARGV;

$NUM_OF_ARGS = $#ARGV + 1;

if ( $NUM_OF_ARGS != 5 ) {
	print "\nUsage: $0 <DAILY_AVG_ING_RATE> <REPLICATION_FACTOR> <NO_OF_DISKS_PER_NODE> <EACH_DISK_CAPACITY> <PERCENTAGE_GROWTH_PER_MONTH>";
	print "\nNote: Capacity is in TB's.\n\n";
	exit;
}


#$DIALY_AVG_ING_RATE = 1 ;# in TB's.
#$REP_FACTOR = 3 ;
$DAILY_RAW_CONSUMPTION = ( $DIALY_AVG_ING_RATE * $REP_FACTOR ) ; # in TB's

print "Daily Avg Ingestion rate = $DIALY_AVG_ING_RATE TB\n";
print "Replication Factor : $REP_FACTOR\n";
print "Daily Raw Consumption: $DAILY_RAW_CONSUMPTION TB\n";
print "Growth Percentage per Month : $PERCENTAGE_GROWTH_PER_MONTH %\n";

#$NO_OF_DISKS_PER_NODE = 12 ;
#$DISK_CAPACITY = 2 ; # in TBs

print "No. of Disks per Node : $NO_OF_DISKS_PER_NODE\n";
print "Each Disk Capacity : $DISK_CAPACITY TB\n";
 
$EACH_NODE_RAW_STORAGE = ( $NO_OF_DISKS_PER_NODE * $DISK_CAPACITY ) ; # In TB's

$MR_TMP_RESERVE_PERCENTAGE =  25 ;
$MR_TMP_RESERVE = ( $EACH_NODE_RAW_STORAGE *  $MR_TMP_RESERVE_PERCENTAGE ) / 100 ;

$NODE_USABLE_RAW_STORAGE = ( $EACH_NODE_RAW_STORAGE - $MR_TMP_RESERVE ) ;# In TB's

$TOTAL_REQ_NODES = ceil( $DIALY_AVG_ING_RATE * $REP_FACTOR * 365 / $NODE_USABLE_RAW_STORAGE ) ;

#$PERCENTAGE_GROWTH_PER_MONTH = 5;

#A = P (1+r/n)nt
$YPG = ceil ( $TOTAL_REQ_NODES * (1 + $PERCENTAGE_GROWTH_PER_MONTH /12 ) );
print "\nCapacity Planning based on your inputs:- \n";

print "	EACH_NODE_RAW_STORAGE  = $EACH_NODE_RAW_STORAGE TB\n" ;
print "	MAPREDUCE_TEMP_RESERVE = $MR_TMP_RESERVE_PERCENTAGE %\n";
print "	1 YEAR - FLAT GROWTH   = $TOTAL_REQ_NODES Nodes\n"; 
print "	1 YEAR - $PERCENTAGE_GROWTH_PER_MONTH % GROWTH PER MONTH = $YPG Nodes\n";
