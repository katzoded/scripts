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
my $RegExp = $ARGV[1];

open(INFILE,$ARGV[0]);

while ($line = <INFILE>)
{
	$lineNumber= $lineNumber+1;
	if ($line =~ /$RegExp/)
	{
#		print STDOUT $line;
		my $CompleteStr = "";
    	if ($line =~ /([0-9]*\.[0-9]* .*)\(([0-9]*), ([0-9]*), ([0-9]*), ([0-9]*)\)/)
    	{
			my $hex = sprintf("%X%X%X", $3, $4, $5);
			my $str = "";
			my $hexDigit = "";
			my $Count=0;
			
			for my $c (split //, $hex)
			{
				$Count = $Count + 1;
				$hexDigit = $hexDigit . $c;
				
				if($Count == 2)
				{
					if($hexDigit ne "00")
					{
						$str = chr(hex($hexDigit));
						$Count = 0;
						$hexDigit	= "";
						$CompleteStr = $CompleteStr . $str;
					}
				}
			}
			$hex = sprintf("%X", $2);
			
			my $RegId = int(hex(substr($hex, -8)));
			my $LineNumber=int(hex(substr($hex, 0, length($hex) - 8)));

			printf STDOUT "$1:$LineNumber($RegId, $CompleteStr)\n";
    	}
	}
	else
	{
			printf STDOUT "$line";
	}
}
