#!/usr/bin/env Rscript

setwd("/sample_data/")


library(dada2)
library(tidyverse)
library(phyloseq)

#Forward and reverse fastq filenames have format: SAMPLENAME_R1.fastq and SAMPLENAME_R2.fastq
fnFs <- sort(list.files(pattern="_R1.fastq", full.names = TRUE))
fnRs <- sort(list.files(pattern="_R2.fastq", full.names = TRUE))
#Extract sample names, assuming filenames have format: SAMPLENAME_XXX.fastq
sample.names <- sapply(strsplit(basename(fnFs), "_"), `[`, 1)


#Inspect quality profiles
fwd_quality_plots <- plotQualityProfile(fnFs)
rev_quality_plots <- plotQualityProfile(fnRs)

#If you have so many samples, subset a few or plot a few randomly(to inspect a few)

#Save your plots
pdf("fwd_quality_reads.pdf")
pdf("rev_quality_reads.pdf")

ggsave(plot = fwd_quality_plots, filename = "fwd_quality_reads.pdf",
       width = 10, height = 10, dpi = "retina")

ggsave(plot = rev_quality_plots, filename = "rev_quality_reads.pdf",
       width = 10, height = 10, dpi = "retina")


#Place filtered files in filtered/subdirectory
filtFs <- file.path("filtered", paste0(sample.names, "_F_filt.fastq.gz"))
filtRs <- file.path("filtered", paste0(sample.names, "_R_filt.fastq.gz"))
names(filtFs) <- sample.names
names(filtRs) <- sample.names


filtered_out <- filterAndTrim(fwd=fnFs, filt=filtFs, rev=fnRs, filt.rev=filtRs,
              truncLen=c(250,200), maxEE=c(2,2), truncQ=2, maxN=0, rm.phix=TRUE,
              compress=TRUE, verbose=TRUE, multithread=TRUE)

path <- "/home/abuchery/Documents/Pipeline5/sample_data/filtered/"

#Inspect quality of filtered reads
#Forward-quality and reverse-quality fastq.gz filenames have format: SAMPLENAME_F_filt.fastq.gz and SAMPLENAME_R_filt.fastq.gz
fnFs_filt <- sort(list.files(path, pattern="_F_filt.fastq.gz", full.names = TRUE))
fnRs_filt <- sort(list.files(path, pattern="_R_filt.fastq.gz", full.names = TRUE))


fwd_filt_quality_plots <- plotQualityProfile(fnFs_filt)
rev_filt_quality_plots <- plotQualityProfile(fnRs_filt)

#Save your plots
pdf("fwd_filt_quality_reads.pdf")
pdf("rev_filt_quality_reads.pdf")

ggsave(plot = fwd_filt_quality_plots, filename = "fwd_filt_quality_reads.pdf",
       width = 10, height = 10, dpi = "retina")

ggsave(plot = rev_filt_quality_plots, filename = "rev_filt_quality_reads.pdf",
       width = 10, height = 10, dpi = "retina")


#Learn the error rates
errF <- learnErrors(filtFs, multithread=TRUE)
errR <- learnErrors(filtRs, multithread=TRUE)

#Plot the error rates
error_rates_fwd <- plotErrors(errF, nominalQ=TRUE)
error_rates_rev <- plotErrors(errR, nominalQ=TRUE)


#Save error plots pdf
pdf("estimated_fwd_error_rates.pdf")
ggsave(plot = error_rates_fwd, filename = "estimated_fwd_error_rates.pdf",
       width = 10, height = 10, dpi = "retina")

pdf("estimated_rev_error_rates.pdf")
ggsave(plot = error_rates_rev, filename = "estimated_rev_error_rates.pdf",
       width = 10, height = 10, dpi = "retina")

#Dereplication
derep_forward <- derepFastq(filtFs, verbose=TRUE)
names(derep_forward) <- sample.names
derep_reverse <- derepFastq(filtRs, verbose=TRUE)
names(derep_reverse) <- sample.names

#Core sample inferance
dadaFs <- dada(derep_forward, err=errF, multithread=TRUE, pool=TRUE)
dadaRs <- dada(derep_reverse, err=errR, multithread=TRUE, pool=TRUE)

#Merge paired reads
mergers <- mergePairs(dadaFs, derep_forward, dadaRs, derep_reverse, verbose=TRUE)

#Construct sequence table
seqtab <- makeSequenceTable(mergers)

#Remove Chimeras
seqtab.nochim <- removeBimeraDenovo(seqtab, method="consensus", multithread=TRUE, verbose=TRUE)

#Track reads through the pipeline so far
getN <- function(x) sum(getUniques(x))
track <- cbind(filtered_out, sapply(dadaFs, getN), sapply(dadaRs, getN), sapply(mergers, getN), sapply(derep_forward, getN), rowSums(seqtab.nochim))
#If processing a single sample, remove the sapply calls: e.g. replace sapply(dadaFs, getN) with getN(dadaFs)
colnames(track) <- c("input", "filtered", "denoisedF", "denoisedR", "merged", "dereplicated_reads", "nonchim")
rownames(track) <- sample.names

write.table(track, "read-count-tracking.tsv", quote=FALSE, sep="\t", col.names=NA)

#Assign taxonomy
library(DECIPHER)

#Create a DNAStringSet from the ASVs
dna <- DNAStringSet(getSequences(seqtab.nochim))
url="http://www2.decipher.codes/Classification/TrainingSets/SILVA_SSU_r138_2019.RData"
destfile="SILVA_SSU_r138_2019.RData"
download.file(url, destfile)
load("SILVA_SSU_r138_2019.RData")
id_info <- IdTaxa(dna, trainingSet, strand="top", processors=NULL, verbose=FALSE)

#Giving the seq headers more manageable names (ASV_1, ASV_2...)
asv_seqs <- colnames(seqtab.nochim)
asv_headers <- vector(dim(seqtab.nochim)[2], mode="character")

for (i in 1:dim(seqtab.nochim)[2]) {
  asv_headers[i] <- paste(">ASV", i, sep="_")
}

#Make and write out a fasta of our final ASV seqs:
asv_fasta <- c(rbind(asv_headers, asv_seqs))
write(asv_fasta, "ASVs.fa")

#Count table:
asv_tab <- t(seqtab.nochim)
row.names(asv_tab) <- sub(">", "", asv_headers)
write.table(asv_tab, "ASVs_counts.tsv", sep="\t", quote=F, col.names=NA)

#Convert the output object of class "Taxa" to a matrix analogous to the output from assignTaxonomy
#Tax table:
#Create table of taxonomy and setting any that are unclassified as "NA"
ranks <- c("domain", "phylum", "class", "order", "family", "genus", "species")
asv_tax <- t(sapply(id_info, function(x) {
  m <- match(ranks, x$rank)
  taxa <- x$taxon[m]
  taxa[startsWith(taxa, "unclassified_")] <- NA
  taxa
}))
colnames(asv_tax) <- ranks
rownames(asv_tax) <- gsub(pattern=">", replacement="", x=asv_headers)

write.table(asv_tax, "ASVs_taxonomy.tsv", sep = "\t", quote=F, col.names=NA)


#Remove likely contaminants
library(decontam)

vector_for_decontam <- c(rep(TRUE), rep(FALSE))

contam_df <- isContaminant(t(asv_tab), neg=vector_for_decontam)

#Getting vector holding the identified contaminant IDs
contam_asvs <- row.names(contam_df[contam_df$contaminant == TRUE, ])

#Make new fasta file
contam_indices <- which(asv_fasta %in% paste0(">", contam_asvs))
dont_want <- sort(c(contam_indices, contam_indices + 1))
asv_fasta_no_contam <- asv_fasta[- dont_want]

#Make new count table
asv_tab_no_contam <- asv_tab[!row.names(asv_tab) %in% contam_asvs, ]

#Make new taxonomy table
asv_tax_no_contam <- asv_tax[!row.names(asv_tax) %in% contam_asvs, ]

#Write them out to files
write(asv_fasta_no_contam, "ASVs-no-contam.fa")
write.table(asv_tab_no_contam, "ASVs_counts-no-contam.tsv",
            sep="\t", quote=F, col.names=NA)
write.table(asv_tax_no_contam, "ASVs_taxonomy-no-contam.tsv",
            sep="\t", quote=F, col.names=NA)

#Reading the data in R
count_tab <- read.table("ASVs_counts-no-contam.tsv", header=T, row.names=1,
             check.names=F, sep="\t")
tax_tab <- as.matrix(read.table("ASVs_taxonomy-no-contam.tsv", header=T,
           row.names=1, check.names=F, sep="\t"))

sample_info_tab <- read.table("practice.dataset1.metadata.tsv", header=T, row.names=1,
                   check.names=F, sep="\t")

#Make phyloseq object with transformed table
count_tab_phy <- otu_table(count_tab, taxa_are_rows=T)
tax_tab_phy <- tax_table(tax_tab)
sample_info_tab_phy <- sample_data(sample_info_tab)

sample_info_tab$color <- as.character(sample_info_tab$Dog)

ASV_physeq <- phyloseq(count_tab_phy, tax_tab_phy, sample_info_tab_phy)

#Plot richness using the plot_richness() function on the phyloseq object
alpha_plot <- plot_richness(ASV_physeq, measures=c("Shannon", "Simpson"), color="Dog")

pdf("Alpha_diversity_plot.pdf")
ggsave(plot = alpha_plot, filename = "Alpha_diversity_plot.pdf",
       width = 10, height = 10, dpi = "retina")

#Box_plot
alpha_box_plot <- plot_richness(ASV_physeq, color="Dog", measures=c("Observed", "Shannon")) + geom_boxplot()

pdf("Alpha_diversity_box_plot.pdf")
ggsave(plot = alpha_box_plot, filename = "Alpha_diversity_box_plot.pdf",
       width = 10, height = 10, dpi = "retina")

#Abundance bar plot
sorting <- names(sort(taxa_sums(ASV_physeq), decreasing=TRUE))
ASV_physeq.sorting <- transform_sample_counts(ASV_physeq, function(OTU) OTU/sum(OTU))
ASV_physeq.sorting <- prune_taxa(sorting, ASV_physeq.sorting)
abundance <- plot_bar(ASV_physeq.sorting, fill="genus") + facet_wrap(~Dog, scales="free_x")

pdf("Classification_bar_plot.pdf")
ggsave(plot = abundance, filename = "Classification_bar_plot.pdf",
       width = 15, height = 10, dpi = "retina")

#Beta diversity
#PCOA plot using Bray-Curtis as distance
bray_curtis_dist = phyloseq::distance(ASV_physeq, method="bray", weighted=F)
ord = ordinate(ASV_physeq, method="PCoA", distance=bray_curtis_dist)
Bray_plt <- plot_ordination(ASV_physeq, ord, color="Dog") + theme(aspect.ratio=1)
pdf("Bray_curtis_plot.pdf")
ggsave(plot = Bray_plt, filename = "Bray_curtis_plot.pdf",
       width = 10, height = 10, dpi = "retina")



