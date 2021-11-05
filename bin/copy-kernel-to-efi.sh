#!/bin/sh

for f in /boot/vmlinuz-*; do 
    cp -v -- "$f" "/boot/efi/EFI/ManjaroKernel/$(basename $f).efi"
done
cp -v /boot/initramfs-*.img /boot/efi/EFI/ManjaroKernel/
cp -v /boot/amd-ucode.img /boot/efi/EFI/ManjaroKernel/
