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
bcftools view -m 2 -M 2 --threads 4 -r $1 -Ob -o referencePanel.$1.bcf referencePanel.vcf.gz

bcftools index -f referencePanel.$1.bcf

##note GLIMPSE tutorial restricts to SNPs here
bcftools view -G -m 2 -M 2 referencePanel.$1.bcf -Oz -o $1.sites.vcf.gz
bcftools index -f $1.sites.vcf.gz

bcftools query -f'%CHROM\t%POS\t%REF,%ALT\n' $1.sites.vcf.gz | bgzip -c > $1.sites.tsv.gz

tabix -s1 -b2 -e2 $1.sites.tsv.gz

#drop SV from files
zgrep -vP "\tN," $1.sites.tsv.gz > $1.noSV.sites.tsv.gz
zgrep -vP "\tN\t" $1.sites.vcf.gz > $1.noSV.sites.vcf.gz


