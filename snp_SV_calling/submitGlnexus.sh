#!/bin/bash
$ -cwd
$ -N runDV.sh
$ -hold_jid runMerge.sh
$ -l h_vmem=35G
$ -l h_rt=50:00:00
$ -pe sharedmem 4
$ -R y
$ -t 1-29
$ -tc 29

# Load modules needed
. /etc/profile.d/modules.sh
module load igmm/apps/tabix/0.2.6
module load roslin/bcftools/1.9
module load roslin/singularity/3.5.3
module load anaconda
source activate manu_env2

#only needs to be run the first time
singularity build glnexus.sif docker://ghcr.io/dnanexus-rnd/glnexus:v1.4.1

chr=("ssa01" "ssa02" "ssa03" "ssa04" "ssa05" "ssa06" "ssa07" "ssa08" "ssa09" "ssa10" "ssa11" "ssa12" "ssa13" "ssa14" "ssa15" "ssa16" "ssa17" "ssa18" "ssa19" "ssa20" "ssa21" "ssa22" "ssa23" "ssa24" "ssa25" "ssa26" "ssa27" "ssa28" "ssa29")

for (( b = 0; b < 29; b++ )) 
do
		echo ${chr[$b]}
		ls *_${chr[$b]}.g.vcf.gz >list_${chr[$b]}.chr.txt
done

INPUT=$(ls ./*.chr.txt | awk "NR == $SGE_TASK_ID")
PREFI="$(basename $INPUT)"
PREFIX="${PREFI%.chr.txt}"

singularity run --bind ${PWD}:/io glnexus.sif glnexus_cli --config DeepVariantWGS --list ./$INPUT --threads 4 --dir /deepvariant/deepvar/split_gvcfs/$PREFIX >$PREFIX.bcf

bcftools index -f $PREFIX.bcf

rm -r $PREFIX

bcftools concat -a -Ov -o all_20_samples.vcf ./*.bcf

vcftools --vcf all_20_samples.vcf --min-alleles 2 --max-alleles 2 --maf 0.01 --max-missing 0.7 --remove-indels --minGQ 10 --minDP 4 --recode --recode-INFO-all --minQ 30 --out all_20_vcf_filter
