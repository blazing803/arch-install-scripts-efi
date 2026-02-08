#!/bin/bash

# Disk selection
read -p "Enter target disk (e.g., /dev/sda): " TARGET_DISK
read -p "Enter root partition (e.g., /dev/sda3): " ROOT_PART
read -p "Enter swap partition (e.g., /dev/sda2): " SWAP_PART
read -p "Enter EFI partition (e.g., /dev/sda1): " EFI_PART
read -p "Enter root partition size (e.g., +20G, leave empty for remaining space): " ROOT_SIZE
read -p "Enter swap size (e.g., +4G): " SWAP_SIZE

timedatectl set-ntp true;printf "g\nn\n1\n\n${ROOT_SIZE}\nt\n1\nn\n2\n\n${SWAP_SIZE}\nt\n2\n19\nn\n3\n\n\nw\n" | fdisk $TARGET_DISK;mkfs.ext4 $ROOT_PART;mkswap $SWAP_PART;mkfs.fat -F 32 $EFI_PART;mount $ROOT_PART /mnt;mount --mkdir $EFI_PART /mnt/boot;swapon $SWAP_PART;pacstrap -K /mnt base linux linux-firmware;genfstab -U /mnt >> /mnt/etc/fstab;arch-chroot /mnt
