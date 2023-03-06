# Scripts to run imputation pipeline on the out-panel samples without supplying external SV genotype likelihoods

## Run the scripts in the following order

#drop sample to impute from reference
>bash submitjob_makeref.sh 

#get GLs
>bash submitjobs_computeGL.sh 

#split imputation into chunks
>bash submitjobs_chunk.sh

##generate genetic map
>bash submitjobs_makemaps.sh

#do the imputation
>bash submitjobs_phase.sh

#get concordance 
>Rscript get_concordance.R
