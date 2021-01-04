#! usr/env/bin/bash


#Download the Greengenes database to train classifier

wget ftp://greengenes.microbio.me/greengenes_release/gg_13_5/gg_13_8_otus.tar.gz
gunzip gg_13_8_otus.tar.gz
tar -xvf gg_13_8_otus.tar


#Copy the files we want into our working directory
#From Greengenes
cp gg_13_8_otus/rep_set/99_otus.fasta sample_data/
cp gg_13_8_otus/taxonomy/99_otu_taxonomy.txt sample_data/

cd sample_data/

#Training feature classifiers with q2-feature-classifier
#Import the reference data sets
qiime tools import \
--type 'FeatureData[Sequence]' \
--input-path 99_otus.fasta \
--output-path 99_otus.qza

qiime tools import \
--type 'FeatureData[Taxonomy]' \
--input-format HeaderlessTSVTaxonomyFormat \
--input-path 99_otu_taxonomy.txt \
--output-path ref-taxonomy.qza

#Extract reference reads
#The primers used here are from the ones used during your sequencing
qiime feature-classifier extract-reads \
--i-sequences 99_otus.qza \
--p-f-primer GTGCCAGCMGCCGCGGTAA \
--p-r-primer GGACTACHVGGGTWTCTAAT \
--o-reads ref-seqs.qza

#Train the classifier
qiime feature-classifier fit-classifier-naive-bayes \
--i-reference-reads ref-seqs.qza \
--i-reference-taxonomy ref-taxonomy.qza \
--o-classifier classifier.qza

