#!/bin/bash

pacman-key --init
pacman-key --populate archlinux
pacman -Sy
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
pacstrap -i /mnt base linux linux-firmware nano base-devel grub networkmanager os-prober dialog wpa_supplicant efibootmgr vim
genfstab -pU /mnt >> /mnt/etc/fstab
cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist
arch-chroot /mnt /bin/bash
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
umount -R /mnt
reboot