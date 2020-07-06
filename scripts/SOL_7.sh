mkdir deseq2
wget https://www.ebi.ac.uk/gxa/experiments-content/E-MTAB-7438/resources/ExperimentDesignFile.RnaSeq/experiment-design -O metadata.tsv
R --vanilla << EOF
library("DESeq2")
gene_counts<-read.delim('hisat2_htseq/4.tsv.gz')
rownames(gene_counts)<-as.character(gene_counts[,1])
gene_counts<-gene_counts[,-1]
Metadata<-read.delim('E-MTAB-7438.metadata')
C_data<-Metadata[,16,drop=FALSE]
rownames(C_data)<-as.character(Metadata[,1])
colnames(C_data)[1]<-'exp_condition'
C_data[C_date=='aldosterone 20 nanomolar']<-'aldosterone_20_nanomolar'
dds<-DESeqDataSetFromMatrix(countData = gene_counts,colData = C_data,design = ~ exp_condition)
dds$exp_condition <- relevel(dds$exp_condition, ref = "none")
dds<-DESeq(dds)
resultados<-results(dds,alpha = 0.05,independentFiltering = TRUE)
resultados_ord<-resultados[order(resultados$padj),]
de_exp<-ord[which(resultados_ord$padj < 0.05),]
write(nrow(de_exp),'7_num_deg.txt')
data_f<-data.frame(resultados_ord$pvalue,resultaods_ord$padj,resultados_ord$log2FoldChange,row.names = rownames(resultados_ord))
data_f$gene_id<-row.names(data_f)
data_f<-data_f[,c(4,1,2,3)]
colnames(data_f)<-c('gene_id','p-value','adjusted-pvalue','log2(Fold-Change')
write.table(data_f,file='7.tsv.gz',quote = FALSE,sep = '\t',row.names = FALSE)
dev.off()
EOF
gzip 7.tsv
mv 7.tsv.gz deseq2
mv 7_num_deg.txt deseq2
mv metadata.tsv deseq2
