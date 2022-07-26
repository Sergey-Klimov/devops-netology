    Домашнее задание к занятию "3.8. Компьютерные сети, лекция 3"

   1. Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP

     telnet route-views.routeviews.org
     Username: rviews
     show ip route x.x.x.x/32
     show bgp x.x.x.x/32

   Решение:
   Мой IP - 179.43.145.229 
   
   route-views>show ip route 179.43.145.229
   Routing entry for 179.43.128.0/18
   Known via "bgp 6447", distance 20, metric 0
   Tag 3303, type external
   Last update from 217.192.89.50 4w5d ago
   Routing Descriptor Blocks:
   * 217.192.89.50, from 217.192.89.50, 4w5d ago
      Route metric is 0, traffic share count is 1
      AS Hops 3
      Route tag 3303
      MPLS label: none

   route-views>show bgp 179.43.128.0/18
   BGP routing table entry for 179.43.128.0/18, version 2326487854
   Paths: (23 available, best #20, table default)
   Not advertised to any peer
   Refresh Epoch 1
   20912 3303 43440 51852
    212.66.96.126 from 212.66.96.126 (212.66.96.126)
      Origin IGP, localpref 100, valid, external
      Community: 3303:1000 3303:1007 3303:1020 3303:3071 20912:65016 43440:200
      path 7FE16810CDF0 RPKI State not found
      rx pathid: 0, tx pathid: 0
    .
    .
    .
    .
    .
    .
    .
    .

   2. Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.

     Решение:

   vagrant@vagrant:$ sudo ip link add type dummy name dummy0
   vagrant@vagrant:$ sudo ip addr add 192.168.1.150/24 dev dummy0
   vagrant@vagrant:$ sudo ip link set up dev dummy0
   vagrant@vagrant:$ ip a show type dummy
   3: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
       link/ether 72:f4:e0:11:52:ee brd ff:ff:ff:ff:ff:ff
       inet 192.168.1.150/24 scope global dummy0
          valid_lft forever preferred_lft forever
       inet6 fe80::70f4:e0ff:fe11:52ee/64 scope link
          valid_lft forever preferred_lft forever
   vagrant@vagrant:$ sudo ip route add 192.168.40.0/24 via 10.0.2.15 
   vagrant@vagrant:$ ip -br route
   default via 10.0.2.2 dev eth0 proto dhcp src 10.0.2.15 metric 100
   10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15
   10.0.2.2 dev eth0 proto dhcp scope link src 10.0.2.15 metric 100
   192.168.1.0/24 dev dummy0 proto kernel scope link src 192.168.1.150
   192.168.40.0/24 via 10.0.2.15 dev eth0
   192.168.100.0/24 dev eth0 proto kernel scope link src 192.168.100.150

   3. Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты?
      Приведите несколько примеров.

   Решение: Порт 53 - DNS,  Порт 22 - SSH.
   
   vagrant@vagrant:$ sudo ss -ltpn
   State     Recv-Q    Send-Q     Local Address:Port    Peer Address:Port     Process
   LISTEN    0         4096       127.0.0.53%lo:53      0.0.0.0:*           users:(("systemd-resolve",pid=590,fd=13))
   LISTEN    0         128        0.0.0.0:22            0.0.0.0:*           users:(("sshd",pid=664,fd=3))
   LISTEN    0         128        [::]:22               [::]:*              users:(("sshd",pid=664,fd=4))
   
   4. Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты?
 
   Решение: 
   
   vagrant@vagrant:$ sudo ss -lupn
   State     Recv-Q     Send-Q    Local Address:Port    Peer Address:Port       Process
   UNCONN     0          0        127.0.0.53%lo:53       0.0.0.0:*           users:(("systemd-resolve",pid=590,fd=12))
   UNCONN     0          0        10.0.2.15%eth0:68      0.0.0.0:*           users:(("systemd-network",pid=588,fd=19))
   
   5. Используя diagrams.net, создайте L3 диаграмму вашей домашней сети или любой другой сети, с которой вы работали.

      Схема сети приложена к решению ДЗ.