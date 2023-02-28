samples=("Enni_12_0008" "Enni_12_0051" "Enni_12_0085" "Enni_12_0092" "Enni_12_0102" "Enni_12_0032" "Enni_12_0064" "Enni_12_0091" "Enni_12_0094" "Enni_12_0105")


chr=("ssa01" "ssa02" "ssa03" "ssa04" "ssa05" "ssa06" "ssa07" "ssa08" "ssa09" "ssa10" "ssa11" "ssa12" "ssa13" "ssa14" "ssa15" "ssa16" "ssa17" "ssa18" "ssa19" "ssa20" "ssa21" "ssa22" "ssa23" "ssa24" "ssa25" "ssa26" "ssa27" "ssa28" "ssa29")


#loop through samples and chromosomes

for (( a = 0; a < 10; a++ ))
do
	for (( b = 0; b < 29; b++ )) 
	do
		echo "${samples[$a]} ${chr[$b]}"
		qsub submitComputeGL.sh ${samples[$a]} ${chr[$b]}
	done
done

