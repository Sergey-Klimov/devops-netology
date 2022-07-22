   Домашнее задание к занятию "3.7. Компьютерные сети, лекция 2"
   
   1. Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и 
      в Windows?

   Ответ:   
   
   Linux - vagrant@vagrant:$ ip -c link
        1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
        link/ether 08:00:27:a2:6b:fd brd ff:ff:ff:ff:ff:ff
   PW (Windows) - PS C:\Windows\System32> Get-NetAdapter

   Name                      InterfaceDescription                    ifIndex Status       MacAddress         LinkSpeed
   ----                      --------------------                    ------- ------       ----------         ---------
   Ethernet 2                Kaspersky Security Data Escort Adapter       18 Not Present  00-FF-DA-CD-97-EB       0 bps
   Ethernet                  Intel(R) 82579LM Gigabit Network Conne…      15 Disconnected F0-92-1C-ED-50-B1       0 bps
   VirtualBox Host-Only Net… VirtualBox Host-Only Ethernet Adapter        54 Up           0A-00-27-00-00-36      1 Gbps
   Ethernet 3                TAP-Windows Adapter V9                       10 Up           00-FF-3A-62-BE-DD    100 Mbps
   Беспроводная сеть         D-Link DWA-125 Wireless N 150 USB Adap…       7 Up           AC-F1-DF-08-1F-05    150 Mbps 

   CMD - ipconfig /all
   
   Cisco - sw#show int status
   
   2. Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в
      Linux для этого?

   Ответ:  
   
   sudo apt install lldpd
   sudo apt install -y snmpd lldpd
   sudo systemctl enable lldpd
   sudoservice lldpd start
   echo "# enable agentx for lldp
   master agentx" >> /etc/snmp/snmpd.conf
   echo 'DAEMON_ARGS="-x -c -s -e"' >> /etc/default/lldpd
   sudo service lldpd restart
   sudo service snmpd restart
    
   vagrant@vagrant:$ lldpctl
   -------------------------------------------------------------------------------
   LLDP neighbors:
   -------------------------------------------------------------------------------
   
   Cisco - sw#show cdp neighbors

   3. Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и
      команды есть в Linux для этого? Приведите пример конфига.

   Ответ:
   
   Для разделения L2 коммутатора на несколько виртуальных сетей используется технология VLAN (Virtual Local Area Network).
   В Linux должен быть установлен модуля 8021q. Если нет, то выполнить команду sudo modprobe 8021q.
   
   vagrant@vagrant:$ sudo modprobe 8021q
   vagrant@vagrant:$ lsmod | grep 8021q
   8021q                  32768  0
   garp                   16384  1 8021q
   mrp                    20480  1 8021q
   
   vagrant@vagrant:$ sudo apt install net-tools
   vagrant@vagrant:$ apt install vlan
   vagrant@vagrant:~$ sudo /sbin/vconfig add eth0 100

   Warning: vconfig is deprecated and might be removed in the future, please migrate to ip(route2) as soon as possible!

   vagrant@vagrant:~$ sudo cat /proc/net/vlan/config
   VLAN Dev name    | VLAN ID
   Name-Type: VLAN_NAME_TYPE_RAW_PLUS_VID_NO_PAD
   eth0.100       | 100  | eth0

   vagrant@vagrant:$ ip a
   1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
   2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:a2:6b:fd brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0
       valid_lft 82133sec preferred_lft 82133sec
    inet6 fe80::a00:27ff:fea2:6bfd/64 scope link
       valid_lft forever preferred_lft forever
   3: eth0.100@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:a2:6b:fd brd ff:ff:ff:ff:ff:ff
    inet 10.3.253.100/24 brd 10.3.253.255 scope global eth0.100
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fea2:6bfd/64 scope link
       valid_lft forever preferred_lft forever

    Что бы настройка VLAN-ов сохранилась после перезагрузки - необходимо отредактировать NetPlan

    vagrant@vagrant:$ sudo nano /etc/netplan/01-netcfg.yaml

    network:
      version: 2
    ethernets:
     eth0:
      dhcp4: true
    vlans:
      eth0.100:
        id: 100
        link: eth0
        addresses: [10.3.253.100/24]
    
    vagrant@vagrant:$ sudo netplan apply

   4. Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите
      пример конфига.
   
   Решение:
   
   В Linux существуют Team и Bonding. Балансировка нагрузки осуществляется в следующих режимах

   0 - balance-rr - (round-robin)
   1 - active-backup
   2 - balance-xor
   3 - broadcast
   4 - 802.3ad - (dynamic link aggregation)
   5 - balance-tlb - (adaptive transmit load balancing)
   6 - balance-alb - (adaptive load balancing)
   
   vagrant@vagrant:$ sudo nano /etc/netplan/01-netcfg.yaml

   network:
     version: 2
   ethernets:
    eth0:
      dhcp4: true
    eth1:
      dhcp4: no
    eth2:
      dhcp4: no
   bonds:
    bond0:
    addresses: [10.3.253.100/24]
    interfaces: [eth1, eth2]
    parameters:
      mode: balance-rr
    
   vagrant@vagrant:$ sudo netplan apply

   vagrant@vagrant:$ ip a show bond0
   5: bond0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 0a:20:6c:5c:14:43 brd ff:ff:ff:ff:ff:ff
    inet 10.3.253.100/24 brd 10.3.253.255 scope global bond0
       valid_lft forever preferred_lft forever
    inet6 fe80::820:6cff:fe5c:1443/64 scope link
       valid_lft forever preferred_lft forever
   
   5. Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите
      несколько примеров /29 подсетей внутри сети 10.10.10.0/24.
   
   Решение: 

   vagrant@vagrant:~$ ipcalc 10.10.10.0/29
   Address:   10.10.10.0           00001010.00001010.00001010.00000 000
   Netmask:   255.255.255.248 = 29 11111111.11111111.11111111.11111 000
   Wildcard:  0.0.0.7              00000000.00000000.00000000.00000 111
   =>
   Network:   10.10.10.0/29        00001010.00001010.00001010.00000 000
   HostMin:   10.10.10.1           00001010.00001010.00001010.00000 001
   HostMax:   10.10.10.6           00001010.00001010.00001010.00000 110
   Broadcast: 10.10.10.7           00001010.00001010.00001010.00000 111
   Hosts/Net: 6                     Class A, Private Internet
   
   В сети с маской /29 всего 8 IP адресов. Из них доступны для устройств - 6. Один адрес используется для сети и еще один для широковещательного запроса.

   Из сети /24 можно получить 32 подсети /29. Например,

   10.10.10.0/29
   10.10.10.8/29
   10.10.10.16/29
   10.10.10.24/29
   10.10.10.32/29
   10.10.10.40/29
   10.10.10.48/29
   10.10.10.56/29
   10.10.10.64/29
   10.10.10.72/29
   10.10.10.80/29
   10.10.10.88/29
   10.10.10.96/29
   
   6. Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12,
      192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета
      максимум 40-50 хостов внутри подсети.

   Решение:  100.64.0.0/26
   
   7. Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить
      только один нужный IP?

   Решение:
   
   Linux/Ubuntu
   ip neighbour show - показать ARP таблицу
   ip neighbour del [ip address] dev [interface] - удалить из ARP таблицы конкретный адрес
   ip neighbour flush all - очищает таблицу ARP

   Windows
   arp -a - показать ARP таблицу
   arp -d * - очистить таблицу ARP
   arp -d [ip address] - удалить из ARP таблицы конкретный адрес
    
   Cisco
   sw# show mac-address-table