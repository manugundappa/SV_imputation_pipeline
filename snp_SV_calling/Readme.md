## SV calling on the 20 out-panel samples

Pipeline completely derived from [Bertolotti et al., 2020](https://www.nature.com/articles/s41467-020-18972-x)

## SNP calling on the outpanel samples

[DeepVariant](https://www.nature.com/articles/nbt.4235) used to call SNPs 

run the pipeline on raw bam files

#run DeepVariant
>qsub submitDV.sh

#split vcf files by chromosomes
>bash submitjobs_splitgvcfs.sh

#run Glnexus
>qsub submitGlnexus
