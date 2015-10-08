#!/usr/bin/perl

($FILE)=@ARGV;

print "\n\nFilename: $FILE\n";

@NAME_ARRAY=`cat $FILE | grep "<name>"`;
@VALUE_ARRAY=`cat $FILE | grep "<value>"`;

$NAME_ARRAY_LENGTH=@NAME_ARRAY;
$VALUE_ARRAY_LENGTH=@VALUE_ARRAY;


for ($i=0; $i<$NAME_ARRAY_LENGTH ; $i++)
{
	chomp($n=$NAME_ARRAY[$i]);
	chomp($v=$VALUE_ARRAY[$i]);	
	
	$n =~ s/<name>//g;
	$n =~ s/<\/name>//g;
	$n =~ s/\s+//g;

	$v =~ s/<value>//g;
	$v =~ s/<\/value>//g;
	$v =~ s/\s+//g;
		
	print "$n = $v\n";
}
