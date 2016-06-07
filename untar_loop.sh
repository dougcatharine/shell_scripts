#!/bin/bash

#where to put files
FROMDIR=/uufs/chpc.utah.edu/common/home/strong-group3/simcity/RUC/TAR
TODIR=/uufs/chpc.utah.edu/common/home/strong-group3/simcity/RUC/TAR/finished

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
printf "\t |                untar_loop.sh                   |\n"
printf "\t |               rev June 7, 2016                 |\n"
printf "\t |                                                |\n"
printf "\t |               by: Doug Catharine               |\n"
printf "\t |                                                |\n"
printf "\t |  This script will untar files using in a  			|\n"
printf "\t |  pseudo parallel fashion.  There is the option |\n"
printf "\t |  to abort before any change is made.           |\n"
printf "\t +------------------------------------------------+$OFF\n\n"


printf "\t Hello $USER!"
printf "\t This resource has $NPROC processors available to untar files.\n"
printf "\t                                     \n"
printf "\t This program will unpack all files to \n"
printf "\t $TODIR\n"
printf "\t Is this where you want to save your files? \n"
printf "\t $YELLOW<y/n>$OFF"; read -n 1 KEYIN

if [[ $KEYIN == "N"  ||  $KEYIN == "n" ]]; then
  printf "\n\n\t OK, I quit and did not do anything.\n\n"
  exit 0
fi

printf "\t This program will unpack the files listed in \n"
printf "\t $FROMDIR\n"
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
  for f in *.tar; do
  	tar -xvf $f  --directory=$TODIR &
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
    for f in *.tar; do
  	   tar -xvf $f  --directory=$TODIR && rm $f &
  	    nrwait $NPROC
      done
      wait
  done
fi
