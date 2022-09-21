# Домашнее задание к занятию "5.5. Оркестрация кластером Docker контейнеров на примере Docker Swarm"

   Задача 1
   Дайте письменые ответы на следующие вопросы:

   В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?
   Какой алгоритм выбора лидера используется в Docker Swarm кластере?
   Что такое Overlay Network?
   
   Решение:

   1. В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?
   
   Для replicated сервисов необходимо указать количество идентичных задач, которы хотим запустить.
   Swarm отслеживает текущее количество запущенных задач и в случае падения какой-либо ноды - запустит задачу на другой 
   (поддерживает заданное количество реплик). Global сервис запускает одну задачу на каждой ноде. То есть при добавлении
   в кластер новых нод, глобальный сервис будет запущен и на ней автоматически.

   2. Какой алгоритм выбора лидера используется в Docker Swarm кластере?
   
   Docker Swarm использует алгоритм консенсуса Raft для определения лидера. Этот алгоритм обеспечивает согласованное
   состояние кластера. Raft требует, чтобы большинство членов кластера согласились на изменение, и допускает (N-1)/2сбоев.
   В случае недоступности лидера, его роль берет на себя одна из нод-менеджеров (если за нее проголосовало большинство
   менеджеров). Реализуется это за счет таймаутов. Если в течение определенного времени менеджер не получил данные от
   лидера - он объявляет себя кандидатом и другие ноды голосуют за него.

   3. Что такое Overlay Network?

   Overlay сеть - это сеть между несколькими демонами Docker. Она перекрывает сети хоста и позволяет контейнерам
   безопасно обмениваться данными (с использованием сертификатов и шифрования). Docker маршрутизирует пакеты к нужному
   хосту и контейнеру.
   
   Задача 2

   Создать ваш первый Docker Swarm кластер в Яндекс.Облаке

   Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:

   docker node ls
   
   Решение: 
   
```
[root@node01 ~]# docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
lp4js6ig0oxlk24omxi0aka6o *   node01.netology.yc   Ready     Active         Leader           20.10.18
labfkz2pikqtupdmpdwlrbxq6     node02.netology.yc   Ready     Active         Reachable        20.10.18
z3h6kblp533z60nh0ruatu6s2     node03.netology.yc   Ready     Active         Reachable        20.10.18
mo2d7cu2bdwd7rmsup8kqzqjr     node04.netology.yc   Ready     Active                          20.10.18
ysgpperbr0rz2vv8h9rvq5a70     node05.netology.yc   Ready     Active                          20.10.18
ioac6w3vm0mke3ie46tssdjvz     node06.netology.yc   Ready     Active                          20.10.18

[root@node01 ~]# docker service ls
ID             NAME                                MODE         REPLICAS   IMAGE                                          PORTS
tru9j7w9g5ia   swarm_monitoring_alertmanager       replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0
2gfq5ibw4lyt   swarm_monitoring_caddy              replicated   1/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
ixnbue5raoz1   swarm_monitoring_cadvisor           global       6/6        google/cadvisor:latest
l1jrurn3pfvd   swarm_monitoring_dockerd-exporter   global       6/6        stefanprodan/caddy:latest
mw1u7yuztvwv   swarm_monitoring_grafana            replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4
n1b4rm00hcfl   swarm_monitoring_node-exporter      global       6/6        stefanprodan/swarmprom-node-exporter:v0.16.0
v4su8g89h1j4   swarm_monitoring_prometheus         replicated   1/1        stefanprodan/swarmprom-prometheus:v2.5.0
sus2svsm7ygt   swarm_monitoring_unsee              replicated   1/1        cloudflare/unsee:v0.8.0
```   
Скриншот страницы cloud.yandex:

   Задача 3

   Создать ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.

   Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:

   docker service ls
   
   Решение:
   
```
[root@node01 ~]# docker service ls
ID             NAME                                MODE         REPLICAS   IMAGE                                          PORTS
tru9j7w9g5ia   swarm_monitoring_alertmanager       replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0
2gfq5ibw4lyt   swarm_monitoring_caddy              replicated   1/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
ixnbue5raoz1   swarm_monitoring_cadvisor           global       6/6        google/cadvisor:latest
l1jrurn3pfvd   swarm_monitoring_dockerd-exporter   global       6/6        stefanprodan/caddy:latest
mw1u7yuztvwv   swarm_monitoring_grafana            replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4
n1b4rm00hcfl   swarm_monitoring_node-exporter      global       6/6        stefanprodan/swarmprom-node-exporter:v0.16.0
v4su8g89h1j4   swarm_monitoring_prometheus         replicated   1/1        stefanprodan/swarmprom-prometheus:v2.5.0
sus2svsm7ygt   swarm_monitoring_unsee              replicated   1/1        cloudflare/unsee:v0.8.0
```
Скриншот страницы Grafana:

   Задача 4 (*)

   Выполнить на лидере Docker Swarm кластера команду (указанную ниже) и дать письменное описание её функционала,
   что она делает и зачем она нужна:

# см.документацию: https://docs.docker.com/engine/swarm/swarm_manager_locking/
docker swarm update --autolock=true

   Решение:

```
vagrant@vagrant:~/loc/terraform$ ssh centos@178.154.203.19
[centos@node01 ~]$ sudo -i
[root@node01 ~]# docker swarm update --autolock=true
Swarm updated.
To unlock a swarm manager after it restarts, run the `docker swarm unlock`
command and provide the following key:

    SWMKEY-1-PST0ZWhcvG3O1xqiyEfU6yYLA3BqRii8YeMVr2Fx6SU

Please remember to store this key in a password manager, since without it you
will not be able to restart the manager.

[root@node01 ~]# shutdown -r now

[centos@node02 ~]$ sudo -i
[root@node02 ~]# docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
lp4js6ig0oxlk24omxi0aka6o     node01.netology.yc   Down      Active         Unreachable      20.10.18
labfkz2pikqtupdmpdwlrbxq6 *   node02.netology.yc   Ready     Active         Leader           20.10.18
z3h6kblp533z60nh0ruatu6s2     node03.netology.yc   Ready     Active         Reachable        20.10.18
mo2d7cu2bdwd7rmsup8kqzqjr     node04.netology.yc   Ready     Active                          20.10.18
ysgpperbr0rz2vv8h9rvq5a70     node05.netology.yc   Ready     Active                          20.10.18
ioac6w3vm0mke3ie46tssdjvz     node06.netology.yc   Ready     Active                          20.10.18

vagrant@vagrant:~/loc/terraform$ ssh centos@178.154.203.19
[centos@node01 ~]$ sudo -i
[root@node01 ~]# docker node ls
Error response from daemon: Swarm is encrypted and needs to be unlocked before it can be used. Please use "docker swarm unlock" to unlock it.
[root@node01 ~]# docker swarm unlock
Please enter unlock key:

[root@node01 ~]# docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
lp4js6ig0oxlk24omxi0aka6o *   node01.netology.yc   Ready     Active         Reachable        20.10.18
labfkz2pikqtupdmpdwlrbxq6     node02.netology.yc   Ready     Active         Leader           20.10.18
z3h6kblp533z60nh0ruatu6s2     node03.netology.yc   Ready     Active         Reachable        20.10.18
mo2d7cu2bdwd7rmsup8kqzqjr     node04.netology.yc   Ready     Active                          20.10.18
ysgpperbr0rz2vv8h9rvq5a70     node05.netology.yc   Ready     Active                          20.10.18
ioac6w3vm0mke3ie46tssdjvz     node06.netology.yc   Ready     Active                          20.10.18
```

Данная команда включает автоблокировки Swarm после перезагрузки ноды.
Когда демон Docker перезапускается, ключи шифрования журналов Raft и ключи TLS для взаимодействия серверов загружаются
в память каждой ноды. Чтобы защитить эти ключи, Docker может включить механизм блокировки ноды
(по сути шифрование этих ключей). После активации данного механизма при перезагрузке ноды необходимо каждый раз
вводить вручную ключ шифрования, чтобы нода успешно запустилась и продолжила работу в составе кластера.