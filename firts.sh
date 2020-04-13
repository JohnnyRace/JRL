#!/bin/bash

timedatectl set-ntp true
loadkeys ru
ls /sys/firmware/efi/efivars
pacman-key --init
pacman-key --populate archlinux
pacman -Sy
mkswap /dev/sda2 -L swap
mkfs.ext4 /dev/sda3 -L root
mkfs.fat -F32 /dev/sda1
mount /dev/sda3 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
swapon /dev/sda2
pacstrap -i /mnt base linux linux-firmware nano base-devel grub networkmanager os-prober dialog wpa_supplicant efibootmgr vim
genfstab -pU /mnt >> /mnt/etc/fstab
cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist
arch-chroot /mnt
