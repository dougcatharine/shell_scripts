#!/bin/bash

#feed directory/to/data.here
WORKDIR=/uufs/chpc.utah.edu/common/home/strong-group3/
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
