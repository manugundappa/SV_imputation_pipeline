#!/bin/sh
# SGE options (lines prefixed with #$)
#$ -N gl.sh
#$ -hold_jid refMake.sh,downsample.sh
#$ -cwd
#$ -l h_rt=5:00:00
#$ -l h_vmem=16G
#  These options are:
#  job name: -N
#  use the current working directory: -cwd
#  runtime limit : -l h_rt
#  memory limit : -l h_vmem

# Initialise the environment modules
. /etc/profile.d/modules.sh
module load igmm/apps/bcftools/1.10.2

#drop SV from files
zgrep -vP "\tN," no$1.$2.sites.tsv.gz > no$1.$2.noSV.sites.tsv.gz ##tsv output

zgrep -vP "\tN\t" no$1.$2.sites.vcf.gz > no$1.$2.noSV.sites.vcf.gz  ###vcf output

bcftools mpileup -f ICSASG_ssa.fa -I -E -a 'FORMAT/DP' -T no$1.$2.noSV.sites.vcf.gz -r $2 $1.$2.1x.bam -Ou | bcftools call -Aim -C alleles -T no$1.$2.noSV.sites.tsv.gz -Oz -o $1.$2.1x.vcf.gz

bcftools index -f $1.$2.1x.vcf.gz

