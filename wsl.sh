#!/bin/bash

qemu-system-aarch64 \
    -machine virt \
    -cpu cortex-a53 \
    -m 2G \
    -smp "$(nproc)" \
    -initrd "${HOME}"/hippo-new-qemu/initrd \
    -kernel "${HOME}"/hippo-new-qemu/vmlinuz \
    -serial stdio \
    -append "root=/dev/sda console=ttys0" \
    -netdev user,id=vnet,hostfwd=:127.0.0.1:0-:22 \
    -drive file="${HOME}"/hippo-new-qemu/ubuntu-image.img,if=none,id=drive0,cache=writeback \
    -drive file="${HOME}"/hippo-new-qemu/flash0.img,format=raw,if=pflash \
    -drive file="${HOME}"/hippo-new-qemu/flash1.img,format=raw,if=pflash \
    -device virtio-blk,drive=drive0,bootindex=0