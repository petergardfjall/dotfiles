### Install Guest Additions on a Debian box

1. `Devices` > `Insert Guest Additions CD Image ...`

2. install required packages for building kernel modules.

     sudo apt-get install build-essential module-assistant

3. prepare your system for building kernel module

      sudo m-a prepare

4. install guest additions, for example

      sudo sh /media/cdrom0/VBoxLinuxAdditions.run

   note: sometimes you'll need to mound the guest additions image, e.g.:

      sudo mount /dev/sr0 /media/cdrom0

5. now you can, for instance, set up a shared machine folder `seed`
   from the host's `~/dev/git/seed/`. Mount it using

     sudo mkdir -p /mnt/seed
     sudo mount -t vboxsf seed /mnt/seed
