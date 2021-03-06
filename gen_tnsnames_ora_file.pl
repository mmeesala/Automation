#! /usr/bin/perl
# Author: Murali Meesala <murali.meesala@gmail.com>
# Script: gen_tnsnames_ora_file.pl
# Version: v1.0
# Functionality: It will read tns.dat file which has OBJECT_STRING, HOST, PORT, SID and generate the tnsnames.ora file
# Usage: ./gen_tnsnames_ora_file.pl
# Output: It will generate master_tnsnames.ora file 

open (IN,"<tns.dat");
open (OUT,">master_tnsnames.ora");

  print OUT "#-------------------------------------------------------------------------------\n";
while (<IN>)
{
  @line=split(/\s+/,$_);
#  print OUT "OBJ: $line[0]   HOST: $line[1]   PORT: $line[2]    SID: $line[3]\n";
  print OUT "$line[0] = \n";
  print OUT " (DESCRIPTION = \n";
  print OUT "   (ADDRESS = (PROTOCOL = TCP) (HOST = $line[1]) (PORT = $line[2]))\n";
  print OUT "     (CONNECT_DATA = \n";
  print OUT "       (SERVER = DEDICATED) \n";
  print OUT "       (SERVICE_NAME = $line[3]) \n";
  print OUT "     ) \n";
  print OUT " ) \n";
  print OUT "#-------------------------------------------------------------------------------\n";
}

close(IN);
close(OUT);
