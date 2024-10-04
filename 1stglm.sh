#!/usr/bin/env bash


#for sess03-12
mkanalysis-sess -fsd bold -sdf sdf.txt -surface self rh -fwhm 5  \
  -event-related  -paradigm localizer.par -nconditions 1 \
  -spmhrf 0 -TR 2 -refeventdur 12 -nskip 4 -polyfit 2 \
  -analysis localizer.skip4.rh -per-run -force
mkanalysis-sess -fsd bold -sdf sdf.txt -surface self lh -fwhm 5  \
  -event-related  -paradigm localizer.par -nconditions 1 \
  -spmhrf 0 -TR 2 -refeventdur 12 -nskip 4 -polyfit 2 \
  -analysis localizer.skip4.lh -per-run -force
mkanalysis-sess -fsd bold -sdf sdf.txt -mni305 -fwhm 5  \
  -event-related  -paradigm localizer.par -nconditions 1 \
  -spmhrf 0 -TR 2 -refeventdur 12 -nskip 4 -polyfit 2 \
  -analysis localizer.skip4.mni305 -per-run -force


mkcontrast-sess -analysis localizer.skip4.rh -contrast on-v-off -a 1
mkcontrast-sess -analysis localizer.skip4.lh -contrast on-v-off -a 1
mkcontrast-sess -analysis localizer.skip4.mni305 -contrast on-v-off -a 1
selxavg3-sess -sf sessidlist -analysis localizer.skip4.rh 
selxavg3-sess -sf sessidlist -analysis localizer.skip4.lh
selxavg3-sess -sf sessidlist -analysis localizer.skip4.mni305

#mkanalysis-sess -fsd bold -sdf triosdf.txt -surface self rh -fwhm 5  \
 # -event-related  -paradigm localizer.par -nconditions 1 \
  #-spmhrf 0 -TR 2 -refeventdur 12 -nskip 4 -polyfit 2 \
  #-analysis localizer.trioskip4.rh -per-run -force
#mkanalysis-sess -fsd bold -sdf triosdf.txt -surface self lh -fwhm 5  \
 # -event-related  -paradigm localizer.par -nconditions 1 \
  #-spmhrf 0 -TR 2 -refeventdur 12 -nskip 4 -polyfit 2 \
 # -analysis localizer.trioskip4.lh -per-run -force
#mkanalysis-sess -fsd bold -sdf triosdf.txt -mni305 -fwhm 5  \
#  -event-related  -paradigm localizer.par -nconditions 1 \
 # -spmhrf 0 -TR 2 -refeventdur 12 -nskip 4 -polyfit 2 \
 # -analysis localizer.trioskip4.mni305 -per-run -force


#mkcontrast-sess -analysis localizer.trioskip4.rh -contrast on-v-off -a 1
#mkcontrast-sess -analysis localizer.trioskip4.lh -contrast on-v-off -a 1
#mkcontrast-sess -analysis localizer.trioskip4.mni305 -contrast on-v-off -a 1
#selxavg3-sess -sf sessidlist -analysis localizer.trioskip4.rh 
#selxavg3-sess -sf sessidlist -analysis localizer.trioskip4.lh
#selxavg3-sess -sf sessidlist -analysis localizer.trioskip4.mni305
