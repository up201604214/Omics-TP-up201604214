#!/bin/bash
grep -o 'ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR293/.*\.gz' E-MTAB-7438.sdrf.txt|while read -r line; do wget "$line"; done
gunzip *.gz
fastqc *.fastq -o ./fastqc




