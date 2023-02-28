#!/bin/sh
# SGE options (lines prefixed with #$)
#$ -N maps.sh
#$ -hold_jid refMake.sh
#$ -cwd
#$ -l h_rt=2:00:00
#$ -l h_vmem=16G
#  These options are:
#  job name: -N
#  use the current working directory: -cwd
#  runtime limit : -l h_rt
#  memory limit : -l h_vmem

# Initialise the environment modules
. /etc/profile.d/modules.sh


module load igmm/apps/R/3.6.1
module load anaconda
source activate r_env

Rscript makeMap.R $1

