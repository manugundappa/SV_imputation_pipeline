#!/bin/sh
# SGE options (lines prefixed with #$)
#$ -N chunk.sh
#$ -hold_jid refMake.sh
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

GLIMPSE/static_bins/GLIMPSE_chunk_static --input no$1.$2.sites.vcf.gz --region $2 --window-size 100000000 --buffer-size 200000 --output chunks.$1.$2.txt

