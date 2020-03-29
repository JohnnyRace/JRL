#!/bin/bash

#/dev/sda1 - /boot
#/dev/sda2 - /swap
#/dev/sda3 - /root
#/dev/sda4 - /home


# Ставим быстрые репы

> /etc/pacman.d/mirrorlist
cat <<EOF >>/etc/pacman.d/mirrorlist

##
## Arch Linux repository mirrorlist
## Generated on 2020-01-02
##

## Belarus
#Server = http://ftp.byfly.by/pub/archlinux/$repo/os/$arch
#Server = http://mirror.datacenter.by/pub/archlinux/$repo/os/$arch
EOF

# Активируем новые репы
pacman-key --init
pacman-key --populate archlinux
pacman -Sy


#Форматируем в ext 4 наш диск
mkswap /dev/sda2 -L swap
mkfs.ext4 /dev/sda3 -L root
mkfs.ext4 /dev/sda4 -L home
mkfs.fat -F32 /dev/sda1


# Монтируем диск к папке
mount /dev/sda3 /mnt
mkdir /mnt/{boot,home}
mount /dev/sda1 /mnt/boot/
mkdir /mnt/boot/efi
mount /dev/sda4 /mnt/home
swapon /dev/sda2



#Устанавливаем based  и linux ядро + софт который нам нужен сразу
pacstrap -i /mnt base linux linux-firmware nano base-devel grub networkmanager os-prober dialog wpa_supplicant efibootmgr vim bash-completion

#Прописываем fstab
genfstab -pU /mnt >> /mnt/etc/fstab

#Прокидываем правильные быстрые репы внутрь
cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist


# Делаем скрипт пост инстала:
cat <<EOF  >> /mnt/opt/install.sh
#!/bin/bash



echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen 
echo 'Обновим текущую локаль системы'
locale-gen

sleep 1
ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
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

#stemctl start lightdm.service
systemctl enable lightdm.service
sleep 1
echo "password for root user:"
passwd
echo "add new user"
useradd -m -g users -s /bin/bash rocket
echo "paaswd for new user"
passwd rocket



exit


EOF

umount -R /mnt
arch-chroot /mnt /bin/bash  /opt/install.sh

reboot