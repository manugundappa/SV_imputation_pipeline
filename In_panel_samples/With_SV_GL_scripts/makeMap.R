library(tidyverse)

args = commandArgs(trailingOnly=TRUE)

file<-paste("no", args[1], ".", args[2], ".sites.tsv.gz", sep="")

dat<-read_tsv(file, col_names = c("chr", "pos", "alleles"))

dat$cM<-dat$pos/1000000

map<-dat %>% select(pos, chr, cM)

write_tsv(map, paste("no", args[1], ".", args[2], ".map", sep=""), col_names=TRUE)
