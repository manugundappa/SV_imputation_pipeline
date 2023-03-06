#!/bin/sh
# SGE options (lines prefixed with #$)
#$ -N refMake.sh
#$ -cwd
#$ -l h_rt=4:00:00
#$ -l h_vmem=16G
#  These options are:
#  job name: -N
#  use the current working directory: -cwd
#  runtime limit of 10 minutes: -l h_rt
#  memory limit of 64 Gbyte: -l h_vmem

# Initialise the environment modules
. /etc/profile.d/modules.sh
module load igmm/apps/bcftools/1.10.2
module load igmm/apps/tabix/0.2.6

#specify dirs 
OUTPUT_DIR=/mgundapp/deepvariant/deepvar/split_gvcfs/

##split
bcftools view -l 9 -r $2 -o $OUTPUT_DIR/$1_$2.g.vcf.gz $1.g.vcf.gz
bcftools index -f $OUTPUT_DIR/$1_$2.g.vcf.gz

