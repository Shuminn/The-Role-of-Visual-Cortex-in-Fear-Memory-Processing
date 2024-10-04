#!/usr/bin/env bash

export SUBJECTS_DIR=/Users/shumin/Desktop/MRI/recon

for subj in `cat ./sessidlist`
do

	mri_label2vol --label $SUBJECTS_DIR/`cat ./${subj}/subjectname`/label/rh.BA4a_exvivo.label --subject `cat ./${subj}/subjectname` --hemi rh --identity --temp $SUBJECTS_DIR/`cat ./${subj}/subjectname`/mri/T1.mgz --o $SUBJECTS_DIR/`cat ./${subj}/subjectname`/mri/rh.BA4a.mgz --proj frac 0 1 0.01

	mri_convert $SUBJECTS_DIR/`cat ./${subj}/subjectname`/mri/rh.BA4a.mgz $SUBJECTS_DIR/`cat ./${subj}/subjectname`/mri/rh.BA4a.nii.gz

	mri_vol2vol --mov $SUBJECTS_DIR/`cat ./${subj}/subjectname`/mri/rh.BA4a.nii.gz --targ ${SUBJECTS_DIR}/`cat ./${subj}/subjectname`/mri/rawavg.mgz --regheader --o ./${subj}/bold/localizer.trioskip4.rh/on-v-off/targBA4ainBS.nii.gz --no-save-reg

done


#for subj in `cat ./sessidlist0`
#do

#	mri_label2vol --label $SUBJECTS_DIR/`cat ./${subj}/subjectname`/label/rh.BA4a_exvivo.label --subject `cat ./${subj}/subjectname` --hemi rh --identity --temp $SUBJECTS_DIR/`cat ./${subj}/subjectname`/mri/T1.mgz --o $SUBJECTS_DIR/`cat ./${subj}/subjectname`/mri/rh.BA4a.mgz --proj frac 0 1 0.01

#	mri_convert $SUBJECTS_DIR/`cat ./${subj}/subjectname`/mri/rh.BA4a.mgz $SUBJECTS_DIR/`cat ./${subj}/subjectname`/mri/rh.BA4a.nii.gz

#	mri_vol2vol --mov $SUBJECTS_DIR/`cat ./${subj}/subjectname`/mri/rh.BA4a.nii.gz --targ ${SUBJECTS_DIR}/`cat ./${subj}/subjectname`/mri/rawavg.mgz --regheader --o ./${subj}/bold/localizer.skip0.rh/left-v-right/targBA4ainBS.nii.gz --no-save-reg
 
#done

