#!/usr/bin/env bash

qemu-system-aarch64  \
    -nographic \
    -machine virt,gic-version=max \
    -m 1500M \
    -cpu max \
    -smp 4 \
    -netdev user,id=vnet,hostfwd=:127.0.0.1:0-:22 \
    -device virtio-net-pci,netdev=vnet \
    -drive file="${HOME}"/hippo-qemu/ubuntu-image.img,if=none,id=drive0,cache=writeback \
    -device virtio-blk,drive=drive0,bootindex=0 \
    -drive file="${HOME}"/hippo-qemu/flash0.img,format=raw,if=pflash \
    -drive file="${HOME}"/hippo-qemu/flash1.img,format=raw,if=pflash \
    -accel tcg,thread=multi
