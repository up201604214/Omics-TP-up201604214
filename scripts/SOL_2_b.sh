#!/bin/bash
cd fastqc && unzip '*.zip'
#array com os nomes das amostras
name=$(find . -regex '.*fastqc'|grep -o 'ERR29303..'|sort) && for i in "${name[@]}";do echo "$i">>names;done
#array com o tamanho de reads de cada amostras
len=$(for i in *_fastqc/fastqc_data.txt;do cat $i|grep "Sequence length"|grep -o "[0123456789]*";done) && for i in "${len[@]}";do echo "$i">>len;done
#array com o numero de reads de cada amostra
number=$(for i in *_fastqc/fastqc_data.txt;do cat $i|grep "Total Sequences"|grep -o "[0123456789]*";done) && for i in "${number[@]}";do echo "$i">>number;done
#criação do ficheiro de tsv
echo -e 'nome\tnumero de reads\ttamanho minimo\ttamanho maximo\tamanho medio' > 2_b.tsv
#preenchimento do ficheiro
paste -d'\t' names number len len len>> 2_b.tsv
mv 2_b.tsv ..
rm names && rm len && rm number




