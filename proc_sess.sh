#!/usr/bin/env bash

export EXP_DATA_FUNC=/Users/shumin/Desktop/MRI/func
export FSF_OUTPUT_FORMAT=nii.gz

preproc-sess -sf sessidlist -fsd bold -sdf sdf.txt -surface self lhrh -mni305 -fwhm 5 -per-run

