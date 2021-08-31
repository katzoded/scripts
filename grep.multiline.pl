#!/usr/local/bin/perl


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
my $InMultilineSeparator = $ARGV[0];
my $InMultilineEndSeparator="";
my $InGrepFilter = $ARGV[1];
my $InGrepVFilter=0;
my $InFileName = $ARGV[2];

my $new_file = "";
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
        $InGrepFilter = "";
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
            elsif($ARGV[$i] eq "-gv")
            {
                $InGrepFilter = $ARGV[$i + 1];
                $InGrepVFilter=1;
            }
            elsif($ARGV[$i] eq "-g")
            {
                $InGrepFilter = $ARGV[$i + 1];
            }
            elsif($ARGV[$i] eq "-f")
            {
                $InFileName = $ARGV[$i + 1];
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
    print STDOUT "\n-h Print this help";
    print STDOUT "\n-ss \"RegEx for Start Separator\"";
    print STDOUT "\n-es \"RegEx for End Separator\" (in case -es doesn't exist only -ss will be used)";
    print STDOUT "\n-g \"RegEx for grepping the multiline\" whatever passes this RegEx will be in output";
    print STDOUT "\n-gv \"RegEx for grepping the multiline\" whatever passes this RegEx will NOT be in output";
    print STDOUT "\n-f \"Input file name\" - this param is not mandatory, STDIN can be used as input ";
    print STDOUT "\nSupport backward comp of using \"RegExp for Start Separator\" \"RegEx for grepping the multiline\" \"Input File name\"";
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
sub CheckAndAddToResult
{
    if(($PassesUserFilter == 1 && $InGrepVFilter == 0) ||  ($PassesUserFilter == 0 && $InGrepVFilter == 1) )
    {
        $keyVal=$keyVal+1;
        $hash{$keyVal}->{stack} = $cmi;
    }
    $cmi="";
    $PassesUserFilter=0;
}

LoadParams();
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
    if($line =~ /$UserFilter/)
    {
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



