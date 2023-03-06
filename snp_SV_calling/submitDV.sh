#!/bin/bash
#$ -cwd
#$ -N runDV.sh
#$ -hold_jid runMerge.sh
#$ -l h_vmem=16G
#$ -l h_rt=50:00:00
#$ -pe sharedmem 12
#$ -R y
#$ -t 1-20
#$ -tc 10

##all 20 bam files
INPUT=$(ls ./z{1..20}_*.bam | awk "NR == $SGE_TASK_ID")
PREFI="$(basename $INPUT)"
PREFIX="${PREFI%.bam}"

# Load modules needed
. /etc/profile.d/modules.sh
module load roslin/singularity/3.5.3
module load igmm/apps/samtools/1.13

# inputs
reference=ICSASG_ssa.fa
bam=$PREFIX.bam
sampleid=$PREFIX
outdir=deepvar

echo $PREFIX

##generate genome index
samtools index -b ${bam} ${bam}.bai

# Create output directories
if [ ! -e deepvar ]; then mkdir deepvar; fi
if [ ! -e deepvar/$sampleid ]; then mkdir deepvar/$sampleid; fi

# Set singularity caches
if [ ! -e ${PWD}/.singularity ]; then mkdir ${PWD}/.singularity; fi
export SINGULARITY_TMPDIR=$PWD/.singularity
export SINGULARITY_CACHEDIR=$PWD/.singularity

# Download the image (do it once)
if [ ! -e deepvariant.sif ]; then singularity build deepvariant.sif docker://google/deepvariant:latest; fi

# Run Deepvariant
singularity exec -p -B ${TMPDIR} -B ${PWD} deepvariant.sif /opt/deepvariant/bin/run_deepvariant \
            --model_type=WGS \
            --ref=${reference} \
            --reads=${bam} \
            --output_vcf=deepvar/${sampleid}/${sampleid}.vcf.gz \
            --output_gvcf=deepvar/${sampleid}/${sampleid}.g.vcf.gz \
            --num_shards=${NSLOTS}
