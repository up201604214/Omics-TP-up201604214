#!/bin/bash
mkdir hisat2_htseq
wget ftp://ftp.ensembl.org/pub/release-100/fasta/rattus_norvegicus/dna/Rattus_norvegicus.Rnor_6.0.dna_rm.toplevel.fa.gz
wget ftp://ftp.ensembl.org/pub/release-100/gtf/rattus_norvegicus/Rattus_norvegicus.Rnor_6.0.100.gtf.gz
gunzip *.gz
for i in *.fastq;do java -jar Trimmomatic SE $i ${i}.trimmed_fastq HEADCROP:13 MINLEN:30;done
hisat2-build Rattus_norvegicus.Rnor_6.0.dna_rm.toplevel.fa /hisat2
for i in *.trimmed_fastq;do hisat2 -x hisat2/index -U $i -S $i.sam;done && for i in *.sam;do htseq-count -s no $i Rattus_norvegicus.Rnor_6.0.100.gtf > $i.counts.txt;done
R --vanilla << EOF
myfiles <- list.files(pattern = "*.counts.txt")
out <- assign(sub(".fastq.trimmed_fastq.sam.counts.txt","",myfiles[1]),read.table(myfiles[1], sep = "\t"))
out <- head(out,-5)
colnames(out)[1] <- "gene"
colnames(out)[2] <- sub(".fastq.trimmed_fastq.sam.counts.txt","",myfiles[1])
for(i in myfiles[-1]){
  sample_name <- sub(".fastq.trimmed_fastq.sam.counts.txt","",i)
  sample_data <- assign(sample_name,read.table(i, sep ="\t"))
  colnames(sample_data)[2] <- sample_name
  name <- head(sample_data,-5)
  out <-cbind(out,name[2])
}
write.table(out, "4.tsv", sep="\t", col.names = TRUE,row.names = FALSE)
dev.off()
EOF
gzip 4.tsv
mv 4.tsv hisat2_htseq
rm *.sam
rm *.fastq.trimmed_fastq.sam.counts.txt
