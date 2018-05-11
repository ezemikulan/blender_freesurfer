#!/usr/bin/env bash

subj=$1 # subject name (1st input parameter)
subj_dir=$2 # freesurfer's subjects dir (2nd input parameter)
fx_dir=$3 # directory with Brainder conversion functions (3rd input parameter)

echo "Processing subject: ${subj}"

dir_bem=${subj_dir}/${subj}/bem/watershed
dir_conv=${dir_bem}/conv

surfs=(brain inner_skull outer_skull outer_skin)

for s in "${surfs[@]}"
do
	surf_edit=${subj}_${s}_surface_edit

	if [ -f ${dir_conv}/${surf_edit}.obj ]; then
		echo "Converting file ${surf_edit}"
		${fx_dir}/obj2srf ${dir_conv}/${surf_edit}.obj > ${dir_conv}/${surf_edit}.asc  # convert to ascii
		mris_convert ${dir_conv}/${surf_edit}.asc ${dir_conv}/${surf_edit} # convert to freesurfer surface
	fi
done

# copy the new surface to the watershed folder and rename as the original

