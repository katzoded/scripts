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
my $PassesUserFilter=0;
my $UserFilter="";
my $UserFilterFileName;
my $FoundCount = 0;
my $InMultilineEndSeparator="";
my $InGrepFilter;
my $InGrepVFilter=0;
my $InFileName;
my $InNumReg = "";
my $numtohexreg = "";
my $hextoword32reg = "";
my $hextocharreg = "";
my $InPrefixReg = "";
my $InSuffixReg = "";

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
        $InGrepFilter = "";
        $InFileName = "";

        for(my $i = 0; $i < $#ARGV; $i++)
        {
            if($ARGV[$i] eq "-gv")
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
            elsif($ARGV[$i] eq "-numtohexreg")
            {
                $numtohexreg = $ARGV[$i + 1];
                $InNumReg = $numtohexreg;
            }
            elsif($ARGV[$i] eq "-hextocharreg")
            {
                $hextocharreg = $ARGV[$i + 1];
                $InNumReg = $hextocharreg;
            }
            elsif($ARGV[$i] eq "-hextoword32reg")
            {
                $hextoword32reg = $ARGV[$i + 1];
                $InNumReg = $hextoword32reg;
           }
            elsif($ARGV[$i] eq "-prefixreg")
            {
                $InPrefixReg = $ARGV[$i + 1];
            }
            elsif($ARGV[$i] eq "-suffixreg")
            {
                $InSuffixReg = $ARGV[$i + 1];
            }
        }
    }
}

sub printHelp
{
    print STDOUT "\n-h Print this help";
    print STDOUT "\n-numreg \"RegEx for converting the Number to Hex";
    print STDOUT "\n-numtohexreg \"RegEx for converting the Number to Hex";
    print STDOUT "\n-hextocharreg \"RegEx for converting the Number to Hex";
    print STDOUT "\n-hextoword32reg \"RegEx for converting the Number to Hex";
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
    my $CompleteStr = $line;
    $PassesUserFilter=0;
    if ($line =~ /$InGrepFilter/)
    {
        $PassesUserFilter = 1;
        $CompleteStr = "";
    }

    if(($PassesUserFilter == 1 && $InGrepVFilter == 0) ||  ($PassesUserFilter == 0 && $InGrepVFilter == 1) )
	{
        my @matches = ( $line =~ /$InPrefixReg/ );
        foreach ( @matches )
        {
            $CompleteStr = $CompleteStr . $_;
        }	

        @matches = ( $line =~ /$InNumReg/ );
        foreach ( @matches )
        {
            if($numtohexreg ne "")
            {
                my $hex = sprintf("%X", $_);
                $CompleteStr = $CompleteStr . $hex;
            }
            elsif($hextocharreg ne "")
            {
                my $hexDigit = "";
                my $Count = 0;
                my $str;
                for my $c (split //, $_)
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
            }
            elsif($hextoword32reg ne "")
            {
                my $hexDigit = "";
                my $Count = 0;
                my $str;
                my $StopAtCount = length($_) % 8;
                
                
                for my $c (split //, $_)
                {
                    $Count = $Count + 1;
                    $hexDigit = $hexDigit . $c;
                    
                    if($Count == $StopAtCount)
                    {
                        $StopAtCount = 8;
                        $str = hex($hexDigit);
                        $Count = 0;
                        $hexDigit	= "";
                        $CompleteStr = $CompleteStr . $str . " ";
                    }
                }
#                if($Count != 0)
#                {
#                    $str = hex($hexDigit);
#                    $Count = 0;
#                    $hexDigit	= "";
#                    $CompleteStr = $CompleteStr . $str . " ";
#                }
            }
        }
        @matches = ( $line =~ /$InSuffixReg/ );
        foreach ( @matches )
        {
            $CompleteStr = $CompleteStr . $_;
        }	
        $CompleteStr = $CompleteStr . "\n";
	}
    printf STDOUT "$CompleteStr";
}

LoadParams();
if($InFileName)
{
    open(INFILE,$InFileName);
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
    }
}
MyReadline();
while ($line)
{
    CheckAndAddToResult();
    MyReadline();
};
