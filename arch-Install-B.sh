#!/bin/bash

# Prompts and Variables
read -p "Enter your timezone (e.g., America/New_York): " TIMEZONE
read -p "Enter locale (default en_US.UTF-8): " LOCALE
read -p "Enter keymap (default us): " KEYMAP
read -sp "Enter root password: " ROOT_PASS
read -p "Enter username: " USERNAME
read -sp "Enter password for $USERNAME: " USERPASS
LOCALE=${LOCALE:-en_US.UTF-8}
KEYMAP=${KEYMAP:-us}
HOSTNAME=$(cat /sys/class/dmi/id/product_name | tr '[:upper:] ' '[:lower:]-')

ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime;hwclock --systohc;sed -i "s/^#\(${LOCALE} UTF-8\)/\1/" /etc/locale.gen;locale-gen;echo "LANG=$LOCALE" > /etc/locale.conf;echo "KEYMAP=$KEYMAP" > /etc/vconsole.conf;echo $HOSTNAME > /etc/hostname;mkinitcpio -P;echo "root:$ROOT_PASS" | chpasswd;pacman -S grub efibootmgr networkmanager doas --noconfirm;grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB;grub-mkconfig -o /boot/grub/grub.cfg;systemctl enable NetworkManager;useradd -m -G wheel -s /bin/bash $USERNAME;echo "$USERNAME:$USERPASS" | chpasswd;echo "permit persist :wheel" > /etc/doas.conf;chown root:root /etc/doas.conf;chmod 0400 /etc/doas.conf
