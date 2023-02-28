#!/bin/sh
# SGE options (lines prefixed with #$)
#$ -N phase.sh
#$ -hold_jid chunk.sh,gl.sh,maps.sh
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

GLIMPSE/static_bins/GLIMPSE_phase_static --input $1.$2.1x.vcf.gz --reference referencePanel.$2.bcf --map $2.map --input-region $3 --output-region $4 --output $1.$2.1x.$5.vcf --impute-reference-only-variants




