chr=("ssa01" "ssa02" "ssa03" "ssa04" "ssa05" "ssa06" "ssa07" "ssa08" "ssa09" "ssa10" "ssa11" "ssa12" "ssa13" "ssa14" "ssa15" "ssa16" "ssa17" "ssa18" "ssa19" "ssa20" "ssa21" "ssa22" "ssa23" "ssa24" "ssa25" "ssa26" "ssa27" "ssa28" "ssa29")

#loop through chromosomes

	for (( b = 0; b < 29; b++ )) 
	do
		echo ${chr[$b]}
		qsub submitMakeRef.sh ${chr[$b]}
	done



