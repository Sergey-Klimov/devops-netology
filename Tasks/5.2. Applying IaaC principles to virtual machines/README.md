# Домашнее задание к занятию "5.2. Применение принципов IaaC в работе с виртуальными машинами"

   Задача 1
   
   Опишите своими словами основные преимущества применения на практике IaaC паттернов.
   Какой из принципов IaaC является основополагающим?

   Решение:
```
   Высокая скорость развертывания инфраструктуру для разработки и тестирования. Унифицированные решения, настройки ВМ и
   установленные приложения для всех участников проекта.
   Т.е. не получится такого что у кого-то функциональность разработанного приложения работает, а у другого не работает.
   
   Главный принцип это то, что каждый раз разворачивая инфрастуктуру с помощью кода, мы получим идетничный результат.
   Идемпотентность - главный принцип. То есть при повторном выполнении мы получаем результат идентичный предыдущему и 
   всем последующим.
```   
   Задача 2

   Чем Ansible выгодно отличается от других систем управление конфигурациями?
   Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?

```
    В Ansible низкий порог вхождения, т.е. не нужно обладать большими навыками в разрабоке чтобы им пользоваться.
    Главное его отличие от других подобных систем в том, что Ansible использует существующую SSH инфраструктуру.
    Так же не требует установки PKI - окружения. И он очень популярен в компаниях.
    По моему мнению pull, потому что сервер сам запрашивает конфигурацию после его разворачивания. В методе push может 
    возникнуть ситуация когда сервер какое-то время будет ждать когда же ему пришлют конфигурацию.
```
   Задача 3

   Установить на личный компьютер:

   VirtualBox
   Vagrant
   Ansible

   Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.
   
   Решение:

   1. VirtualBox
```
   vagrant@vagrant:~$ vboxmanage --version
   6.1.34_Ubuntur150636
```
   2. Vagrant.
```
   $ vagrant --version
   Vagrant 2.3.0

``` 
   3. Ansible.
```
   vagrant@vagrant:~$ ansible --version
   ansible 2.9.6
   config file = /etc/ansible/ansible.cfg
   configured module search path = ['/home/vagrant/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
   ansible python module location = /usr/lib/python3/dist-packages/ansible
   executable location = /usr/bin/ansible
   python version = 3.8.10 (default, Mar 15 2022, 12:22:08) [GCC 9.4.0]

```
  
   Задача 4 (*) Воспроизвести практическую часть лекции самостоятельно.

   Создать виртуальную машину. Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды docker ps
   
   Решение:

```
   vagrant@vagrant:~$ sudo systemctl status docker
● docker.service - Docker Application Container Engine
     Loaded: loaded (/lib/systemd/system/docker.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2022-09-06 20:54:52 UTC; 49s ago
TriggeredBy: ● docker.socket
       Docs: https://docs.docker.com
   Main PID: 28848 (dockerd)
      Tasks: 8
     Memory: 41.8M
     CGroup: /system.slice/docker.service
             └─28848 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock
             
   vagrant@vagrant:~$ sudo docker ps
   CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
   vagrant@vagrant:~$ sudo docker -v
   Docker version 20.10.17, build 100c701
   
```