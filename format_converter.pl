#!/usr/bin/perl
#usage: format_converter.pl <rnafile> <proteinfile> <mode> <outputfile>

use warnings;

#Read in RNA file
open (FASTA,$ARGV[0]) || die "Cannot open the fasta file";
$sequence="";
$header="";
$seq_flag=0;
while($line=<FASTA>)
{
	if($line=~/^>(.+)/)
	{
		chomp($line);
		if($seq_flag==1)
		{
			$nu_fasta_hash{$header}=$sequence;
			$sequence="";
		}
		$header=$1;
	}
	else
	{
		$seq_flag=1;
		chomp($line);
		$sequence=$sequence.$line;
	}
		
}
$nu_fasta_hash{$header}=$sequence; 

close(FASTA);

#Read in protein file
open (FASTA2,$ARGV[1]) || die "Cannot open the protein fasta file";
$sequence="";
$header="";
$seq_flag=0;
while($line=<FASTA2>)
{
	if($line=~/^>(.+)/)
	{
		chomp($line);
		if($seq_flag==1)
		{
			$prot_fasta_hash{$header}=$sequence;
			$sequence="";
		}
		$header=$1;
	}
	else
	{
		$seq_flag=1;
		chomp($line);
		$sequence=$sequence.$line;
	}
		
}
$prot_fasta_hash{$header}=$sequence;

close(FASTA2);

@nu_seq_headers=keys(%nu_fasta_hash);
@prot_seq_headers=keys(%prot_fasta_hash);

#Print to file
#my $outFile = 'test_data.txt';
my $outFile = $ARGV[3];
open(my $fh, '>', $outFile) or die "Could not open file '$outFile' $!";

#Option 1: 1 to 1 comparison
if ($ARGV[2]==0 || $ARGV[2]==1)
{
$counter=0;
	while ($nu_seq_headers[$counter]&&$prot_seq_headers[$counter])
	{
		print $fh ">$prot_seq_headers[$counter]"."_"."$nu_seq_headers[$counter]\n";
		print $fh $prot_fasta_hash{$prot_seq_headers[$counter]}."\n";
		print $fh $nu_fasta_hash{$nu_seq_headers[$counter]}."\n";
		$counter++;
	}
}

#Option 2: 1 RNA to many proteins
elsif ($ARGV[2]==2)
{
	foreach $nu_seq (@nu_seq_headers)
	{
		foreach $prot_seq(@prot_seq_headers)
		{
			print $fh ">$prot_seq"."_"."$nu_seq\n";
			print $fh $prot_fasta_hash{$prot_seq}."\n";
			print $fh $nu_fasta_hash{$nu_seq}."\n";
		}
	}
}

#Option 3: 1 protein to many RNAs:
elsif ($ARGV[2]==3)
{
	foreach $prot_seq(@prot_seq_headers)
	{
		foreach $nu_seq(@nu_seq_headers)
		{
			print $fh ">$prot_seq"."_"."$nu_seq\n";
			print $fh $prot_fasta_hash{$prot_seq}."\n";
			print $fh $nu_fasta_hash{$nu_seq}."\n";
		}
	}
}

close $fh;
