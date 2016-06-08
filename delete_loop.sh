#!/bin/bash
#Written by Doug Catharine
#dougcatharine@gmail.com
#Written 150716
#delete_loop_grib2nc.sh will systematicly go through and erase all .grb2.
#This prevents erasing of files that may not have been converted.  May be put
#into a master script to clean up periodicly as conversion occurs

#feed directory/to/data.here
WORKDIR=/uufs/chpc.utah.edu/common/home/strong-group3/simcity/for_daniel/grb2

################################################################################
###############                  functions                    ##################
################################################################################

# wildcard
function wildcard() {
printf "\t This program will delete files that match the provided wildcard \n"
printf "\t Please enter the wildcard of the files you would like to keep \n"
printf "\t example '*000.nc'\n"
printf "\t enter wildcard followed by [ENTER]:"; read WILDCARD
printf "\t is $WILDCARD the correct wildcard of the file to save?\n"
printf "\t $YELLOW<y/n>$OFF"; read -n 1 KEYIN
if [[ $KEYIN == "y"  ||  $KEYIN == "Y" ]]; then
	break
else
	wildcard
fi
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
printf "\t |                delete_loop.sh                 |\n"
printf "\t |               rev June 7, 2016                 |\n"
printf "\t |                                                |\n"
printf "\t |               by: Doug Catharine               |\n"
printf "\t |             dougcatharine@gmail.com            |\n"
printf "\t |                                                |\n"
printf "\t |    This script will delete files that have a   |\n"
printf "\t |    duplicate, but alternate file type.  This   |\n"
printf "\t |    script was written to assist with file		  |\n"
printf "\t |    conversion, to prevent the deleting of      |\n"
printf "\t |    uncoverted files.  There is the option to   |\n"
printf "\t |    abort before any change is made.            |\n"
printf "\t +------------------------------------------------+$OFF\n\n"


printf "\t Hello $USER!\n"

printf "\t This program will delete files listed in \n"
printf "\t $WORKDIR\n"
printf "\t Is this the correct directory? \n"
printf "\t $YELLOW<y/n>$OFF"; read -n 1 KEYIN

if [[ $KEYIN == "N"  ||  $KEYIN == "n" ]]; then
  printf "\n\n\t OK, adjust the script so that the directory is correct.\n\n"
  exit 0
fi

wildcard

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
	for f in *.nc ; do
	#must have NCO to reduce netcdf
	    ncks -4 -O -R -v $params "$f" "./mod_$f"  &
	    nrwait $NPROC
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
		for f in *.nc ; do
		#must have NCO to reduce netcdf
		    ncks -4 -O -R -v $params "$f" "./mod_$f"  && rm $f & &
		    nrwait $NPROC
		done
		wait
		for f in *.grb2 ; do
			echo $f ;
			ncl_convert2nc $f && rm $f &  #need to have ncl available in .bashprofile
			nrwait $NPROC
			#rm $f
		done
		wait
  done
fi


echo "hi $USER!"
echo "will start to untar your files in $WORKDIR in 10 seconds"
echo " ."  #provide a chance to cancel file
sleep 3
echo " .."
sleep 3
echo " ..."
sleep 3
for f in *000.nc; do
	X="${f/000.nc}000.grb2"; #find .nc files that have .grb2
	rm $X #delete converted file
done
