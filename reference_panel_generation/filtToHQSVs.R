library(tidyverse)
library(vroom)

Sys.setenv("VROOM_CONNECTION_SIZE" = 131072 * 400)

dat <- vroom("~/allSV.vcf.gz", skip=232715)

hq<-read_tsv("~/Supplementary_data_2.txt")
hq_info<-hq %>% select(Chromosome, Start, End, SVclass)
filt<-inner_join(dat, hq_info, by=c("#CHROM"="Chromosome", "POS"="Start", "ALT"="SVclass"))


colnames(filt)[1]<-"CHROM"
filt_hq<-filt %>% group_by(CHROM, POS, ALT) %>% filter(n()=1)
colnames(filt_hq)[1]<-"#CHROM"
write_tsv(filt_hq, "~/SVs_HQ.vcf")
