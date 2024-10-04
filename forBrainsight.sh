#!/usr/bin/env bash

export SUBJECTS_DIR=/Users/shumin/Desktop/MRI/recon

for subj in `cat ./sessidlist`
do

	mri_label2vol --label $SUBJECTS_DIR/`cat ./${subj}/subjectname`/label/rh.V1_exvivo.label --subject `cat ./${subj}/subjectname` --hemi rh --identity --temp $SUBJECTS_DIR/`cat ./${subj}/subjectname`/mri/T1.mgz --o $SUBJECTS_DIR/`cat ./${subj}/subjectname`/mri/rh.V1.mgz --proj frac 0 1 0.01

	mri_convert $SUBJECTS_DIR/`cat ./${subj}/subjectname`/mri/rh.V1.mgz $SUBJECTS_DIR/`cat ./${subj}/subjectname`/mri/rh.V1.nii.gz
	mri_binarize --i ./${subj}/bold/localizer.skip4.rh/on-v-off/t.nii.gz --o ./${subj}/bold/localizer.skip4.rh/on-v-off/t.binary.nii.gz --min 1.25
	
	mri_surf2vol --o ./${subj}/bold/localizer.skip4.rh/on-v-off/targ.nii.gz --subject `cat ./${subj}/subjectname` --so  $SUBJECTS_DIR/`cat ./${subj}/subjectname`/surf/rh.white ./${subj}/bold/localizer.skip4.rh/on-v-off/t.binary.nii.gz

	mri_mask ./${subj}/bold/localizer.skip4.rh/on-v-off/targ.nii.gz $SUBJECTS_DIR/`cat ./${subj}/subjectname`/mri/rh.V1.nii.gz ./${subj}/bold/localizer.skip4.rh/on-v-off/targV1.nii.gz

	mri_vol2vol --mov ./${subj}/bold/localizer.skip4.rh/on-v-off/targV1.nii.gz --targ ${SUBJECTS_DIR}/`cat ./${subj}/subjectname`/mri/rawavg.mgz --regheader --o ./${subj}/bold/localizer.skip4.rh/on-v-off/targV1inBS.nii.gz --no-save-reg

done

#for subj in `cat ./sessidlist`
#do

	#mri_label2vol --label $SUBJECTS_DIR/`cat ./${subj}/subjectname`/label/rh.V1_exvivo.label --subject `cat ./${subj}/subjectname` --hemi rh --identity --temp $SUBJECTS_DIR/`cat ./${subj}/subjectname`/mri/T1.mgz --o $SUBJECTS_DIR/`cat ./${subj}/subjectname`/mri/rh.V1.mgz --proj frac 0 1 0.01

	#mri_convert $SUBJECTS_DIR/`cat ./${subj}/subjectname`/mri/rh.V1.mgz $SUBJECTS_DIR/`cat ./${subj}/subjectname`/mri/rh.V1.nii.gz

	#mri_binarize --i ./${subj}/bold/localizer.trioskip4.rh/on-v-off/t.nii.gz --o ./${subj}/bold/localizer.trioskip4.rh/on-v-off/t.binary.nii.gz --min 1.25
	
#	mri_surf2vol --o ./${subj}/bold/localizer.trioskip4.rh/on-v-off/targ.nii.gz --subject `cat ./${subj}/subjectname` --so  $SUBJECTS_DIR/`cat ./${subj}/subjectname`/surf/rh.white ./${subj}/bold/localizer.trioskip4.rh/on-v-off/t.binary.nii.gz

#	mri_mask ./${subj}/bold/localizer.trioskip4.rh/on-v-off/targ.nii.gz $SUBJECTS_DIR/`cat ./${subj}/subjectname`/mri/rh.V1.nii.gz ./${subj}/bold/localizer.trioskip4.rh/on-v-off/targV1.nii.gz

#	mri_vol2vol --mov ./${subj}/bold/localizer.trioskip4.rh/on-v-off/targV1.nii.gz --targ ${SUBJECTS_DIR}/`cat ./${subj}/subjectname`/mri/rawavg.mgz --regheader --o ./${subj}/bold/localizer.trioskip4.rh/on-v-off/targV1inBS.nii.gz --no-save-reg

#done

#for subj in `cat ./sessidlist0`
#do

#	mri_label2vol --label $SUBJECTS_DIR/`cat ./${subj}/subjectname`/label/rh.V1_exvivo.label --subject `cat ./${subj}/subjectname` --hemi rh --identity --temp $SUBJECTS_DIR/`cat ./${subj}/subjectname`/mri/T1.mgz --o $SUBJECTS_DIR/`cat ./${subj}/subjectname`/mri/rh.V1.mgz --proj frac 0 1 0.01

#	mri_convert $SUBJECTS_DIR/`cat ./${subj}/subjectname`/mri/rh.V1.mgz $SUBJECTS_DIR/`cat ./${subj}/subjectname`/mri/rh.V1.nii.gz

#	mri_binarize --i ./${subj}/bold/localizer.skip0.rh/left-v-right/t.nii.gz --o ./${subj}/bold/localizer.skip0.rh/left-v-right/t.binary.nii.gz --min 1.25

#	mri_surf2vol --o ./${subj}/bold/localizer.skip0.rh/left-v-right/targ.nii.gz --subject `cat ./${subj}/subjectname` --so  $SUBJECTS_DIR/`cat ./${subj}/subjectname`/surf/rh.white ./${subj}/bold/localizer.skip0.rh/left-v-right/t.binary.nii.gz

#	mri_mask ./${subj}/bold/localizer.skip0.rh/left-v-right/targ.nii.gz $SUBJECTS_DIR/`cat ./${subj}/subjectname`/mri/rh.V1.nii.gz ./${subj}/bold/localizer.skip0.rh/left-v-right/targV1.nii.gz
	
#	mri_vol2vol --mov ./${subj}/bold/localizer.skip0.rh/left-v-right/targV1.nii.gz --targ ${SUBJECTS_DIR}/`cat ./${subj}/subjectname`/mri/rawavg.mgz --regheader --o ./${subj}/bold/localizer.skip0.rh/left-v-right/targV1inBS.nii.gz --no-save-reg
 
#done
	

#	mris_calc -o ./${subj}/bold/localizer.skip0.rh/left-v-right/targV1.nii.gz ./${subj}/bold/localizer.skip0.rh/left-v-right/t.binary.nii.gz masked $SUBJECTS_DIR/`cat ./${subj}/subjectname`/label/rh.V1_exvivo.label 

#mri_mask ./${subj}/bold/localizer.skip0.rh/left-v-right/t.binary.nii.gz $SUBJECTS_DIR/`cat ./${subj}/subjectname`/mri/rh.V1.nii.gz ./${subj}/bold/localizer.skip0.rh/left-v-right/targV1.nii.gz

	#mri_vol2vol --mov ./${subj}/bold/localizer.skip0.rh/left-v-right/targV1.nii.gz --targ ${SUBJECTS_DIR}/`cat ./${subj}/subjectname`/mri/rawavg.mgz --regheader --o ./${subj}/bold/localizer.skip0.rh/left-v-right/targV1inBS.nii.gz --no-save-reg
 

	#mri_vol2surf --mov $SUBJECTS_DIR/`cat ./${subj}/subjectname`/mri/rh.V1.nii.gz --ref T1.mgz --regheader `cat ./${subj}/subjectname` --hemi rh --o $SUBJECTS_DIR/`cat ./${subj}/subjectname`/mri/rh.V1.surf.nii.gz

	#$SUBJECTS_DIR/`cat ./${subj}/subjectname`/mri/rh.V1.surf.nii.gz 


        #mri_binarize --i ./${subj}/bold/localizer.skip4.rh/on-v-off/t.nii.gz --o ./${subj}/bold/localizer.skip4.rh/on-v-off/t.binary.nii.gz --min 1.25
	
	#mris_calc -o ./${subj}/bold/localizer.skip4.rh/on-v-off/sigV1.nii.gz ./${subj}/bold/localizer.skip4.rh/on-v-off/t.binary.nii.gz  masked $SUBJECTS_DIR/`cat ./${subj}/subjectname`/label/rh.V1_exvivo.label
	
		#mri_sur2vol --so ./${subj}/bold/localizer.skip4.rh/on-v-off/sigV1.nii.gz --lta --o  ./${subj}/bold/localizer.skip4.rh/on-v-off/targV1.nii.gz


#mri_vol2surf --mov $SUBJECTS_DIR/`cat ./${subj}/subjectname`/mri/rh.V1.nii.gz --ref T1.mgz --regheader `cat ./${subj}/subjectname` --hemi rh --o $SUBJECTS_DIR/`cat ./${subj}/subjectname`/mri/rh.V1.surf.nii.gz
	
	#$SUBJECTS_DIR/`cat ./${subj}/subjectname`/mri/rh.V1.surf.nii.gz
	
	#mris_calc -o ./${subj}/bold/localizer.skip0.rh/left-v-right/sigV1.nii.gz ./${subj}/bold/localizer.skip0.rh/left-v-right/t.binary.nii.gz masked $SUBJECTS_DIR/`cat ./${subj}/subjectname`/label/rh.V1_exvivo.label 


	#mri_surf2vol --o ./${subj}/bold/localizer.skip0.rh/left-v-right/tV1.nii.gz --subject `cat ./${subj}/subjectname` --so $SUBJECTS_DIR/`cat ./${subj}/subjectname`/surf/rh.inflated ./${subj}/bold/localizer.skip0.rh/left-v-right/t.binary.nii.gz

	 #mris_calc -o ./${subj}/bold/localizer.skip4.rh/on-v-off/targV1s.nii.gz ./${subj}/bold/localizer.skip4.rh/on-v-off/t.binary.nii.gz  masked $SUBJECTS_DIR/`cat ./${subj}/subjectname`/mri/rh.V1.nii.gz
	
	#mri_vol2vol --mov ./${subj}/bold/localizer.skip4.rh/on-v-off/targ.nii.gz --targ ${SUBJECTS_DIR}/`cat ./${subj}/subjectname`/mri/T1.mgz --regheader --o ./${subj}/bold/localizer.skip4.rh/on-v-off/targV1T1.nii.gz

