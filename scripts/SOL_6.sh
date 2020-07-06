#!/bin/bash
mkdir corr
wget https://www.ebi.ac.uk/gxa/experiments-content/E-MTAB-7438/resources/DifferentialSecondaryDataFiles.RnaSeq/raw-counts
R --vanilla << EOF
raw_counts <- read.delim("raw-counts")
myfile <- read.delim("hisat2_htseq/4.tsv.gz")
myfile[is.na(myfile)] <- 0
raw_counts_sorted <-cbind(raw_counts[1],raw_counts[,sort(names(raw_counts[3:8]))])
raw_counts_sorted <-data.frame(raw_counts_sorted)
myfile <- data.frame(myfile)
sample_correlation = 0
number_of_samples <- length(names(myfile)) - 1
for (i in c(2:7)){
  print(cor(myfile[,i],raw_counts_sorted[,i]))
  sample_correlation = sample_correlation + cor(myfile[,i],raw_counts_sorted[,i])
}
median_correlation = sample_correlation/number_of_samples
cat(median_correlation,file = "6.txt")
dev.off()
EOF
mv 6.txt corr
mv raw-counts corr

