#!/bin/bash

#reshapeNetCDF.sh
#Written by Doug Catharine
#dougcatharine@gmail.com
#written 160123



WORKDIR=/uufs/chpc.utah.edu/common/home/strong-group3/simcity/RUC/TAR/data
cd $WORKDIR

NPROC=$(nproc)


function nrwait() {
	local nrwait_my_arg
    if [[ -z $1 ]] ; then
	nrwait_my_arg=2
    else
	nrwait_my_arg=$1
    fi

    while [[ $(jobs -p | wc -l) -ge $nrwait_my_arg ]] ; do
	sleep 0.1;
    done
 }

params=HPBL_P0_L1_GLC0,TMP_P0_L1_GLC0,POT_P0_L103_GLC0,SPFH_P0_L103_GLC0,TMP_P0_L100_GLC0,RH_P0_L100_GLC0,UGRD_P0_L100_GLC0,UGRD_P0_L103_GLC0,VGRD_P0_L100_GLC0,VGRD_P0_L103_GLC0,PRES_P0_L1_GLC0,HGT_P0_L100_GLC0,HGT_P0_L1_GLC0,lv_ISBL0,gridrot_0,gridlat_0,gridlon_0


echo "hi $USER!"
echo "will start to untar your files in $WORKDIR in 10 seconds"
echo " ."  #provide a chance to cancel file
sleep 3
echo " .."
sleep 3
echo " ..."
sleep 3
for f in *.nc ; do
#must have NCO to reduce netcdf
    ncks -4 -O -R -v $params "$f" "../finished/mod_$f"  &
    nrwait $NPROC
done
wait


#must run in interactive mode command "bash filename", or run outside of
#interactive mode with "sbatch filename"

#params = ['TMP_P0_L1_GLC0,',... = surface temp
#'POT_P0_L103_GLC0,'... = potential temp at hight 2[m]
#'SPFH_P0_L103_GLC0,'... = specific humidity at hight 2[m]
#'TMP_P0_L100_GLC0,'... = temp at 37 pressure levels
#'RH_P0_L100_GLC0,'... = rh at 37 pressure levels
#'UGRD_P0_L100_GLC0,'... = u at 37 pressure levels
#'UGRD_P0_L103_GLC0,'... = u 10m wind
#'VGRD_P0_L100_GLC0,'... = v at 37 pressure levels
#'VGRD_P0_L103_GLC0,'... = v 10m wind
#'PRES_P0_L1_GLC0,'...  = surface pressure
#'HGT_P0_L100_GLC0,'... = geopotential height of 37 pressure levels
#'HGT_P0_L1_GLC0,'... = geopotential height of ground
#'lv_ISBL0,'... = pressure levels
#'gridrot_0,'... = grid rotation
#'gridlat_0,'... = grid lat
#'gridlon_0']; % = grid lon
