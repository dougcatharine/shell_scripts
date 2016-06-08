#!/bin/bash

#feed directory/to/data.here
WORKDIR=/uufs/chpc.utah.edu/common/home/strong-group3/

#number of processors available for psudo parallel function
NPROC=$(nproc)



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
printf "\t |                grib2nc.sh                      |\n"
printf "\t |               rev June 7, 2016                 |\n"
printf "\t |                                                |\n"
printf "\t |               by: Doug Catharine               |\n"
printf "\t |                                                |\n"
printf "\t |  This script will convert grib files to netcdf |\n"
printf "\t |  files in a pseudo parallel fashion.  There is |\n"
printf "\t |  the option to abort before any change is made.|\n"
printf "\t |  made.                                         |\n"
printf "\t +------------------------------------------------+$OFF\n\n"


printf "\t Hello $USER!"
printf "\t This resource has $NPROC processors available to untar files.\n"


printf "\t This program will convert the files listed in \n"
printf "\t $WORKDIR\n"
printf "\t Is this the correct directory? \n"
printf "\t $YELLOW<y/n>$OFF"; read -n 1 KEYIN

if [[ $KEYIN == "N"  ||  $KEYIN == "n" ]]; then
  printf "\n\n\t OK, I quit and did not do anything.\n\n"
  exit 0
fi

printf "\t Would you like to delete files after unpacking? \n"
printf "\t $YELLOW<y/n>$OFF"; read -n 1 KEYINDELETE

if [[ $KEYINDELETE == "N"  ||  $KEYINDELETE == "n" ]]; then
  printf "\t Starting program in 10 seconds.  Use ctrl-c to exit \n"
  for i in {1..10}
  do
    printf "."
    sleep 1
  done
	cd $WORKDIR
	for f in *.grb2 ; do
		echo $f ;
		ncl_convert2nc $f &  #need to have ncl available in .bashprofile
	  nrwait $NPROC
		#rm $f
	done
	wait
else
  printf "\t Starting program in 10 seconds.  Use ctrl-c to exit \n"
  for i in {1..10}
  do
    printf "."
    sleep 1
  done
# repeat for failed extracts
  for ii in {1..3}
  do
		cd $WORKDIR
		for f in *.grb2 ; do
			echo $f ;
			ncl_convert2nc $f && rm $f &  #need to have ncl available in .bashprofile
			nrwait $NPROC
			#rm $f
		done
		wait
  done
fi
