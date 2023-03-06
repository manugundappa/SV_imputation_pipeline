library(tidyverse)
library(vroom)

ids<-c("Enni_12_0008", "Enni_12_0051", "Enni_12_0085", "Enni_12_0092", "Enni_12_0102", "Enni_12_0032", "Enni_12_0064", "Enni_12_0091", "Enni_12_0094", "Enni_12_0105")

cov<-"1x"
dir.create(paste(cov, "_merged_nological_results", sep=""), showWarnings = FALSE)

for(i in ids)
{
  #would prefer not to hard code the number of header lines to skip but vroom seems to have a problem with specifying comments as ##
  files1<-dir(pattern = glob2rx(paste(i, ".*.",cov,".00.vcf", sep="")))
  files2<-dir(pattern = glob2rx(paste(i, ".*.",cov,".00.svtyper.vcf", sep="")))
  
  dat1<- vroom(files1, skip=15)
  dat2<- vroom(files2, skip=15)
  
  dat1_snps<-dat1 %>% filter(REF!="N")
  
  dat1_svs<- dat1 %>% filter(REF=="N")
  dat2_svs<- dat2 %>% filter(REF=="N")
  
  filt_anti<-anti_join(dat1_svs,dat2_svs, by=c("#CHROM","POS","ALT"))
  
  filt<-semi_join(dat2_svs,dat1_svs, by=c("#CHROM","POS","ALT"))
  
  imputed <- bind_rows(dat1_snps,filt,filt_anti)
  
  imputed$geno<-str_sub(imputed %>% pull(i), 1,3)
  imputed$posteriors<-sapply(strsplit(imputed %>% pull(i), ":"), function(x) x[3])
  imputed <- imputed %>% separate(posteriors, into=c("homRefPost", "hetPost", "homAltPost"), sep=",")
  imputed$maxPost<-pmax(imputed$homRefPost, imputed$hetPost, imputed$homAltPost)
  imputed <- imputed %>% filter(maxPost > 0.90)
  colnames(imputed)[1]<-"CHROM"
  
  Sys.setenv("VROOM_CONNECTION_SIZE" = 131072 * 400)
  filesT<-dir(pattern = glob2rx(paste("referencePanel.only",i, ".*.vcf.gz", sep="")))
  truth <- vroom(filesT, skip=232762) 
  truth$geno<-str_sub(truth %>% pull(i), 1,3)
  colnames(truth)[1]<-"CHROM"
  
  merged<-left_join(imputed, truth, by=c("CHROM", "POS", "ID", "REF", "ALT"))
  
  SVCon<-merged %>% filter(REF=="N") %>% group_by(ALT, geno.x, geno.y) %>% tally() %>% spread(geno.y, n)
  SNPCon<-merged %>% filter(REF!="N") %>% group_by(geno.x, geno.y) %>% tally() %>% spread(geno.y, n)
  
  write_tsv(SVCon, paste(cov, "_merged_nological_results/",i, "_SV_merged_nological_results.txt", sep=""))
  write_tsv(SNPCon, paste(cov, "_merged_nological_results/",i, "_SNP_merged_nological_results.txt", sep=""))
  
  rm(dat1)
  rm(dat2)
  rm(imputed)
  rm(merged)
  rm(truth)  
}

