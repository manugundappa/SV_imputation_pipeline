
Steps to merge\
#R script to just pull out high quality SVs\
>Rscript filtToHQSVs.R\
_#22 SVs that could not be unambiguously matched to entries in VCF were dropped_\

#Manually put the header back onto the output\
>zgrep "^##" allSV.vcf.gz > header.txt\
>cat header.txt SVs_HQ.vcf > highQualSV_allSamps.vcf

#Run merge of SNPs and SVs\
>qsub submitPrepareRef_2.sh
