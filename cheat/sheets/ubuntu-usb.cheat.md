### make bootable usb

1. find out device name of usb (e.g., `/dev/sdh`)

        lsblk

2. write image to usb

        sudo dd if=xubuntu-16.04-desktop-amd64.iso of=<usb-device-path> bs=4M

3. flush file system buffers

        sudo sync
