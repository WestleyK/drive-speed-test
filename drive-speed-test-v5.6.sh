#!/bin/bash

# https://github.com/WestleyK/drive-speed-test
# version-5.6
# email: westley@sylabs.io
# date updated: Jun 29, 2018
# desinged and tested on raspberry pi

# make sure bc is install bc
# sudo apt-get install bc


echo "https://github.com/WestleyK/drive-speed-test"
echo "Version-5.6"


mount_point=("/media/pi")


if [[ ! -d "$mount_point" ]]; then
	echo
	echo "no mounting point!"
	echo $mount_point
	echo 
	exit
fi

echo
bc_installed=$( dpkg-query -l bc | wc -l )
if [ "$bc_installed" -le "2" ]; then
	echo "errer: bc not installed!"
	echo "sudo apt-get install bc"
	exit
fi

no_disk_test=$( sudo fdisk -l | grep '^/dev/s' )
if [[ -z $no_disk_test ]]; then
	echo "there is no disk available"
	echo
	exit
fi


echo 
while true; do
	echo
	sudo fdisk -l | grep '^/dev/s' | grep -n '/dev/s'
	echo
	echo "What drive would you like to speed test?"
	echo -n "[1-9]:"
	read input
	echo
	disk_number=$input
	if [[ $disk_number != [1-9] ]]; then
		echo
		exit
	else
		disk_loc=$( sudo fdisk -l |  grep '^/dev/s' | cut -f 1 -d ' ' | grep -n '/dev/s' | grep ^$disk_number | cut -c3- )
		if [[ -z $disk_loc ]]; then
			echo
			echo "Wrong input!"
			echo
			sleep 2s
		else
			echo $disk_loc
			echo
			break
		fi
	fi
done


disk_mount=$( df | grep ^$disk_loc | grep $mount_point )
if [[ -z $disk_mount ]]; then
	echo "Un-mounting"
	sudo umount $disk_loc
	sleep 0.1s
	echo "Re-mounting"
	sudo mount $disk_loc $mount_point -o uid=pi,gid=pi
fi


file_check=$( ls $mount_point | grep 'speed_test_file' )
if [[ ! -z $file_check ]]; then
	echo
	echo "You already have the test file in your drive! it should be removed"
	exit
fi

echo "How big do you want your file in Mb?"
read input3
file_size=$input3

if ! [[ "$file_size" =~ ^[0-9]+$ ]]; then
	echo "Stoping! only integers input!"
	echo
	exit
fi

echo
echo "This will copy $file_size Mb file to your drive"
echo "Think twice before doing!"
echo
echo "Are you sure you want to continue?"
echo -n "[Y,n]:"
read input2

if [[ $input2 == "y" || $input2 == "Y" ]]; then	
	echo
	echo "Writing..."
	start=$(date +%s%3N)
	dd if=/dev/zero of=$mount_point/speed_test_file bs=1024 count=0 seek=$[1024*$file_size] &> /dev/null
	last=$(date +%s%3N)
	time=$(echo "scale=4; $last - $start" | bc)
	time2=$(echo "scale=4; $time / 1000" | bc)
	echo
	echo "Time = $time2 s"
	mb_s=$(echo "scale=4; $file_size / $time2" | bc)
	echo "Write = $mb_s Mb/s"
	write=$mb_s
	echo
	echo
	echo "Reading..."
	start=$(date +%s%3N)
	cat $mount_point/speed_test_file > /dev/null
	last=$(date +%s%3N)
	time=$(echo "scale=4; $last - $start" | bc )
	time2=$(echo "scale=4; $time / 1000" | bc)
	echo "Time = $time2 s"
	mb_s=$(echo "scale=4; $file_size / $time2" | bc)
	echo "Read = $mb_s Mb/s"
	echo
	echo "Removing speed_test_file..."
	sleep 0.5s
	rm $mount_point/speed_test_file
	echo "Done"
	echo 
	echo
	echo 
	echo "Your results with $file_size\ Mb file size:"
	echo
	echo "Write speed = $write Mb/s"
	echo "Read speed = $mb_s Mb/s"
	echo
	exit
else
	echo "your loss!"
	exit
fi



