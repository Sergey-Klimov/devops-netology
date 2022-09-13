# Домашнее задание к занятию "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"

   Задача 1
   
   Сценарий выполения задачи:

   создайте свой репозиторий на https://hub.docker.com;
   выберете любой образ, который содержит веб-сервер Nginx;
   создайте свой fork образа;
   реализуйте функциональность: запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
   <html>
   <head>
   Hey, Netology
   </head>
   <body>
   <h1>I’m DevOps Engineer!</h1>
   </body>
   </html>
   
   Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.

   Решение:
```
   https://hub.docker.com/r/sergeyklimov/repo/tags
```   
   Задача 2

   Посмотрите на сценарий ниже и ответьте на вопрос: "Подходит ли в этом сценарии использование Docker контейнеров
   или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

   Детально опишите и обоснуйте свой выбор.

   --

   Сценарий:

   Высоконагруженное монолитное java веб-приложение;
   Nodejs веб-приложение;
   Мобильное приложение c версиями для Android и iOS;
   Шина данных на базе Apache Kafka;
   Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
   Мониторинг-стек на базе Prometheus и Grafana;
   MongoDB, как основное хранилище данных для java-приложения;
   Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.

Высоконагруженное монолитное java веб-приложение;

```
Зависит от того, может ли приложение масштабироваться и взаимодействовать с каким-нибудь балансировщиком. 
Если архитектура это позволяет - то контейнеры будут удобней виртуальных машин, т.к. они быстрей разворачиваются,
менее требовательны к месту и прочим ресурсам.
Если в приложение не заложено масштабирование, тогда лучше физическая машина, чтобы не тратить лишние ресурсы на
виртуализацию.
```
Nodejs веб-приложение;
```
Докер подойдёт хорошо, т.к. это позволит быстро развернуть приложение со всеми необходимыми библиотеками.
Это могло бы пригодиться, например для автотестов и удобства разработки, чтобы поделиться билдом приложения с коллегами
и запустить его без боли и так далее. 
```
Шина данных на базе Apache Kafka;
```
Да, вполне. Брокеры активно используются в современных распределённых приложениях, доставка приложения через докер на
сервера и разработчикам в тестовую среду должна упростить жизнь.
Ещё очень важно иметь возможность быстро откатиться если приложение обновили, и в продакшене что-то пошло не так. 
Докер будет особенно удобен чтобы "вернуть как было" один из центральных узлов приложения - шину.
```
Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и
две ноды kibana;
```
Docker подойдёт лучше, так как он будет удобней для кластеризации.
```
Мониторинг-стек на базе Prometheus и Grafana;
```
Докер подойдёт для этой задачи хорошо. Разворвачивать node_exporter с Docker скорей всего не стоит, т.к. ему требуется
прямой доступ к метрикам ядра, но Prometheus и Grafana можно использовать в Докере.
```
MongoDB, как основное хранилище данных для java-приложения;
```
Да, вполне подойдёт Docker. У MongoDB даже есть официальный образ на Docker Hub.
```
Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.
```
В общем случае, думаю удобней будет виртуальная машина, т.к. серверу GitLab не требуется масштабирование или деплой 
новой версии несколько раз в день, а виртуальная машина позволит очень удобно делать бекапы и при необходимости 
мигрировать её в кластере.
```

   Задача 3

   Запустите первый контейнер из образа centos c любым тэгом в фоновом режиме, подключив папку /data из текущей рабочей
   директории на хостовой машине в /data контейнера;

   Запустите второй контейнер из образа debian в фоновом режиме, подключив папку /data из текущей рабочей директории
   на хостовой машине в /data контейнера;

   Подключитесь к первому контейнеру с помощью docker exec и создайте текстовый файл любого содержания в /data;
   
   Добавьте еще один файл в папку /data на хостовой машине;

   Подключитесь во второй контейнер и отобразите листинг и содержание файлов в /data контейнера.
   
   Решение:

```
   vagrant@vagrant:~$ docker ps
   CONTAINER ID   IMAGE           COMMAND   CREATED        STATUS        PORTS     NAMES

   vagrant@vagrant:~$ docker run -it --rm -d --name centos-task3 -v $(pwd)/data:/data centos:latest
   354be59e71b2419981b754b4783c11f77b41770a052f0590de88b3e2c10daaf0
   
   vagrant@vagrant:~$ docker run -it --rm -d --name debian-task3 -v $(pwd)/data:/data debian:latest
   e6b778f76d3ebf200b802481c452bc36cc394166129d840baedfee77ba79a7a2
   
   vagrant@vagrant:~$ docker ps
   CONTAINER ID   IMAGE           COMMAND       CREATED          STATUS          PORTS     NAMES
   e6b778f76d3e   debian:latest   "bash"        38 seconds ago   Up 38 seconds             debian-task3
   354be59e71b2   centos:latest   "/bin/bash"   2 minutes ago    Up 2 minutes              centos-task3
   
   vagrant@vagrant:~/data$ docker exec -it centos-task3 bash
   [root@354be59e71b2 /]# echo "Hello world from CentOS Test 1" > /data/centosfile.txt
   [root@354be59e71b2 /]# cat /data/centosfile.txt
   Hello world from CentOS Test 1
   [root@354be59e71b2 /]# exit
   
   vagrant@vagrant:~/data$ ls -l
   total 8
   -rw-r--r-- 1 root    root    31 Sep 13 13:55 centosfile.txt
   vagrant@vagrant:~/data$ cat centosfile.txt
   Hello world from CentOS Test 1
   
   vagrant@vagrant:~/data$ echo "Hellow world from Host! Test 2" > hostfile.txt
   vagrant@vagrant:~/data$ ls -l
   total 12
   -rw-r--r-- 1 root    root    31 Sep 13 13:55 centosfile.txt
   -rw-rw-r-- 1 vagrant vagrant 31 Sep 13 13:57 hostfile.txt
   
   vagrant@vagrant:~/data$ docker exec -it centos-task3 bash
   [root@354be59e71b2 /]# cd data
   [root@354be59e71b2 data]# ls -l
   total 8
   -rw-r--r-- 1 root root 31 Sep 13 13:55 centosfile.txt
   -rw-rw-r-- 1 1000 1000 31 Sep 13 13:57 hostfile.txt
   [root@354be59e71b2 data]# cat hostfile.txt
   Hellow world from Host! Test 2
   
   vagrant@vagrant:~/data$ docker exec -it debian-task3 bash
   root@e6b778f76d3e:/# cd data
   root@e6b778f76d3e:/data# ls -l
   total 8
   -rw-r--r-- 1 root root 31 Sep 13 13:55 centosfile.txt
   -rw-rw-r-- 1 1000 1000 31 Sep 13 13:57 hostfile.txt
   root@e6b778f76d3e:/data# echo "Hellow world from Debian! Test 3" > debianfile.txt
   root@e6b778f76d3e:/data# exit
   
   vagrant@vagrant:~/data$ ls -l
   total 12
   -rw-r--r-- 1 root    root    31 Sep 13 13:55 centosfile.txt
   -rw-r--r-- 1 root    root    33 Sep 13 14:13 debianfile.txt
   -rw-rw-r-- 1 vagrant vagrant 31 Sep 13 13:57 hostfile.txt
   vagrant@vagrant:~/data$ cat debianfile.txt
   Hellow world from Debian! Test 3
```
   
   Задача 4 (*)

   Воспроизвести практическую часть лекции самостоятельно.

   Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.

```
   https://hub.docker.com/r/sergeyklimov/devops22/tags
   
```