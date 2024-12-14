#!/bin/sh

VMLINUZ=vmlinuz-*
INITRAMFS=initramfs-*{x86_64,lqx}.img
# Uncomment after all installs using this have EFI partition that fits at least 2 kernels (4 images) worth of initramfs
# INITRAMFS_FALLBACK=initramfs-*{x86_64,lqx}-fallback.img

eval rm -v /boot/efi/EFI/Manjaro/$VMLINUZ /boot/efi/EFI/Manjaro/$INITRAMFS /boot/efi/EFI/Manjaro/$INITRAMFS_FALLBACK
# eval rm -v /boot/efi/EFI/Manjaro/$VMLINUZ /boot/efi/EFI/Manjaro/$INITRAMFS /boot/efi/EFI/Manjaro/$INITRAMFS_FALLBACK
for f in /boot/$VMLINUZ; do
    cp -v -- "$f" "/boot/efi/EFI/Manjaro/$(basename $f).efi"
done
eval cp -v /boot/$INITRAMFS /boot/efi/EFI/Manjaro/
# eval cp -v /boot/$INITRAMFS_FALLBACK /boot/efi/EFI/Manjaro/
cp -v /boot/amd-ucode.img /boot/efi/EFI/Manjaro/
