#!/bin/sh

VMLINUZ=vmlinuz-*
INITRAMFS=initramfs-*{x86_64,lqx}.img

eval rm -v /boot/efi/EFI/Manjaro/$VMLINUZ /boot/efi/EFI/Manjaro/$INITRAMFS
for f in /boot/$VMLINUZ; do
    cp -v -- "$f" "/boot/efi/EFI/Manjaro/$(basename $f).efi"
done
eval cp -v /boot/$INITRAMFS /boot/efi/EFI/Manjaro/
cp -v /boot/amd-ucode.img /boot/efi/EFI/Manjaro/
