#!/bin/bash
disk=$1
lba=$2

if [[ -z $disk || -z $lba ]];
then
    echo 'Usage: calc_bad_blocks.sh /dev/sdX <LBA of first error>'
fi

function get_part_end {

    fdisk -lu $disk|egrep \^$disk|while read partition_line; do
        part_end=`echo $partition_line|sed -r 's/^[^ ]+ +[0-9]+ +([0-9]+) +.*$/\1/'`
        if [[ $lba -lt $part_end ]]; then
            echo $part_end
            break
        fi
    done
}
partition_end=`get_part_end`
partition=`fdisk -lu $disk|grep $partition_end|sed -r 's/^([^ ]+) +.*$/\1/'`
partition_start=`fdisk -lu $disk|grep $partition_end|sed -r 's/^[^ ]+ +([0-9]+) +.*$/\1/'`

if [[ $partition ]]; then
    echo LBA $lba belongs to $partition, which spans from $partition_start to $partition_end
else
    echo "No partition was found. Either you have specified invalid LBA or there is an error in this script"
    exit
fi

block_size=`tune2fs -l $partition|grep 'Block size'|sed -r 's/^.+ +([0-9]+)$/\1/'`

echo $partition block size is $block_size

part_block=`echo "($lba-$partition_start)*512/$block_size"|bc`

echo "Block number(counting from start of $partition): $part_block"
echo "Command for writing zeros to that block:"
echo "dd if=/dev/zero of=$partition bs=$block_size count=1 seek=$part_block"
