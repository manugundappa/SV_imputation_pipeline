### calculate concordance for SVs and SNPs
library(tidyverse)
library(vroom)

cov<-"1x" ##run this across all depths 1x.2x.3x.4x 
maxpost<-"0.60" ##run this for 0.75 and 0.90 
PP<-"60PP"

##sample IDs of outpanel samples
ids<-c("Enni_12_0008", "Enni_12_0051", "Enni_12_0085", "Enni_12_0092", "Enni_12_0102", "Enni_12_0032", "Enni_12_0064", "Enni_12_0091", "Enni_12_0094", "Enni_12_0105")

##create directory to store the outputs
dir.create(paste(cov, "_inpanel_nosvtyper_",PP,"_results", sep=""), showWarnings = FALSE)

##loop for SNP and SV concordance
for(i in ids)
{
  Sys.setenv("VROOM_CONNECTION_SIZE" = 131072 * 400)
  filesT<-dir(pattern = glob2rx(paste("referencePanel.only",i, ".*.vcf.gz", sep=""))) ##reference panel with true genotypes
  truth <- vroom(filesT, skip=232762) 
  truth$geno<-str_sub(truth %>% pull(i), 1,3)
  colnames(truth)[1]<-"CHROM"
  
  #would prefer not to hard code the number of header lines to skip but vroom seems to have a problem with specifying comments as ##
  filesI<-dir(pattern = glob2rx(paste(i, ".*.1x.00.vcf", sep="")))
  imputed <- vroom(filesI, skip=15) 
  imputed$geno<-str_sub(imputed %>% pull(i), 1,3)
  imputed$posteriors<-sapply(strsplit(imputed %>% pull(i), ":"), function(x) x[3])
  imputed <- imputed %>% separate(posteriors, into=c("homRefPost", "hetPost", "homAltPost"), sep=",")
  imputed$maxPost<-pmax(imputed$homRefPost, imputed$hetPost, imputed$homAltPost)
  imputed <- imputed %>% filter(maxPost > maxpost)
  colnames(imputed)[1]<-"CHROM"
  
  merged<-left_join(imputed, truth, by=c("CHROM", "POS", "ID", "REF", "ALT"))
  
  SVCon<-merged %>% filter(REF=="N") %>% group_by(ALT, geno.x, geno.y) %>% tally() %>% spread(geno.y, n)
  SNPCon<-merged %>% filter(REF!="N") %>% group_by(geno.x, geno.y) %>% tally() %>% spread(geno.y, n)
  
  write_tsv(SNPCon, paste(cov, "_inpanel_nosvtyper_",PP,"_results/",i, "_inpanel_nosvtyper_",PP,"_SNPCon.txt", sep=""))
  write_tsv(SNPCon, paste(cov, "_inpanel_nosvtyper_",PP,"_results/",i, "_inpanel_nosvtyper_",PP,"_SVCon.txt", sep=""))
  
  rm(truth)
  rm(merged)
  rm(imputed)
  rm(SNPCon)
  rm(SVcon)                           
}

