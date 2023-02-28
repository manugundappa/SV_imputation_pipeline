samples=("z1_BDSW190610692-2a_HN2NHDSXX_L4_ssa" "z2_BDSW190610693-2a_HN2NHDSXX_L1_ssa" "z3_BDSW190610694-2a_HN2NHDSXX_L3_ssa" "z4_BDSW190610695-2a_HN2NHDSXX_L3_ssa" \
"z5_BDSW190610696-2a_HN2NHDSXX_L3_ssa" "z6_BDSW190610697-2a_HN2NHDSXX_L3_ssa" "z7_BDSW190610698-2a_HN2NHDSXX_L3_ssa" "z8_BDSW190610699-2a_HN2NHDSXX_L3_ssa" \
"z9_BDSW190610700-2a_HN2NHDSXX_L3_ssa" "z10_BDSW190610701-2a_HN2NHDSXX_L3_ssa" "z11_BDSW190610702-1a_HN2NHDSXX_L4_ssa" \
"z12_BDSW190610703-1a_HN2NHDSXX_L4_ssa" "z13_BDSW190610704-1a_HN2NHDSXX_L3_ssa" \
"z14_BDSW190610705-1a_HN2NHDSXX_L3_ssa" "z15_BDSW190610706-1a_HN2NHDSXX_L4_ssa" \
"z16_BDSW190610707-1a_HN2NHDSXX_L4_ssa" "z17_BDSW190610708-1a_HN2NHDSXX_L2_ssa" \
"z18_BDSW190610709-1a_HN2NHDSXX_L2_ssa" "z19_BDSW190610710-1a_HN2NHDSXX_L3_ssa" "z20_BDSW190610711-1a_HN2NHDSXX_L3_ssa")


chr=("ssa01" "ssa02" "ssa03" "ssa04" "ssa05" "ssa06" "ssa07" "ssa08" "ssa09" "ssa10" "ssa11" "ssa12" "ssa13" "ssa14" "ssa15" "ssa16" "ssa17" "ssa18" "ssa19" "ssa20" "ssa21" "ssa22" "ssa23" "ssa24" "ssa25" "ssa26" "ssa27" "ssa28" "ssa29")


#loop through samples and chromosomes

for (( a = 0; a < 20; a++ ))
do
	for (( b = 0; b < 29; b++ )) 
	do
		echo "${samples[$a]} ${chr[$b]}"
		qsub submitComputeGL.sh ${samples[$a]} ${chr[$b]}
	done
done

