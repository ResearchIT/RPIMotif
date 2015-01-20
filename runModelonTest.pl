#!/usr/bin/perl
#perl runModelonTest.pl <model file> <testfile in arff format>
use strict;
use warnings;

my $modelFL = shift or die;
my $testFL = shift or die;
my $outputFL = "Output_prediction_step1.txt";

system("java -Xmx4096m -cp weka.jar weka.classifiers.trees.RandomForest -l $modelFL -T $testFL -p 0 -distribution > $outputFL");

open(F,$outputFL) or die $!;
our @prediction;
our @actual;
foreach (<F>){
	s/[\n\r]//mg;
	if(/^[\s\t]+\d+/){
		my @a = split(/[\s\t]+/, $_);
		chomp(@a);
		my @temp = split(/:/,$a[2]);
		chomp(@temp);
		push(@actual,$temp[1]);
		my @b = split(/[,\*]+/, $a[-1]);
		chomp(@b);
		foreach my $value (@b){
			print "$value; "
		}
		my $predictionScore = $b[-1]; #$b = *0.508,0.492
		print "$predictionScore\n";
		push(@prediction, $predictionScore);
	}
}
close(F);
my $file = "Output_step2.txt";
open(OUT,">$file");
my $count = 0;
my $i = 0;
foreach my $val (@prediction){
	$count++;
	if($val >= 0.5){
		print OUT "$count, $val, $actual[$i], 1\n";
	}
	else{
		print OUT "$count, $val, $actual[$i], 0\n";
	}
	$i++;
}
close(OUT);
