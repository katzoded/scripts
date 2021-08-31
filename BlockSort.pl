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
	if ($line =~ /(\d+)\/(\d+)\/(\d+) (\d+):(\d+):(\d+).(\d+)(.*)/) {
		  $keyVal=$4; 
		  $keyVal=($keyVal * 100) + $5; 
		  $keyVal=($keyVal * 100) + $6; 
		  $keyVal=($keyVal * 1000000) + $7;
		  
		  $hash{$keyVal}->{Line_Data} = $line;
		  $hash{$keyVal}->{stack} = '';		
	}
	else	
	{
		if($keyVal ne "") {
		       $hash{$keyVal}->{stack} .= $line;
	    }
	}
}
open(my $fh, '>', $new_file) or die "Could not open file '$new_file' $!";
foreach my $key (sort { $a <=> $b } keys %hash) {
                 print $fh $hash{$key}->{Line_Data}, "\n";
                 print $fh $hash{$key}->{stack};
}
close $fh;

