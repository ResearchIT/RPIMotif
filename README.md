RPIMotif
========

This repository contains code and related datasets for a new method to make RNA-protein partner predictions.

The "Data" folder contains:
(i) Interacting_RNA_Protein_Pairs.txt - this file contains PDB IDs and the IDs of protein and RNA chains found to be interacting using the 5 angstrom distance cut-off.

(ii) NPInterUniqSeq.txt - 11,281 positive examples of known RNA-protein pairs. The file is in the following format:
>sequence_name
Protein sequence
RNA sequence

(iii) NRBP.txt- 971 negative examples i.e. proteins which are not known to bind RNA, randomly paired with RNAs from fRNAdb. The file is in the following format:
>sequence_name
Protein sequence
RNA sequence

(iv) Positive_Fasta_RPI2241.txt - positive examples

(v) Negative_Fasta_RPI2241.txt - negative examples

Files (ii) and (iii) constitute the independent test set.
Files (iv) and (v) constitute the training set.

To run RPIMotif-ct, you will require the following files, as well as Perl:
(i) less_motifs.txt
(ii) arffHeaderP3R4
(iii) RF_17910_ct.model
(iv) createARFF_test.pl
(v) runModelonTest.pl

You first need to create a test arff file with your query RNA-protein pairs. The format in which the data should be provided is shown in test_data.txt. Run the following command to generate an arff file:
perl createARFF_test.pl less_motifs.txt test_data.txt

The output from this will be test_data.arff

Next, run the following command:
perl runModelonTest.pl RF_17910_ct.model test_data.arff

The output will be in Output_step2.txt in the format:
Query_Number,Probability,?,Prediction

The prediction will be either "0" which means the RNA-protein pair is not predicted to interact or "1" which means the RNA-protein pair is predicted to interact.

