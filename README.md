# 16S-rRNA End-to-End Analysis

Qiime2 and DADA2 are one of the latest bioinformatics tools used in 16S rRNA End to End RNA analysis. The current Qiime2 and DADA2 pipelines support End to End 16S RNA analysis, -with informative information, among other analyses.

## 16S RNA

### What is the 16S rRNA

[16S rRNA](https://www.cd-genomics.com/16S-18S-ITS-Amplicon-Sequencing.html) (16S ribosomal RNA), is a component of the prokaryotic ribosome 30S subunit. The “S” in 16S is a sedimentation coefficient, that is, an index reflecting the downward velocity of the macromolecule in the centrifugal field. The higher the value, the greater the molecule. The 16S rRNA gene is the DNA sequence corresponding to rRNA encoding bacteria, which exists in the genome of all bacteria. 16S rRNA is highly conserved and specific, and the gene sequence is long enough.

More about 16S RNA sequencing and its importance can be read though the [following link](https://www.cd-genomics.com/blog/16s-rrna-one-of-the-most-important-rrnas/).

While Qiime2 may be interactive and facilatated for your your use as a Bioinformatician, Qiime2 works best through what are termed as Qiime2 artifacts. If you are unfamiliar with Qiime2 as an analysis tool, you can read more about [it here](https://docs.qiime2.org/2020.8/) and participate through its various tutorials.

DADA2 is more straightforward and requires no specially formarted files. DADA2 pipelines are mostly an R package analysis tools with the option of saving images generated in quality plots. 

Git clone this repo : https://github.com/BryanAbuchery/16S-rRNA-End-to-End-Analysis.git

The pipelines explored here follow a analysis tutorial pipelines with the end goal of understanding an End to End 16S rRNA analysis with experimental datasets obtained from H3eaBionet as is shown below:

## Set Up And Installation (QIIME2)

`cd 16S-rRNA-End-to-End-Analysis`

For you to be able to follow this workflow;

1. Install Qiime2 by following [this link](https://docs.qiime2.org/2020.8/install/native/).

2. Activate the Qiime2 environment to conda install fastqc through [clicking here](https://anaconda.org/bioconda/fastqc). Alternatively, there is a .yml Qiime2-2020.8 environment on this repo. On the terminal; `cd QIIME2-End-to-End-Analysis/Qiime2_env/` and bash `conda create -f Qiime2_env.yml` After running successfully, bash `conda activate Qiime2-2020.8`

3. To download dataset and metadata used in this mock analysis and run the pipeline, `cd QIIME2-End-to-End-Analysis && bash scripts/16srna-deblur.sh` or `cd QIIME2-End-to-End-Analysis && bash scripts/16srna-dada2.sh` Qiime2 involves both Deblur and DADA2 plugins used for feature table creation. You can run either of the two. However, Training Classifiers with Qiime2 for the SILVA database is resource-intensive. It requires you to be logged onto a HPC. You can move the scripts directory to a HPC and `bash scripts/16srna-deblur.sh` if you decide to use deblur for denoising or `bash scripts/16srna-dada2.sh` to use dada2. You can also use a database of your choice. Remember to module avail Qiime2 and FastQc on the HPC before you bash. If they aren't available, please contact your system administrator. For the purposes of this mock analysis, the Greengenes database was used. The script can work with most local computers and is not as resource-intensive as the SILVA database.

4. Some people prefer to have their downstream downstream analysis done with R. Make sure you have installed the latest R version and then install Phyloseq. Phyloseq is an R package that lets you explore microbiome profiles using R. You can read more about [it here](https://joey711.github.io/phyloseq/). Install Phyloseq through first installing the [Bioconductor package](https://bioconductor.org/install/) and then install Phyloseq itself [through here](http://bioconductor.org/packages/release/bioc/html/phyloseq.html)

5. You can also follow your own 16S or other Microbiome Analyses through following [this Phyloseq tutorial](https://vaulot.github.io/tutorials/Phyloseq_tutorial.html)

6. Please ensure that you read the documentation for each of the scripts used. The automatic manifest file maker was adapted [from this repo](https://github.com/Micro-Biology/BasicBashCode/blob/master/BasicScripts/Q2_manifest_maker.py) The script that exports Qiime2 artifacts into objects that can be used with phyloseq was adopted from [this tutorial](http://john-quensen.com/tutorials/processing-16s-sequences-with-qiime2-and-dada2/) More information about importing dada2 artifacts into phyloseq can also be obtained [from here.](http://john-quensen.com/r/import-dada2-asv-tables-into-phyloseq/)


## Set up and installation (DADA2)

On your terminal (after cloning the repo) `cd 16S-rRNA-End-to-End-Analysis/DADA2-End-to-End-Analysis`

To be able to run a DADA2 analysis pipeline, there are dependency packages that cannot be run on R version lower than 4.0 Therefore, this installation step provides guidelines from updating your R and your packages to setting up your DADA2 pipeline in the event that you are using a 3.x R version. All your older packages will still be preserved.

1. Install and/or update your R version and re-install all of your packages [through here](https://medium.com/@hpgomide/how-to-update-your-r-3-x-to-the-r-4-x-in-your-linux-ubuntu-46e2209409c3)

2. Switch to R.

3. Install the [Bioconductor package](https://www.bioconductor.org/install/) and all its [core packages](https://www.bioconductor.org/install/)

4. Install DADA2 dependency packages; DADA2, Phyloseq, Tidyverse, DECIPHER and Decontam. The links for installing them are found here below, in that order:

* [Installs DADA2](https://www.bioconductor.org/packages/release/bioc/html/dada2.html)

* [Installs Phyloseq](https://bioconductor.org/packages/release/bioc/html/phyloseq.html)

* [Installs Tidyverse](https://www.tidyverse.org/packages/)

* [Installs DECIPHER](https://www.bioconductor.org/packages/release/bioc/html/DECIPHER.html)

* [Installs Decontam](https://bioconductor.org/packages/release/bioc/html/decontam.html)

5. Exit R

6. Download the dataset and the metadata used for this mock analysis by running `bash scripts/download.sh`

7. Run DADA2 End-to-End Analysis by running `Rscript scripts/dada2_pipeline.R`

In a computational resource-challenged environment, move the the scripts directory in this directory to the HPC and run steps 2 to 7. However, the R module used on the HPC has to be R version 4.x Contact your systems administrator to ensure that this is available for you. Load the R VERSION 4.x module and rrun steps 2 to 7. This mock analysis for the DADA2 pipeline assumes that your data has been demultiplexed and the trimming done for to remain with quality datasets.

## Resources

[H3eaBionet Datasets/metadata used and SOP](https://h3abionet.github.io/H3ABionet-SOPs/16s-rRNA)

### QIIME2 Analysis

1. [Moving pictures tutorial](https://docs.qiime2.org/2020.11/tutorials/moving-pictures/)

2. [QIIME2 16S rRNA Analysis tutorial](chrome-extension://gphandlahdpffmccakmbngmbjnjiiahp/http://compbio.ucsd.edu/wp-content/uploads/2016/10/20170712_microbiome_16s_tutorial_non-interactive.pdf)

3. [QIIME2 data analysis tutorial](https://docs.qiime2.org/2020.11/tutorials/overview/)

4. [How to make a manifest file for importing data into QIIME2 artifact](https://github.com/Micro-Biology/BasicBashCode/blob/master/BasicScripts/Q2_manifest_maker.py)

### DADA2 Analysis

1. [DADA2 16S rRNA Analysis tutorial](https://astrobiomike.github.io/amplicon/dada2_workflow_ex)

2. [DADA2 analysis tutorial](https://benjjneb.github.io/dada2/tutorial.html#)

3. [DADA2 Pipeline for multiplexed data](https://github.com/amoliverio/dada2_fiererlab)


## Bugs
There are no known bugs, but incase of any feel free to reach any collaborators of this repository.

## LICENSE
[MIT](https://github.com/BryanAbuchery/16S-Qiime2-2020.8-E2E-/blob/main/LICENSE)

