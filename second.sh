#!/bin/bash

ln -sf /usr/share/zoneinfo/Europe/Minsk /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen 
locale-gen
sleep 1

nano /etc/hostname
#rocket
nano /etc/hosts
#127.0.0.1			localhost
#::1				localhost
#127.0.1.1			rocket.localdomain			rocket
passwd
useradd -mg users -G wheel,storage,power -s /bin/bash rocket
passwd rocket
pacman -S sudo
EDITOR=nano visudo #uncomment %wheel ALL=(ALL) ALL

pacman -S efibootmgr
pacman -S os-prober
os-prober
mkinitcpio -P
pacman -S dosfstools mtools efibootmgr grub
grub-install --target=x86_64-efi --efi-directory=/boot/ --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

pacman-key --init
pacman-key --populate archlinux
pacman -Syu
pacman -Sy xorg xorg-server 
pacman -Sy plasma plasma-desktop kde-applications 
systemctl enable sddm
systemctl enable NetworkManager
pacman -Sy xf86-video-nouveau

