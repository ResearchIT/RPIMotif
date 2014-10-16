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
