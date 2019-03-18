#!/usr/bin/env bash

subj=$1 # subject name (1st input parameter)
subj_dir=$2 # freesurfer's subjects dir (2nd input parameter)
fx_dir=$3 # directory with Brainder conversion functions (3rd input parameter)

echo "Processing subject: ${subj}"

dir_bem=${subj_dir}/${subj}/bem
dir_surf=${subj_dir}/${subj}/surf
dir_conv=${subj_dir}/${subj}/conv

if [ ! -d "$dir_conv" ]; then
  mkdir ${dir_conv}
fi

surfs=(brain inner_skull outer_skull outer_skin)
seg_surfs=(seghead)
hemis=(lh rh)


for s in "${surfs[@]}"
do
        if [ -f "${dir_bem}/watershed/${subj}_${s}_surface" ]; then
            dir_ori=watershed
            surf_ori=${subj}_${s}_surface
        elif [ -f "${dir_bem}/flash/${s}.surf" ]; then
            dir_ori=flash
            surf_ori=${s}.surf
        else
            echo "No watershed or flash file found for: ${s} "
            echo "under ${dir_bem}/watershed/${subj}_${s}_surface "
            echo "or ${dir_bem}/flash/${s}.surf" 
            continue
        fi
        surf_bkup=${dir_conv}/${surf_ori}_bkup
	

	if [ ! -f "$surf_bkup" ]; then
	  cp ${dir_bem}/${dir_ori}/${surf_ori} ${surf_bkup} # make backup file if it doesn't exist
	fi

	mris_convert ${surf_bkup} ${dir_conv}/${surf_ori}.asc   # convert to ascii
	${fx_dir}/srf2obj ${dir_conv}/${surf_ori}.asc > ${dir_conv}/${surf_ori}.obj # convert to .obj

done


for hemi in "${hemis[@]}"
do
    for s in "${seg_surfs[@]}"
    do
        if [ -f "${dir_surf}/${hemi}.${s}" ]; then
            surf_ori=${hemi}.${s}
        else
            echo "No surface file found for: ${hemi}.${s} "
            continue
        fi
        surf_bkup=${dir_conv}/${surf_ori}_bkup
    

        if [ ! -f "$surf_bkup" ]; then
          cp ${dir_surf}/${surf_ori} ${surf_bkup} # make backup file if it doesn't exist
        fi

        mris_convert ${surf_bkup} ${dir_conv}/${surf_ori}.asc   # convert to ascii
        ${fx_dir}/srf2obj ${dir_conv}/${surf_ori}.asc > ${dir_conv}/${surf_ori}.obj # convert to .obj
    
    done

done
# -> EDIT IN BLENDER





