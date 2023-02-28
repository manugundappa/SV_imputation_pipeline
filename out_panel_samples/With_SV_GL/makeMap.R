library("ggplot2")
library("dplyr")
library("tidyverse")

args = commandArgs(trailingOnly=TRUE)

file<-paste(args[1], ".sites.tsv.gz", sep="")

dat<-read_tsv(file, col_names = c("chr", "pos", "alleles"))

dat$cM<-dat$pos/1000000

map<-dat %>% select(pos, chr, cM)

write_tsv(map, paste(args[1], ".map", sep=""), col_names=TRUE)
