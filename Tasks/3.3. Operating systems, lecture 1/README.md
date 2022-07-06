# Домашнее задание к занятию "3.3. Операционные системы, лекция 1"

1. Какой системный вызов делает команда cd? В прошлом ДЗ мы выяснили, что cd не является самостоятельной
   программой, это shell builtin, поэтому запустить strace непосредственно на cd не получится. Тем не менее,
   вы можете запустить strace на /bin/bash -c 'cd /tmp'. В этом случае вы увидите полный список системных
   вызовов, которые делает сам bash при старте. Вам нужно найти тот единственный, который относится именно к cd.
   Обратите внимание, что strace выдаёт результат своей работы в поток stderr, а не в stdout.

   Вводим:

   vagrant@vagrant:$ strace /bin/bash -c 'cd /tmp'
   В выводе есть строка:

   chdir("/tmp")                           = 0

   Значит, что системный вызов CD - это chdir("/tmp").

2. Попробуйте использовать команду file на объекты разных типов на файловой системе. Например:

   vagrant@netology1:$ file /dev/tty   
   /dev/tty: character special (5/0)
   vagrant@netology1:$ file /dev/sda
   /dev/sda: block special (8/0)
   vagrant@netology1:$ file /bin/bash
   /bin/bash: ELF 64-bit LSB shared object, x86-64
   
   Используя strace выясните, где находится база данных file на основании которой она делает свои догадки.

   Вводим:
   strace -e openat file /dev/tty
   Вывод:
   
   openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
   openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libmagic.so.1", O_RDONLY|O_CLOEXEC) = 3
   openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
   openat(AT_FDCWD, "/lib/x86_64-linux-gnu/liblzma.so.5", O_RDONLY|O_CLOEXEC) = 3
   openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libbz2.so.1.0", O_RDONLY|O_CLOEXEC) = 3
   openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libz.so.1", O_RDONLY|O_CLOEXEC) = 3
   openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libpthread.so.0", O_RDONLY|O_CLOEXEC) = 3
   openat(AT_FDCWD, "/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
   openat(AT_FDCWD, "/etc/magic.mgc", O_RDONLY) = -1 ENOENT (No such file or directory)
   openat(AT_FDCWD, "/etc/magic", O_RDONLY) = 3
   openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
   openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/gconv/gconv-modules.cache", O_RDONLY) = 3
   /dev/tty: character special (5/0)
   +++ exited with 0 +++
   
   Аналогичный вывод на другие типы файлов...

   Думаю база данных file находитья тут:

   /etc/magic.mgc
   /etc/magic
   /usr/share/misc/magic.mgc


3. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако 
   возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет.
   Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается.
   Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного 
   файла (чтобы освободить место на файловой системе).

   Перенаправляем вывод:  exec 5> ping.log
   Запускаем:             ping localhost >&5
   Смотрим файл:          less ping.log
   Смотрим дескрипторы:   lsof | grep deleted
   Смотрим процессы:      lrwx------ 1 vagrant vagrant 64 Jul  5 08:15 0 -> /dev/pts/0
                          lrwx------ 1 vagrant vagrant 64 Jul  5 08:15 1 -> /dev/pts/0
                          lrwx------ 1 vagrant vagrant 64 Jul  5 08:15 2 -> /dev/pts/0
                          lrwx------ 1 vagrant vagrant 64 Jul  5 12:49 255 -> /dev/pts/0
                          l-wx------ 1 vagrant vagrant 64 Jul  5 08:15 5 -> /home/vagrant/ping.log
   Удаляем файл:          rm ping.log
   Смотрим дескрипторы:   lsof | grep deleted
                          ping  8124  vagrant  5w   REG  253,0   6468   1317559 /home/vagrant/ping.log (deleted)
                          ping  8124  vagrant  5w   REG  253,0   6468   1317559 /home/vagrant/ping.log (deleted)
   Обнуляем файловый 
   дескриптор (5):        echo ""| tee /proc/8124/fd/5



4. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?

   "Зомби-процессы", в отличии от "сирот" освобождают свои ресурсы, но не освобождают ID процесса в таблице процессов. 
    ID процесса можно освободить при вызове wait() родительским процессом. 

5. В iovisor BCC есть утилита opensnoop:
   
     root@vagrant:# dpkg -L bpfcc-tools | grep sbin/opensnoop
     /usr/sbin/opensnoop-bpfcc
   
    На какие файлы вы увидели вызовы группы open за первую секунду работы утилиты? Воспользуйтесь пакетом
    bpfcc-tools для Ubuntu 20.04. Дополнительные сведения по установке.
    
    Установил:       sudo apt install bpfcc-tools
    Запустил:        dpkg -L bpfcc-tools | grep sbin/opensnoop
                     /usr/sbin/opensnoop-bpfcc
    Выполнение 
    заданя:          sudo opensnoop-bpfcc
                     PID    COMM               FD ERR PATH
                     810    vminfo              4   0 /var/run/utmp
                     605    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
                     605    dbus-daemon        22   0 /usr/share/dbus-1/system-services
                     605    dbus-daemon        -1   2 /lib/dbus-1/system-services
                     605    dbus-daemon        22   0 /var/lib/snapd/dbus-1/system-services/

6. Какой системный вызов использует uname -a? Приведите цитату из man по этому системному вызову, где
   описывается альтернативное местоположение в /proc, где можно узнать версию ядра и релиз ОС.

   Part of the utsname information is also accessible via 
   /proc/sys/kernel/{ostype, hostname, osrelease, version, domainname}.

7. Чем отличается последовательность команд через ; и через && в bash? Например:
   root@netology1:# test -d /tmp/some_dir; echo Hi
   Hi
   root@netology1:# test -d /tmp/some_dir && echo Hi
   root@netology1:#
   Есть ли смысл использовать в bash &&, если применить set -e?

   ; - разделитель последовательных команд, значит,что команды будут выполеляться последовательно.
   && - условный оператор. Команда после && выполняются только если команда до && завершилась успешно (статус выхода 0).

   Так как каталога /tmp/some_dir не существует, то статус выхода не равен 0 и echo Hi не выполниться.

   set -e - прерывает сессию при ненулевом значении на выходе в конвеере кроме последней.
   в случае &&  вместе с set -e- вероятно не имеет смысла, так как при ошибке , выполнение команд прекратиться.

8. Из каких опций состоит режим bash set -euxo pipefail и почему его хорошо было бы использовать в сценариях?

   -e  Exit immediately if a command exits with a non-zero status.
   -u  Treat unset variables as an error when substituting.
   -x  Print commands and their arguments as they are executed.
   -o  pipefail the return value of a pipeline is the status of
       the last command to exit with a non-zero status, 
       or zero if no command exited with a non-zero status
   
   В скриптах было бы удобно спользовать этот режим для более подробного вывода ошибок (логирования) и прекражения 
   выполенния с крипта при возникновении ошибок. Облегчает "траблшутинг".

9. Используя -o stat для ps, определите, какой наиболее часто встречающийся статус у процессов в системе. 
   В man ps ознакомьтесь (/PROCESS STATE CODES) что значат дополнительные к основной заглавной буквы статуса процессов. 
   Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).


   vagrant@vagrant:$ ps -o stat
   STAT
   Ss
   T
   T
   T
   T
   R+
 
   
   S*(S,S+,Ss,Ssl,Ss+) - Процессы ожидающие завершения,
   I*(I,I<) - фоновые процессы ядра.

   Думаю, что можно считать равнозначными потому, что это дополнительная характеристика, например приоритет.
   