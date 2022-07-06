#!/bin/sh

VMLINUZ=vmlinuz-*
INITRAMFS=initramfs-*{x86_64,lqx}.img

eval rm -v /boot/efi/EFI/ManjaroKernel/$VMLINUZ /boot/efi/EFI/ManjaroKernel/$INITRAMFS
for f in /boot/$VMLINUZ; do
    cp -v -- "$f" "/boot/efi/EFI/ManjaroKernel/$(basename $f).efi"
done
eval cp -v /boot/$INITRAMFS /boot/efi/EFI/ManjaroKernel/
cp -v /boot/amd-ucode.img /boot/efi/EFI/ManjaroKernel/
