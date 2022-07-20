   Домашнее задание к занятию "3.5. Файловые системы"
   
   1. Узнайте о sparse (разряженных) файлах.

   Ответ:   
   
   Разреженные файлы - это файлы, для которых выделяется пространство на диске только для участков с ненулевыми данными.
   Список всех "дыр" хранится в метаданных ФС и используется при операциях с файлами. 
   В результате получается, что разреженный файл занимает меньше места на диске 
   (более эффективное использование дискового пространства)
   
   2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?

   Ответ:

   Не могут, так как жесткие ссылки имеют один и тот же inode (объект, который содержит метаданные файла).
   
   3. Сделайте vagrant destroy на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:

      Vagrant.configure("2") do |config|
      config.vm.box = "bento/ubuntu-20.04"
      config.vm.provider :virtualbox do |vb|
      lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
      lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
      vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
      vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
      vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
      vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
      end
     end

   Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.
   
   Решение:
   
   vagrant@vagrant:$ lsblk
   NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
   loop0                       7:0    0 43.6M  1 loop /snap/snapd/14978
   loop1                       7:1    0 61.9M  1 loop /snap/core20/1328 
   loop2                       7:2    0 67.2M  1 loop /snap/lxd/21835
   sda                         8:0    0   64G  0 disk
   ├─sda1                      8:1    0    1M  0 part
   ├─sda2                      8:2    0  1.5G  0 part /boot
   └─sda3                      8:3    0 62.5G  0 part
     └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm  /
   sdb                         8:16   0  2.5G  0 disk
   sdc                         8:32   0  2.5G  0 disk
   

   4. Используя fdisk, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.

   Решение:
           vagrant@vagrant:$ sudo fdisk /dev/sdb
           Welcome to fdisk (util-linux 2.34).
           Changes will remain in memory only, until you decide to write them.
           Be careful before using the write command.

           Device does not contain a recognized partition table.
           Created a new DOS disklabel with disk identifier 0x65b17220.

           Command (m for help): n
           Partition type
           p   primary (0 primary, 0 extended, 4 free)
           e   extended (container for logical partitions)
           Select (default p): p
           Partition number (1-4, default 1): 1
           First sector (2048-5242879, default 2048):
           Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-5242879, default 5242879): +2g

           Created a new partition 1 of type 'Linux' and of size 2 GiB.

           Command (m for help): n
           Partition type
           p   primary (1 primary, 0 extended, 3 free)
           e   extended (container for logical partitions)
           Select (default p): p
           Partition number (2-4, default 2):
           First sector (4196352-5242879, default 4196352):
           Last sector, +/-sectors or +/-size{K,M,G,T,P} (4196352-5242879, default 5242879):

           Created a new partition 2 of type 'Linux' and of size 511 MiB.

           Command (m for help): w
           The partition table has been altered.
           Calling ioctl() to re-read partition table.
           Syncing disks.

   vagrant@vagrant:$ lsblk
   NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
   loop0                       7:0    0 61.9M  1 loop /snap/core20/1328
   loop1                       7:1    0 67.2M  1 loop /snap/lxd/21835
   loop2                       7:2    0 43.6M  1 loop /snap/snapd/14978
   loop3                       7:3    0 61.9M  1 loop /snap/core20/1518
   loop4                       7:4    0   47M  1 loop /snap/snapd/16292
   loop5                       7:5    0 67.8M  1 loop /snap/lxd/22753
   sda                         8:0    0   64G  0 disk
   ├─sda1                      8:1    0    1M  0 part
   ├─sda2                      8:2    0  1.5G  0 part /boot
   └─sda3                      8:3    0 62.5G  0 part
     └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm  /
   sdb                         8:16   0  2.5G  0 disk
   ├─sdb1                      8:17   0    2G  0 part
   └─sdb2                      8:18   0  511M  0 part
   sdc                         8:32   0  2.5G  0 disk

   5. Используя sfdisk, перенесите данную таблицу разделов на второй диск.

   Решение:

   vagrant@vagrant:$ sudo sfdisk -d /dev/sdb | sudo sfdisk /dev/sdc
   Checking that no-one is using this disk right now ... OK

   Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
   Disk model: VBOX HARDDISK
   Units: sectors of 1 * 512 = 512 bytes
   Sector size (logical/physical): 512 bytes / 512 bytes
   I/O size (minimum/optimal): 512 bytes / 512 bytes
  
   >>> Script header accepted.
   >>> Script header accepted.
   >>> Script header accepted.
   >>> Script header accepted.
   >>> Created a new DOS disklabel with disk identifier 0x65b17220.
   /dev/sdc1: Created a new partition 1 of type 'Linux' and of size 2 GiB.
   /dev/sdc2: Created a new partition 2 of type 'Linux' and of size 511 MiB.
   /dev/sdc3: Done.

   New situation:
   Disklabel type: dos
   Disk identifier: 0x65b17220

   Device     Boot   Start     End Sectors  Size Id Type
   /dev/sdc1          2048 4196351 4194304    2G 83 Linux
   /dev/sdc2       4196352 5242879 1046528  511M 83 Linux
   
   The partition table has been altered.
   Calling ioctl() to re-read partition table.
   Syncing disks.
   vagrant@vagrant:$ lsblk
   NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
   loop0                       7:0    0 61.9M  1 loop /snap/core20/1328
   loop1                       7:1    0 67.2M  1 loop /snap/lxd/21835
   loop2                       7:2    0 43.6M  1 loop /snap/snapd/14978
   loop3                       7:3    0 61.9M  1 loop /snap/core20/1518
   loop4                       7:4    0   47M  1 loop /snap/snapd/16292
   loop5                       7:5    0 67.8M  1 loop /snap/lxd/22753
   sda                         8:0    0   64G  0 disk
   ├─sda1                      8:1    0    1M  0 part
   ├─sda2                      8:2    0  1.5G  0 part /boot
   └─sda3                      8:3    0 62.5G  0 part
     └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm  /
   sdb                         8:16   0  2.5G  0 disk
   ├─sdb1                      8:17   0    2G  0 part
   └─sdb2                      8:18   0  511M  0 part
   sdc                         8:32   0  2.5G  0 disk
   ├─sdc1                      8:33   0    2G  0 part
   └─sdc2                      8:34   0  511M  0 part
   
   6. Соберите mdadm RAID1 на паре разделов 2 Гб.
 
   Решение:
   
   vagrant@vagrant:$ sudo mdadm --create /dev/md0 -l 1 -n 2 /dev/sdb1 /dev/sdc1
   mdadm: Note: this array has metadata at the start and
         may not be suitable as a boot device.  If you plan to
         store '/boot' on this device please ensure that
         your boot-loader understands md/v1.x metadata, or use
         --metadata=0.90
   Continue creating array? y
   mdadm: Defaulting to version 1.2 metadata
   mdadm: array /dev/md0 started.
   vagrant@vagrant:$ lsblk
   NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
   loop0                       7:0    0 61.9M  1 loop  /snap/core20/1328
   loop1                       7:1    0 67.2M  1 loop  /snap/lxd/21835
   loop2                       7:2    0 43.6M  1 loop  /snap/snapd/14978
   loop3                       7:3    0 61.9M  1 loop  /snap/core20/1518
   loop4                       7:4    0   47M  1 loop  /snap/snapd/16292
   loop5                       7:5    0 67.8M  1 loop  /snap/lxd/22753
   sda                         8:0    0   64G  0 disk
   ├─sda1                      8:1    0    1M  0 part
   ├─sda2                      8:2    0  1.5G  0 part  /boot
   └─sda3                      8:3    0 62.5G  0 part
     └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm   /
   sdb                         8:16   0  2.5G  0 disk
   ├─sdb1                      8:17   0    2G  0 part
   │ └─md0                     9:0    0    2G  0 raid1
   └─sdb2                      8:18   0  511M  0 part
   sdc                         8:32   0  2.5G  0 disk
   ├─sdc1                      8:33   0    2G  0 part
   │ └─md0                     9:0    0    2G  0 raid1
   └─sdc2                      8:34   0  511M  0 part
   
   7. Соберите mdadm RAID0 на второй паре маленьких разделов.

   Решение:

   vagrant@vagrant:$ sudo mdadm --create /dev/md1 -l 0 -n 2 /dev/sdb2 /dev/sdc2
   mdadm: Defaulting to version 1.2 metadata
   mdadm: array /dev/md1 started.
   vagrant@vagrant:$ lsblk
   NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
   loop0                       7:0    0 61.9M  1 loop  /snap/core20/1328
   loop1                       7:1    0 67.2M  1 loop  /snap/lxd/21835
   loop2                       7:2    0 43.6M  1 loop  /snap/snapd/14978
   loop3                       7:3    0 61.9M  1 loop  /snap/core20/1518
   loop4                       7:4    0   47M  1 loop  /snap/snapd/16292
   loop5                       7:5    0 67.8M  1 loop  /snap/lxd/22753
   sda                         8:0    0   64G  0 disk
   ├─sda1                      8:1    0    1M  0 part
   ├─sda2                      8:2    0  1.5G  0 part  /boot
   └─sda3                      8:3    0 62.5G  0 part
     └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm   /
   sdb                         8:16   0  2.5G  0 disk
   ├─sdb1                      8:17   0    2G  0 part
   │ └─md0                     9:0    0    2G  0 raid1
   └─sdb2                      8:18   0  511M  0 part
     └─md1                     9:1    0 1018M  0 raid0
   sdc                         8:32   0  2.5G  0 disk
   ├─sdc1                      8:33   0    2G  0 part
   │ └─md0                     9:0    0    2G  0 raid1
   └─sdc2                      8:34   0  511M  0 part
     └─md1                     9:1    0 1018M  0 raid0

   8. Создайте 2 независимых PV на получившихся md-устройствах.

   Решение:

   vagrant@vagrant:$ sudo pvcreate /dev/md1 /dev/md0
   Physical volume "/dev/md1" successfully created.
   Physical volume "/dev/md0" successfully created.

   vagrant@vagrant:$ sudo pvscan
   PV /dev/sda3   VG ubuntu-vg       lvm2 [<62.50 GiB / 31.25 GiB free]
   PV /dev/md0                       lvm2 [<2.00 GiB]
   PV /dev/md1                       lvm2 [1018.00 MiB]
   Total: 3 [<65.49 GiB] / in use: 1 [<62.50 GiB] / in no VG: 2 [2.99 GiB]

   9. Создайте общую volume-group на этих двух PV.

   Решение:

   vagrant@vagrant:$ sudo vgcreate volume-group1 /dev/md0 /dev/md1
   Volume group "volume-group1" successfully created
   vagrant@vagrant:$ sudo vgscan
   Found volume group "ubuntu-vg" using metadata type lvm2
   Found volume group "volume-group1" using metadata type lvm2
   
   10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.
   
   Решение:

   vagrant@vagrant:$ sudo lvcreate -L 100M -n lv1 volume-group1 /dev/md1
   Logical volume "lv1" created.
   
   11. Создайте mkfs.ext4 ФС на получившемся LV.

   Решение:

   vagrant@vagrant:$ sudo mkfs.ext4 /dev/volume-group1/lv1
   mke2fs 1.45.5 (07-Jan-2020)
   Creating filesystem with 25600 4k blocks and 25600 inodes

   Allocating group tables: done
   Writing inode tables: done
   Creating journal (1024 blocks): done
   Writing superblocks and filesystem accounting information: done
   
   12. Смонтируйте этот раздел в любую директорию, например, /tmp/new.

   Решение:   

   vagrant@vagrant:$ mkdir /tmp/new
   vagrant@vagrant:$ sudo mount /dev/volume-group1/lv1 /tmp/new 

   13. Поместите туда тестовый файл, например wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz.

   Решение:

   vagrant@vagrant:~$ sudo wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
   --2022-07-20 13:55:04--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
   Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
   Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
   HTTP request sent, awaiting response... 200 OK
   Length: 23835339 (23M) [application/octet-stream]
   Saving to: ‘/tmp/new/test.gz’
   
   /tmp/new/test.gz                                            100%[==================================================
   ======================================================================================>]  22.73M  1.26MB/s    in 18s
   
   2022-07-20 13:55:31 (1.24 MB/s) - ‘/tmp/new/test.gz’ saved [23835339/23835339]
   
   14. Прикрепите вывод lsblk.

   Решение:
  
   vagrant@vagrant:$ lsblk
   NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
   loop0                       7:0    0 61.9M  1 loop  /snap/core20/1328
   loop1                       7:1    0 67.2M  1 loop  /snap/lxd/21835
   loop2                       7:2    0 43.6M  1 loop  /snap/snapd/14978
   loop3                       7:3    0 61.9M  1 loop  /snap/core20/1518
   loop4                       7:4    0   47M  1 loop  /snap/snapd/16292
   loop5                       7:5    0 67.8M  1 loop  /snap/lxd/22753
   sda                         8:0    0   64G  0 disk
   ─sda1                      8:1    0    1M  0 part
   ├─sda2                      8:2    0  1.5G  0 part  /boot
   └─sda3                      8:3    0 62.5G  0 part
     └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm   /
   sdb                         8:16   0  2.5G  0 disk
   ├─sdb1                      8:17   0    2G  0 part
   │ └─md0                     9:0    0    2G  0 raid1
   └─sdb2                      8:18   0  511M  0 part
     └─md1                     9:1    0 1018M  0 raid0
     └─volume-group1-lv1     253:1    0  100M  0 lvm   /tmp/new
   sdc                         8:32   0  2.5G  0 disk
   ├─sdc1                      8:33   0    2G  0 part
   │ └─md0                     9:0    0    2G  0 raid1
   └─sdc2                      8:34   0  511M  0 part
     └─md1                     9:1    0 1018M  0 raid0
       └─volume-group1-lv1     253:1    0  100M  0 lvm   /tmp/new
   
   15. Протестируйте целостность файла:

   Решение:
 
   vagrant@vagrant:$ sudo -i
   root@vagrant:~# gzip -t /tmp/new/test.gz
   root@vagrant:~# echo $?
   0

   16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.

   Решение:

   vagrant@vagrant:$ sudo pvmove /dev/md1 /dev/md0
   /dev/md1: Moved: 8.00%
   /dev/md1: Moved: 100.00%

   17. Сделайте --fail на устройство в вашем RAID1 md.

   Решение:

   vagrant@vagrant:$ sudo mdadm /dev/md0 -f /dev/sdc1
   mdadm: set /dev/sdc1 faulty in /dev/md0
    
   18. Подтвердите выводом dmesg, что RAID1 работает в деградированном состоянии.

   Решение:

   vagrant@vagrant:$ dmesg |grep md/raid
   [ 2342.609688] md/raid1:md0: not clean -- starting background reconstruction
   [ 2342.609689] md/raid1:md0: active with 2 out of 2 mirrors
   [ 5898.580893] md/raid1:md0: Disk failure on sdc1, disabling device.
                  md/raid1:md0: Operation continuing on 1 devices.

   19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:

   Решение:

   vagrant@vagrant:~$ sudo -i
   root@vagrant:~# gzip -t /tmp/new/test.gz && echo $?
   0

   20. Погасите тестовый хост, vagrant destroy.

   Решение:

   vagrant@vagrant:$ logout
   Connection to 127.0.0.1 closed.
   PS D:\Vagrant\Test3> vagrant destroy
       default: Are you sure you want to destroy the 'default' VM? [y/N] y
   ==> default: Forcing shutdown of VM...
   ==> default: Destroying VM and associated drives...

       