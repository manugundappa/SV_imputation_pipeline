##use this script to downsample the bam files using factor values


# SGE options (lines prefixed with #$)
#$ -N downsample.sh
#$ -cwd
#$ -l h_rt=2:00:00
#$ -l h_vmem=16G

# Initialise the environment modules
. /etc/profile.d/modules.sh
module load roslin/samtools/1.10

#downsample using existing data from chromosome level bams

samtools view -T ICSASG_ssa.fa -s $3 -bo $1.$2.$4.bam $1.$2.bam
samtools index $1.$2.$4.bam
