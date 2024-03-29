# Домашнее задание к занятию "8.1 Введение в Ansible"

## Подготовка к выполнению
1. Установите ansible версии 2.10 или выше.
2. Создайте свой собственный публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

**Решение:**

```bash
vagrant@vagrant:~$ sudo apt update && sudo apt upgrade
vagrant@vagrant:~$ sudo apt install python3-pip
vagrant@vagrant:~$ pip3 install ansible
vagrant@vagrant:~$ ansible --version
ansible [core 2.13.6]
  config file = None
  configured module search path = ['/home/vagrant/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /home/vagrant/.local/lib/python3.8/site-packages/ansible
  ansible collection location = /home/vagrant/.ansible/collections:/usr/share/ansible/collections
  executable location = /home/vagrant/.local/bin/ansible
  python version = 3.8.10 (default, Jun 22 2022, 20:18:18) [GCC 9.4.0]
  jinja version = 3.1.2
  libyaml = True
 
vagrant@vagrant:~$ git clone https://github.com/Sergey-Klimov/ansiblegit.git
```

[https://github.com/Sergey-Klimov/ansiblegit](https://github.com/Sergey-Klimov/ansiblegit/tree/main/playbook)

## Основная часть
1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.

**Решение:** `some_fact` для указанного хоста имеет значение **12**

```
vagrant@vagrant:~/ansiblegit/playbook$ ansible-playbook  -i inventory/test.yml site.yml
PLAY [Print os facts] ********************************************************************************************************************
TASK [Gathering Facts] *******************************************************************************************************************
ok: [localhost]
TASK [Print OS] **************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}
TASK [Print fact] ************************************************************************************************************************
ok: [localhost] => {
    "msg": 12
}
PLAY RECAP *******************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.

**Решение:**

```
vagrant@vagrant:~/ansiblegit/playbook$ cat group_vars/all/examp.yml
---
  some_fact: all default fact
```

3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.

**Решение: Выполнено.**

4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.

**Решение:**

```
vagrant@vagrant:~/ansiblegit/playbook$ cat inventory/prod.yml
---
  el:
    hosts:
      centos7:
        ansible_connection: local
  deb:
    hosts:
      ubuntu:
        ansible_connection: local
vagrant@vagrant:~/ansiblegit/playbook$ ansible-playbook -i inventory/prod.yml site.yml
PLAY [Print os facts] ********************************************************************************************************************************************************
TASK [Gathering Facts] *******************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]
TASK [Print OS] **************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "Ubuntu"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
TASK [Print fact] ************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}
PLAY RECAP *******************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.

**Решение:**

```
vagrant@vagrant:~/ansiblegit/playbook/group_vars$ cat deb/examp.yml ;echo ""
---
  some_fact: "deb default fact"
vagrant@vagrant:~/ansiblegit/playbook/group_vars$ cat el/examp.yml ;echo ""
---
  some_fact: "el default fact"
```
6. Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.

**Решение:**

```
vagrant@vagrant:~/ansiblegit/playbook$ ansible-playbook -i inventory/prod.yml site.yml
PLAY [Print os facts] ********************************************************************************************************************************************************
TASK [Gathering Facts] *******************************************************************************************************************************************************
ok: [centos7]
ok: [ubuntu]
TASK [Print OS] **************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "Ubuntu"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
TASK [Print fact] ************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
PLAY RECAP *******************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.

**Решение:**

```
vagrant@vagrant:~/ansiblegit/playbook$ ansible-vault encrypt group_vars/deb/examp.yml
New Vault password:
Confirm New Vault password:
Encryption successful
vagrant@vagrant:~/ansiblegit/playbook$ ansible-vault encrypt group_vars/el/examp.yml
New Vault password:
Confirm New Vault password:
Encryption successful
```

8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.

**Решение:**

```
vagrant@vagrant:~/ansiblegit/playbook$ ansible-playbook -i inventory/prod.yml site.yml
PLAY [Print os facts] ********************************************************************************************************************************************************
ERROR! Attempting to decrypt but no vault secrets found
vagrant@vagrant:~/ansiblegit/playbook$ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password:
PLAY [Print os facts] ********************************************************************************************************************************************************
TASK [Gathering Facts] *******************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]
TASK [Print OS] **************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "Ubuntu"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
TASK [Print fact] ************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
PLAY RECAP *******************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.


10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.

**Решение:**

```
vagrant@vagrant:~/ansiblegit/playbook$ cat inventory/prod.yml
---
  el:
    hosts:
      centos7:
        ansible_connection: local
  deb:
    hosts:
      ubuntu:
        ansible_connection: local
  local:
    hosts:
      localhost:
        ansible_host: localhost
        ansible_connection: local
```
11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.

**Решение:**

```
vagrant@vagrant:~/ansiblegit/playbook$ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password:
PLAY [Print os facts] ********************************************************************************************************************************************************
TASK [Gathering Facts] *******************************************************************************************************************************************************
ok: [centos7]
ok: [localhost]
ok: [ubuntu]
TASK [Print OS] **************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "Ubuntu"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "Ubuntu"
}
TASK [Print fact] ************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "all default fact"
}
PLAY RECAP *******************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

12.Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.

[playbook](./playbook/)

---