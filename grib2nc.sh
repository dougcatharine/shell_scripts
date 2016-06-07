#!/bin/bash
#Written by Doug Catharine
#dougcatharine@gmail.com
#Written 150716
#grib2nc.sh will convert .grb2 files to netcdf in parallel.  must have NCL
#installed.  Will automaticly optimize to the number of processors avalable

#feed directory/to/data.here
WORKDIR=/uufs/chpc.utah.edu/common/home/strong-group3/
cd $WORKDIR



NPROC=$(nproc)   #find the number of processors available to work

#function to parallelize iterative processes
#finds the number of processors available, if less than 1 sleep
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


echo "hi $USER!"
for f in *.grb2 ; do
	echo $f ;
	ncl_convert2nc $f &  #need to have ncl available in .bashprofile
  nrwait $NPROC
	#rm $f
done
wait
