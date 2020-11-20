#!/usr/bin/perl

use Data::Dumper;
use strict;
use warnings;

# open the file whose name is given in the first argument on the command
# line, assigning to a file handle INFILE (it is customary to choose
# all-caps names for file handles in Perl); file handles do not have any
# prefixing punctuation
my $keyVal = 0;
my $line;
my $key;
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
my $FoundCountNonCmi = 0;
my $IsTimeLine = 0;
my $InMultilineSeparator = $ARGV[0];
my $InGrepFilter = $ARGV[1];
my $InSearch = $ARGV[2];
my $InReplace = $ARGV[3];
my $InFileName = $ARGV[4];
my $new_file = "";
my %hash = ();

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

sub ProcessMultilineData
{
    if($PassesUserFilter == 1)
    {
        $cmi =~ s/$InSearch/$InReplace/g;
        
        if($InSearch =~ "\n" && $InReplace =~ "\\n")
        {
            $cmi = $cmi . "\n";
        }
        if($InSearch =~ "\r" && $InReplace =~ "\\r")
        {
            $cmi = $cmi . "\n";
        }
    }
    $keyVal=$keyVal+1;
    $hash{$keyVal}->{stack} = $cmi;
    $FoundCountNonCmi = $FoundCountNonCmi + 1;
    $cmi=$line;
    $IsTimeLine=1;
    $PassesUserFilter=0;
}

if($InFileName)
{
    open(INFILE,$InFileName);
    $new_file = $InFileName;
}
if($InGrepFilter)
{
	$UserFilter=$InGrepFilter;
	$UserFilterFileName=$InGrepFilter;
	$UserFilterFileName =~ s/\{//g;
	$UserFilterFileName =~ s/\}//g;
	$UserFilterFileName =~ s/://g;
	$UserFilterFileName =~ s/ //g;
	$UserFilterFileName =~ s/\|/-/g;
	$UserFilter =~ s/\{/\\\{/g;
	$UserFilter =~ s/\}/\\\}/g;
	
#	print STDOUT "Argv=$InGrepFilter, UserFilter=$UserFilter, UserFilterFileName=$UserFilterFileName\n";

    if($InFileName)
    {
        $new_file .= ".$UserFilterFileName";
    }
}
else
{
    if($InFileName)
    {
        $new_file .= ".cmi";
    }
}
MyReadline();
while ($line)
{
	if($line =~ /$InMultilineSeparator/)
	{
        ProcessMultilineData();
	}
	if($line =~ /.*$UserFilter.*/)
	{
		$PassesUserFilter=1;
	}
    if($IsTimeLine!=1)
    {
        $cmi .= $line;
    }
    $IsTimeLine=0;
    MyReadline();
}

ProcessMultilineData();

my $fh;
if($new_file)
{
    open($fh, '>', $new_file) or die "Could not open file '$new_file' $!";
}
foreach my $key (sort { $a <=> $b } keys %hash)
{
    if($fh)
    {
        print $fh $hash{$key}->{stack};
    }
    print STDOUT $hash{$key}->{stack};
}
if($fh)
{
    close $fh;
}
#print STDOUT "Process CMI=$keyVal, Written CMI=$FoundCount, WrittenInfo=$FoundCountNonCmi\n";



