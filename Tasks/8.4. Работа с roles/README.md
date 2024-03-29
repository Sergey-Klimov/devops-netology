# Домашнее задание к занятию 4 «Работа с roles»

## Подготовка к выполнению

1. * Необязательно. Познакомьтесь с [LightHouse](https://youtu.be/ymlrNlaHzIY?t=929).

### Решение:
Видео посмотрел, на канал продписан, палей вверх поставил.

2. Создайте два пустых публичных репозитория в любом своём проекте: vector-role и lighthouse-role.

### Решение:

- [vector-role](https://github.com/Sergey-Klimov/vector-role/tree/main)
- [lighthouse-role](https://github.com/Sergey-Klimov/lighthouse-role/tree/main)

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

### Решение:

Сделано.

5. Перенести нужные шаблоны конфигов в `templates`.

### Решение:

-vector.service.j2

```yml
[Unit]
Description=Vector service
Documentation=https://vector.dev
After=network-online.target
Requires=network-online.target

[Service]
User= {{ ansible_user_id }}
Group= {{ ansible_user_gid }}
ExecStart=/root/{{ vector_dir }}/bin/vector --config /root/{{ vector_dir }}/config/vector.toml --watch-config true
Restart=always

[Install]
WantedBy=multi-user.target
```

6. Опишите в `README.md` обе роли и их параметры.

- [vector-role README.md](https://github.com/Sergey-Klimov/vector-role/blob/main/README.md)
- [lighthouse-role README.md](https://github.com/Sergey-Klimov/lighthouse-role/blob/main/README.md)


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

-nginx.repo.j2

```yml
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true

[nginx-mainline]
name=nginx mainline repo
baseurl=http://nginx.org/packages/mainline/centos/$releasever/$basearch/
gpgcheck=1
enabled=0
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
```

-nginx.conf.j2


```yml
server
 {
  listen 8123;
  server_name localhost;
  location / {
        root {{ document_root }}/{{ app_dir }};
        index index.html index.htm;
        default_type "text/html";
        try_files $uri.html $uri $uri/ =404;
    }
}   
```

8. Выложите все roles в репозитории. Проставьте теги, используя семантическую нумерацию. Добавьте roles в `requirements.yml` в playbook.

### Решение:

- [vector-role](https://github.com/Sergey-Klimov/vector-role/tree/main)
- [lighthouse-role](https://github.com/Sergey-Klimov/lighthouse-role/tree/main)


-requirements.yml

```yml
---
- src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
  scm: git
  version: "1.11.0"
  name: clickhouse

- src: git@github.com:rdbmw/vector-role.git
  scm: git
  version: "1.0.0"
  name: vector

- src: git@github.com:rdbmw/lighthouse-role.git
  scm: git
  version: "1.0.0"
  name: lighthouse
```

9. Переработайте playbook на использование roles. Не забудьте про зависимости LightHouse и возможности совмещения `roles` с `tasks`.

### Решение:

Сделано.

10. Выложите playbook в репозиторий.

### Решение:

Сделано.

11. В ответе дайте ссылки на оба репозитория с roles и одну ссылку на репозиторий с playbook.

### Решение:

- [vector-role](https://github.com/Sergey-Klimov/vector-role/tree/main)
- [lighthouse-role](https://github.com/Sergey-Klimov/lighthouse-role/tree/main)
- [playbook](https://github.com/Sergey-Klimov/devops-netology/tree/main/Tasks/8.4.%20%D0%A0%D0%B0%D0%B1%D0%BE%D1%82%D0%B0%20%D1%81%20roles)
---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
