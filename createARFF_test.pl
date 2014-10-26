#!/usr/bin/perl
#perl createARFF_test.pl <Interaction_motifs> <Test_data>
# create features from motifs (RPIMs), and conjoint triads (Muppirala et al. 2011)
use strict;
use List::Util qw[min max];
#use warnings;

my $usage = "perl createARFF_test.pl <Interaction_motifs> <Test_data> <text>\n";
my $infile1 = shift or die $usage;
my $infile2 = shift or die $usage;

#name of arff file created from query data
my $outf = "test_data.arff";
#open file to output stuff to
open(OUT,">$outf");

#read in the motifs
open(F,$infile1) or die $!;
our @motifs = <F>;
chomp(@motifs);
close(F);
my $length = scalar(@motifs);
my $featurelength = $length + 343 + 256;

print OUT "\@relation interactions\n";
print OUT "\n";
#attributes related to conjoint triad
open(IN,"<arffHeaderP3R4");
while(my $line = <IN>){
	chomp($line);
	print OUT "$line\n";
}
close(IN);
#attributes related to motifs
for(my $i = 0; $i < $length; $i++){
	my $count = $i + 1;
	print OUT "\@attribute m$count numeric\n";
}

print OUT "\@attribute class {0,1}\n";
print OUT "\n";
print OUT "\@data\n";
print OUT "\n";

our %proteinGroups = (
		       'A' => 0,
		       'G' => 0,
		       'V' => 0,
		       'I' => 1,
		       'L' => 1,
		       'F' => 1,
		       'P' => 1,
		       'Y' => 2,
		       'M' => 2,
		       'T' => 2,
		       'S' => 2,
		       'H' => 3,
		       'N' => 3,
		       'Q' => 3,
		       'W' => 3,
		       'R' => 4,
		       'K' => 4,
		       'D' => 5,
		       'E' => 5,
		       'C' => 6 );
	
our %rnaGroups = (
		   'A' => 0,
		   'U' => 1,
		   'C' => 2,
		   'G' => 3
		  );

#open file with query RNA-protein pairs
open(IN,$infile2) or die $!;
while(my $line = <IN>){
	chomp($line);
	print "Creating arff file\n";
	if(substr($line,0,1) eq ">"){
		$line = <IN>;
		chomp($line);
		our $protein = $line;
		chomp($protein);
		our $plength = length($protein);
		my $ppattern = "/([^AGVILFPYMTSHNQWRKDEC])/";
		$protein =~ s/$ppattern//g;
		my @pseq = split(//,$protein);
		chomp(@pseq);
		$line = <IN>;
		chomp($line);
		our $rna = $line;
		$rna =~ s/T/U/g;
		my $rpattern = "/([^AUCG])/";
		$rna =~ s/$rpattern//g;
		chomp($rna);
		our $rlength = length($rna);
		my @rseq = split(//,$rna);
		chomp(@rseq);
		print OUT "{";
		######################################################################
		#Usha's conjoint triads
		my %output_p = ();
		for (my $i = 0; $i < scalar(@pseq) - 2; ++$i){
			my $key = $proteinGroups{$pseq[$i]} * 7 * 7 + 
			$proteinGroups{$pseq[$i + 1]} * 7  + 
			$proteinGroups{$pseq[$i + 2]};
			$output_p{$key}++;
		}
		for (my $i = 0; $i < 343; ++$i){
			if (!defined($output_p{$i})){
				$output_p{$i} = 0;
			}
		}
		my $minimum = min(values %output_p);
		my $maximum = max(values %output_p);
		#normalization step		
		for (my $i = 0; $i < 343; ++$i){	
			$output_p{$i} = ($output_p{$i} - $minimum)/$maximum;
			print OUT "$i $output_p{$i},";
		}
		my %output_r = ();
		for (my $i = 0; $i < scalar (@rseq) - 3; ++$i){
			my $key = $rnaGroups{$rseq[$i]} * 4 * 4 * 4 + 
			$rnaGroups{$rseq[$i + 1]} * 4 * 4 +
			$rnaGroups{$rseq[$i + 2]} * 4     +
			$rnaGroups{$rseq[$i + 3]};
			$key += 343;
			$output_r{$key}++;
		}
		for (my $i = 343; $i < 343 + 256; ++$i){
			if (!defined($output_r{$i})){
				$output_r{$i} = 0;
			}
		}
		$minimum = min(values %output_r);
		$maximum = max(values %output_r);
		#normalization step
		for (my $i = 343; $i < 343 + 256; ++$i){
			$output_r{$i} = ($output_r{$i} - $minimum)/$maximum;
			print OUT "$i $output_r{$i},";
		}
		
		#####################################################################
		our %protein_index = ();
		our %rna_index = ();
		our @data = ();
		our @index = ();
		my $flength = 599;
		for(my $i = 0; $i < scalar(@motifs); $i++){
			my @temp = split(/:/,$motifs[$i]);
			chomp(@temp);
			my $pstring = $temp[0];
			$pstring =~ s/[\r\n\t\s]//g;
			my $rstring = $temp[1];
			$rstring =~ s/[\r\n\t\s]//g;
			my $pwhere = index($protein, $pstring);
			my $rwhere = index($rna, $rstring);
			if (($pwhere != -1) and ($rwhere != -1) and (!exists($protein_index{$pwhere})) and (!exists($rna_index{$rwhere}))) {
				$protein_index{$pwhere} = 1;
				$rna_index{$rwhere} = 1;
				my $pattern = $pstring.":".$rstring;
				push(@data,1);
				push(@index,$i+$flength);
			}
		}
		for(my $i = 0; $i < scalar(@data); $i++){
				print OUT "$index[$i] $data[$i],";
		}
		print OUT "$featurelength ?}\n";
	}
}
close(IN);
print "\n";
close(OUT);

