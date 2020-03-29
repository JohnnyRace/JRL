#!/bin/bash

echo 'ПРЕДВАРИТЕЛЬНО НАСТРОЙ wi-fi menu и mirrorlist' 

loadkeys ru
setfont cyr-sun16

timedatectl set-ntp true

echo '/dev/sda1 boot'
echo '/dev/sda2 swap'
echo '/dev/sda3 root'
echo '/dev/sda4 home'
cfdisk
mkswap /dev/sda2 -L swap
mkfs.ext4 /dev/sda3 -L root
mkfs.ext4 /dev/sda4 -L home
mkfs.fat -F32 /dev/sda1

mount /dev/sda3 /mnt
mkdir /mnt/{boot,home}
mount /dev/sda1 /mnt/boot/
mkdir /mnt/boot/efi
mount /dev/sda4 /mnt/home
swapon /dev/sda2

pacstrap -i /mnt base linux linux-firmware nano base-devel grub networkmanager os-prober dialog wpa_supplicant efibootmgr

genfstab -pU /mnt >> /mnt/etc/fstab

arch-chroot /mnt /bin/bash
nano /etc/locale.gen
locale-gen
mkinitcpio -P
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub
grub-mkconfig -o /boot/grub/grub.cfg
passwd
exit
umount -R /mnt