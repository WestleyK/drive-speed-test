#!/bin/bash
# Created by: WestleyK
# Email: westleyk@nym.hush.com
# Url: https://github.com/WestleyK/drive-speed-test
# Last modified date: 2020-06-17
#
# This file is licensed under the terms of
#
# The Clear BSD License
#
# Copyright (c) 2018-2020 WestleyK
# All rights reserved.
#
# This software is licensed under a Clear BSD License.
#

#
# desinged and tested on raspberry pi
#
# make sure you install bc:
#   $ sudo apt-get install bc
#

set -e

VERSION="Version-6.0.0"

default_mount_point="/media/usb"

mount_point=""

if ! command -v bc > /dev/null ; then
  echo "ERROR: bc not installed!"
  echo "  $ sudo apt-get install bc"
  exit 1
fi

check_for_disks() {
  no_disk_test=$( sudo fdisk -l | grep '/dev/s' )
  if [[ -z $no_disk_test ]]; then
    echo "There is no disk available"
    echo
    echo "You can specify a target path using --path /some/path"
    exit 1
  fi
}

DRIVE_LOCATION=""
ask_for_drive() {
  while true; do
    echo
    sudo fdisk -l | grep 'Disk /dev/s' | cut -f 2 -d ' ' | grep -n '/dev/s'
    echo
    echo "What drive would you like to speed test?"
    echo -n "[1-9]: "
    read -n1 input
    echo
    disk_number=$input
    if [[ $disk_number != [1-9] ]]; then
      echo "Invalid number"
      sleep 1s;
    else
      DRIVE_LOCATION=$( sudo fdisk -l |  grep 'Disk /dev/s' | cut -f 2 -d ' ' | cut -f 1 -d ' ' | grep -n '/dev/s' | grep ^$disk_number | cut -c3- | cut -f 1 -d : )
      if [[ -z $DRIVE_LOCATION ]]; then
        echo "Wrong input!"
        sleep 2s
      else
        echo $DRIVE_LOCATION
        break
      fi
    fi
  done
}

remount_drive() {
  disk_loc=$1
  if [[ -z `df | grep ^$disk_loc | grep $default_mount_point` ]]; then
    echo "Un-mounting"
    sudo umount $disk_loc || true # incase its not mounted
    sleep 0.1s
    echo "Re-mounting"
    sudo mount $disk_loc $default_mount_point -o uid=pi,gid=pi
  fi
}

check_for_speed_test_file() {
  if test -f $1/speed_test_file ; then
    echo "You already have the test file in your drive! it should be removed"
    exit 1
  fi
}

FILE_SIZE=0
ask_how_big() {
  echo "How big do you want your file in Mb?"
  read s
  FILE_SIZE=$s

  if ! [[ "$FILE_SIZE" =~ ^[0-9]+$ ]]; then
    echo "Stoping! only integers input!"
    echo
    exit 1
  fi
}

confirm_test() {
  echo "This will copy $2 Mb file onto $1"
  echo "Think twice before doing!"
  echo
  echo "Are you sure you want to continue?"
  echo -n "[Y,n]: "
  read input2

  if [[ $input2 == "y" || $input2 == "Y" ]]; then
    return 0
  fi

  echo "Your loss!"
  exit 1
  return 1
}

test_from_path() {
  mount_point=$1
  file_size=$2

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
  echo "Your results with $file_size Mb file size:"
  echo
  echo "Write speed = $write Mb/s"
  echo "Read speed = $mb_s Mb/s"
  exit 0
}

print_usage() {
  echo "USAGE:"
  echo "  $0"
  exit 0
}

while [[ $# -gt 0 ]]; do
  option="$1"
  case $option in
    -p|--path)
      if [ -z $2 ]; then
        echo "--path flag but no value"
        exit 1
      fi
      mount_point="$2"
      shift
      shift
      ;;
    -s|--size)
      if [ -z $2 ]; then
        echo "--size flag but no value"
        exit 1
      fi
      FILE_SIZE="$2"
      shift
      shift
      ;;
    -h|--help)
      print_usage
      exit 0
      ;;
    *)
      echo "E: unknown argument: ${option}"
      exit 22
      ;;
  esac
done

if [[ -z $mount_point ]]; then
  check_for_disks
  ask_for_drive

  remount_drive $DRIVE_LOCATION

  check_for_speed_test_file $DRIVE_LOCATION

  if [[ $FILE_SIZE -eq 0 ]]; then
    ask_how_big
  fi

  confirm_test $default_mount_point $FILE_SIZE
  test_from_path $default_mount_point $FILE_SIZE
else
  if ! test -d $mount_point ; then
    echo "No mount point: $mount_point"
    exit 1
  fi

   if [[ $FILE_SIZE -eq 0 ]]; then
    ask_how_big
  fi

  confirm_test $mount_point $FILE_SIZE
  test_from_path $mount_point $FILE_SIZE
fi


# vim: tabstop=2 shiftwidth=2 expandtab autoindent softtabstop=0
