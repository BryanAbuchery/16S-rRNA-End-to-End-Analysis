#! usr/bin/env/bash


#For Convenience, work within a High Performance Computer(HPC) environment
#Prepare your reads by ensuring that they have the correct format
#For practice, we will use download data from h3abionet website (16S RNA Analysis workflow)
bash scripts/download.sh

#Reformat the barcodes of the paired-end reads, renaming the original
#with a ".bak extension.
#perl -i.bak -pe 'if (m/^\@.*?\s+.*?\+.*?$/){s/\+//;} Undetermined_S0_L001_R1_001.fastq Undetermined_S0_L001_R2_001.fastq

#Check the following link for more information about formating your link https://docs.qiime2.org/2020.8/ or consult
# someone in the lab for more info.

cd sample_data/

#Format the practice metadata file into a Qiime compartible object

awk 'NR==1{$0=tolower($0)} 1' practice.dataset1.metadata.tsv >> metadata.tsv
sed -e '1s/sample/sample-id/' metadata.tsv >> metadata1.tsv
rm practice.dataset1.metadata.tsv && rm metadata.tsv
mv metadata1.tsv practice.dataset1.metadata.tsv

#Do FastQc

fastqc *.fastq
mkdir fastqc_results
mv *.zip fastqc_results/ && mv *.html fastqc_results/
cd fastqc_results/
for zip in *.zip; do unzip $zip; done
cat */summary.txt >> fastqc_summary.txt
mv fastqc_summary.txt ../
cd ..


#Qiime2 Analysis

#Prepare manifest and Import your data into Qiime2 Artifacts.

#Ensure the formating conforms to required state
gzip *.fastq
for i in *.gz; do mv "$i" "`echo $i | sed 's/_/./'`"; done

#Automate making a manifest file using Q2_manifest_maker.py
#Further information about Q2_manifest_maker.py can be found on this repo:
# : https://github.com/Micro-Biology/BasicBashCode/blob/master/BasicScripts/Q2_manifest_maker.py
python ../scripts/Q2_manifest_maker.py --input_dir ./
sort Manifest.csv >> sorted.csv
sed '$d' sorted.csv | sed -i '1s/^/sample-id,absolute-filepath,direction\n/' sorted.csv
sed '$d' sorted.csv >> ready.csv
rm Manifest.csv && rm sorted.csv
mv ready.csv Manifest.csv

#Import your data into Qiime2 Artifacts
qiime tools import \
--type 'SampleData[PairedEndSequencesWithQuality]' \
--input-path Manifest.csv \
--output-path PE_demux.qza \
--input-format PairedEndFastqManifestPhred33

#Demultiplex your sequences if they still contain barcodes.

#Requires you to have  your barcodes file in the same directory  as your sample files
#These samples are already demultiplexed, so the following demux command will be hashed.
#qiime cutadapt demux-paired \
#--i-seqs PE_demux.qza \
#--m-barcodes-file <barcodesfile> \
#--m-barcodes-column BarcodeSequence \
#--o-per-sample-sequences demux.qza \
#--o-untrimmed-sequences un.demux.qza

#To know if your demultiplexing worked
#qiime demux summarize \
#--i-data demux.qza \
#--o-visualization demux.qzv

#Drag and drop any <file_name.qzv> file to Qiime2 View or do the following to view:
#qiime tools view <file_name.qzv>, for example;
#Drag and drop the demux.qzv file to Qiime2 View or do the following to view
#qiime tools view demux.qzv
#press q to escape or quit


#Quality Control
#If your sequences were demultiplexed, the input file here would be demux.qza
qiime quality-filter q-score \
--i-demux PE_demux.qza \
--o-filtered-sequences demux-filtered.qza \
--o-filter-stats demux-filter-stats.qza

qiime metadata tabulate \
--m-input-file demux-filter-stats.qza \
--o-visualization demux-filter-stats.qzv

#Feature Table Creation
#Either use dada2 or deblur to select sequence variants
#Denoising
#Using deblur
#The trim length is determined using the demux-filter-stats.qzv results
#qiime deblur denoise-16S \
#--i-demultiplexed-seqs demux-filtered.qza \
#--p-trim-length 120 \
#--o-representative-sequences rep-seqs.qza \
#--o-table deblur-table.qza \
#--p-sample-stats \
#--o-stats deblur-stats.qza

#qiime deblur visualize-stats \
#--i-deblur-stats  deblur-stats.qza \
#--o-visualization deblur-stats.qzv

#Adding metadata and examining count tables
#qiime feature-table summarize \
#--i-table deblur-table.qza \
#--o-visualization deblur-table.qzv \
#--m-sample-metadata-file practice.dataset1.metadata.tsv

#qiime feature-table tabulate-seqs \
#--i-data rep-seqs.qza \
#--o-visualization rep-seqs.qzv


#Using dada2
qiime dada2 denoise-paired \
--i-demultiplexed-seqs PE_demux.qza \
--p-trunc-len-f 250 \
--p-trunc-len-r 200 \
--o-table dada2-table.qza \
--o-representative-sequences rep-seqs-dada2.qza \
--o-denoising-stats dada2-denoise-stats.qza

#Adding metadata and examining count tables
qiime feature-table summarize \
--i-table dada2-table.qza \
--o-visualization dada2-table.qzv \
--m-sample-metadata-file practice.dataset1.metadata.tsv

qiime feature-table tabulate-seqs \
--i-data rep-seqs-dada2.qza \
--o-visualization rep-seqs-dada2.qzv

#Phylogenetics
#The next steps assumes using deblur in the previous steps
#If you used dada2, ensure that you use the correct filenames created using the dada2 step.

#Alignment
qiime alignment mafft \
--i-sequences rep-seqs-dada2.qza \
--o-alignment aligned-rep-seqs-dada2.qza

#Masking
qiime alignment mask \
--i-alignment aligned-rep-seqs-dada2.qza \
--o-masked-alignment masked-aligned-rep-seqs-dada2.qza

#Tree
qiime phylogeny fasttree \
--i-alignment masked-aligned-rep-seqs-dada2.qza \
--o-tree unrooted-tree.qza

#Midpoint rooting
qiime phylogeny midpoint-root \
--i-tree unrooted-tree.qza \
--o-rooted-tree rooted-tree.qza


#Core Metrics Analyses
#Pick a sampling depth that works well for your samples
qiime diversity core-metrics-phylogenetic \
--i-phylogeny rooted-tree.qza \
--i-table dada2-table.qza \
--p-sampling-depth 800 \
--m-metadata-file practice.dataset1.metadata.tsv \
--output-dir metrics

#Pick individual analysis that fits your your hypothesis.
#Alpha Diversity Analyses
#Faith_pd_vector
qiime diversity alpha-group-significance \
--i-alpha-diversity metrics/faith_pd_vector.qza \
--m-metadata-file practice.dataset1.metadata.tsv \
--o-visualization metrics/faith-pd-group-significance.qzv

#Evenness
qiime diversity alpha-group-significance \
--i-alpha-diversity metrics/evenness_vector.qza \
--m-metadata-file practice.dataset1.metadata.tsv \
--o-visualization metrics/evennes-alpha-correlation.qzv

#Shannon_diversity
qiime diversity alpha-group-significance \
--i-alpha-diversity metrics/shannon_vector.qza \
--m-metadata-file practice.dataset1.metadata.tsv \
--o-visualization metrics/shannon-diversity.qzv

#Beta Diversity Analyses
#There are both Orrdination analyses and Principal Coordinates Analysis
#Ordination
qiime emperor plot \
--i-pcoa metrics/unweighted_unifrac_pcoa_results.qza \
--m-metadata-file practice.dataset1.metadata.tsv \
--o-visualization metrics/unweighted-unifrac-emperor.qzv

#Alpha rare-faction
#Pick whatever sampling depth is ideal for your samples
qiime diversity alpha-rarefaction \
--i-table dada2-table.qza \
--i-phylogeny rooted-tree.qza \
--p-max-depth 4000 \
--m-metadata-file practice.dataset1.metadata.tsv \
--o-visualization alpha-rarefaction.qzv

#Group significance
qiime diversity beta-group-significance \
--i-distance-matrix metrics/unweighted_unifrac_distance_matrix.qza \
--m-metadata-file practice.dataset1.metadata.tsv \
--m-metadata-column dog \
--p-pairwise \
--o-visualization metrics/unweighted-unifrac-dog-significance.qzv


#Taxonomic Assignment

#Pick a reference database, there are different reference databases like shown below (not complete list)
#Greengenes: 16S : ftp://greengenes.microbio.me/greengenes_release/gg_13_5/gg_13_8_otus.tar.gz
#Silva: 16S/18S : https://www.arb-silva.de/fileadmin/silva_databases/qiime/Silva_132_release.zi
#RDP: 16S/18S/28S : http://rdp.cme.msu.edu/
#UNITE: ITS : https://unite.ut.ee/
#In this case we will use the Greengenes 13_8 release database.


#Train a classifier algorithm to assign taxonomies to sequences(always good to have your own trained classifier)
#Run the classifier algorithm on your sequence features
#Train your classifier using either SILVA or Greengenes
#DONT USE BOTH!

cd ..

#Train classifier using SILVA
#bash scripts/train_classifier_silva.sh

#Train Classifier using Greengenes
bash scripts/train_classifier_gg.sh

cd sample_data/

#Assign Taxonomy
qiime feature-classifier classify-sklearn \
--i-classifier classifier.qza \
--i-reads rep-seqs-dada2.qza \
--o-classification taxonomy.qza

qiime metadata tabulate \
--m-input-file taxonomy.qza \
--o-visualization taxonomy.qzv

qiime taxa barplot \
--i-table dada2-table.qza \
--i-taxonomy taxonomy.qza \
--m-metadata-file practice.dataset1.metadata.tsv \
--o-visualization taxa-barplot.qzv

#Qiime may not offer all the analysis you want.
#For publication-worthy analysis reports, you may consider using R.
#You can utilize Phyloseq, an R package to Explore Microbiome profiles using R

#Export to phyloseq objects
cd ..
bash scripts/phyloseq.sh
