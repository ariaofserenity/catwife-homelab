#!/usr/bin/env bash

# Quick brainless script to deploy my NixOS hosts

DISK="/dev/sda"
BOOT_PARTITON="/dev/sda3"
OS_PARTITION="/dev/sda1"
SWAP="/dev/sda2"

# Create partitions
    parted $DISK -- mklabel gpt
    parted $DISK -- mkpart root ext4 512MB -8GB
    parted $DISK -- mkpart swap linux-swap -8GB 100%
    parted $DISK -- mkpart ESP fat32 1MB 512MB
    parted $DISK -- set 3 esp on

# Format partitions
    mkfs.ext4 -L nixos $OS_PARTITION
    mkswap -L swap $SWAP
    mkfs.fat -F 32 -n boot $BOOT_PARTITON

# Mount devices
    mount /dev/disk/by-label/nixos /mnt
    mkdir -p /mnt/boot
    mount /dev/disk/by-label/boot /mnt/boot
    swapon $SWAP

# Generate config
    nixos-generate-config --root /mnt