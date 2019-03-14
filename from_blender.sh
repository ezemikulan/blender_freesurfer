#!/usr/bin/env bash

subj=$1 # subject name (1st input parameter)
subj_dir=$2 # freesurfer's subjects dir (2nd input parameter)
fx_dir=$3 # directory with Brainder conversion functions (3rd input parameter)

echo "Processing subject: ${subj}"

dir_bem=${subj_dir}/${subj}/bem
dir_surf=${subj_dir}/${subj}/surf
dir_conv=${subj_dir}/${subj}/conv

surfs=(brain inner_skull outer_skull outer_skin)
seg_surfs=(seghead)
hemis=(lh rh)

for s in "${surfs[@]}"
do
	surf_ori=${subj}_${s}_surface
	surf_edit=${surf_ori}_edit

	if [ -f ${dir_conv}/${surf_edit}.obj ]; then
		echo "Converting file ${surf_edit}"
		${fx_dir}/obj2srf ${dir_conv}/${surf_edit}.obj > ${dir_conv}/${surf_edit}.asc  # convert to ascii
		mris_convert ${dir_conv}/${surf_edit}.asc ${dir_conv}/${surf_edit} # convert to freesurfer surface
		
		# copy the new surface to the watershed folder and rename as the original
		# cp ${dir_conv}/${surf_edit} ${dir_bem}/${surf_ori}
	fi
done

for hemi in "${hemis[@]}"
do
    for s in "${seg_surfs[@]}"
    do
    	surf_edit=${hemi}.${s}.edit

        if [ -f "${dir_surf}/${hemi}.${s}" ]; then
            echo "Converting file ${surf_edit}"
			${fx_dir}/obj2srf ${dir_conv}/${surf_edit}.obj > ${dir_conv}/${surf_edit}.asc  # convert to ascii
			mris_convert ${dir_conv}/${surf_edit}.asc ${dir_conv}/${surf_edit} # convert to freesurfer surface
        fi
    
    done

done



