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

my %hash = ();

open(INFILE,$ARGV[0]);

$new_file .= ".flow";
$new_filtered_file .= ".flow.filtered";
$new_compare_file .= ".flow.compare";
$new_msg_file .= ".flow.msg";

open(my $fh, '>', $new_file) or die "Could not open file '$new_file' $!";
open(my $fh_filtered, '>', $new_filtered_file) or die "Could not open file '$new_filtered_file' $!";
open(my $fh_compare, '>', $new_compare_file) or die "Could not open file '$new_compare_file' $!";
open(my $fh_msg, '>', $new_msg_file) or die "Could not open file '$new_msg_file' $!";
print $fh "title $new_file \r\n";
print $fh_filtered "title $new_file \r\n";
print $fh_compare "title $new_file \r\n";
print $fh_msg "title $new_file \r\n";
print STDOUT "title $new_file \r\n";

sub ArrangeStr{
    my $c;
    my $prevIsSlash=0;
    my $NewLineCounter=0;
    $ArrangedStr="";
    for ( my $i = 0; $i < length($PreArrangedStr); $i++ )
    { 
        $c = substr( $PreArrangedStr, $i, 1);
        $ArrangedStr = "$ArrangedStr$c";
        $NewLineCounter++;
       
        if("$c" =~ "\n")
        {
            $NewLineCounter=0;
        }
        if($prevIsSlash == 1)
        {
            $prevIsSlash=0;
            if("$c" =~ "n")
            {
                $NewLineCounter=0;
            }
        }
        if("$c" =~ "\\\\")
        {
            $prevIsSlash=1
        }
        if(($NewLineCounter >= 60) && "$c" =~ " ")
        {
            $ArrangedStr = "$ArrangedStr\\n";
            $NewLineCounter=0;
        }
        if($NewLineCounter == 70)
        {
            $ArrangedStr = "$ArrangedStr\\n";
            $NewLineCounter=0;
        }
    }
    $ArrangedStr =~ s/\r|\n/\\n/g;
#    $ArrangedStr =~ s/\\n\\n/\\n/g;
}

sub PrintAggregatedLineStr
{
	if ($lastAggregatedline)
	{
	    my $SearchStr;
	    my $ReplaceStr;
        $lastAggregatedline =~ s/\\n\\n/\\n/g;

		#print STDOUT "$lastAggregatedline$lastTime\\n{LineNumber=$lastLineNumber}\r\n";

    	if (($lastAggregatedline =~ /.*SIP\/2\.0.*/ && ($currentIsSending =~ 1 || $currentIsReceiving =~ 1)) || ($lastAggregatedline =~ /.*->.*/))
    	{
    	    my $changeToColor="";
    	    
        	if($currentIsSending =~ 1)
        	{
            	$changeToColor="yellow";
    		}
    		elsif($currentIsReceiving =~ 1)
    		{
            	$changeToColor="lightblue";
    		}

            if($changeToColor ne "")
    		{
                $lastAggregatedline =~ s/orange/$changeToColor/g;
    		}
		    print $fh_msg "$lastAggregatedline$lastTime\\n{LineNumber=$lastLineNumber}\r\n";
            $currentIsSending=0;
            $currentIsReceiving=0;
    	}
		print $fh "$lastAggregatedline$lastTime\\n{LineNumber=$lastLineNumber}\r\n";
    	if (!($lastAggregatedline =~ /.*lightgreen/))
    	{
    	    if (!($lastAggregatedline =~ /.*Dummy*->/))
    	    {
    		    print $fh_filtered "$lastAggregatedline$lastTime\\n{LineNumber=$lastLineNumber}\r\n";
		    }
    	}

        $SearchStr="$currentEntityNAME-$currentEntityID";
        $ReplaceStr=$currentEntityNAME;
        if(!($currentEntityNAME =~ ""))
        {
            $lastAggregatedline =~ s/$SearchStr/$ReplaceStr/g;
        }

        $SearchStr="$currentEntityNAME2-$currentEntityID2";
        $ReplaceStr=$currentEntityNAME2;
        if(!($currentEntityNAME2 =~ "-"))
        {
            $lastAggregatedline =~ s/$SearchStr/$ReplaceStr/g;
        }

		print $fh_compare "$lastAggregatedline\r\n";

#        print STDOUT "$lastAggregatedline$lastTime\\n{LineNumber=$lastLineNumber}\r\n";
		$lastAggregatedline="";
		$lastTime="";
	}
}

$currentIsSending=0;
$currentIsReceiving=0;

while ($line = <INFILE>)
{
	$lineNumber= $lineNumber+1;
	if ($line =~ /(^\[\d*\/\d*\/\d* \d*:\d*:\d*:\d*\]).*/)
	{
		#print STDOUT "$1 \n";
        PrintAggregatedLineStr();
    	$currentEntityID="";
    	$currentEntityID2="";
    	$currentEntityNAME="";
    	$currentEntityNAME2="";
		$lastTime=$1;
		$lastLineNumber=$lineNumber;
    	if ($line =~ /^\[.*\].*, ([a-zA-Z0-9_]*)[-]+(\d*)->([a-zA-Z0-9_]*)[-]+(\d*):(.*)\n/)
    	{
#			print STDOUT "$1   $2    $3    $4\n";
    	    $currentEntityNAME=$3;
    	    $currentEntityID=$4;
    	    $currentEntityNAME2=$1;
    	    $currentEntityID2=$2;
    	    $lineData="$1-$2->$3-$4:$5";
        	$lastAggregatedline=$lineData;
            $lastAggregatedline =~ s/\r|\n/\\n/g;
    	}
    	if ($line =~ /^\[.*\].*, note over ([a-zA-Z0-9_]*)[-]+(\d*)#([a-z]*):(.*)\n/)
    	{
			#print STDOUT "$1   $2    $3    $4\n";
    	    $currentEntityNAME=$1;
    	    $currentEntityID=$2;
        	$PreArrangedStr=$4;
        	ArrangeStr();

    	    $lineData="note over $1-$2#$3:$ArrangedStr\\n";
        	$lastAggregatedline=$lineData;
    	}
#
#
    	if($line =~ /.*====> Sending message.*/)
    	{
            $currentIsSending=1;
    	}
    	if($line =~ /.*<==== Receiving message.*/)
    	{
            $currentIsReceiving=1;
    	}
	}
	else
	{
	    if($lastAggregatedline)
	    {
        	if ($line =~ /(.*)/)
        	{
            	$PreArrangedStr=$line;
            	ArrangeStr();
            	
    	        $lastAggregatedline = "$lastAggregatedline$ArrangedStr";
    	    }
	    }
	}
	
#			print STDOUT "$line --- Open=$OpenBracketCount, Close=$CloseBracketCount\n";

}

PrintAggregatedLineStr();

close $fh;
close $fh_filtered;
close $fh_compare;
close $fh_msg;

#print STDOUT "Process CMI=$keyVal, Written CMI=$FoundCount\n";



