#!/bin/bash
rna_sequence_file=$1
protein_sequence_file=$2
pipeline=$3
result_file=$4
output_prediction_file=$5
arff_preprocess_file=$6
arff_intermediate_file=$7

/deployments/format_converter.pl $rna_sequence_file $protein_sequence_file $pipeline $arff_preprocess_file
/deployments/createARFF_test.pl --input $arff_preprocess_file --output $arff_intermediate_file
/deployments/runModelonTest.pl --input $arff_intermediate_file --output $output_prediction_file --outstep2 $result_file