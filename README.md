# Termux On ExtSD


## How can I install Termux on ExtSD?

1. Prepare an empty MicroSD

2. Create two partitions on MicroSD

3. Install Termux and keep it stopped

4. Open Magisk and install this module

5. Reboot your device

6. Open Termux to initialize environment


## How to create two partitions on MicroSD?

In this guide, we assumed you will use gdisk and create a GUID partition table.

So, your instructions will be like:

1. Enter gdisk
```
$ gdisk /dev/block/mmcblk1
Disk device is /dev/block/mmcblk1
Partition table scan:
  MBR: not present
  BSD: not present
  APM: not present
  GPT: not present

Creating new GPT entries in memory.
Warning! Unable to generate a proper UUID! Creating an improper one as a last
resort! Windows 7 may crash if you save this partition table!
```

2. Create a GUID partition table
```
Command (? for help): o
This option deletes all partitions and creates a new protective MBR.
Proceed? (Y/N): y
Warning! Unable to generate a proper UUID! Creating an improper one as a last
resort! Windows 7 may crash if you save this partition table!
```

3. Create first Windows partition
```
Command (? for help): n
Partition number (1-128, default 1):
First sector (34-67108830, default = 2048) or {+-}size{KMGTP}:
Last sector (2048-67108830, default = 67108830) or {+-}size{KMGTP}: +8G
Warning! Unable to generate a proper UUID! Creating an improper one as a last
resort! Windows 7 may crash if you save this partition table!
Current type is 8300 (Linux filesystem)
Hex code or GUID (L to show codes, Enter = 8300): 0700
Changed type of partition to 'Microsoft basic data'
```

4. Create second Windows hidden partition
```
Command (? for help): n
Partition number (2-128, default 2):
First sector (34-67108830, default = 16775168) or {+-}size{KMGTP}:
Last sector (16775168-67108830, default = 67108830) or {+-}size{KMGTP}:
Warning! Unable to generate a proper UUID! Creating an improper one as a last
resort! Windows 7 may crash if you save this partition table!
Current type is 8300 (Linux filesystem)
Hex code or GUID (L to show codes, Enter = 8300): 0c01
Changed type of partition to 'Microsoft reserved'
```

5. Quit gdisk
```
Command (? for help): wq

Final checks complete. About to write GPT data. THIS WILL OVERWRITE EXISTING
PARTITIONS!!

Do you want to proceed? (Y/N): y
OK; writing new GUID partition table (GPT) to /dev/block/mmcblk1.
```

6. Format partitions
```
# First partition FAT32 (for most devices)
$ mkfs.fat -F32 /dev/block/mmcblk1p1

# First partition exFAT/FAT64 (for device support exFAT)
$ mkfs.exfat /dev/block/mmcblk1p1

# Second partition
$ mkfs.ext4 -O ^metadata_csum /dev/block/mmcblk1p2
```


## Notes

1. Uninstall Termux will destroy your Termux environment on MicroSD too

2. Disable service log can help to increase MicroSD lifespan

3. When you want remove your MicroSD, you should disable this module first
