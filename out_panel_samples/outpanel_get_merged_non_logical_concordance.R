library(tidyverse)
library(vroom)

cov<-"1x"
PP<-"90PP"

dir.create(paste(cov, "_aqualeap_non_logical_merged_",PP,"_results", sep=""), showWarnings = FALSE)


ids=c("z1_BDSW190610692-2a_HN2NHDSXX_L4","z2_BDSW190610693-2a_HN2NHDSXX_L1","z3_BDSW190610694-2a_HN2NHDSXX_L3", "z4_BDSW190610695-2a_HN2NHDSXX_L3", 
      "z5_BDSW190610696-2a_HN2NHDSXX_L3", "z6_BDSW190610697-2a_HN2NHDSXX_L3", "z7_BDSW190610698-2a_HN2NHDSXX_L3", "z8_BDSW190610699-2a_HN2NHDSXX_L3",
      "z9_BDSW190610700-2a_HN2NHDSXX_L3", "z10_BDSW190610701-2a_HN2NHDSXX_L3", "z11_BDSW190610702-1a_HN2NHDSXX_L4", "z12_BDSW190610703-1a_HN2NHDSXX_L4",
      "z13_BDSW190610704-1a_HN2NHDSXX_L3", "z14_BDSW190610705-1a_HN2NHDSXX_L3", "z15_BDSW190610706-1a_HN2NHDSXX_L4", 
      "z16_BDSW190610707-1a_HN2NHDSXX_L4", "z17_BDSW190610708-1a_HN2NHDSXX_L2", 
      "z18_BDSW190610709-1a_HN2NHDSXX_L2", "z19_BDSW190610710-1a_HN2NHDSXX_L3", "z20_BDSW190610711-1a_HN2NHDSXX_L3")

for(i in ids)
{
  #would prefer not to hard code the number of header lines to skip but vroom seems to have a problem with specifying comments as ##
  files1<-dir(pattern = glob2rx(paste(i, "*.",cov,".00.vcf", sep="")))
  files2<-dir(pattern = glob2rx(paste(i, "*.",cov,".00.svtyper.vcf", sep="")))
  
  dat1<- vroom(files1, skip=15)
  dat2<- vroom(files2, skip=15)
  
  dat1_svs<- dat1 %>% filter(REF=="N")
  dat2_svs<- dat2 %>% filter(REF=="N")
  
  filt_anti<-anti_join(dat1_svs,dat2_svs, by=c("#CHROM","POS","ALT"))
  
  filt<-semi_join(dat2_svs,dat1_svs, by=c("#CHROM","POS","ALT"))
  
  imputed <- bind_rows(filt,filt_anti)
  
  imputed$geno<-str_sub(imputed %>% pull(i), 1,3)
  imputed$posteriors<-sapply(strsplit(imputed %>% pull(i), ":"), function(x) x[3])
  imputed <- imputed %>% separate(posteriors, into=c("homRefPost", "hetPost", "homAltPost"), sep=",")
  imputed$maxPost<-pmax(imputed$homRefPost, imputed$hetPost, imputed$homAltPost)
  imputed <- imputed %>% filter(maxPost > 0.90)
  colnames(imputed)[1]<-"CHROM"
  imputed$ID<-as.numeric(imputed$ID)
  
  #just read truth set once
  Sys.setenv("VROOM_CONNECTION_SIZE" = 131072 * 400)
  #filesT<-dir(pattern = glob2rx(paste("aqualeap_snps.",i,".*.vcf.gz", sep="")))
  truth <- vroom("../merged_SVtyper_genotypes_15x.smoove.square.vcf.gz", skip=86)
  truth$geno<-str_sub(truth %>% pull(i), 1,3)
  colnames(truth)[1]<-"CHROM"
  
  merged<-left_join(imputed, truth, by=c("CHROM", "POS", "ID", "REF", "ALT"))
  
  SVCon<-merged %>% filter(REF=="N") %>% group_by(ALT, geno.x, geno.y) %>% tally() %>% spread(geno.y, n)
  
  write_tsv(SVCon, paste(cov, "_aqualeap_non_logical_merged_",PP,"_results/",i, "_SV_merged_nological_results.txt", sep=""))
  
  rm(dat1)
  rm(dat2)
  rm(imputed)
  rm(merged)
  rm(truth)  
}