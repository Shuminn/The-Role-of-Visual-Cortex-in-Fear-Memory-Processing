#!/usr/bin/env bash

export SUBJECTS_DIR=/Users/shumin/Desktop/MRI/recon

for subj in `cat ./all`
do
	recon-all -s ${subj} -i ./subjnii/${subj}/T1/*.nii.gz -cm -T2 /Users/shumin/Desktop/MRI/subjnii/${subj}/T2/T2.nii.gz -T2pial -all -qcache
done
