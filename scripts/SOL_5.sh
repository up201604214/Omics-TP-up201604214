#!/bin/sh
mkdir kallisto
wget ftp://ftp.ensembl.org/pub/release-100/fasta/rattus_norvegicus/cdna/Rattus_norvegicus.Rnor_6.0.cdna.all.fa.gz
gunzip *.gz
for i in *.fastq;do java -jar Trimmomatic SE $i ${i}.trimmed_fastq HEADCROP:13 MINLEN:30;done
kallisto index -i Rnor_transcripts.idx Rattus_norvegicus.Rnor_6.0.cdna.all.fa
for i in *.trimmed_fastq;do java -jar Trimmomatic-0.39 SE $i ${i}.trimmed_fastq HEADCROP:13 MINLEN:30;done
for j in *.fastq_trimmed;kallisto quant -i Rnor_transcripts.idx -o ${j}.kallisto.tsv --single -l 43 -s 1 $j
mv *.kallisto.tsv kallisto
