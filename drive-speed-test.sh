#!/bin/bash

# https://github.com/WestleyK/drive-speed-test
# version-5.3
# email: westley@sylabs.io
# date updated: Jun 14, 2018
# desinged and tested on raspberry pi


# on raspberry pi, install bc
# sudo apt-get install bc


#echo
#no_disk_test=$( sudo fdisk -l | grep '^/dev/s' | grep -v '30548031' )
#if [[ -z $no_disk_test ]]; then
#	echo "there is no disk available"
#	echo
#	exit
#fi

echo 
while true; do
	echo
	sudo fdisk -l | grep '^/dev/s' | grep -n '/dev/s'
	echo
	echo "what drive would you like to speed test?"
	read input
	disk_number=$input
	if [[ $disk_number != [1-9] ]]; then
		echo
		exit
	else
		disk_loc=$( sudo fdisk -l |  grep '^/dev/s' | cut -f 1 -d ' ' | grep -n '/dev/s' | grep ^$disk_number | cut -c3- )
		if [[ -z $disk_loc ]]; then
			echo
			echo "wrong input!"
			echo
			sleep 2s
		else
			echo $disk_loc
			echo
			break
		fi
	fi
done


disk_mount=$( df | grep ^$disk_loc | grep 'media/pi$' )
if [[ -z $disk_mount ]]; then
	echo "un-mounting"
	sudo umount $disk_loc
	sleep 0.1s
	echo "re-mounting"
	sudo mount $disk_loc /media/pi -o uid=pi,gid=pi
fi


file_check=$( ls /media/pi/ | grep 'speed_test_file' )
if [[ ! -z $file_check ]]; then
	echo
	echo "you already have the test file in your drive! it should be removed"
	exit
fi

echo "how big do you want your file in Mb?"
read input3
file_size=$input3
echo
echo "this will copy $file_size Mb file to your drive"
echo "think twice before doing!"
echo
echo "do you want to continue?"
echo "[y,n]"
read input2

if [[ $input2 == "y" || $input2 == "Y" ]]; then		
	start=$(date +%s%3N)
	dd if=/dev/zero of=/media/pi/speed_test_file bs=1024 count=0 seek=$[1024*$file_size] &> /dev/null
	last=$(date +%s%3N)
	time=$(echo "scale=4; $last - $start" | bc)
	time2=$(echo "scale=4; $time / 1000" | bc)
	echo
	echo "time = $time2 s"
	mb_s=$(echo "scale=4; $file_size / $time2" | bc)
	echo "write = $mb_s Mb/s"
	echo
	echo
	start=$(date +%s%3N)
	cat /media/pi/speed_test_file > /dev/null
	last=$(date +%s%3N)
	time=$(echo "scale=4; $last - $start" | bc )
	time2=$(echo "scale=4; $time / 1000" | bc)
	echo "time = $time2 s"
	mb_s=$(echo "scale=4; $file_size / $time2" | bc)
	echo "read = $mb_s Mb/s"
	echo
	echo "removing speed_test_file(s)"
	sleep 1s
	rm /media/pi/speed_test_file
	echo "done"
	exit
else
	echo "maybe think 3 times before doing"
	exit
fi



