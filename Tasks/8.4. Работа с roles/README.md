# Домашнее задание к занятию 4 «Работа с roles»

## Подготовка к выполнению

1. * Необязательно. Познакомьтесь с [LightHouse](https://youtu.be/ymlrNlaHzIY?t=929).

### Решение:
Видео посмотрел, на канал продписан, палей вверх поставил.

2. Создайте два пустых публичных репозитория в любом своём проекте: vector-role и lighthouse-role.

### Решение:
- [vector-role](https://github.com/Sergey-Klimov/vector-role/tree/main)
- [lighthouse-role](https://github.com/Sergey-Klimov/lighthouse-role/tree/main)
- Дополнительно:
- [Nginx-role](https://github.com/Sergey-Klimov/nginx-role/tree/main)


3. Добавьте публичную часть своего ключа к своему профилю на GitHub.

### Решение:

Сделано.

## Основная часть

Ваша цель — разбить ваш playbook на отдельные roles. 

Задача — сделать roles для ClickHouse, Vector и LightHouse и написать playbook для использования этих ролей. 

Ожидаемый результат — существуют три ваших репозитория: два с roles и один с playbook.

**Что нужно сделать**

1. Создайте в старой версии playbook файл `requirements.yml` и заполните его содержимым:

   ```yaml
   ---
     - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
       scm: git
       version: "1.11.0"
       name: clickhouse 
   ```
### Решение:

``` yml
vagrant@vagrant:~/share/08-ansible-04-role/playbook$ cat requirements.yml

---
  - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
    scm: git
    version: "1.11.0"
    name: clickhouse
```
2. При помощи `ansible-galaxy` скачайте себе эту роль.

### Решение:

``` yml
vagrant@vagrant:~/share/08-ansible-04-role/playbook$ ansible-galaxy install -r requirements.yml
Starting galaxy role install process
- extracting clickhouse to /home/vagrant/.ansible/roles/clickhouse
- clickhouse (1.11.0) was installed successfully
```

``` yml
vagrant@vagrant:~/.ansible/roles/clickhouse$ ls -la
total 72
drwxrwxr-x 10 vagrant vagrant  4096 Mar 25 19:01 .
drwxrwxr-x  3 vagrant vagrant  4096 Mar 25 19:01 ..
drwxrwxr-x  2 vagrant vagrant  4096 Mar 25 19:01 defaults
drwxrwxr-x  3 vagrant vagrant  4096 Mar 25 19:01 .github
-rw-rw-r--  1 vagrant vagrant    62 Apr  8  2022 .gitignore
drwxrwxr-x  2 vagrant vagrant  4096 Mar 25 19:01 handlers
drwxrwxr-x  2 vagrant vagrant  4096 Mar 25 19:01 meta
drwxrwxr-x 12 vagrant vagrant  4096 Mar 25 19:01 molecule
-rw-rw-r--  1 vagrant vagrant 12926 Apr  8  2022 README.md
-rw-rw-r--  1 vagrant vagrant  1153 Apr  8  2022 requirements-test.txt
drwxrwxr-x  5 vagrant vagrant  4096 Mar 25 19:01 tasks
drwxrwxr-x  2 vagrant vagrant  4096 Mar 25 19:01 templates
-rw-rw-r--  1 vagrant vagrant   743 Apr  8  2022 .travis.yml
drwxrwxr-x  2 vagrant vagrant  4096 Mar 25 19:01 vars
-rw-rw-r--  1 vagrant vagrant   598 Apr  8  2022 .yamllint
```

3. Создайте новый каталог с ролью при помощи `ansible-galaxy role init vector-role`.

### Решение:

``` yml
vagrant@vagrant:~/.ansible/roles$ ansible-galaxy role init vector-role
- Role vector-role was created successfully
vagrant@vagrant:~/.ansible/roles$ ls -la
total 16
drwxrwxr-x  4 vagrant vagrant 4096 Mar 25 19:08 .
drwxrwxr-x  6 vagrant vagrant 4096 Mar 25 19:01 ..
drwxrwxr-x 10 vagrant vagrant 4096 Mar 25 19:01 clickhouse
drwxrwxr-x 10 vagrant vagrant 4096 Mar 25 19:08 vector-role
vagrant@vagrant:~/.ansible/roles$ cd vector-role
vagrant@vagrant:~/.ansible/roles/vector-role$ ls -la
total 48
drwxrwxr-x 10 vagrant vagrant 4096 Mar 25 19:08 .
drwxrwxr-x  4 vagrant vagrant 4096 Mar 25 19:08 ..
drwxrwxr-x  2 vagrant vagrant 4096 Mar 25 19:08 defaults
drwxrwxr-x  2 vagrant vagrant 4096 Mar 25 19:08 files
drwxrwxr-x  2 vagrant vagrant 4096 Mar 25 19:08 handlers
drwxrwxr-x  2 vagrant vagrant 4096 Mar 25 19:08 meta
-rw-rw-r--  1 vagrant vagrant 1328 Mar 25 19:08 README.md
drwxrwxr-x  2 vagrant vagrant 4096 Mar 25 19:08 tasks
drwxrwxr-x  2 vagrant vagrant 4096 Mar 25 19:08 templates
drwxrwxr-x  2 vagrant vagrant 4096 Mar 25 19:08 tests
-rw-rw-r--  1 vagrant vagrant  539 Mar 25 19:08 .travis.yml
drwxrwxr-x  2 vagrant vagrant 4096 Mar 25 19:08 vars
```

4. На основе tasks из старого playbook заполните новую role. Разнесите переменные между `vars` и `default`. 
5. Перенести нужные шаблоны конфигов в `templates`.
6. Опишите в `README.md` обе роли и их параметры.
7. Повторите шаги 3–6 для LightHouse. Помните, что одна роль должна настраивать один продукт.
### Решение:

``` yml
vagrant@vagrant:~/.ansible/roles$ ansible-galaxy role init LightHouse
- Role LightHouse was created successfully
vagrant@vagrant:~/.ansible/roles$ cd LightHouse
vagrant@vagrant:~/.ansible/roles/LightHouse$ ls -la
total 48
drwxrwxr-x 10 vagrant vagrant 4096 Mar 25 19:11 .
drwxrwxr-x  5 vagrant vagrant 4096 Mar 25 19:11 ..
drwxrwxr-x  2 vagrant vagrant 4096 Mar 25 19:11 defaults
drwxrwxr-x  2 vagrant vagrant 4096 Mar 25 19:11 files
drwxrwxr-x  2 vagrant vagrant 4096 Mar 25 19:11 handlers
drwxrwxr-x  2 vagrant vagrant 4096 Mar 25 19:11 meta
-rw-rw-r--  1 vagrant vagrant 1328 Mar 25 19:11 README.md
drwxrwxr-x  2 vagrant vagrant 4096 Mar 25 19:11 tasks
drwxrwxr-x  2 vagrant vagrant 4096 Mar 25 19:11 templates
drwxrwxr-x  2 vagrant vagrant 4096 Mar 25 19:11 tests
-rw-rw-r--  1 vagrant vagrant  539 Mar 25 19:11 .travis.yml
drwxrwxr-x  2 vagrant vagrant 4096 Mar 25 19:11 vars
```
8. Выложите все roles в репозитории. Проставьте теги, используя семантическую нумерацию. Добавьте roles в `requirements.yml` в playbook.
9. Переработайте playbook на использование roles. Не забудьте про зависимости LightHouse и возможности совмещения `roles` с `tasks`.
10. Выложите playbook в репозиторий.
11. В ответе дайте ссылки на оба репозитория с roles и одну ссылку на репозиторий с playbook.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
