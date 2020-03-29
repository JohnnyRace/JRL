#!/bin/bash

echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen 
locale-gen
sleep 1
ln -sf /usr/share/zoneinfo/Europe/Minsk /etc/localtime
echo "/dev/sda /    ext4 defaults 0 1" > /etc/fstab
mkinitcpio -P
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub
grub-mkconfig -o /boot/grub/grub.cfg
pacman-key --init
pacman-key --populate archlinux
pacman  -Sy  xorg xorg-server  lightdm-deepin-greeter  
pacman  -Sy  plasma
pacman -Sy plasma-wayland-session.
pacman -Sy kde-applications 
sleep 1
passwd
useradd -m -g users -s /bin/bash rocket
passwd rocket
exit