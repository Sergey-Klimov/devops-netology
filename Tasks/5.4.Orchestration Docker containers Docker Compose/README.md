# Домашнее задание к занятию "5.4. Оркестрация группой Docker контейнеров на примере Docker Compose"

   Задача 1
   
   Создать собственный образ операционной системы с помощью Packer.

   Для получения зачета, вам необходимо предоставить:

   Скриншот страницы, как на слайде из презентации (слайд 37).
   
   Решение:
```
   vagrant@vagrant:~/data$ packer build centos-7-base.json
   yandex: output will be in this color.

   ==> yandex: Creating temporary RSA SSH key for instance...
   ==> yandex: Using as source image: fd88d14a6790do254kj7 (name: "centos-7-v20220620", family: "centos-7")
   ==> yandex: Use provided subnet id e9b69204bf3978jdgt44
   ==> yandex: Creating disk...
   ==> yandex: Creating instance...
   .
   .
   .
   .
   .
   Build 'yandex' finished after 5 minutes 40 seconds.
   
   ==> Wait completed after 5 minutes 40 seconds
         
   ==> Builds finished. The artifacts of successful builds are:
   --> yandex: A disk image was created: centos-7-base (id: fd86c46j5prdok9em4mr) with family name centos
   
   vagrant@vagrant:~/data$ yc compute image list
   +----------------------+---------------+--------+----------------------+--------+
   |          ID          |     NAME      | FAMILY |     PRODUCT IDS      | STATUS |
   +----------------------+---------------+--------+----------------------+--------+
   | fd86c46j5prdok9em4mr | centos-7-base | centos | f2euv1kekdgvc0jrpaet | READY  |
   +----------------------+---------------+--------+----------------------+--------+
   
  
```
   Скриншот страницы: 
   
   https://github.com/Sergey-Klimov/devops-netology/blob/main/Tasks/5.4.%20Orchestration%20Docker%20containers%20Docker%20Compose/5.4%20task%201.png
    

   Задача 2

   Создать вашу первую виртуальную машину в Яндекс.Облаке.

   Для получения зачета, вам необходимо предоставить:

   Скриншот страницы свойств созданной ВМ, как на примере ниже:
   
   Решение. 
   Скриншот страницы:
   
https://github.com/Sergey-Klimov/devops-netology/blob/main/Tasks/5.4.%20Orchestration%20Docker%20containers%20Docker%20Compose/node01.png

   Задача 3

   Создать ваш первый готовый к боевой эксплуатации компонент мониторинга, состоящий из стека микросервисов.

   Для получения зачета, вам необходимо предоставить:

   Скриншот работающего веб-интерфейса Grafana с текущими метриками, как на примере ниже:
   
   Решение.
   
```
vagrant@vagrant:~/data/ansible$ ssh -A centos@51.250.75.216
Enter passphrase for key '/home/vagrant/.ssh/id_rsa':

[centos@node01 ~]$ sudo -i

[root@node01 stack]# docker-compose ps
    Name                  Command                  State                                                   Ports
-------------------------------------------------------------------------------------------------------------------------------------------------------------
alertmanager   /bin/alertmanager --config ...   Up             9093/tcp
caddy          /sbin/tini -- caddy -agree ...   Up             0.0.0.0:3000->3000/tcp, 0.0.0.0:9090->9090/tcp, 0.0.0.0:9091->9091/tcp, 0.0.0.0:9093->9093/tcp
cadvisor       /usr/bin/cadvisor -logtostderr   Up (healthy)   8080/tcp
grafana        /run.sh                          Up             3000/tcp
nodeexporter   /bin/node_exporter --path. ...   Up             9100/tcp
prometheus     /bin/prometheus --config.f ...   Up             9090/tcp
pushgateway    /bin/pushgateway                 Up             9091/tcp

```
Скриншот страницы Grafana:

https://github.com/Sergey-Klimov/devops-netology/blob/main/Tasks/5.4.%20Orchestration%20Docker%20containers%20Docker%20Compose/5.4%20task%203.png