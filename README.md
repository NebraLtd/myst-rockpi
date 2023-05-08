# Introduction
The scripts and systemd services in this repository are meant for preparing a stock debian image to include following features:
- automatically update to the latest mysterium package daily.
- get the myst_os_upgrade.sh from github daily and execute it. This is meant for doing os maintenance tasks on the image.

# Installation on Radxa' image.
1. Clone this entire repo
2. execute install.sh
3. remote cloned repo
3. reboot

# Take disk dump from the sd card.
- Here /dev/sdc is the sd card device name. N is the end sector of the last partition on the card. Please replace them appropriately.

  ```sudo dd if=/dev/sdc of=./myst_rock-4b-debian-buster-4.4-sd_card.img bs=512 count=N+1```

- if the source image is gpt type, Radxa's debian buster is GPT. Add space for backup gpt

  ```sudo truncate -s +16896 ./myst_rock-4b-debian-buster-4.4-sd_card.img```

- use gdisk to fix the backup gpt

  ```sudo gdisk ./myst_rock-4b-debian-buster-4.4-sd_card.img```
  use r (entering recovery menu) and e (fix issues) at the prompt

# modifying balena's flashing image
- increase size of disk

  ```qemu-img resize -f raw ./rockpi-4b-rk3399-2.108.25+rev1-v14.4.10.img +3.2G```
- move partiions

   ```
   echo '+3.19G,' | sfdisk --move-data ./rockpi-4b-rk3399-2.108.25+rev1-v14.4.10.img -N 8
   echo '+3.19G,' | sfdisk --move-data ./rockpi-4b-rk3399-2.108.25+rev1-v14.4.10.img -N 7
   echo '+3.19G,' | sfdisk --move-data ./rockpi-4b-rk3399-2.108.25+rev1-v14.4.10.img -N 6
   ```
- resize rootA partition using gparted.
  - find first loop device

    ```losetup -f```
  - use it to mount the image, eg loop47 was output of last command, replace is appropriately

    ```sudo losetup -P /dev/loop47 ./rockpi-4b-rk3399-2.108.25+rev1-v14.4.10.img```
  - use gparted or something like that to resize of the rootA partition into empty space.

    ```sudo gparted /dev/loop47```
- mount rootA and copy the prepared image that we want to be flashed in emmc

  ```cp ./myst_rock-4b-debian-buster-4.4-sd_card.img <flash-rootA mount points>/opt/balena-image-rockpi-4b-rk3399.balenaos-img```
