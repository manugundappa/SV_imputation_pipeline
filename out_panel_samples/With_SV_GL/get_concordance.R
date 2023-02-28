### calculate concordance for SVs only and not SNPs

library(tidyverse)
library(vroom)

cov<-"1x" ##run this across all depths 1x.2x.3x.4x 
maxpost<-"0.60" ##run this for 0.75 and 0.90 
PP<-"60PP"

##create directory to store the outputs
dir.create(paste(cov, "_aqualeap_svtyper_",PP,"_results", sep=""), showWarnings = FALSE)

##sample IDs of outpanel samples
ids=c("z1_BDSW190610692-2a_HN2NHDSXX_L4","z2_BDSW190610693-2a_HN2NHDSXX_L1","z3_BDSW190610694-2a_HN2NHDSXX_L3", "z4_BDSW190610695-2a_HN2NHDSXX_L3", 
         "z5_BDSW190610696-2a_HN2NHDSXX_L3", "z6_BDSW190610697-2a_HN2NHDSXX_L3", "z7_BDSW190610698-2a_HN2NHDSXX_L3", "z8_BDSW190610699-2a_HN2NHDSXX_L3",
         "z9_BDSW190610700-2a_HN2NHDSXX_L3", "z10_BDSW190610701-2a_HN2NHDSXX_L3", "z11_BDSW190610702-1a_HN2NHDSXX_L4", "z12_BDSW190610703-1a_HN2NHDSXX_L4",
         "z13_BDSW190610704-1a_HN2NHDSXX_L3", "z14_BDSW190610705-1a_HN2NHDSXX_L3", "z15_BDSW190610706-1a_HN2NHDSXX_L4", 
         "z16_BDSW190610707-1a_HN2NHDSXX_L4", "z17_BDSW190610708-1a_HN2NHDSXX_L2", 
         "z18_BDSW190610709-1a_HN2NHDSXX_L2", "z19_BDSW190610710-1a_HN2NHDSXX_L3", "z20_BDSW190610711-1a_HN2NHDSXX_L3")


###loop this script across all 20 samples
for(i in ids)
{
  #just read truth set once
  Sys.setenv("VROOM_CONNECTION_SIZE" = 131072 * 400)
  truth <- vroom("../merged_SVtyper_genotypes_15x.smoove.square.vcf.gz", skip=86) ##True genotypes called using 15x data
  colnames(truth)[1]<-"CHROM"
  
  #would prefer not to hard code the number of header lines to skip but vroom seems to have a problem with specifying comments as ##
  
  filesI<-dir(pattern = glob2rx(paste(i, "*.",cov,".00.svtyper.vcf", sep=""))) ##imputed output vcf files 
  imputed <- vroom(filesI, skip=15)
  imputed$geno<-str_sub(imputed %>% pull(i), 1,3)
  imputed$posteriors<-sapply(strsplit(imputed %>% pull(i), ":"), function(x) x[3])
  imputed <- imputed %>% separate(posteriors, into=c("homRefPost", "hetPost", "homAltPost"), sep=",")
  imputed$maxPost<-pmax(imputed$homRefPost, imputed$hetPost, imputed$homAltPost)
  imputed <- imputed %>% filter(maxPost > maxpost)
  colnames(imputed)[1]<-"CHROM"
  
  #extract this sample from truth set
  truth<-truth %>% select(CHROM:FORMAT, i)
  truth$geno<-str_sub(truth %>% pull(i), 1,3)
  
  #note had to drop including the variant id in the merge as dont seem to tally
  #this should ideally be fixed as currently just effectively merging on same type of
  #sv at same location as exact alleles are not shown
  merged<-left_join(imputed, truth, by=c("CHROM", "POS", "REF", "ALT"))
  
  SVCon<-merged %>% filter(REF=="N") %>% group_by(ALT, geno.x, geno.y) %>% tally() %>% spread(geno.y, n)
  
  write_tsv(SVCon, paste(cov, "_aqualeap_svtyper_",PP,"_results/",i, "_aqualeap_svtyper_",PP,"_SVCon.txt", sep=""))
  
  rm(truth)
  rm(merged)
  rm(imputed)
  rm(SVCon)
}
