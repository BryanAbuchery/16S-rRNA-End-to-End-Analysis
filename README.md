# 16S-Qiime2-2020.8-E2E-
Qiime2 is one of the latest tools used in 16S RNA analysis. The current Qiime2 supports End to End 16S RNA analysis, among other analyses.

## 16S RNA

### What is the 16S rRNA

[16S rRNA](https://www.cd-genomics.com/16S-18S-ITS-Amplicon-Sequencing.html) (16S ribosomal RNA), is a component of the prokaryotic ribosome 30S subunit. The “S” in 16S is a sedimentation coefficient, that is, an index reflecting the downward velocity of the macromolecule in the centrifugal field. The higher the value, the greater the molecule. The 16S rRNA gene is the DNA sequence corresponding to rRNA encoding bacteria, which exists in the genome of all bacteria. 16S rRNA is highly conserved and specific, and the gene sequence is long enough.

More about 16S RNA sequencing and its importance can be read though the [following link](https://www.cd-genomics.com/blog/16s-rrna-one-of-the-most-important-rrnas/).

While Qiime2 may be interactive and facilatated for your your use as a Bioinformatician, Qiime2 works best through what are termed as Qiime2 artifacts. If you are unfamiliar with Qiime2 as an analysis tool, you can read more about [it here](https://docs.qiime2.org/2020.8/) and participate through its various tutorials.

## Set Up And Installation

For you to be able to follow this workflow;

1. Install Qiime2 by following [this link](https://docs.qiime2.org/2020.8/install/native/).

2. Activate the Qiime2 environment to conda install fastqc through [clicking here](https://anaconda.org/bioconda/fastqc). Alternatively, there is a .yml Qiime2-2020.8 environment on this repo. After cloning the repo, on the terminal; `cd` into "Qiime2_env" and bash `conda create -f Qiime2_env.yml` After running successfully, bash `conda activate Qiime2-2020.8`

3. Git clone this repo https://github.com/BryanAbuchery/16S-Qiime2-2020.8-E2E-.git

4. To download dataset and metadata used in this mock analysis and run, `cd 16S-Qiime2-2020.8-E2E- && bash scripts/16srna.sh` However, remember that you need to be on a HPC because Training Classifiers with Qiime2 is resource-intensive.

5. Some people prefer to have their downstream downstream analysis done with R. Make sure you have installed the latest R version and then install Phyloseq. Phyloseq is an R package that lets you explore microbiome profiles using R. You can read more about [it here](https://joey711.github.io/phyloseq/). Install Phyloseq through first installing the [Bioconductor package](https://bioconductor.org/install/) and then install Phyloseq itself [through here](http://bioconductor.org/packages/release/bioc/html/phyloseq.html)

6. You can also follow your own 16S or other Microbiome Analyses through following [this Phyloseq tutorial](https://vaulot.github.io/tutorials/Phyloseq_tutorial.html)

7. Please ensure that you read the documentation for each of the scripts used. The automatic manifest file maker was adapted [from this repo](https://github.com/Micro-Biology/BasicBashCode/blob/master/BasicScripts/Q2_manifest_maker.py)
