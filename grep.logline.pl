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
my $FoundCountNonCmi = 0;
my $NotCMI = 0;
my $IsTimeLine = 0;

my %hash = ();

open(INFILE,$ARGV[0]);
if($ARGV[1])
{
	$UserFilter=$ARGV[1];
	$UserFilterFileName=$ARGV[1];
	$UserFilterFileName =~ s/\{//g;
	$UserFilterFileName =~ s/\}//g;
	$UserFilterFileName =~ s/://g;
	$UserFilterFileName =~ s/ //g;
	$UserFilterFileName =~ s/\|/-/g;
	$UserFilter =~ s/\{/\\\{/g;
	$UserFilter =~ s/\}/\\\}/g;
	
#	print STDOUT "Argv=$ARGV[1], UserFilter=$UserFilter, UserFilterFileName=$UserFilterFileName\n";

	$new_file .= ".$UserFilterFileName";
}
else
{
	$new_file .= ".cmi";
}
while ($line = <INFILE>) {
	if($line =~ /\[.*\]/)
	{
          if($NotCMI==1)
		  {
				if($PassesUserFilter == 1)
				{
					$keyVal=$keyVal+1;
					$hash{$keyVal}->{stack} = $cmi;
					$FoundCountNonCmi = $FoundCountNonCmi + 1;
				}
		  
		  }
		  $cmi=$line;
		  $NotCMI=1;
		  $IsTimeLine=1;
		  $PassesUserFilter=0;
	}
	if($line =~ /.*$UserFilter.*/)
	{
		$PassesUserFilter=1;
	}
	if ($line =~ /.*CCL_BaseMessage.*/)
	{
          $cmi.=$line;
	      $keyVal=$keyVal+1;
          $PassesUserFilter=0;
		  $NotCMI=0;
	}
	else	
	{
  	    if($IsTimeLine!=1)
		{
			$cmi .= $line;
		}
		$IsTimeLine=0;
		if ($line =~ /^CMI.*/)
		{
			  $StartCounting=1;
			  $OpenBracketCount=0;
			  $CloseBracketCount=0;
		}

		if($StartCounting == 1)
		{
			$OpenBracketCurrCount = () = $line =~ /\{/g;
			$OpenBracketCount = $OpenBracketCount + $OpenBracketCurrCount;
			$CloseBracketCurrCount = () = $line =~ /\}/g;
			$CloseBracketCount = $CloseBracketCount + $CloseBracketCurrCount;
#			print STDOUT "$line --- Open=$OpenBracketCount, Close=$CloseBracketCount\n";

			
			if($OpenBracketCount - $CloseBracketCount == 0)
			{
				if($PassesUserFilter == 1)
				{
					$hash{$keyVal}->{stack} = $cmi;
					$FoundCount = $FoundCount + 1;
				}
				$StartCounting=0;
			}
		}
	}

}
open(my $fh, '>', $new_file) or die "Could not open file '$new_file' $!";
foreach my $key (sort { $a <=> $b } keys %hash) {
                 print $fh $hash{$key}->{stack};
}
close $fh;
print STDOUT "Process CMI=$keyVal, Written CMI=$FoundCount, WrittenInfo=$FoundCountNonCmi\n";



