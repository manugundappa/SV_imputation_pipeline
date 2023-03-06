# SGE options (lines prefixed with #$)
#$ -N smoove.sh
#$ -cwd
#$ -l h_rt=2:00:00
#$ -l h_vmem=16G

# Initialise the environment modules
module load anaconda
source activate smoove2.3

#run smoove
smoove genotype -d -p 1 --name $1.$2.$3-joint --outdir ./genotype/ --fasta ../data/ICSASG_ssa.fa --vcf ../split_vcf/$2.vcf $1.$2.$3.bam