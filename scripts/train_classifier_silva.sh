#! usr/env/bin/bash

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

