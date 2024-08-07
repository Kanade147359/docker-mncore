#!/bin/bash
/etc/init.d/smbd start
qemu-system-x86_64 -hda /path/to/disk.img -net user,smb=/mnt/share -m 512 &
mount -t cifs -o user=myuser,password=mypassword //localhost/share /mnt/share
/bin/bash
