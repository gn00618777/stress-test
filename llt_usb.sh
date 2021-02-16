#!/bin/bash

write_size=$1
_bs=1048576 #1M

function usage()
{
        echo "./llt_usb.sh <size>"
        echo "size: 1, 2, 3,... 1=1GB, 2=2GB, 3=3GB,..."
        echo "ex: ./llt_usb.sh 1"
}

if [ $# -le 1 ]; then
	usage
	exit 1
fi

if [ $1 -le 0 ]; then
        usage
	exit 1
fi

_count=$(( $1*1024*1024*1024/$_bs ))

df | grep "sd" > usb_stick

while read line
do
	echo "start stress testing $line"
	mkdir -p /tmp/usb_mount
	mount $line /tmp/usb_mount

	dd if=/dev/urandom of=/tmp/usb_mount/write_bin bs=$_bs count=$_count
	sync
	dd if=/tmp/usb_mount/write_bin of=/read_bin bs=$_bs count=$_count
	sync

	cmp /tmp/usb_mount/write_bin read_bin
	if [ $? -ne 0 ]; then
		echo "data is not correct!"
		exit 1
	fi

	rm /tmp/usb_mount/write_bin
	sync
	umount /tmp/usb_mount

done < usb_stick

rm usb_stick
