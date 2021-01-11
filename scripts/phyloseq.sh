#! usr/env/bin/bash

#This script helps to export your qiime2-created files into formats that are read easily in R
#in the event that you want to do your analysis with R.
#If you used Dada2, remember to change files accordingly.

cd sample_data/
# Export OTU table
mkdir phyloseq
qiime tools export \
--input-path deblur-table.qza \
--output-path phyloseq

# Convert biom format to tsv format
biom convert \
-i phyloseq/feature-table.biom \
-o phyloseq/otu_table.tsv \
--to-tsv
cd phyloseq
sed -i '1d' otu_table.tsv
sed -i 's/OTU ID//' otu_table.tsv
cd ../

# Export representative sequences
qiime tools export \
--input-path rep-seqs.qza \
--output-path phyloseq

# Export tree files
qiime tools export \
--input-path unrooted-tree.qza \
--output-path phyloseq
cd phyloseq
mv tree.nwk unrooted_tree.nwk
cd ../

qiime tools export \
--input-path rooted-tree.qza \
--output-path phyloseq
cd phyloseq
mv tree.nwk rooted_tree.nwk
cd ../

#Export taxonomy table
qiime tools export \
--input-path taxonomy.qza \
--output-path phyloseq

#Copy the metadata file into phyloseq too (required)
cp practice.dataset1.metadata.tsv phyloseq/
