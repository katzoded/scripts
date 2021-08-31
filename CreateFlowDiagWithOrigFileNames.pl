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
my $lastPresTime;
my $lastCallId;
my $lastCmiFrom;
my $lastCmiTo;
my $lastCmiMsgId;
my $lastCmiLineNumber;
my $new_file = $ARGV[0];
my $cmi="";
my $OpenBracketCount;
my $CloseBracketCount;
my $StartCounting=0;
my $CloseBracketCurrCount;
my $OpenBracketCurrCount;
my $PassesUserFilter=0;
my $UserFilter="";
my $UserFilterFileName;
my $FoundCount = 0;
my $lastSendOrReceive = "";
my $currSendOrReceive = "";

my %hash = ();

open(INFILE,$ARGV[0]);

$new_file .= ".flow";

open(my $fh, '>', $new_file) or die "Could not open file '$new_file' $!";
print $fh "title $new_file \n";

while ($line = <INFILE>)
{
	$lineNumber= $lineNumber+1;
	if($line =~ /Sending Message/)
	{
	    $currSendOrReceive="(S)";
	}
	else
	{
    	if($line =~ /Received Message/)
    	{
    	    $currSendOrReceive="(R)";
    	}
		else
		{
			if($line =~ /Received Event/)
			{
				$currSendOrReceive="(R)";
			}
		}
    }
	if ($line =~ /(\[.*\]).*/)
	{
		if($lastCmiFrom)
		{
			print $fh "$lastPresTime sortby $lastCmiFrom->$lastCmiTo:$lastSendOrReceive$lastCmiMsgId \\n ($lastCallId) \\n Link[$ARGV[0]:$lastCmiLineNumber] \\n $lastPresTime \\n \n";
			$lastCmiFrom="";
			$lastCmiTo="";
			$lastCmiMsgId="";
			$lastSendOrReceive="";
		}
		$lastPresTime=$1;
		$lastSendOrReceive=$currSendOrReceive;
	}
	
	if($line =~ /LocalCallId: CMP_LocalCallId \{ CallId (\d+)/)
	{
		$lastCallId = $1;
	}
	if ($line =~ /^CMI_([a-zA-Z0-9]*)_([a-zA-Z0-9]*)_([a-zA-Z_0-9]*)/)
	{
		$lastCmiFrom=$1;
		$lastCmiTo=$2;
		$lastCmiMsgId=$3;
		$lastCmiLineNumber=$lineNumber;
	}
	if($line =~ /.*from.*[:] ([0-9a-zA-Z_]*) to.*[:] ([0-9a-zA-Z_]*)/i)
	{
    	my $fromState=$1;
    	my $toState=$2;
    	
#    	$fromState=~ s/(.*) .*//;
#    	$toState=~ s/(.*) .*//;
		print $fh "$lastPresTime sortby note left of SMTrans\n$fromState->$toState\\n($lastCallId)\\n Link[$ARGV[0]:$lineNumber]\\n $lastPresTime\\n \nend note\n";
	}
	
#			print STDOUT "$line --- Open=$OpenBracketCount, Close=$CloseBracketCount\n";

}
if($lastCmiFrom)
{
	print $fh "$lastPresTime sortby $lastCmiFrom->$lastCmiTo:$lastSendOrReceive$lastCmiMsgId \\n ($lastCallId) \\n Link[$ARGV[0]:$lastCmiLineNumber] \\n $lastPresTime \\n \n";
}

close $fh;
#print STDOUT "Process CMI=$keyVal, Written CMI=$FoundCount\n";



