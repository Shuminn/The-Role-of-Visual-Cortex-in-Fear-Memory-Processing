#!/usr/bin/env bash

for subj in `ls ./subjdcm`
do
	mkdir -p ./subjnii/${subj}
	dcm2niix -o ./subjnii/${subj} -z y /Users/shumin/Desktop/MRI/subjdcm/${subj}
done
~                                                                       
