#! /usr/bin/perl
# Author: Murali Meesala, <murali.meesala@gmail.com>
# Sr. Hadoop Architect
# Script Name: hdfs_report.pl
# Functionality: It will scan the HDFS path and generates the report of user and group usage which was not touched from last 30 days. Also, it will list out all the files names along with size, user and date of the file last touched.
# Usage : ./hdfs_report 

`hadoop fs -ls -R / | grep ^- > lsr_report.txt`;

`cat lsr_report.txt | awk \'{ print \$3 }\' | sort | uniq > hdfs_file_ownerslist.txt`;
`cat lsr_report.txt | awk \'{ print \$4 }\' | sort | uniq > hdfs_file_grouplist.txt`;
`cat lsr_report.txt | awk \'{ print \$2 }\' | sort | uniq > hdfs_rfs.txt`;

chomp($cutoff_date=`date -d "30 days ago" '+%Y-%m-%d'`);

open (OUT,">consider_files.txt");

for $LINE (`cat lsr_report.txt`)
{
	chomp($LINE);
	($perm,$rf,$owner,$group,$size,$rec_date,$hrs,$filename)=split(/\s+/,$LINE);	
	print OUT "$rf $owner $group $size $rec_date $filename\n" if $rec_date lt $cutoff_date;
}

close(OUT);

## Processing User data
open (USER_USAGE_DATA,">user_usage_data.txt");
open (USER_FILE_DATA,">user_files__data.txt");
$FILESIZE=10240;
for $USER (`cat hdfs_file_ownerslist.txt`)
{
	chop($USER);
	#print "MM = $USER";
	chomp($user_usage=`awk  \'\$2 ~ /^$USER\$/ {sum+=\$4} END {printf (\"\%.2f\", sum/(1024*1024*1024*1024) ) }\' consider_files.txt`); 

	chomp($FILENAMES=`awk  \'\$2 ~ /^$USER\$/  && \$2 > \$FILESIZE { print \$2,\$4,\$5,\$6 }\' consider_files.txt`); 

	if ($user_usage >= 1.0) {
	print USER_USAGE_DATA "$USER = $user_usage TB\n";
	#print "$FILENAMES\n";
	print USER_FILE_DATA "$FILENAMES\n";
	}
}
close(USER_USAGE_DATA);
close(USER_FILE_DATA);
## Processing group data


open (GROUP_USAGE_DATA,">group_usage_data.txt");

for $GROUP (`cat hdfs_file_grouplist.txt`)
{
	chop($GROUP);
	chomp($group_usage=`awk  \'\$3 ~ /^$GROUP$\/ {sum+=\$4} END {printf (\"\%.2f\", sum/(1024*1024*1024*1024) ) }\' consider_files.txt`);
	if ($group_usage >= 1.0 ) {
	print GROUP_USAGE_DATA "$GROUP = $group_usage TB\n";
	}
}
close(GROUP_USAGE_DATA);

## Prepare report.
print "----------------------------------------------------\n";
print "User Usage Information:\n";
$DATA=`cat user_usage_data.txt | sort -rnk3`;
print $DATA;

print "----------------------------------------------------\n";
print "Users filelist which was not touched from last 30 days and user total data usage is morethan 1 TB:\n";
$DATA=`cat user_files__data.txt | sort`;
print $DATA;

print "----------------------------------------------------\n";

print "Group Usage Information:\n";
$DATA=`cat group_usage_data.txt | sort -rnk3`;
print $DATA;
print "----------------------------------------------------";
print "Done!";

