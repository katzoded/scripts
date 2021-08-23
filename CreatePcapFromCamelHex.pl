#!/usr/bin/perl

use Data::Dumper;
use strict;
use warnings;

# open the file whose name is given in the first argument on the command
# line, assigning to a file handle INFILE (it is customary to choose
# all-caps names for file handles in Perl); file handles do not have any
# prefixing punctuation
my $lineNumber = 0;
my $line;
my $lineData;
my $lastTime;
my $lastAggregatedline;
my $updatedLine;
my $new_file = $ARGV[0];
my $new_compare_file = $ARGV[0];
my $new_msg_file = $ARGV[0];
my $new_filtered_file = $ARGV[0];
my $update1;
my $lastLineNumber;
my $PreArrangedStr;
my $ArrangedStr;
my $currentEntityID;
my $currentEntityID2;
my $currentEntityNAME;
my $currentEntityNAME2;
my $currentIsSending;
my $currentIsReceiving;
my $OutFileName;

$OutFileName = $ARGV[0]. "\.pcap";
$OutFileName =~ s/\s//g;
open(my $fh, '>', $OutFileName) or die "Could not open file '$OutFileName' $!";
binmode $fh;

 print $fh pack("H*", "a1b2c3d40002000400000000000000000000ffff00000001");
#print $fh pack("H*", "d4c3b2a1020004000000000000000000ffff000001000000");

open(INFILE,$ARGV[0]);

while ($line = <INFILE>)
{
	$lineNumber= $lineNumber+1;
	if ($line =~ /^45 */)
	{
		$line =~ s/\s//g;
		print STDOUT $line;
		my $BufferLen;
		my $BufferLenHexFormat;
		
		my @arr_data;
		$BufferLen = length($line) / 2 + 14;
		$BufferLenHexFormat = sprintf ("%08x", $BufferLen);
		@arr_data=pack("H*", "0000000000000000");
		print $fh @arr_data;
		@arr_data=pack("H*", $BufferLenHexFormat);
		print $fh @arr_data;
		@arr_data=pack("H*", $BufferLenHexFormat);
		print $fh @arr_data;
		@arr_data=pack("H*", "0000000000000000000000000800");
		print $fh @arr_data;
		@arr_data=pack("H*", $line);
		print $fh @arr_data;
	}

#$filename = "data.out";
#open DATAOUT,">$filename"
# or die "Error opening file $filename: $!\n";
# set the stream to binary mode
#binmode DATAOUT;
#close DATAOUT
# or die "Error closing file $fielname: $!\n";
 
		
} 
close $fh;
