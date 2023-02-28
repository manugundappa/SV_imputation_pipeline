#!/bin/sh
# SGE options (lines prefixed with #$)
#$ -N addSV.sh
#$ -hold_jid gl.sh,refMake.sh
#$ -cwd
#$ -l h_rt=1:00:00
#$ -l h_vmem=16G
#  These options are:
#  job name: -N
#  use the current working directory: -cwd
#  runtime limit : -l h_rt
#  memory limit : -l h_vmem

# Initialise the environment modules
. /etc/profile.d/modules.sh

module load igmm/apps/bcftools/1.10.2
module load roslin/gatk/4.1.7.0
module load igmm/apps/picard/2.25.4

module load anaconda
source activate r_env

Rscript convertGLtoPL.R $1 $2 $3

zgrep "^##" genotype_${3}_chromosome_vcfs/$1.$2.${3}-joint-smoove.genotyped.vcf.gz > $1.$2.${3}-joint-smoove.genotyped.head
cat $1.$2.${3}-joint-smoove.genotyped.head $1.$2.${3}.svCalls.noHead.vcf > $1.$2.$3.svCalls.vcf
rm $1.$2.${3}-joint-smoove.genotyped.head
gatk UpdateVCFSequenceDictionary -V $1.$2.$3.svCalls.vcf --source-dictionary $1.$2.$3.vcf.gz --output $1.$2.$3.svCalls.reHead.vcf --replace=true

picard MergeVcfs I=$1.$2.$3.vcf.gz I=$1.$2.$3.svCalls.reHead.vcf O=$1.$2.$3.sv_snpCalls.vcf

mkdir ${1}_${2}

bcftools sort $1.$2.$3.sv_snpCalls.vcf -Oz -o $1.$2.$3.sv_snpCalls.sorted.vcf.gz -m 14G -T /exports/eddie/scratch/mgundapp/imputation/4x_aqua/${1}_${2}/
bcftools index $1.$2.$3.sv_snpCalls.sorted.vcf.gz

rm -r ${1}_${2}


