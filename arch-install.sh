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
(echo -e "m"; echo -e "g"; echo -e "m"; echo -e "n"; echo -e "";  echo -e ""; echo -e "+3G"; echo -e "n"; echo -e "2"; echo -e ""; echo -e "+3G"; echo -e "n"; echo -e "3"; echo -e ""; echo -e ""; echo -e "m"; echo -e "t"; echo -e "1"; echo -e "1"; echo -e "t"; echo -e "2"; echo -e "19"; echo -e "m"; echo -e "w") | fdisk /dev/sda
clear
#Format 
mkfs.fat -F32 /dev/sda1
mkswap /dev/sda2
swapon /dev/sda2
mkfs.ext4 /dev/sda3
#Mount 
mount /dev/sda3 /mnt
#Run Pacstrap to install base system for Arch
pacstrap /mnt base linux linux-firmware
#Generate our filesystem table
clear
genfstab -U /mnt >> /mnt/etc/fstab
#Change into the root directory of our new installation
arch-chroot /mnt
#Set timezone
clear
ls /usr/share/zoneinfo/
ls /usr/share/zoneinfo/Australia/
ln -sf /usr/share/zoneinfo/Australia/Brisbane /etc/localtime
#Set hardware clock
clear
hwclock --systohc
#Set Locale
sudo sed -i '/^#.*en_US.UTF8*/s/^# //g' /etc/locale.gen
#Generate Locale
locale-gen
#Set Hostname
echo "9b3a50d8-b652-4807-86ac-86ca7cab7dc1" >> /etc/hostname
clear
#Add Localhost to Hosts Configuration
sudo echo "" >> /etc/hosts
sudo echo "127.0.0.1     localhost" >> /etc/hosts
sudo echo "127.0.1.1     9b3a50d8-b652-4807-86ac-86ca7cab7dc1" >> /etc/hosts
sudo echo "" >> /etc/hosts
sudo echo "# The following lines are desirable for IPv6 capable hosts" >> /etc/hosts
sudo echo "::1     localhost ip6-localhost ip6-loopback" >> /etc/hosts
sudo echo "ff02::1 ip6-allnodes" >> /etc/hosts
sudo echo "ff02::2 ip6-allrouters" >> /etc/hosts
#Create User Account and Set Passwords
clear
sudo echo -e "1\n1" | sudo passwd
#Add a normal user account
useradd -m user
echo -e "lol\nlol" | passwd dt
#Add user to sudo group
clear
usermod -aG wheel,audio,video,optical,storage user
#Install sudo on the system
clear
pacman -S sudo --noconfirm
clear
#Uncomment the Line so that a user of group can execute any command
sudo sed -i '/^#.*%wheel ALL=(ALL:ALL) ALL*/s/^# //g' /etc/sudoers
#Install Grub
clear
pacman -S grub efibootmgr dosfstools os-prober mtools --noconfirm
clear
#Create our EFI directory in our Boot directory
mkdir /boot/EFI
#Mount EFI Partitions
mount /dev/sda1 /boot/EFI
#Run grub install now
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
clear
#Generate a grub configuration file
grub-mkconfig -o /boot/grub/grub.cfg
#Install network manager for Internet after reboot
pacman -S networkmanager vim git net-tools --noconfirm
#Enable network manager to start at boot
systemctl enable NetworkManager
exit
clear
#Unmount Drives
df -h
umount -l /mnt
