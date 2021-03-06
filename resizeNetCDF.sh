#!/bin/bash

#feed directory/to/data.here
WORKDIR=/uufs/chpc.utah.edu/common/home/strong-group3/simcity/RUC/grib

#number of processors available for psudo parallel function
NPROC=$(nproc)
#min/max lat/lon of general area
# Sample matlab code to find index

# test = 'ruc2_130_20090904_1300_000.nc';
# ncid=netcdf.open(test);
# lon_number = netcdf.inqVarID(ncid,'gridlon_0');
# lon = netcdf.getVar(ncid,lon_number,'double');
# lat_number = netcdf.inqVarID(ncid,'gridlat_0');
# lat = netcdf.getVar(ncid,lat_number,'double');
minimum_lat=38.5;
maximum_lat=42.5;
minimum_lon=-113.5;
maximum_lon=-110.;
# [index indey] = find((lat>=minimum_lat & lat <=maximum_lat)  & (lon>=minimum_lon & lon <=maximum_lon));
# minx_grid = min(index)
# maxx_grid = max(index)
# miny_grid = min(indey)
# maxy_grid = max(indey)

minx=126
maxx=151
miny=162
maxy=198



#must run in interactive mode command "bash filename", or run outside of
#interactive mode with "sbatch filename"

#params = ['TMP_P0_L1_GLC0,',... = surface temp
#'HPBL_P0_L1_GLC0,'... = pbl height
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

params=HPBL_P0_L1_GLC0,TMP_P0_L1_GLC0,POT_P0_L103_GLC0,SPFH_P0_L103_GLC0,TMP_P0_L100_GLC0,RH_P0_L100_GLC0,UGRD_P0_L100_GLC0,UGRD_P0_L103_GLC0,VGRD_P0_L100_GLC0,VGRD_P0_L103_GLC0,PRES_P0_L1_GLC0,HGT_P0_L100_GLC0,HGT_P0_L1_GLC0,lv_ISBL0,gridrot_0,gridlat_0,gridlon_0


################################################################################
###############                  functions                    ##################
################################################################################

# pseudo parallel function
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


################################################################################
###############         Make the user feel important          ##################
################################################################################
# Pretty ANSI text colors
OFF="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"

clear
printf "\n\n\t $YELLOW           "; date ; printf "$OFF"
printf "\n $GREEN"
printf "\t +------------------------------------------------+\n"
printf "\t |                resizeNetCDF.sh                 |\n"
printf "\t |               rev June 10, 2016                |\n"
printf "\t |                                                |\n"
printf "\t |               by: Doug Catharine               |\n"
printf "\t |             dougcatharine@gmail.com            |\n"
printf "\t |                                                |\n"
printf "\t |  This script will remove excess netcdf         |\n"
printf "\t |  domain in a pseudo parallel fashion.          |\n"
printf "\t |  There is the option to abort before any 			|\n"
printf "\t |  change is made.                               |\n"
printf "\t +------------------------------------------------+$OFF\n\n"


printf "\t Hello $USER!\n"
printf "\t This resource has $NPROC processors available to untar files.\n"
printf "\t $RED NCO (http://nco.sourceforge.net/) must be installed! $OFF\n"

printf "\t This program will convert the files listed in \n"
printf "\t $WORKDIR\n"
printf "\t Is this the correct directory? \n"
printf "\t $YELLOW<y/n>$OFF"; read -n 1 KEYIN

if [[ $KEYIN == "N"  ||  $KEYIN == "n" ]]; then
  printf "\n\n\t OK, adjust the script so that the directory is correct.\n\n"
  exit 0
fi

printf "\t This program will reprocess to only include data in\n"
printf "\t latiudes $minimum_lat - $maximum_lat and \n"
printf "\t longitudes $minimum_lon - $maximum_lon \n"
printf "\t Is this correct? \n"
printf "\t $YELLOW<y/n>$OFF"; read -n 1 KEYIN

if [[ $KEYIN == "N"  ||  $KEYIN == "n" ]]; then
  printf "\n\n\t OK, adjust the script so that the params are correct.\n\n"
  exit 0
fi
printf "\t Would you like to delete files after resizing? \n"
printf "\t $YELLOW<y/n>$OFF"; read -n 1 KEYINDELETE



#Warning time
printf "\t Starting program in 10 seconds.  Use ctrl-c to exit \n"
for i in {1..10}
do
  printf "."
  sleep 1
done

#No Delete
if [[ $KEYINDELETE == "N"  ||  $KEYINDELETE == "n" ]]; then
	cd $WORKDIR
	for f in *.nc ; do
	#must have NCO to reduce netcdf
      echo $f && ncks -d xgrid_0,$minx,$maxx -d ygrid_0,$miny,$maxy "$f" "../resized/resize_$f"  &
	    nrwait $NPROC
	done
	wait
else   #Delete
# repeat for failed extracts
  for ii in {1..3}
  do
		cd $WORKDIR
		for f in ruc2_130_2010* ; do
		#must have NCO to reduce netcdf
      echo $f && ncks -d xgrid_0,$minx,$maxx -d ygrid_0,$miny,$maxy "$f" "../resized/resize_$f"  && rm $f &
      nrwait $NPROC
		done
		wait
  done
fi
