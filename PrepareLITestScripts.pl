#!/usr/bin/perl

use Data::UUID;
use Data::Dumper;
use File::Basename;
use Time::HiRes qw(usleep nanosleep);
use strict;
use warnings;

# open the file whose name is given in the first argument on the command
# line, assigning to a file handle INFILE (it is customary to choose
# all-caps names for file handles in Perl); file handles do not have any
# prefixing punctuation
my @DidArray;
my @XidArray;
my $NumOfDids;
my $NumOfXids;
my $DidTemplateFileName;
my $XidTemplateFileName;
my $DidArray;
my $XidArray;
my $XidRemovalTemplateFileName;
my $DidRemovalTemplateFileName;
my $iDid;
my $iXid;


$NumOfDids = $ARGV[0];
$NumOfXids = $ARGV[1];
$DidTemplateFileName = $ARGV[2];
$XidTemplateFileName = $ARGV[3];
$DidRemovalTemplateFileName = $ARGV[4];
$XidRemovalTemplateFileName = $ARGV[5];

sub FormatLineParams($$)
{
    my $line;
    my $index;
    
    $line  = $_[0];
    $index = $_[1];
    
	if ($line =~ /.*TEMP_DID.*/)
	{
        $line =~ s/TEMP_DID/$DidArray[$iDid]/g;
#        $line = $line."\nDidArray[".$iDid."]\n";
    }
	if ($line =~ /.*TEMP_XID.*/)
	{
        $line =~ s/TEMP_XID/$XidArray[($iDid * $NumOfXids) + $iXid]/g;
#        $line = $line."\nXidArray[".(($iDid * $NumOfXids) + $iXid)."]\n";
    }
	if ($line =~ /(.*)BASE_NUMBER=(\d*)(.*\n)/)
	{
	    my $Number=$2+$index;
	    $line = "$1$Number$3";
	}
	if ($line =~ /(.*)RANDOMSET=\((.*)\)(.*\n)/)
	{
        my @values = split(',', $2);
        
	    $line = "$1@values[rand(@values)]$3";
	}
    return $line;
}

sub ReplaceParamInTemplate($$$$$)
{
    my $TemplateFile;
    my $OutputFile;
    my $InuptFileName   = $_[0];
    my $OutputFileName  = $_[1];
    my $Index           = $_[2];
    my $ShouldWait      = $_[3];
    my $ScriptFile      = $_[4];
    my $line;

    open($TemplateFile, $InuptFileName);
    open($OutputFile, '>', $OutputFileName) or die "Could not open file '$OutputFile' $!";


    while ($line = <$TemplateFile>)
    {
        $line = FormatLineParams($line, $Index);
    	print $OutputFile $line;
    }
    close $OutputFile;
    if($ShouldWait)
    {
        print $ScriptFile "\nsleep 1s";
    }
    print $ScriptFile "\ncurl -k -H 'Content-Type: text/xml' https://10.10.30.227:5555 --data-ascii @".$OutputFileName;
    if($ShouldWait)
    {
        print $ScriptFile "\nsleep 1s";
    }
    else
    {
        print $ScriptFile "   &";
    }
}

sub IsUniqe($$$$)
{
    my $ArgArray        = $_[0];
    my $ArrayStartsFrom = $_[1];
    my $ArgCurrentIndex = $_[2];
    my $NewValue        = $_[3];

    if($NewValue eq "")
    {
        return 0;
    }
#    printf "\n".$NewValue;
    for(my $i = $ArrayStartsFrom; $i < $ArgCurrentIndex; $i++)
    {
#        printf "\n[".$i."]".@$ArgArray[$i];
        if(@$ArgArray[$i] eq $NewValue)
        {
            return 0;
        }
    }
    return 1;
}

for($iDid = 0; $iDid < $NumOfDids; $iDid++)
{
    my $ug;
    my $uuid;
    my $str;
    $str = "";
    
#    while(!IsUniqe(\@DidArray, 0, $iDid, $str))
    {
        $ug    = Data::UUID->new;
        $uuid  = $ug->create();
        $str   = $ug->to_string( $uuid );
#        usleep(250);
    }
    $DidArray[$iDid] = $str;
    

    for($iXid = 0; $iXid < ($NumOfXids / $NumOfDids); $iXid++)
    {
        $str = "";
        
#        while(!IsUniqe(\@XidArray, 1, ($iDid * $NumOfXids) + $iXid, $str))
        {
            $ug    = Data::UUID->new;
            $uuid  = $ug->create();
            $str   = $ug->to_string( $uuid );
 #           usleep(250);
        }
        $XidArray[($iDid * $NumOfXids) + $iXid] = $str;
    }
}

my $ScriptFile;
open($ScriptFile, '>', "./AddTargets.sh") or die "Could not open file './AddTargets.sh' $!";
for($iDid = 0; $iDid < $NumOfDids; $iDid++)
{

    ReplaceParamInTemplate($DidTemplateFileName, "./".basename(fileparse($DidTemplateFileName), ".xml").$iDid.".xml", $iDid, 1, $ScriptFile);
    for($iXid = 0; $iXid < ($NumOfXids / $NumOfDids); $iXid++)
    {
        ReplaceParamInTemplate($XidTemplateFileName, "./".basename(fileparse($XidTemplateFileName), ".xml").$iDid.$iXid.".xml", ($iDid * $NumOfXids) + $iXid, 0, $ScriptFile);
    }
}

open($ScriptFile, '>', "./RemoveTargets.sh") or die "Could not open file './RemoveTargets.sh' $!";
for($iDid = 0; $iDid < $NumOfDids; $iDid++)
{
    for($iXid = 0; $iXid < ($NumOfXids / $NumOfDids); $iXid++)
    {
        ReplaceParamInTemplate($XidRemovalTemplateFileName, "./".basename(fileparse($XidRemovalTemplateFileName), ".xml").$iDid.$iXid.".xml", ($iDid * $NumOfXids) + $iXid, 0, $ScriptFile);
    }
    ReplaceParamInTemplate($DidRemovalTemplateFileName, "./".basename(fileparse($DidRemovalTemplateFileName), ".xml").$iDid.".xml", $iDid, 1, $ScriptFile);
}



