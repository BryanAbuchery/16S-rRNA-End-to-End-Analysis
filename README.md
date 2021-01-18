# 16S-rRNA End-to-End Analysis

Qiime2 and DADA2 are one of the latest bioinformatics tools used in 16S rRNA End to End RNA analysis. The current Qiime2 and DADA2 pipelines support End to End 16S RNA analysis, -with informative information, among other analyses.

## 16S RNA

### What is the 16S rRNA

[16S rRNA](https://www.cd-genomics.com/16S-18S-ITS-Amplicon-Sequencing.html) (16S ribosomal RNA), is a component of the prokaryotic ribosome 30S subunit. The “S” in 16S is a sedimentation coefficient, that is, an index reflecting the downward velocity of the macromolecule in the centrifugal field. The higher the value, the greater the molecule. The 16S rRNA gene is the DNA sequence corresponding to rRNA encoding bacteria, which exists in the genome of all bacteria. 16S rRNA is highly conserved and specific, and the gene sequence is long enough.

More about 16S RNA sequencing and its importance can be read though the [following link](https://www.cd-genomics.com/blog/16s-rrna-one-of-the-most-important-rrnas/).

While Qiime2 may be interactive and facilatated for your your use as a Bioinformatician, Qiime2 works best through what are termed as Qiime2 artifacts. If you are unfamiliar with Qiime2 as an analysis tool, you can read more about [it here](https://docs.qiime2.org/2020.8/) and participate through its various tutorials.

DADA2 is more straightforward and requires no specially formarted files. DADA2 pipelines are mostly an R package analysis tools with the option of saving images generated in quality plots. 

Git clone this repo : 

The pipelines explored here follow a analysis tutorial pipelines with the end goal of understanding an End to End 16S rRNA analysis with experimental datasets obtained from H3eaBionet as is shown below:

## Set Up And Installation (QIIME2)

For you to be able to follow this workflow;

1. Install Qiime2 by following [this link](https://docs.qiime2.org/2020.8/install/native/).

2. Activate the Qiime2 environment to conda install fastqc through [clicking here](https://anaconda.org/bioconda/fastqc). Alternatively, there is a .yml Qiime2-2020.8 environment on this repo. After cloning the repo, on the terminal; `cd` into "Qiime2_env" and bash `conda create -f Qiime2_env.yml` After running successfully, bash `conda activate Qiime2-2020.8`

3. To download dataset and metadata used in this mock analysis and run, `cd 16S-Qiime2-2020.8-E2E- && bash scripts/16srna.sh` However, Training Classifiers with Qiime2 for the SILVA database is resource-intensive. It requires you to be logged onto a HPC. You can move the scripts directory to HPC and `bash scripts/16srna-deblur.sh` if you decide to use deblur for denoising or `bash scripts/16srna-dada2.sh` to use dada2. You can also use a database of your choice. Remember to module avail Qiime and FastQc before you bash. If they aren't available, please contact your system administrator. For the purposes of this mock analysis, the Greengenes database was used. The script can work with most local computers and is not as resource-intensive as the SILVA database.

4. Some people prefer to have their downstream downstream analysis done with R. Make sure you have installed the latest R version and then install Phyloseq. Phyloseq is an R package that lets you explore microbiome profiles using R. You can read more about [it here](https://joey711.github.io/phyloseq/). Install Phyloseq through first installing the [Bioconductor package](https://bioconductor.org/install/) and then install Phyloseq itself [through here](http://bioconductor.org/packages/release/bioc/html/phyloseq.html)

5. You can also follow your own 16S or other Microbiome Analyses through following [this Phyloseq tutorial](https://vaulot.github.io/tutorials/Phyloseq_tutorial.html)

6. Please ensure that you read the documentation for each of the scripts used. The automatic manifest file maker was adapted [from this repo](https://github.com/Micro-Biology/BasicBashCode/blob/master/BasicScripts/Q2_manifest_maker.py) The script that exports Qiime2 artifacts into objects that can be used with phyloseq was adopted from [this tutorial](http://john-quensen.com/tutorials/processing-16s-sequences-with-qiime2-and-dada2/) More information about importing dada2 artifacts into phyloseq can also be obtained [from here.](http://john-quensen.com/r/import-dada2-asv-tables-into-phyloseq/)


## Set up and installation (DADA2)

To be able to run a DADA2 analysis pipeline, there are dependency packages that cannot be run on R version lower than 4.0 Therefore, this installation step provides guidelines from updating your R and your packages to setting up your DADA2 pipeline.

1. Install and/or update your R version and all of your packages [through here](https://medium.com/@hpgomide/how-to-update-your-r-3-x-to-the-r-4-x-in-your-linux-ubuntu-46e2209409c3)

On the terminal switch to R.

2. Install the [Bioconductor package](https://www.bioconductor.org/install/) and all its [core packages](https://www.bioconductor.org/install/)

3. Install DADA2 dependency packages; DADA2, Phyloseq, Tidyverse, DECIPHER and Decontam. The links for installing them are found here below, in that order:

* [Installs DADA2](https://www.bioconductor.org/packages/release/bioc/html/dada2.html)

* [Installs Phyloseq](https://bioconductor.org/packages/release/bioc/html/phyloseq.html)

* [Installs Tidyverse](https://www.tidyverse.org/packages/)

* [Installs DECIPHER](https://www.bioconductor.org/packages/release/bioc/html/DECIPHER.html)

* [Installs Decontam](https://bioconductor.org/packages/release/bioc/html/decontam.html)

Navigate into the DADA2 directory 


## Bugs
There are no known bugs, but incase of any feel free to reach any collaborators of this repository.

## LICENSE
[MIT](https://github.com/BryanAbuchery/16S-Qiime2-2020.8-E2E-/blob/main/LICENSE)

