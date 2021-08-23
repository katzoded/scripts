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
my $update1;
my $lastLineNumber;
my $PreArrangedStr;
my $ArrangedStr;
my $lastElement="";

my $lastCallId;
my $lastCmiFrom;
my $lastCmiTo;
my $lastCmiMsgId;
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
print $fh "title $new_file \r\n";
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
#            $lastAggregatedline =~ s{\n}{ }g;
#            $lastAggregatedline =~ s/\n/ /g;
#           $lastAggregatedline =~ s/\r|\n/\\n/g;
        $lastAggregatedline =~ s/\\n\\n/\\n/g;

		print $fh "$lastAggregatedline$lastTime\\n{LineNumber=$lastLineNumber}\r\n";
#            $lastAggregatedline =~ s/\\n/\\\\n/g;
        print STDOUT "$lastAggregatedline$lastTime\\n{LineNumber=$lastLineNumber}\r\n";
		$lastAggregatedline="";
		$lastTime="";
	}
}

while ($line = <INFILE>)
{
	$lineNumber= $lineNumber+1;
	if ($line =~ /(^\[\d*\/\d*\/\d* \d*:\d*:\d*:\d*\]).*/)
	{
        PrintAggregatedLineStr();
		$lastTime=$1;
		$lastLineNumber=$lineNumber;
    	if ($line =~ /^\[.*\].*, (.*)->(.*):(.*)\n/)
    	{
    	    $lastElement=$2;
    	    $lineData="$1->$2:$3";
        	$lastAggregatedline=$lineData;
            $lastAggregatedline =~ s/\r|\n/\\n/g;
    	}
    	else
    	{
        	if ($line =~ /^\[.*\].*, note over ([a-zA-Z\-]*)#([a-z]*):(.*)\n/)
        	{
        	    $lastElement=$2;
            	$PreArrangedStr=$3;
            	ArrangeStr();

        	    $lineData="note over $1#$2:$ArrangedStr\\n";
            	$lastAggregatedline=$lineData;
        	}
        	else 
        	{
        	    if($line =~ /^\[.*\].*, (.*)\n/)
        	    {
        	        if(!($lastElement =~ ""))
        	        {
                    	$PreArrangedStr=$1;
                    	ArrangeStr();

                	    $lineData="note over $lastElement:$ArrangedStr\\n";
                    	$lastAggregatedline=$lineData;
                    	}
            	}
        	}
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
#print STDOUT "Process CMI=$keyVal, Written CMI=$FoundCount\n";



