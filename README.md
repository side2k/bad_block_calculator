# Bad block calculator

Simple bash script helping to locate bad blocks on the partition


This script's functionality is based on the [Smartmontools instructions](https://www.smartmontools.org/wiki/BadBlockHowto#ext2ext3firstexample) on how to locate bad blocks and reallocate them. After doing several times, required to google that doc each time, I decided to make a simple script which will be easy enough to locate and reuse.

Feel free to use and improve it.

# Usage of the script

Call format is simple:
```bash
./calc_bad_blocks.sh <disk device> <LBA>
```
Now, some explanations.

You can locate LBA of the bad block in the `smartctl` output: 

```
SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed: read failure       80%     24712         529212968
# 2  Short offline       Completed without error       00%     24698         -
# 3  Short offline       Completed: read failure       90%     24698         529343704
# 4  Extended offline    Interrupted (host reset)      90%     24698         -
# 5  Extended offline    Interrupted (host reset)      90%     24698         -
# 6  Short offline       Completed without error       00%     24698         -
```

See this "LBA of first error" column? This is the number we need. 

For example, if your drive is `/dev/sda`, you should run the script as:

```bash
./calc_bad_blocks.sh /dev/sda 529212968
```
