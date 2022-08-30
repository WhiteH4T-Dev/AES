#Check Keymap
ls /usr/share/kbd/keymaps/**/*.map.gz
#Check Internet Access
ping google.com -c 4
#Sync your system clock
timedatectl set-ntp true
#Verify
timedatectl status
#Partition Disks
fdisk -l
fdisk /dev/sda
(echo m; echo g; echo m; echo n; echo "";  echo ""; echo +3G; echo n; echo 2; echo ""; echo +3G; echo n; echo 3; echo ""; echo ""; echo m; echo t; echo 1; echo 1; echo t; echo 2; echo 19; echo m; echo w;) | fdisk /dev/sda
clear
