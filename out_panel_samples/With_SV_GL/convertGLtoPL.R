library("tidyverse")

args = commandArgs(trailingOnly=TRUE)

cov<-args[3]
id<-args[1]
chr<-args[2]
id2<-str_remove(id, "_ssa")

sv<-read_tsv(paste("genotype_",cov,"_chromosome_vcfs/",id,".",chr,".",cov,"-joint-smoove.genotyped.vcf.gz",sep=""), comment="##") %>% 
  separate(id2, sep=":", into=c("GT", "GQ", "SQ", "GL", "DP", "RO", "AO", "QR", "QA", "RS", "AS", "ASC", "RP", "AP", "AB", "DHFC", "DHFFC", "DHBFC", "DHSP")) %>%
  filter(GQ > 0)

sv<-sv %>% separate(GL, sep=",", into=c("GL1", "GL2", "GL3"), convert = TRUE)
sv<-sv %>% mutate(FORMAT="GT:PL:DP", PL1=-10*log10(10^GL1), PL2=-10*log10(10^GL2), PL3=-10*log10(10^GL3))

sv[,id2]<-paste(sv$GT, ":", sv$PL1, ",", sv$PL2, ",", sv$PL3, ":", sv$DP, sep="")
sv$FORMAT<-"GT:PL:DP"

sv<-sv %>% select(c("#CHROM", "POS", "ID", "REF", "ALT", "QUAL", "FILTER", "INFO", "FORMAT", id2))

write_tsv(sv, paste(id,".",chr,".",cov,".svCalls.noHead.vcf",sep=""))
