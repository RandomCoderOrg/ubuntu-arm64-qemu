# ubuntu-arm64-qemu
small qemu container with ubuntu 18.04 server minimal rootfs
quick installation script `install.sh` help you install the fs and setup qemu

## Installation
Depends on packages
- `lz4` & `tar` to extraction and decode images
- `git` to clone this code
- `qemu-system-aarch64` to boot image
- `wget` to download files
```bash
apt install lz4 tar git qemu-system-aarch64 wget -y
git clone https://github.com/RandomCoderOrg/ubuntu-arm64-qemu
cd ubuntu-arm64-qemu
bash install.sh
```

## Running/ Boot image
A script `boot.sh` is located in your `${HOME}/hippo-qemu` so just run it with
```bash
bash ${HOME}/hippo-qemu/boot.sh
```

## Login Password
| User | Password |
|-|-|
|hippo|`hippo`

## About images
for now the rootfs is ubuntu version 18.04 is gets updated
`ubuntu-image.img` where ubuntu installed
`flash0.img` & `flash1.img`  are efi images where grub bootloader sits in
and `ubuntu-image.img` is set to `20GB`
</hr>

### manual way to extract image package
to decrease download size i made an archive of multiple stages
- images are packed in lxz compression
- `hippo-arm64` (**folder containing iamges**) is compressed with tar
this compressed ~**1.7GB** to **610mb**

#### to exract manually
1. Download the compressed package
```bash
wget https://github.com/RandomCoderOrg/ubuntu-arm64-qemu/releases/download/test-v01/qemu-ubuntu-18-test.tgz
```
2. extract `.tgz` archive with tar with `x` and `f` attributes
```bash
tar -xf qemu-ubuntu-18-test.tgz
```
3. now change directory to `hippo-qemu` folder with `cd hippo-qemu` then you see 3 files with `.lz` extension to extract them you need to install `lz4` package [ for debian user `apt install lz4 -y` ]
4.  extracting them
 ```bash
 lz4 -d ubutnu-image.img.lz ubuntu-image.img
 lz4 -d flash0.img.lz flash0.img
 lz4 -d flash1.img.lzl flash1.img
 ```
 > Thats it.
 
 </hr>
 
 # ! Additional
 ## Termux 
 for now there is no known way to me to crank the speed but using this in `arm64` host gives better performence than `X86_64` guest.
 > suggest me by creating an issue 
 
 ## KVM users
 if you want to enable kvm add `-enable-kvm` and remove `-accel tcg,thread=single` at  the in `/home/hippo-qemu/boot.sh`
 final script looks like this
 ```bash
 #!/usr/bin/env bash
qemu-system-aarch64 \
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
-enable-kvm
 ```

## WSL users
wsl users may error with tcg so remove last in in `boot.sh` file

final script looks like this
```bash
 #!/usr/bin/env bash
qemu-system-aarch64 \
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
-drive file="${HOME}"/hippo-qemu/flash1.img,format=raw,if=pflash
```
