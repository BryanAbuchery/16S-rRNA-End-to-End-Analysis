#! usr/env/bin/bash


cd ..
#Download SILVA database to train classifier
wget https://www.arb-silva.de/fileadmin/silva_databases/qiime/Silva_132_release.zip

unzip
unzip Silva_132_release.zip

#Copy the files we want into working directory
#From SILVA
cp SILVA_132_QIIME_release/rep_set/rep_set_16S_only/99/silva_132_99_16S.fna sample_data/
cp SILVA_132_QIIME_release/taxonomy/16S_only/99/taxonomy_all_levels.txt sample_data/


cd sample_data/

#Training feature classifiers with q2-feature-classifier
#Import the reference data sets
qiime tools import \
--type 'FeatureData[Sequence]' \
--input-path silva_132_99_16S.fna \
--output-path silva_132_99.qza

qiime tools import \
--type 'FeatureData[Taxonomy]' \
--input-format HeaderlessTSVTaxonomyFormat \
--input-path taxonomy_all_levels.txt \
--output-path ref-taxonomy.qza

#Extract reference reads
#The primers used here are from the ones used during your sequencing
qiime feature-classifier extract-reads \
--i-sequences silva_132_99.qza \
--p-f-primer GTGCCAGCMGCCGCGGTAA \
--p-r-primer GGACTACHVGGGTWTCTAAT \
--o-reads ref-seqs.qza

#Train the classifier
qiime feature-classifier fit-classifier-naive-bayes \
--i-reference-reads ref-seqs.qza \
--i-reference-taxonomy ref-taxonomy.qza \
--o-classifier classifier.qza

