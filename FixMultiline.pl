#!/usr/bin/perl
package FixMultiline;

use Data::Dumper;
use strict;
use warnings;
use Exporter;
# open the file whose name is given in the first argument on the command
# line, assigning to a file handle INFILE (it is customary to choose
# all-caps names for file handles in Perl); file handles do not have any
# prefixing punctuation
my $InSeparator;
my $InFileName;

my $line = "";

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
        $InSeparator = "";
        $InFileName = "";

        for(my $i = 0; $i < $#ARGV; $i++)
        {
            if($ARGV[$i] eq "-s")
            {
#                $InSeparator = "s/".$ARGV[$i + 1]."/".$ARGV[$i + 1]."\\\\n/g";
                $InSeparator = $ARGV[$i + 1];
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
    print STDOUT "\n-s \"Separator\"";
    print STDOUT "\n-f \"Input file name\" - this param is not mandatory, STDIN can be used as input ";
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

LoadParams();
if($InFileName)
{
    open(INFILE,$InFileName);
}

MyReadline();
while ($line)
{
 #$InSeparator = "s/".$ARGV[$i + 1]."/".$ARGV[$i + 1]."\\\\n/g";
    $line =~ s/$InSeparator/$InSeparator\n/g;
    print STDOUT $line;
    
    MyReadline();
}



