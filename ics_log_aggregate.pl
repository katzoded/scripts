#!/usr/bin/perl

use Data::Dumper;
use strict;
use warnings;

# open the file whose name is given in the first argument on the command
# line, assigning to a file handle INFILE (it is customary to choose
# all-caps names for file handles in Perl); file handles do not have any
# prefixing punctuation
my $keyVal="";
my $line;
my $key;
my $new_file = $ARGV[0];
$new_file .= ".sorted";
my %hash = ();

open(INFILE,$ARGV[0]);

while ($line = <INFILE>) {
	if ($line =~ /^([A-Z][a-z][a-z]) ([A-Z][a-z][a-z]) (\d+) (\d+):(\d+):(\d+) (\d+) (.*)/)
	{
		  $keyVal=$3; 
		  $keyVal=($keyVal * 100) + $4; 
		  $keyVal=($keyVal * 100) + $5; 
		  $keyVal=($keyVal * 100) + $6; 
#		  $keyVal=($keyVal * 1000000) + $7;
		  
		  if(exists $hash{$keyVal})
		  {
		       $hash{$keyVal}->{stack} .= $line;
		  }
		  else
		  {
			  $hash{$keyVal}->{Line_Data} = $line;
			  $hash{$keyVal}->{stack} = '';		
		  }
	}
	else	
	{
		
		if($keyVal ne "")
		{
		       $hash{$keyVal}->{stack} .= $line;
	    }
#		print STDOUT "keyVal=$keyVal line=$line";
#		print STDOUT "$hash{$keyVal}->{stack}";
	}
}
open(my $fh, '>', $new_file) or die "Could not open file '$new_file' $!";
foreach my $key (sort { $a <=> $b } keys %hash)
{
                 print $fh $hash{$key}->{Line_Data};
                 print $fh $hash{$key}->{stack};
}
close $fh;

