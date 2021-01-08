#! usr/env/bin/bash

#Downloads the practice data set and metadata
mkdir -p sample_data

cd sample_data/

#Download the practice dataset

wget http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/dataset1/Dog1_R1.fastq
wget http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/dataset1/Dog1_R2.fastq
wget http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/dataset1/Dog2_R1.fastq
wget http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/dataset1/Dog2_R2.fastq
wget http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/dataset1/Dog3_R1.fastq
wget http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/dataset1/Dog3_R2.fastq
wget http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/dataset1/Dog8_R1.fastq
wget http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/dataset1/Dog8_R2.fastq
wget http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/dataset1/Dog9_R1.fastq
wget http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/dataset1/Dog9_R2.fastq
wget http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/dataset1/Dog10_R1.fastq
wget http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/dataset1/Dog10_R2.fastq
wget http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/dataset1/Dog15_R1.fastq
wget http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/dataset1/Dog15_R2.fastq
wget http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/dataset1/Dog16_R1.fastq
wget http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/dataset1/Dog16_R2.fastq
wget http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/dataset1/Dog17_R1.fastq
wget http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/dataset1/Dog17_R2.fastq
wget http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/dataset1/Dog22_R1.fastq
wget http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/dataset1/Dog22_R2.fastq
wget http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/dataset1/Dog23_R1.fastq
wget http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/dataset1/Dog23_R2.fastq
wget http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/dataset1/Dog24_R1.fastq
wget http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/dataset1/Dog24_R2.fastq
wget http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/dataset1/Dog29_R1.fastq
wget http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/dataset1/Dog29_R2.fastq
wget http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/dataset1/Dog30_R1.fastq
wget http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/dataset1/Dog30_R2.fastq
wget http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/dataset1/Dog31_R1.fastq
wget http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/dataset1/Dog31_R2.fastq

#Download the practice metadata

wget http://h3data.cbio.uct.ac.za/assessments/16SrRNADiversityAnalysis/practice/practice.dataset1.metadata.tsv

cd ..
