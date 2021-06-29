#!/usr/bin/perl
#perl runModelonTest.pl --model <modelFL> --input <testFL> --output <outputFL> --heap <heapSize> --outstep2 <outputFL2>
use strict;
use warnings;
use Getopt::Long qw(GetOptions);

my $usage = "Usage: $0 --model <modelFL> --input <testFL> --output <outputFL> --heap <heapSize> --outstep2 <outputFL2> --wekapath <wekaFL> --help\n";

my $modelFL = '/opt/app-root/src/RF_17910_ct.model';
my $testFL = '/opt/app-root/src/results/test_data.arff';
my $outputFL = '/opt/app-root/src/Output_prediction_step1.txt';
my $heapSize = '4096';
my $outputFL2 = '/opt/app-root/src/results/Output_step2.txt';
my $wekaFL = '/opt/app-root/src/weka.jar';
my $help;

GetOptions(
	'model=s' => \$modelFL,
	'input=s' => \$testFL,
	'output=s' => \$outputFL,
	'heap=s' => \$heapSize,
	'outstep2=s' => \$outputFL2,
	'wekapath=s' => \$wekaFL,
	'help' => \$help,
	) or die $usage;

if ($help) {
	print $usage;
	exit 0;
}

#validation for heap size parm
if (!($heapSize % 8 == 0 and $heapSize >= 512 and $heapSize <= 32768)) {
	$heapSize = '4096';
}

system("java -Xmx" . $heapSize . "m -cp " . $wekaFL . " weka.classifiers.trees.RandomForest -l $modelFL -T $testFL -p 0 -distribution > $outputFL");

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

open(OUT,">$outputFL2");
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
