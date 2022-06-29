# Решение домашнего задания к занятию "3.1. Работа в терминале, лекция 1"

1. Установите средство виртуализации [Oracle VirtualBox](https://www.virtualbox.org/).

    Установлен из дистрибутива: VirtualBox-6.1.34-150636-Win.exe
    Так же установлен: Oracle_VM_VirtualBox_Extension_Pack-6.1.34-150636.vbox-extpack

2. Установите средство автоматизации [Hashicorp Vagrant](https://www.vagrantup.com/).

    Установлен из дистрибутива: vagrant_2.2.19_i686.msi

3. В вашем основном окружении подготовьте удобный для дальнейшей работы терминал. Можно предложить:

    Windows Terminal в Windows.
    Стандартное приглашение: vagrant@vagrant-ubuntu-trusty-64:~$
    Настроенное приглашение: 12:19:44 vagrant@vagrant-ubuntu-trusty-64(0):~$
    В приглашении добавил текущее время и число фоновых процессов:
    PS1='${debian_chroot:+($debian_chroot)}\t \[\033[01;32m\]\u@\h(\j)\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
 

 
4. С помощью базового файла конфигурации запустите Ubuntu 20.04 в VirtualBox посредством Vagrant:

    Выполнено:
 
    vagrant init bento/ubuntu-20.04
    vagrant up
    vagrant status
    vagrant suspend
    vagrant up
    vagrant halt
    vagrant reload
    vagrant ssh
    
5. Ознакомьтесь с графическим интерфейсом VirtualBox, посмотрите как выглядит виртуальная машина, которую создал для вас Vagrant, какие аппаратные ресурсы ей выделены. Какие ресурсы выделены по-умолчанию?

   По-умолчанию выделено:

   RAM:1024mb
   CPU:1 cpu
   HDD:64gb
   video:8mb

   Изменил на:
   
   RAM:1024mb
   CPU:2 cpu
   HDD:64gb
   video:32mb

6. Ознакомьтесь с возможностями конфигурации VirtualBox через Vagrantfile: [документация](https://www.vagrantup.com/docs/providers/virtualbox/configuration.html). Как добавить оперативной памяти или ресурсов процессора виртуальной машине?

   config.vm.provider "virtualbox" do |vb|   
   vb.memory = "1024"
   vb.cpus = 2
   end
   
7. Команда `vagrant ssh` из директории, в которой содержится Vagrantfile, позволит вам оказаться внутри виртуальной машины без каких-либо дополнительных настроек. Попрактикуйтесь в выполнении обсуждаемых команд в терминале Ubuntu.

   Ввел команду: vagrant ssh, перешел на виртуальной машине. Попракитиковался....

   Welcome to Ubuntu 14.04.6 LTS (GNU/Linux 3.13.0-170-generic x86_64)
   * Documentation:  https://help.ubuntu.com/
   System information as of Tue Jun 28 14:32:50 UTC 2022
   System load:  0.76              Processes:           107
   Usage of /:   3.6% of 39.34GB   Users logged in:     0
   Memory usage: 8%                IP address for eth0: 10.0.2.15
   Swap usage:   0%
  
   Graph this data and manage this system at:
   https://landscape.canonical.com/

   UA Infrastructure Extended Security Maintenance (ESM) is not enabled.

   0 updates can be installed immediately.
   0 of these updates are security updates.

   Enable UA Infrastructure ESM to receive 64 additional security updates.
   See https://ubuntu.com/advantage or run: sudo ua status

   New release '16.04.7 LTS' available.
   Run 'do-release-upgrade' to upgrade to it.

   Last login: Tue Jun 28 14:29:52 2022 from 10.0.2.2
   
   vagrant@vagrant-ubuntu-trusty-64:~$
   vagrant@vagrant-ubuntu-trusty-64:~$ uptime
   14:39:57 up 7 min,  1 user,  load average: 0.00, 0.05, 0.05
   vagrant@vagrant-ubuntu-trusty-64:~$ sudo apt-get update
   Reading package lists... Done
   vagrant@vagrant-ubuntu-trusty-64:~$

   И другие команды....

8. Ознакомиться с разделами `man bash`, почитать о настройках самого bash:
    * какой переменной можно задать длину журнала `history`, и на какой строчке manual это описывается?
      HISTFILESIZE - максимальное число строк в файле истории для сохранения, строка 564
    * что делает директива `ignoreboth` в bash?
      A value of ignoreboth is shorthand for ignorespace and ignoredups.
      ignoreboth это сокращение для команд ignorespace and ignoredups, 
      ignorespace - не сохранять команды начинающиеся с пробела, а ignoredups - не сохранять команду, если такая уже есть в истории
      
9. В каких сценариях использования применимы скобки `{}` и на какой строчке `man bash` это описано?
 
   {} - зарезервированные слова, список команд в отличии от "(...)" исполнятся в текущем инстансе в различных условных циклах, условных операторах, или ограничивает тело функции.
      В командах выполняет подстановку элементов из списка , если упрощенно то  цикличное выполнение команд с подстановкой например mkdir ./DIR_{A..Z} - создаст каталоги сименами DIR_A, DIR_B...DIR_Z.
      Cтрока 132.

10. С учётом ответа на предыдущий вопрос, как создать однократным вызовом `touch` 100000 файлов? Получится ли аналогичным образом создать 300000? Если нет, то почему?

    vagrant@vagrant-ubuntu-trusty-64:~$ touch {1..116057}.txt
    vagrant@vagrant-ubuntu-trusty-64:~$ touch {1..116058}.txt
    -bash: /usr/bin/touch: Argument list too long

     100000 файлов создать получится. Максимум 116058. 300000 не получиться - список аргументов слишком большой.

11. В man bash поищите по `/\[\[`. Что делает конструкция `[[ -d /tmp ]]`

    Эта конструкция проверяет условие у -d /tmp и возвращает ее статус (0 или 1), наличие каталога /tmp

    Пример:

    if [[ -d /tmp ]]
    then
    echo "каталог есть"
    else
    echo "каталога нет"
    fi

12. Основываясь на знаниях о просмотре текущих (например, PATH) и установке новых переменных; командах, которые мы рассматривали, добейтесь в выводе type -a bash в виртуальной машине наличия первым пунктом в списке:

     ```bash
     bash is /tmp/new_path_directory/bash
     bash is /usr/local/bin/bash
     bash is /bin/bash
     ```
    Вводим команды:

     mkdir /tmp/new_path_directory/
     sudo su
     cp /bin/bash /tmp/new_path_directory/
     cp /bin/bash /usr/local/bin/
     PATH=/tmp/new_path_directory/:$PATH
     type -a bash
     bash is /tmp/new_path_directory/bash
     bash is /usr/local/bin/bash
     bash is /bin/bash
     
     (прочие строки могут отличаться содержимым и порядком)
     В качестве ответа приведите команды, которые позволили вам добиться указанного вывода или соответствующие скриншоты.

13. Чем отличается планирование команд с помощью `batch` и `at`?

    at - команда запускается в указанное время (в параметре)
    batch - запускается когда уровень загрузки системы снизится ниже 1.5

14. Завершите работу виртуальной машины чтобы не расходовать ресурсы компьютера и/или батарею ноутбука.

    vagrant status
    Current machine states:

    default                   running (virtualbox)    

    vagrant suspend
    vagrant status
    Current machine states:

    default                   saved (virtualbox)
    
