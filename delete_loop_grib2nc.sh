#!/bin/bash
#Written by Doug Catharine
#dougcatharine@gmail.com
#Written 150716
#delete_loop_grib2nc.sh will systematicly go through and erase all .grb2.
#This prevents erasing of files that may not have been converted.  May be put
#into a master script to clean up periodicly as conversion occurs

#feed directory/to/data.here
WORKDIR=/uufs/chpc.utah.edu/common/home/strong-group3/simcity/for_daniel/grb2
cd $WORKDIR




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
