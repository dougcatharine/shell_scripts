#!/bin/bash


#where to put files temp location
WORKDIR=/uufs/chpc.utah.edu/common/home/strong-group3/simcity/RUC/TAR
#where to put files final location
FINISHED=/uufs/chpc.utah.edu/common/home/strong-group3/simcity/RUC/TAR/finished
#where list of files to get
WORKsheet=/uufs/chpc.utah.edu/common/home/strong-group3/simcity/RUC/RUC_update.txt

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
printf "\t |                file_fetch.sh                   |\n"
printf "\t |               rev June 7, 2016                 |\n"
printf "\t |                                                |\n"
printf "\t |               by: Doug Catharine               |\n"
printf "\t |                                                |\n"
printf "\t |  This script will fetch files using wget in a  |\n"
printf "\t |  pseudo parallel fashion.  There is the option |\n"
printf "\t |  to abort before any change is made.           |\n"
printf "\t +------------------------------------------------+$OFF\n\n"

printf "\t This resource has $NPROC processors available to download files.\n"
printf "\t                                     \n"
printf "\t This program will save all files to \n"
printf "\t $WORKDIR\n"
printf "\t Is this where you want to save your files? \n"
printf "\t $YELLOW<y/n>$OFF"; read -n 1 KEYIN

if [[ $KEYIN == "N"  ||  $KEYIN == "n" ]]; then
  printf "\n\n\t OK, I quit and did not do anything.\n\n"
  exit 0
fi

printf "\t This program will fetch the files listed in \n"
printf "\t $WORKsheet\n"
printf "\t Is this the current list of files? \n"
cat $WORKsheet
printf "\t Is this the current list of files? \n"
printf "\t $YELLOW<y/n>$OFF"; read -n 1 KEYIN

if [[ $KEYIN == "N"  ||  $KEYIN == "n" ]]; then
  printf "\n\n\t OK, I quit and did not do anything.\n\n"
  exit 0
fi


printf "\t Starting program in 10 seconds.  Use ctrl-c to exit \n"
for i in {1..10}
do
  printf "."
  sleep 1
done




################################################################################
###############         Where the real magic happens          ##################
################################################################################


cd $WORKDIR


while read p; do
	wget -nv -m -np -nH --cut-dirs=3 --reject "index.html*" $p &
  #echo $p &
nrwait $NPROC
done < $WORKsheet
wait

printf "\t !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! \n"
sleep 1
printf "\t @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ \n"
sleep 1
printf "\t ################################################################# \n"
sleep 1
printf "\t All Done \n"

################################################################################
###############                   cleanup                     ##################
################################################################################


cd $WORKDIR
#create ddir if doesnt exist
if [ ! -d "$FINISHED" ]; then
  mkdir $FINISHED
fi
mv ./*/*.tar $FINISHED

rmdir HAS0107654*


# # #must run in interactive mode for total efficiency
