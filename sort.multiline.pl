#!/usr/bin/perl

use Data::Dumper;
use strict;
use warnings;

# open the file whose name is given in the first argument on the command
# line, assigning to a file handle INFILE (it is customary to choose
# all-caps names for file handles in Perl); file handles do not have any
# prefixing punctuation
my $keyVal = "";
my $line;
my $key;
my $cmi="";
my $OpenBracketCount;
my $CloseBracketCount;
my $StartCounting=0;
my $CloseBracketCurrCount;
my $OpenBracketCurrCount;
my $PassesUserFilter=0;
my $FoundCount = 0;
my $InMultilineSeparator = $ARGV[0];
my $InMultilineEndSeparator="";
my $InSortRegExp = $ARGV[1];
my $InFileName = $ARGV[2];
my $Uniq=0;
my $PrintCount=0;
my $HumanSort=0;
my $new_file = "";
my $fh;
my %hash = ();

sub LoadParams
{
    my $NewIf = 0;
    
    if($ARGV[0] =~ "-h")
    {
        printHelp();
    }
    for(my $i = 0; $i < $#ARGV; $i++)
    {
        if($ARGV[$i] =~ /^-.*/)
        {
            $NewIf = 1;
        }
    }
    if($NewIf == 1)
    {
        $InMultilineSeparator = "";
        $InSortRegExp = "";
        $InFileName = "";

        for(my $i = 0; $i < $#ARGV; $i++)
        {
            if($ARGV[$i] eq "-ss")
            {
                $InMultilineSeparator = $ARGV[$i + 1];
            }
            elsif($ARGV[$i] eq "-es")
            {
                $InMultilineEndSeparator = $ARGV[$i + 1];
            }
            elsif($ARGV[$i] eq "-sp")
            {
                $InSortRegExp = $ARGV[$i + 1];
            }
            elsif($ARGV[$i] eq "-f")
            {
                $InFileName = $ARGV[$i + 1];
            }
            elsif($ARGV[$i] eq "-u")
            {
                $Uniq = 1;
            }
            elsif($ARGV[$i] eq "-c")
            {
                $PrintCount = 1;
            }
            elsif($ARGV[$i] eq "-h")
            {
                $HumanSort = 1;
            }
        }
    }
    else
    {
        printHelp();
    }
}

sub printHelp
{
    print STDOUT "\n--help Print this help";
    print STDOUT "\n-ss \"RegEx for Start Separator\"";
    print STDOUT "\n-es \"RegEx for End Separator\" (in case -es doesn't exist only -ss will be used)";
    print STDOUT "\n-sp \"RegEx for sort param\" whatever passes this RegEx will be in output";
    print STDOUT "\n-f \"Input file name\" - this param is not mandatory, STDIN can be used as input ";
    print STDOUT "\n-u uniq";
    print STDOUT "\n-c count";
    print STDOUT "\n-h human sort";
    print STDOUT "\nExample for Date sorting DATE_FORMAT=\"[0-9]*/[0-9]*/[0-9]* [0-9]*:[0-9]*:[0-9]*:[0-9]*\" \n -ss \"^\[\${DATE_FORMAT}\]\" -sp  \"^\[\${DATE_FORMAT}\]\"";
    exit;
}

sub MyReadline
{
    if($InFileName)
    {
        $line = <INFILE>;
    }
    else
    {
        $line = <STDIN>;
    }
}

sub PrintHashEntry
{
    my $key=shift;
    my $PrintedStr="";
    
    if($PrintCount == 1)
    {
        $PrintedStr = $hash{$key}->{count}." ";
    }
    $PrintedStr = $PrintedStr . $hash{$key}->{stack};
    
    if($fh)
    {
        print $fh $PrintedStr;
    }
    print STDOUT $PrintedStr;
}

sub CheckAndAddToResult
{
    if($PassesUserFilter == 1)
    {
        if($Uniq == 0 || not defined $hash{$keyVal}  )
        {
            $hash{$keyVal}->{stack} .= $cmi;
            $hash{$keyVal}->{count} = 0;
        }
        $hash{$keyVal}->{count} = $hash{$keyVal}->{count} + 1;
    }
    $keyVal="";
    $cmi="";
    $PassesUserFilter=0;
}

LoadParams();
if($InFileName)
{
    open(INFILE,$InFileName);
}

MyReadline();
while ($line)
{
    if($line =~ /$InMultilineSeparator/)
    {
        if($InMultilineEndSeparator eq "")
        {
            CheckAndAddToResult();
        }
        else
        {
            my @splitarr= split(/$InMultilineSeparator/,$line);
            $FoundCount=$FoundCount+@splitarr;
        }
    }
    if($line =~ /($InSortRegExp)/)
    {
        my $SortStr=$1;
        if(defined $2)
        {
            $SortStr=$2;
        }
        $keyVal=$keyVal.$SortStr; 
        $PassesUserFilter=1;
    }
    $cmi.=$line;
    if(not $InMultilineEndSeparator =~ "")
    {
        if($FoundCount > 0 && $line =~ /$InMultilineEndSeparator/)
        {
            my @splitarr= split(/$InMultilineEndSeparator/,$line);
            $FoundCount=$FoundCount-@splitarr;
            
            if($FoundCount == 0)
            {
                CheckAndAddToResult();
            }
        }       
    }
    MyReadline();
}

CheckAndAddToResult();

if($new_file)
{
    open($fh, '>', $new_file) or die "Could not open file '$new_file' $!";
}
if($HumanSort == 0)
{
    foreach my $key (sort keys %hash)
    {
        PrintHashEntry($key);
    }
}
else
{
    foreach my $key (sort { $a <=> $b } keys %hash)
    {
        PrintHashEntry($key);
    }    
}
if($fh)
{
    close $fh;
}
#print STDOUT "Process CMI=$keyVal, Written CMI=$FoundCount, WrittenInfo=$FoundCountNonCmi\n";



