#!/bin/bash
log_file=$1
rna_sequence_file=$2
protein_sequence_file=$3
pipeline=$4
result_file=$5
output_prediction_file=$6
arff_preprocess_file=$7
arff_intermediate_file=$8

/deployments/format_converter.pl $rna_sequence_file $protein_sequence_file $pipeline $arff_preprocess_file >> $log_file
/deployments/createARFF_test.pl --input $arff_preprocess_file --output $arff_intermediate_file >> $log_file
/deployments/runModelonTest.pl --input $arff_intermediate_file --output $output_prediction_file --outstep2 $result_file >> $log_file