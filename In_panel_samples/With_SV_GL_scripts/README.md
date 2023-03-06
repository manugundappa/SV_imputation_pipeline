# Scripts to run imputation pipeline on the inpanel samples with supplying external SV genotype likelihoods

## Run the scripts in the following order

#genotype the downsampled vcf files for SV likelihoods using SVTyper
>bash submitjobs_inpanel_genotype.sh

#drop sample to impute from reference
>bash submitjob_makeref.sh

#get GLs
>bash submitjobs_computeGL.sh

#merge SVTyper genotype likelihoods with SNP GLs
>bash submitjobs_addinSV.sh

#split imputation into chunks
>bash submitjobs_chunk.sh

#generate genetic map
>bash submitjobs_makemaps.sh

#do the imputation
>bash submitjobs_phase.sh

#get concordance
>Rscript get_concordance.R
