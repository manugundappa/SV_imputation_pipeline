#!/bin/sh
$ -N reference.sh
$ -cwd
$ -l h_rt=5:00:00
$ -l h_vmem=16G

#  These options are:
#  job name: -N
#  use the current working directory: -cwd
#  runtime limit of 5 hours: -l h_rt
#  memory limit of 16 Gbyte: -l h_vmem

# Initialise the environment modules 
. /etc/profile.d/modules.sh

module load igmm/apps/bcftools/1.10.2

module load roslin/gatk/4.1.7.0

#restrict VCFs to overlapping samples and high quality SVs

bcftools view -S overlappingSamples.txt -Oz -o highQualSV.vcf.gz highQualSV_allSamps.vcf

bcftools view -S overlappingSamples.txt -Oz -o allSNPs.vcf.gz ssa.all.gatk.rename.filter.DP4.GQ10.miss0.7.annotate.snpable.no_aqua.recode.vcf.gz

gatk IndexFeatureFile -I highQualSV.vcf.gz

#contig specs in headers of VCFs dont match so fix
gatk UpdateVCFSequenceDictionary -V highQualSV.vcf.gz --source-dictionary allSNPs.vcf.gz --output highQualSV_updatedDict.vcf.gz --replace=true

#merge vcfs
java -jar picard.jar MergeVcfs I=allSNPs.vcf.gz I=highQualSV_updatedDict.vcf.gz O=myMerged_SNPs_SVs.vcf.gz

##sort and index
bcftools sort myMerged_SNPs_SVs.vcf.gz -Oz -o referencePanel.vcf.gz -m 14G -T /home/Scratch/GLIMPSE

bcftools index referencePanel.vcf.gz
