#!/usr/bin/env bash

subj=$1 # subject name (1st input parameter)
subj_dir=$2 # freesurfer's subjects dir (2nd input parameter)
fx_dir=$3 # directory with Brainder conversion functions (3rd input parameter)

echo "Processing subject: ${subj}"

dir_bem=${subj_dir}/${subj}/bem/watershed
dir_conv=${dir_bem}/conv

if [ ! -d "$dir_conv" ]; then
  mkdir ${dir_conv}
fi

surfs=(brain inner_skull outer_skull outer_skin)

for s in "${surfs[@]}"
do
	surf_ori=${subj}_${s}_surface
	surf_bkup=${dir_conv}/${surf_ori}_bkup

	if [ ! -f "$surf_bkup" ]; then
	  cp ${dir_bem}/${surf_ori} ${surf_bkup} # make backup file if it doesn't exist
	fi

	mris_convert ${surf_bkup} ${dir_conv}/${surf_ori}.asc   # convert to ascii
	${fx_dir}/srf2obj ${dir_conv}/${surf_ori}.asc > ${dir_conv}/${surf_ori}.obj # convert to .obj
done

# -> EDIT IN BLENDER





