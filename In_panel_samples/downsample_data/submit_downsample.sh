#use this script to get coverage values for each chromosome across all samples


# SGE options (lines prefixed with #$)
#$ -N downsample.sh
#$ -cwd
#$ -l h_rt=10:00:00
#$ -l h_vmem=16G

# Initialise the environment modules
. /etc/profile.d/modules.sh
module load roslin/samtools/1.10

#get individual chromosomes
samtools view -bo $1.$2.bam ${1}.bam $2
samtools index $1.$2.bam
samtools coverage -r $2 $1.$2.bam > $1.$2.cov

