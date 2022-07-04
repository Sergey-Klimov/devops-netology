# Домашнее задание к занятию "3.2. Работа в терминале, лекция 2"

1. Какого типа команда cd? Попробуйте объяснить, почему она именно такого типа; опишите ход своих мыслей, 
   если считаете что она могла бы быть другого типа.

   cd - сокращение от change directory (изменить каталог) - это shell builtin (встроенная команда), то есть команда, 
   которая вызывается напрямую в shell, а не как внешняя исполняемая. Если использовать внешний вызов, 
   то он будет работать со своим окружением, и менять  текущий каталог внутри своего окружения, а на вызвовший shell влиять не будет.

2. Какая альтернатива без pipe команде grep <some_string> <some_file> | wc -l? man grep поможет в ответе на 
   этот вопрос. Ознакомьтесь с документом о других подобных некорректных вариантах использования pipe.

   grep <some_string> <some_file> -c

   Пример: 

   vagrant@vagrant:$ grep 12345 test -c
   1
   vagrant@vagrant:$ grep 12345 test |wc -l
   1
   
3. Какой процесс с PID 1 является родителем для всех процессов в вашей виртуальной машине Ubuntu 20.04?

   systemd

   vagrant@vagrant:~$ pstree -p
   systemd(1)─┬─ModemManager(669)─┬─{ModemManager}(679)
           │                   └─{ModemManager}(682)
           ├─VBoxService(810)─┬─{VBoxService}(813)
           │                  ├─{VBoxService}(814)
           │                  ├─{VBoxService}(815)
           │                  ├─{VBoxService}(816)
           │                  ├─{VBoxService}(817)
           │                  ├─{VBoxService}(818)
           │                  ├─{VBoxService}(820)
           │                  └─{VBoxService}(821)
           ├─accounts-daemon(604)─┬─{accounts-daemon}(636)
           │                      └─{accounts-daemon}(659)
           ├─agetty(634)
           ├─atd(627)
           ├─cron(623)
           ├─dbus-daemon(605)
           ├─multipathd(507)─┬─{multipathd}(508)
           │                 ├─{multipathd}(509)
           │                 ├─{multipathd}(510)
           │                 ├─{multipathd}(511)
           │                 ├─{multipathd}(512)
           │                 └─{multipathd}(513)
           ├─networkd-dispat(612)
           ├─polkitd(613)─┬─{polkitd}(635)
           │              └─{polkitd}(660)
           ├─rsyslogd(614)─┬─{rsyslogd}(641)
           │               ├─{rsyslogd}(642)
           │               └─{rsyslogd}(643)
           ├─snapd(616)─┬─{snapd}(822)
           │            ├─{snapd}(823)
           │            ├─{snapd}(824)
           │            ├─{snapd}(825)
           │            ├─{snapd}(858)
           │            ├─{snapd}(864)
           │            ├─{snapd}(865)
           │            ├─{snapd}(956)
           │            └─{snapd}(5556)
           ├─sshd(657)───sshd(6928)───sshd(6980)───bash(6981)───pstree(7046)
           ├─systemd(6944)───(sd-pam)(6945)
           ├─systemd-journal(333)
           ├─systemd-logind(618)
           ├─systemd-network(589)
           ├─systemd-resolve(591)
           ├─systemd-udevd(364)
           └─udisksd(619)─┬─{udisksd}(647)
                          ├─{udisksd}(661)
                          ├─{udisksd}(675)
                          └─{udisksd}(694)

4. Как будет выглядеть команда, которая перенаправит вывод stderr ls на другую сессию терминала?

   ls /root 2>/dev/pts/x,
   где /dev/pts/x - псевдотерминал другой сессии.

5. Получится ли одновременно передать команде файл на stdin и вывести ее stdout в другой файл? Приведите работающий пример.

   Да, получится. Пример:

   vagrant@vagrant:/test$ ls -l
   total 8
   -rw-rw-r-- 1 vagrant vagrant 18 Jul  4 08:52 file
   -rw-rw-r-- 1 vagrant vagrant 18 Jul  4 08:53 file1   
   vagrant@vagrant:/test$ cat file
   Texst in file 123
   vagrant@vagrant:/test$ cat file1
   123 
   vagrant@vagrant:/test$ cat <file> file1
   vagrant@vagrant:/test$ cat file1
   Texst in file 123

6. Получится ли находясь в графическом режиме, вывести данные из PTY в какой-либо из эмуляторов TTY? 
   Сможете ли вы наблюдать выводимые данные?

   Да, получится. Пример:

   vagrant@vagrant:$ sudo -i
   root@vagrant:# echo "test" > /dev/tty1

   Находясь в tty1, я увижу отправленные данные.

7. Выполните команду bash 5>&1. К чему она приведет? 
   Что будет, если вы выполните echo netology > /proc/$$/fd/5? Почему так происходит?

   vagrant@vagrant:$ bash 5>&1 - создаст новый дескриптор 5 и перенаправит его на STDOUT
   vagrant@vagrant:$ echo netology > /proc/$$/fd/5 - перенаправит результат команды echo в дескриптор 5

8. Получится ли в качестве входного потока для pipe использовать только stderr команды, не потеряв при этом 
   отображение stdout на pty? Напоминаем: по умолчанию через pipe передается только stdout команды слева 
   от | на stdin команды справа. Это можно сделать, поменяв стандартные потоки местами через промежуточный
   новый дескриптор, который вы научились создавать в предыдущем вопросе.

   Да, получится. Для этого нужно ввести промежуточный дескриптор и перенаправить выводы STDOUT и STDERR". 
   Для этого применяется конструкция N>&1 1>&2 2>&N (где N - новый промежуточный дескриптор).

   3>&2 - новый дескриптор перенаправили в stderr
   2>&1 - stderr перенаправили в stdout 
   1>&3 - stdout - перенаправили в в новый дескриптор

9. Что выведет команда cat /proc/$$/environ? Как еще можно получить аналогичный по содержанию вывод?

   Эта команда выведет переменные окружения:
 
   vagrant@vagrant:$ cat /proc/$$/environ
   USER=vagrantLOGNAME=vagrantHOME=/home/vagrantPATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:
   /usr/games:/usr/local/games:/snap/binSHELL=/bin/bashTERM=xterm-256colorXDG_SESSION_ID=85XDG_RUNTIME_DIR=
   /run/user/1000DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/busXDG_SESSION_TYPE=ttyXDG_SESSION_CLASS=
   userMOTD_SHOWN=pamLANG=en_US.UTF-8SSH_CLIENT=10.0.2.2 61725 22SSH_CONNECTION=10.0.2.2 61725 10.0.2.15 22SSH_TTY=
   /dev/pts/0vagrant@vagrant:$

   Аналогичный по содержанию вывод можно получить с помощью команды printenv:
 
    vagrant@vagrant:$ printenv
    SHELL=/bin/bash
    PWD=/home/vagrant
    LOGNAME=vagrant
    XDG_SESSION_TYPE=tty
    MOTD_SHOWN=pam
    HOME=/home/vagrant
    LANG=en_US.UTF-8
    LS_COLORS=rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:
    SSH_CONNECTION=10.0.2.2 61725 10.0.2.15 22
    LESSCLOSE=/usr/bin/lesspipe %s %s
    XDG_SESSION_CLASS=user
    TERM=xterm-256color
    LESSOPEN=| /usr/bin/lesspipe %s
    USER=vagrant
    SHLVL=1
    XDG_SESSION_ID=85
    XDG_RUNTIME_DIR=/run/user/1000
    SSH_CLIENT=10.0.2.2 61725 22
    XDG_DATA_DIRS=/usr/local/share:/usr/share:/var/lib/snapd/desktop
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
    DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus
    SSH_TTY=/dev/pts/0
    _=/usr/bin/printenv
    OLDPWD=/home/vagrant/test

10. Используя man, опишите что доступно по адресам /proc/<PID>/cmdline, /proc/<PID>/exe.

    /proc/<PID>/cmdline - полный путь до исполняемого файла процесса [PID]  
    /proc/<PID>/exe - содержит ссылку до файла запущенного для процесса [PID], 
                        
11. Узнайте, какую наиболее старшую версию набора инструкций SSE поддерживает ваш процессор с помощью /proc/cpuinfo.

    sse4_2

    grep sse /proc/cpuinfo
    flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 
    ht syscall nx rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni ssse3 cx16 pcid sse4_1
    sse4_2 hypervisor lahf_lm pti fsgsbase md_clear flush_l1d arch_capabilities

12. При открытии нового окна терминала и vagrant ssh создается новая сессия и выделяется pty. Это можно 
    подтвердить командой tty, которая упоминалась в лекции 3.2. Однако:

    vagrant@netology1:$ ssh localhost 'tty'
    not a tty
    
    Почитайте, почему так происходит, и как изменить поведение.

    После подключения ожидается пользователь, а не другой процесс, и нет создаётся локальн tty локально. 
    Для запуска можно добавить -t для принудительново создания псевдотерминала.

    vagrant@vagrant:$ ssh -t localhost 'tty'

13. Бывает, что есть необходимость переместить запущенный процесс из одной сессии в другую. Попробуйте
    сделать это, воспользовавшись reptyr. Например, так можно перенести в screen процесс, который вы
    запустили по ошибке в обычной SSH-сессии.

    vagrant@vagrant:$ sudo -i
    root@vagrant:# apt install reptyr
    Reading package lists... Done
    Building dependency tree
    Reading state information... Done
    reptyr is already the newest version (0.6.2-1.3).
    0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
    root@vagrant:~# nano /etc/sysctl.d/10-ptrace.conf
    #Изменил значение 1 на 0#
    kernel.yama.ptrace_scope = 0

14. sudo echo string > /root/new_file не даст выполнить перенаправление под обычным пользователем, так как 
    перенаправлением занимается процесс shell'а, который запущен без sudo под вашим пользователем. Для 
    решения данной проблемы можно использовать конструкцию echo string | sudo tee /root/new_file. Узнайте
    что делает команда tee и почему в отличие от sudo echo команда с sudo tee будет работать.

    Ответ:

    tee - получает значения из stdin и записывает их в stdout и файл. 
    Так как tee запускается отдельным процессом из-под sudo, то получая в stdin
    через pipe данные от echo - у нее есть права записать в файл.

