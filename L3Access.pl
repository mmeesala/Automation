#! /usr/bin/perl
# Author: Murali Meesala, <murali.meesala@ge.com>
# Script : L3Access.pl
# Version : v1.0
# Functionality : It will provide the access to L3support.
# Dependencies : hostfile.txt
# Usage : ./L3Access.pl -l ; ./L3Access.pl -a <userid> ; ./L3Access.pl -r <userid>.

use Switch;

sub CreateGroup{
	($grp)=@_;
	print "Creating $grp Group...\n";
	print "groupadd $grp\n";
	`ssh $H groupadd $grp`;
	print "Completed!\n";	
}

sub AddUserToGroup{
	($user)=@_;
        print "Adding $user to L3support group...\n";
	print "ssh $H usermod -a -G L3support $user\n";
	`ssh $H usermod -a -G L3support $user`;
	print "Completed!\n";	
}

sub RemoveUserFromGroup{
	($user)=@_;
	print "Removing $user from L3support group...\n";
	print "ssh $H gpasswd -d $user L3support\n";
	`ssh $H gpasswd -d $user L3support`;
	print "Completed!\n";	
}

sub ListGroupUsers{
	print "Listing 'L3support' Group Users:\n";
	`ssh $H cat /etc/group | grep L3support`;
# 	$TMP=`ssh $H cat /etc/group | grep devops`;
 	$TMP=`ssh $H cat /etc/group | grep L3support`;
	print $TMP;
}

sub ListUserGroups{
	($user)=@_;
	print "Listing Groups for $user:\n";
	$TMP=`ssh $H groups $user`;
	print $TMP;
}

($val,$argument)=@ARGV;

print "VAL = $val\n";
print "ARGUMENT = $argument\n";

@Hosts = `cat hostfile.txt`;

foreach $H (@Hosts)
{
	chomp($H);
	print "\nHost = $H\n";
	
	switch ($val) {
			case "-l" { 
					ListGroupUsers(); 
					# ListUserGroups("murali");
			}
			
			case "-a" { 
					if ($argument) { 
						AddUserToGroup($argument); 
					} 
					else { 
						print "Missing argument to the given flag.\n"; 
						exit; 
					} 
			}

			case "-r" { 
					if ($argument) { 
						RemoveUserFromGroup($argument); 
					} 
					else { 
						print "Missing argument to the given flag.\n"; 
						exit; 
					} 
			}	
	
			case "-c" { 
					if ($argument) { 
						CreateGroup($argument); 
					} 
					else { 
						print "Missing argument to the given flag.\n"; 
						exit; 
					} 
			}
	
			else  { 
					print "You gave WRONG Options...\n"; 
					print "Correct Usage:\n \t./L3Access.pl -l\n"; 
					print "\t./L3Access.pl -a <username>\n"; 
					print "\t./L3Access.pl -r <username>\n"; 
					print "\t./L3Access.pl -c <groupname>\n"; 
					exit;
			}	
	}
	

}
