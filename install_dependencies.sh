#!/bin/bash
cd /
#fastqc
wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip
unzip fastqc_v0.11.9.zip
chmod 755 fastqc_v0.11.9

#Trimmomatic
wget http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-Src-0.39.zip
unzip Trimmomatic-Src-0.39.zip

#hisat2
wget http://ccb.jhu.edu/software/hisat2/downloads/hisat2-2.0.0-beta-source.zip
unzip Trimmomatic-Src-0.39.zip

#GETTING HTSeq
pip install HTSeq

#GETTING KALLISTO
wget https://github.com/pachterlab/kallisto/releases/download/v0.46.1/kallisto_linux-v0.46.1.tar.gz
tar xvzf kallisto_linux-v0.46.1.tar.gz

#GETTING DESEq2
R --save<<EOF
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("DESeq2")
dev.off()
EOF


