#!/bin/sh
# SGE options (lines prefixed with #$)
#$ -N refMake.sh
#$ -cwd
#$ -l h_rt=4:00:00
#$ -l h_vmem=16G
#  These options are:
#  job name: -N
#  use the current working directory: -cwd
#  runtime limit : -l h_rt
#  memory limit : -l h_vmem

# Initialise the environment modules
. /etc/profile.d/modules.sh
module load igmm/apps/bcftools/1.10.2
module load igmm/apps/tabix/0.2.6

##note GLIMPSE tutorial restricts to SNPs here
bcftools view -m 2 -M 2 -s ^$1 --threads 4 -r $2 -Ob -o referencePanel.no$1.$2.bcf referencePanel.vcf.gz
bcftools index -f referencePanel.no$1.$2.bcf

##note GLIMPSE tutorial restricts to SNPs here
bcftools view -G -m 2 -M 2 referencePanel.no$1.$2.bcf -Oz -o no$1.$2.sites.vcf.gz
bcftools index -f no$1.$2.sites.vcf.gz

bcftools query -f'%CHROM\t%POS\t%REF,%ALT\n' no$1.$2.sites.vcf.gz | bgzip -c > no$1.$2.sites.tsv.gz
tabix -s1 -b2 -e2 no$1.$2.sites.tsv.gz

#get true variants to compare to at end
bcftools view -m 2 -M 2 -s $1 --threads 4 -r $2 -Oz -o referencePanel.only$1.$2.vcf.gz referencePanel.vcf.gz

