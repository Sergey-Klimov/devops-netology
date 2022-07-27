
    Домашнее задание к занятию "3.9. Элементы безопасности информационных систем"

   1. Установите Bitwarden плагин для браузера. Зарегестрируйтесь и сохраните несколько паролей.

      Установил плагин на Google Chrome. Сохранил несколько паролей.

   2. Установите Google authenticator на мобильный телефон. Настройте вход в Bitwarden аккаунт через Google
      authenticator OTP.

      Установил Google authenticator на мобильный телефон. Настроил вход в Bitwarden аккаунт через Google
      authenticator OTP.

   3. Установите apache2, сгенерируйте самоподписанный сертификат, настройте тестовый сайт для работы по HTTPS.

      Решение:

   vagrant@vagrant:$ sudo apt update
   vagrant@vagrant:$ sudo apt install apache2
   vagrant@vagrant:$ sudo systemctl status apache2
   ● apache2.service - The Apache HTTP Server
     Loaded: loaded (/lib/systemd/system/apache2.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2022-07-26 16:34:50 UTC; 8min ago
       Docs: https://httpd.apache.org/docs/2.4/
   Main PID: 2446 (apache2)
      Tasks: 55 (limit: 2274)
     Memory: 5.2M
     CGroup: /system.slice/apache2.service
             ├─2446 /usr/sbin/apache2 -k start
             ├─2449 /usr/sbin/apache2 -k start
             └─2450 /usr/sbin/apache2 -k start

   Jul 26 16:34:50 vagrant systemd[1]: Starting The Apache HTTP Server...
   Jul 26 16:34:50 vagrant apachectl[2445]: AH00558: apache2: Could not reliably determine the server's fully
   qualified domain name, using 127.0.1.1. Set the 'ServerName' directive globally to suppress this message
   Jul 26 16:34:50 vagrant systemd[1]: Started The Apache HTTP Server.
   
   vagrant@vagrant:$ sudo a2enmod ssl
   Considering dependency setenvif for ssl:
   Module setenvif already enabled
   Considering dependency mime for ssl:
   Module mime already enabled
   Considering dependency socache_shmcb for ssl:
   Enabling module socache_shmcb.
   Enabling module ssl.
   See /usr/share/doc/apache2/README.Debian.gz on how to configure SSL and create self-signed certificates.
   To activate the new configuration, you need to run:
   systemctl restart apache2
   
   vagrant@vagrant:$ sudo systemctl restart apache2
   vagrant@vagrant:$ sudo openssl req -x509 -nodes -days 365 \ -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key \
   -out /etc/ssl/certs/apache-selfsigned.crt
   Generating a RSA private key
   ...............................................................................+++++
   ..................................................................+++++
   writing new private key to '/etc/ssl/private/apache-selfsigned.key'
   -----
   You are about to be asked to enter information that will be incorporated
   into your certificate request.
   What you are about to enter is what is called a Distinguished Name or a DN.
   There are quite a few fields but you can leave some blank
   For some fields there will be a default value,
   If you enter '.', the field will be left blank.
   -----
   Country Name (2 letter code) [AU]:ru
   State or Province Name (full name) [Some-State]:Task3.9
   Locality Name (eg, city) []:
   Organization Name (eg, company) [Internet Widgits Pty Ltd]:Netologi  
   Organizational Unit Name (eg, section) []:
   Common Name (e.g. server FQDN or YOUR name) []:10.0.2.2
   Email Address []:task3.9@google.com

   vagrant@vagrant:$ sudo nano /etc/apache2/sites-available/10.0.2.2.conf
   
   <VirtualHost *:443>
   ServerName 10.5.5.5
   DocumentRoot /var/www/10.5.5.5

   SSLEngine on
   SSLCertificateFile /etc/ssl/certs/apache-selfsigned.crt
   SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key
   </VirtualHost>
   
   vagrant@vagrant:$ sudo mkdir /var/www/10.0.2.2
   vagrant@vagrant:$ sudo nano /var/www/10.0.2.2/index.html
   vagrant@vagrant:$ sudo a2ensite 10.0.2.2.conf
   Enabling site 10.0.2.2.
   To activate the new configuration, you need to run:
   systemctl reload apache2
   vagrant@vagrant:$ sudo a2ensite 10.0.2.2.conf
   Site 10.0.2.2 already enabled
   
   Из другой VM:
   
   vagrant@vagrant:$ ping 10.0.2.2
   PING 10.0.2.2 (10.0.2.2) 56(84) bytes of data.
   64 bytes from 10.0.2.2: icmp_seq=1 ttl=64 time=0.294 ms
   64 bytes from 10.0.2.2: icmp_seq=2 ttl=64 time=0.658 ms
   64 bytes from 10.0.2.2: icmp_seq=3 ttl=64 time=0.650 ms
   64 bytes from 10.0.2.2: icmp_seq=4 ttl=64 time=0.932 ms
   
   vagrant@vagrant:$ curl --insecure -v https://10.0.2.2
   * Trying 10.0.2.2:443...
   * Connected to 10.0.2.2 (10.0.2.2) port 443 (#0)
   * ALPN, offering h2
   * ALPN, offering http/1.1
   * successfully set certificate verify locations:
   * CAfile: /etc/ssl/certs/ca-certificates.crt
   * CApath: /etc/ssl/certs
   * TLSv1.3 (OUT), TLS handshake, Client hello (1):
   * TLSv1.3 (IN), TLS handshake, Server hello (2):
   * TLSv1.3 (IN), TLS handshake, Encrypted Extensions (8):
   * TLSv1.3 (IN), TLS handshake, Certificate (11):
   * TLSv1.3 (IN), TLS handshake, CERT verify (15):
   * TLSv1.3 (IN), TLS handshake, Finished (20):
   * TLSv1.3 (OUT), TLS change cipher, Change cipher spec (1):
   * TLSv1.3 (OUT), TLS handshake, Finished (20):
   * SSL connection using TLSv1.3 / TLS_AES_256_GCM_SHA384
   * ALPN, server accepted to use http/1.1
   * Server certificate:
   * subject: C=RU; ST=Example; L=Example; O=Example; CN=10.0.2.2; emailAddress=task3.9@google.com
   * start date: Jul 26 14:48:34 2022 GMT
   * expire date: Jul 26 14:48:34 2023 GMT
   * issuer: C=RU; ST=Example; L=Example; O=Example; CN=10.0.2.2; emailAddress=task3.9@google.com
   * SSL certificate verify result: self signed certificate (18), continuing anyway.
    > GET / HTTP/1.1
    > Host: 10.0.2.2
    > User-Agent: curl/7.74.0
    > Accept: */*
    >
   * TLSv1.3 (IN), TLS handshake, Newsession Ticket (4):
   * TLSv1.3 (IN), TLS handshake, Newsession Ticket (4):
   * old SSL session ID is stale, removing
   * Mark bundle as not supporting multiuse
   < HTTP/1.1 200 OK
   < Date: Sat, 26 Jul 2022 15:00:40 GMT
   < Server: Apache/2.4.48 (Ubuntu)
   < Last-Modified: Sat, 26 Jul 2022 14:54:50 GMT
   < ETag: "14-5d6b9bbc20d84"
   < Accept-Ranges: bytes
   < Content-Length: 20
   < Content-Type: text/html
   <
   <h1>Hello Netology</h1>
   * Connection #0 to host 10.0.2.2 left intact

   4. Проверьте на TLS уязвимости произвольный сайт в интернете (кроме сайтов МВД, ФСБ, МинОбр, НацБанк,
      РосКосмос, РосАтом, РосНАНО и любых госкомпаний, объектов КИИ, ВПК ... и тому подобное).

   Решение:

   vagrant@vagrant:$ sudo apt-get install testssl.sh
   vagrant@vagrant:$ testssl -p https://netology.ru/

   No engine or GOST support via engine with your /usr/bin/openssl

   ###########################################################
    testssl       3.0 from https://testssl.sh/

      This program is free software. Distribution and
             modification under GPLv2 permitted.
      USAGE w/o ANY WARRANTY. USE IT AT YOUR OWN RISK!

       Please file bugs @ https://testssl.sh/bugs/

   ###########################################################

   Using "OpenSSL 1.1.1f  31 Mar 2020" [~79 ciphers]
   on vagrant:/usr/bin/openssl
   (built: "May  3 17:49:36 2022", platform: "debian-amd64")


   Start 2022-07-27 14:13:19        -->> 188.114.98.160:443 (netology.ru) <<--

   Further IP addresses:   2a06:98c1:3123:a000::
   rDNS (188.114.98.160):  --
   Service detected:       HTTP


   Testing protocols via sockets except NPN+ALPN

   SSLv2      not offered (OK)
   SSLv3      not offered (OK)
   TLS 1      offered (deprecated)
   TLS 1.1    offered (deprecated)
   TLS 1.2    offered (OK)
   TLS 1.3    offered (OK): final
   NPN/SPDY   not offered
   ALPN/HTTP2 h2, http/1.1 (offered)

   Done 2022-07-27 14:13:30 [  13s] -->> 188.114.98.160:443 (netology.ru) <<--
   
   5. Установите на Ubuntu ssh сервер, сгенерируйте новый приватный ключ. Скопируйте свой публичный ключ на
      другой сервер. Подключитесь к серверу по SSH-ключу.

   Решение:

   vagrant@vagrant:$ systemctl status sshd.service
   ● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/lib/systemd/system/ssh.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2022-07-26 17:11:58 UTC; 21h ago
       Docs: man:sshd(8)
             man:sshd_config(5)
   Main PID: 1123 (sshd)
      Tasks: 1 (limit: 2274)
     Memory: 4.9M
     CGroup: /system.slice/ssh.service
             └─1123 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
   
   vagrant@vagrant:$ ssh-keygen
   Generating public/private rsa key pair.
   Enter file in which to save the key (/home/vagrant/.ssh/id_rsa):
   Enter passphrase (empty for no passphrase):
   Enter same passphrase again:
   Your identification has been saved in /home/vagrant/.ssh/id_rsa
   Your public key has been saved in /home/vagrant/.ssh/id_rsa.pub
   The key fingerprint is:
   SHA256:NesFJGOFEB/DjO5WZlSJeV5GhXzr9r+TX4iD8O17sFs vagrant@vagrant
   The key's randomart image is:
   +---[RSA 3072]----+
   |      o***++.o.  |
   |      .oB*o = .  |
   |     . ..o+o . . |
   |      . +..+  .  |
   |     . +S . ..   |
   |      o  + +..o. |
   |     .    + ++E.o|
   |           ..o.oo|
   |            ++ .B|
   +----[SHA256]-----+
   
   vagrant@vagrant:$ ssh-copy-id vagrant@10.0.2.2

   /usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/vagrant/.ssh/id_rsa.pub"
   The authenticity of host '10.5.5.5 (10.0.2.2)' can't be established.
   ECDSA key fingerprint is SHA256:/rZjeIEeI4GXObGdc6iTj7LjwLh3TA1bwOPXEHLrkaM.
   Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
   /usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
   /usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
   vagrant@10.0.2.2's password:

   Number of key(s) added: 1

   Now try logging into the machine, with:   "ssh 'vagrant@10.0.2.2'"
   and check to make sure that only the key(s) you wanted were added.

   vagrant@vagrant:$ ssh vagrant@10.0.2.2
   Welcome to Ubuntu 21.10 (GNU/Linux 5.13.0-22-generic x86_64)

  * Documentation:  https://help.ubuntu.com
  * Management:     https://landscape.canonical.com
  * Support:        https://ubuntu.com/advantage

  System information as of Sat Jul 26 03:12:03 PM UTC 2022

  System load:  0.0                Processes:             113
  Usage of /:   11.6% of 30.83GB   Users logged in:       1
  Memory usage: 20%                IPv4 address for eth0: 10.0.2.15
  Swap usage:   0%                 IPv4 address for eth1: 10.0.2.2


  This system is built by the Bento project by Chef Software
  More information can be found at https://github.com/chef/bento
  Last login: Sat Jul 26 14:26:12 2022 from 10.0.2.5
  
   6. Переименуйте файлы ключей из задания 5. Настройте файл конфигурации SSH клиента,
      так чтобы вход на удаленный сервер осуществлялся по имени сервера.

   Решение:
   
   vagrant@vagrant:$ mv /home/vagrant/.ssh/id_rsa /home/vagrant/.ssh/linux2_rsa
   vagrant@vagrant:$ touch ~/.ssh/config && chmod 600 ~/.ssh/config
   vagrant@vagrant:$ nano .ssh/config

   Host linux2
     HostName 10.0.2.2
     User vagrant
     IdentityFile ~/.ssh/linux2_rsa
     
   vagrant@vagrant:$ ssh linux2
   Welcome to Ubuntu 21.10 (GNU/Linux 5.13.0-22-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Sat Jul 26 03:21:15 PM UTC 2022

  System load:  0.0                Processes:             113
  Usage of /:   11.6% of 30.83GB   Users logged in:       1
  Memory usage: 20%                IPv4 address for eth0: 10.0.2.15
  Swap usage:   0%                 IPv4 address for eth1: 10.0.2.2


   7. Соберите дамп трафика утилитой tcpdump в формате pcap, 100 пакетов. Откройте файл pcap в Wireshark.

   Решение:

   vagrant@vagrant:$ sudo tcpdump -c 100 -w tcpdump01.pcap -i eth0
   tcpdump: listening on eth0, link-type EN10MB (Ethernet), capture size 262144 bytes
   100 packets captured
   102 packets received by filter
   0 packets dropped by kernel

   PrintSCR приложен в решении ДЗ.

   
