# Домашнее задание к занятию "3.4. Операционные системы, лекция 2"

1. На лекции мы познакомились с node_exporter. В демонстрации его исполняемый файл запускался в background.
   Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под 
   внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой unit-файл для 
   node_exporter:

     поместите его в автозагрузку,
     предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите,
     например, на systemctl cat cron),
     удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки
     автоматически поднимается.

   Решение:
   
   Создал пользователя для Node Exporter:           sudo useradd --no-create-home --shell /bin/false node_exporter
   Установил владельцем node_exporter пользователя: sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter
   Создал файл node_exporter.service:               sudo nano /etc/systemd/system/node_exporter.service
                                                    
                                                       [Unit]
                                                       Description=Node Exporter
                                                       Wants=network-online.target
                                                       After=network-online.target

                                                       [Service]
                                                       User=node_exporter
                                                       Group=node_exporter 
                                                       Type=simple
                                                       ExecStart=/usr/local/bin/node_exporter

                                                       [Install]
                                                       WantedBy=multi-user.target
      
   Перезагрузил демона:                             sudo systemctl daemon-reload
   Запустил службу node_exporter с помощью команды: sudo systemctl start node_exporter
   Node_exporter запускается после перезагрузки виртуальной машины: 
   systemctl status node_exporter.service
   ● node_exporter.service - Node Exporter
     Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
     Active: active (running) since Sun 2022-07-17 12:37:21 UTC; 36min ago
   Main PID: 620 (node_exporter)
      Tasks: 3 (limit: 2274)
     Memory: 14.0M
     CGroup: /system.slice/node_exporter.service
             └─620 /usr/local/bin/node_exporter

   Jul 17 12:37:22 vagrant node_exporter[620]: ts=2022-07-17T12:37:22.132Z caller=node_exporter.go:115 level=info collector=thermal_zone
   Jul 17 12:37:22 vagrant node_exporter[620]: ts=2022-07-17T12:37:22.132Z caller=node_exporter.go:115 level=info collector=time
   Jul 17 12:37:22 vagrant node_exporter[620]: ts=2022-07-17T12:37:22.132Z caller=node_exporter.go:115 level=info collector=timex
   Jul 17 12:37:22 vagrant node_exporter[620]: ts=2022-07-17T12:37:22.132Z caller=node_exporter.go:115 level=info collector=udp_queues
   Jul 17 12:37:22 vagrant node_exporter[620]: ts=2022-07-17T12:37:22.132Z caller=node_exporter.go:115 level=info collector=uname
   Jul 17 12:37:22 vagrant node_exporter[620]: ts=2022-07-17T12:37:22.132Z caller=node_exporter.go:115 level=info collector=vmstat
   Jul 17 12:37:22 vagrant node_exporter[620]: ts=2022-07-17T12:37:22.132Z caller=node_exporter.go:115 level=info collector=xfs
   Jul 17 12:37:22 vagrant node_exporter[620]: ts=2022-07-17T12:37:22.132Z caller=node_exporter.go:115 level=info collector=zfs
   Jul 17 12:37:22 vagrant node_exporter[620]: ts=2022-07-17T12:37:22.132Z caller=node_exporter.go:199 level=info msg="Listening on" address=:9100
   Jul 17 12:37:22 vagrant node_exporter[620]: ts=2022-07-17T12:37:22.133Z caller=tls_config.go:195 level=info msg="TLS is disabled." http2=false
   
   После перезагрузки меняется Main PID:

  systemctl status node_exporter.service
  ● node_exporter.service - Node Exporter
     Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
     Active: active (running) since Sun 2022-07-17 13:17:06 UTC; 1min 59s ago
   Main PID: 614 (node_exporter)
      Tasks: 3 (limit: 2274)
     Memory: 14.2M
     CGroup: /system.slice/node_exporter.service
             └─614 /usr/local/bin/node_exporter

  Jul 17 13:17:08 vagrant node_exporter[614]: ts=2022-07-17T13:17:07.966Z caller=node_exporter.go:115 level=info collector=thermal_zone
  Jul 17 13:17:08 vagrant node_exporter[614]: ts=2022-07-17T13:17:07.966Z caller=node_exporter.go:115 level=info collector=time
  Jul 17 13:17:08 vagrant node_exporter[614]: ts=2022-07-17T13:17:07.966Z caller=node_exporter.go:115 level=info collector=timex  
  Jul 17 13:17:08 vagrant node_exporter[614]: ts=2022-07-17T13:17:07.966Z caller=node_exporter.go:115 level=info collector=udp_queues
  Jul 17 13:17:08 vagrant node_exporter[614]: ts=2022-07-17T13:17:07.966Z caller=node_exporter.go:115 level=info collector=uname
  Jul 17 13:17:08 vagrant node_exporter[614]: ts=2022-07-17T13:17:07.966Z caller=node_exporter.go:115 level=info collector=vmstat
  Jul 17 13:17:08 vagrant node_exporter[614]: ts=2022-07-17T13:17:07.966Z caller=node_exporter.go:115 level=info collector=xfs
  Jul 17 13:17:08 vagrant node_exporter[614]: ts=2022-07-17T13:17:07.966Z caller=node_exporter.go:115 level=info collector=zfs
  Jul 17 13:17:08 vagrant node_exporter[614]: ts=2022-07-17T13:17:07.966Z caller=node_exporter.go:199 level=info msg="Listening on" address=:9100
  Jul 17 13:17:08 vagrant node_exporter[614]: ts=2022-07-17T13:17:07.970Z caller=tls_config.go:195 level=info msg="TLS is disabled." http2=false

   ps -e |grep node_exporter
   614 ?        00:00:00 node_exporter

  sudo cat /proc/614/environ
  LANG=en_US.UTF-8PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/binHOME=
  /home/node_exporterLOGNAME=node_exporterUSER=node_exporterINVOCATION_ID=1094148200a84c19b6185023992336eaJOURNAL_STREAM=9:22275vagrant@vagrant:~$

2. Ознакомьтесь с опциями node_exporter и выводом /metrics по-умолчанию. Приведите несколько опций, которые вы бы выбрали
   для базового мониторинга хоста по CPU, памяти, диску и сети.
   
   Решение:

                         CPU

   node_cpu_seconds_total{cpu="0",mode="idle"} 3610.83
   node_cpu_seconds_total{cpu="0",mode="iowait"} 2.22
   node_cpu_seconds_total{cpu="0",mode="irq"} 0
   node_cpu_seconds_total{cpu="0",mode="nice"} 0
   node_cpu_seconds_total{cpu="0",mode="softirq"} 0.72
   node_cpu_seconds_total{cpu="0",mode="steal"} 0
   node_cpu_seconds_total{cpu="0",mode="system"} 14.74
   node_cpu_seconds_total{cpu="0",mode="user"} 11.02
   process_cpu_seconds_total 0.12
 
                        Memory
                    
   node_memory_MemAvailable_bytes
   node_memory_MemFree_bytes
   node_memory_Buffers_bytes
   node_memory_Cached_bytes

                        Disk

   node_disk_io_time_seconds_total{device="sda"}
   node_disk_read_time_seconds_total{device="sda"}
   node_disk_write_time_seconds_total{device="sda"}
   node_filesystem_avail_bytes

                        Network

   node_network_info
   node_network_receive_bytes_total
   node_network_receive_errs_total
   node_network_transmit_bytes_total
   node_network_transmit_errs_total

3. Установите в свою виртуальную машину Netdata. Воспользуйтесь готовыми пакетами для установки (sudo apt install -y netdata).
   После успешной установки:

    в конфигурационном файле /etc/netdata/netdata.conf в секции [web] замените значение с localhost на bind to = 0.0.0.0,
    добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте vagrant reload:
    config.vm.network "forwarded_port", guest: 19999, host: 19999
    
    После успешной перезагрузки в браузере на своем ПК (не в виртуальной машине) вы должны суметь зайти на localhost:19999.
    Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые даны к этим метрикам.

    Решение:

   vagrant@vagrant:$ sudo apt install -y netdata
   Reading package lists... Done   
   Building dependency tree
   Reading state information... Done
   netdata is already the newest version (1.19.0-3ubuntu1).
   0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
 
   До редактирования Vagrantfile:

   vagrant@vagrant:$ sudo lsof -i :19999
   COMMAND PID    USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
   netdata 612 netdata    4u  IPv4  24676      0t0  TCP localhost:19999 (LISTEN)
 
   vagrant@vagrant:$ sudo ss -tulpn | grep :19999
   tcp    LISTEN   0        4096            127.0.0.1:19999          0.0.0.0:*      users:(("netdata",pid=612,fd=4))
 
   После редактирования и vagrant reload:

   vagrant@vagrant:$ sudo ss -tulpn | grep :19999
   tcp    LISTEN   0        4096              0.0.0.0:19999          0.0.0.0:*      users:(("netdata",pid=612,fd=4))
   vagrant@vagrant:$ sudo lsof -i :19999
   COMMAND PID    USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
   netdata 612 netdata    4u  IPv4  24305      0t0  TCP *:19999 (LISTEN)
   netdata 612 netdata   39u  IPv4  26438      0t0  TCP vagrant:19999->_gateway:54878 (ESTABLISHED)

   Ссылка на PrintScreen http://localhost:19999/#menu_system;theme=slate приложена в решении ДЗ. 



4. Можно ли по выводу dmesg понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?
   
   Решение:
 
   Да, можно: vagrant@vagrant:$ dmesg | grep -i virtual
              [    0.000000] DMI: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
              [    0.004991] CPU MTRRs all blank - virtualized system.
              [    0.051511] Booting paravirtualized kernel on KVM
              [    5.580018] systemd[1]: Detected virtualization oracle.


5. Как настроен sysctl fs.nr_open на системе по-умолчанию? Узнайте, что означает этот параметр. 
   Какой другой существующий лимит не позволит достичь такого числа (ulimit --help)?

   Решение:

   agrant@vagrant:$ /sbin/sysctl -n fs.nr_open
   1048576 - число дескриптов по-умолчанию
   nr_open - это максимальное число дескрипторов, которые может использовать процесс.

   vagrant@vagrant:~$ ulimit -n
   1024 - этот лимит не даст достичь значения 1048576.

6. Запустите любой долгоживущий процесс (не ls, который отработает мгновенно, а, например, sleep 1h) в отдельном неймспейсе
   процессов; покажите, что ваш процесс работает под PID 1 через nsenter. Для простоты работайте в данном задании 
   под root (sudo -i). Под обычным пользователем требуются дополнительные опции (--map-root-user) и т.д.

   Решение:

   vagrant@vagrant:$ sudo -i
   root@vagrant:# unshare -f --pid --mount-proc sleep 1h
   root@vagrant:# ps -e |grep sleep
   1692 pts/0    00:00:00 sleep
   root@vagrant:~# nsenter --target 1692 --pid --mount
   root@vagrant:/# ps
    PID TTY          TIME CMD
      1 pts/0    00:00:00 sleep
     37 pts/0    00:00:00 bash
     48 pts/0    00:00:00 ps

7. Найдите информацию о том, что такое :(){ :|:& };:. Запустите эту команду в своей виртуальной машине Vagrant
   с Ubuntu 20.04 (это важно, поведение в других ОС не проверялось). Некоторое время все будет "плохо",
   после чего (минуты) – ОС должна стабилизироваться. Вызов dmesg расскажет, какой механизм помог автоматической стабилизации.
   Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?

   Решение:
 
   Выполнил команду: vagrant@vagrant:$ :(){ :|:& };: -  эта функция рекурсивно вызывает себя и передается
   через пайп другому вызову этой же функции. То есть запускаются 2 фоновых процесса, каждый из которых вызывает
   еще два фоновых процесса и тд, пока не закончатся ресурсы. 
   
   Далее выполнил:
   vagrant@vagrant:$ dmesg -S
   .
   .
   .
   [  292.829173] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-1.scope

   Посмотрел значение по-умолчанию: vagrant@vagrant:$ ulimit -u
                                    7581  - Количество возможных одновременно запущенных процессов.

   Далее установил предельное значение для одновременно запущенных процессов:
                                    vagrant@vagrant:$ ulimit -u 1000
                                    vagrant@vagrant:$ ulimit -u
                                    1000

   