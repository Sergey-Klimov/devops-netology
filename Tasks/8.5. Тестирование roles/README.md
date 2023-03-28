# Домашнее задание к занятию 5 «Тестирование roles»

## Подготовка к выполнению

1. Установите molecule: `pip3 install "molecule==3.5.2"`.

### Решение:

``` bash
vagrant@vagrant:~$ pip3 install "molecule==3.5.2"
Collecting molecule==3.5.2
  Downloading molecule-3.5.2-py3-none-any.whl (240 kB)
     |████████████████████████████████| 240 kB 1.4 MB/s
.
.
.
Installing collected packages: binaryornot, python-dateutil, arrow, jinja2-time, text-unidecode, python-slugify, charset-normalizer, requests, click, cookiecutter, click-help-colors, typing-extensions, mdurl, markdown-it-py, pygments, rich, enrich, zipp, importlib-resources, pkgutil-resolve-name, jsonschema, subprocess-tee, ansible-compat, pluggy, cerberus, bcrypt, paramiko, molecule
Successfully installed ansible-compat-3.0.1 arrow-1.2.3 bcrypt-4.0.1 binaryornot-0.4.4 cerberus-1.3.2 charset-normalizer-3.1.0 click-8.1.3 click-help-colors-0.9.1 cookiecutter-2.1.1 enrich-1.2.7 importlib-resources-5.12.0 jinja2-time-0.2.0 jsonschema-4.17.3 markdown-it-py-2.2.0 mdurl-0.1.2 molecule-3.5.2 paramiko-2.12.0 pkgutil-resolve-name-1.3.10 pluggy-1.0.0 pygments-2.14.0 python-dateutil-2.8.2 python-slugify-8.0.1 requests-2.28.2 rich-13.3.2 subprocess-tee-0.4.1 text-unidecode-1.3 typing-extensions-4.5.0 zipp-3.15.0

vagrant@vagrant:~$ molecule --version
molecule 3.5.2 using python 3.8 
    ansible:2.13.7
    delegated:3.5.2 from molecule
```

2. Выполните `docker pull aragast/netology:latest` —  это образ с podman, tox и несколькими пайтонами (3.7 и 3.9) внутри.

### Решение:

``` bash
vagrant@vagrant:~$ docker pull aragast/netology:latest
latest: Pulling from aragast/netology
Digest: sha256:e44f93d3d9880123ac8170d01bd38ea1cd6c5174832b1782ce8f97f13e695ad5
Status: Image is up to date for aragast/netology:latest
docker.io/aragast/netology:latest

vagrant@vagrant:~$ docker image ls
REPOSITORY          TAG       IMAGE ID       CREATED         SIZE
ubuntu              latest    6b7dfa7e8fdb   3 months ago    77.8MB
aragast/netology    latest    b453a84e3f7a   5 months ago    2.46GB
hello-world         latest    feb5d9fea6a5   18 months ago   13.3kB
pycontribs/centos   7         bafa54e44377   23 months ago   488MB
pycontribs/ubuntu   latest    42a4e3b21923   3 years ago     664MB
```

## Основная часть

Ваша цель — настроить тестирование ваших ролей. 

Задача — сделать сценарии тестирования для vector. 

Ожидаемый результат — все сценарии успешно проходят тестирование ролей.

### Molecule

1. Запустите  `molecule test -s centos_7` внутри корневой директории clickhouse-role, посмотрите на вывод команды. Данная команда может отработать с ошибками, это нормально. Наша цель - посмотреть как другие в реальном мире используют молекулу.

### Решение:

```bash
vagrant@vagrant:~/.ansible/roles/clickhouse$ molecule test -s centos_7
INFO     centos_7 scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/home/vagrant/.cache/ansible-compat/7e099f/modules:/home/vagrant/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/home/vagrant/.cache/ansible-compat/7e099f/collections:/home/vagrant/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/home/vagrant/.cache/ansible-compat/7e099f/roles:/home/vagrant/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Inventory /home/vagrant/.ansible/roles/clickhouse/molecule/centos_7/../resources/inventory/hosts.yml linked to /home/vagrant/.cache/molecule/clickhouse/centos_7/inventory/hosts
INFO     Inventory /home/vagrant/.ansible/roles/clickhouse/molecule/centos_7/../resources/inventory/group_vars/ linked to /home/vagrant/.cache/molecule/clickhouse/centos_7/inventory/group_vars
INFO     Inventory /home/vagrant/.ansible/roles/clickhouse/molecule/centos_7/../resources/inventory/host_vars/ linked to /home/vagrant/.cache/molecule/clickhouse/centos_7/inventory/host_vars
INFO     Running centos_7 > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Inventory /home/vagrant/.ansible/roles/clickhouse/molecule/centos_7/../resources/inventory/hosts.yml linked to /home/vagrant/.cache/molecule/clickhouse/centos_7/inventory/hosts
INFO     Inventory /home/vagrant/.ansible/roles/clickhouse/molecule/centos_7/../resources/inventory/group_vars/ linked to /home/vagrant/.cache/molecule/clickhouse/centos_7/inventory/group_vars
INFO     Inventory /home/vagrant/.ansible/roles/clickhouse/molecule/centos_7/../resources/inventory/host_vars/ linked to /home/vagrant/.cache/molecule/clickhouse/centos_7/inventory/host_vars
INFO     Running centos_7 > lint
COMMAND: yamllint .
ansible-lint
flake8

fatal: not a git repository (or any of the parent directories): .git
Traceback (most recent call last):
  File "/usr/bin/ansible-lint", line 11, in <module>
    load_entry_point('ansible-lint==4.2.0', 'console_scripts', 'ansible-lint')()
  File "/usr/lib/python3/dist-packages/ansiblelint/__main__.py", line 153, in main
    args = get_playbooks_and_roles(options=options)
  File "/usr/lib/python3/dist-packages/ansiblelint/utils.py", line 772, in get_playbooks_and_roles
    files = OrderedDict.fromkeys(sorted(subprocess.check_output(
  File "/usr/lib/python3.8/subprocess.py", line 415, in check_output
    return run(*popenargs, stdout=PIPE, timeout=timeout, check=True,
  File "/usr/lib/python3.8/subprocess.py", line 516, in run
    raise CalledProcessError(retcode, process.args,
subprocess.CalledProcessError: Command '['git', 'ls-files', '*.yaml', '*.yml']' returned non-zero exit status 128.
/bin/bash: line 2: flake8: command not found
CRITICAL Lint failed with error code 127
WARNING  An error occurred during the test sequence action: 'lint'. Cleaning up.
INFO     Inventory /home/vagrant/.ansible/roles/clickhouse/molecule/centos_7/../resources/inventory/hosts.yml linked to /home/vagrant/.cache/molecule/clickhouse/centos_7/inventory/hosts
INFO     Inventory /home/vagrant/.ansible/roles/clickhouse/molecule/centos_7/../resources/inventory/group_vars/ linked to /home/vagrant/.cache/molecule/clickhouse/centos_7/inventory/group_vars
INFO     Inventory /home/vagrant/.ansible/roles/clickhouse/molecule/centos_7/../resources/inventory/host_vars/ linked to /home/vagrant/.cache/molecule/clickhouse/centos_7/inventory/host_vars
INFO     Running centos_7 > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Inventory /home/vagrant/.ansible/roles/clickhouse/molecule/centos_7/../resources/inventory/hosts.yml linked to /home/vagrant/.cache/molecule/clickhouse/centos_7/inventory/hosts
INFO     Inventory /home/vagrant/.ansible/roles/clickhouse/molecule/centos_7/../resources/inventory/group_vars/ linked to /home/vagrant/.cache/molecule/clickhouse/centos_7/inventory/group_vars
INFO     Inventory /home/vagrant/.ansible/roles/clickhouse/molecule/centos_7/../resources/inventory/host_vars/ linked to /home/vagrant/.cache/molecule/clickhouse/centos_7/inventory/host_vars
INFO     Running centos_7 > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos_7)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
ok: [localhost] => (item=centos_7)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
```

2. Перейдите в каталог с ролью vector-role и создайте сценарий тестирования по умолчанию при помощи `molecule init scenario --driver-name docker`.

### Решение:

```bash
vagrant@vagrant:~/.ansible/roles/vector-role$ molecule init scenario --driver-name docker
INFO     Initializing new scenario default...
INFO     Initialized scenario in /home/vagrant/.ansible/roles/vector-role/molecule/default successfully.
```

3. Добавьте несколько разных дистрибутивов (centos:8, ubuntu:latest) для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.

### Решение:

```bash
vagrant@vagrant:~/.ansible/roles/vector-role$ molecule init scenario centos8 --driver-name docker
INFO     Initializing new scenario centos8...
INFO     Initialized scenario in /home/vagrant/.ansible/roles/vector-role/molecule/centos8 successfully.
```

```bash
vagrant@vagrant:~/.ansible/roles/vector-role$ molecule init scenario ubuntu_latest --driver-name docker
INFO     Initializing new scenario ubuntu_latest...
INFO     Initialized scenario in /home/vagrant/.ansible/roles/vector-role/molecule/ubuntu_latest successfully.
```

4. Добавьте несколько assert в verify.yml-файл для  проверки работоспособности vector-role (проверка, что конфиг валидный, проверка успешности запуска и др.).

### Решение:

```yml
# This is an example playbook to execute Ansible tests.

- name: Verify
  hosts: all
  gather_facts: false
  vars:
    vector_config_path: /etc/vector/vector.yaml
  tasks:

  - name: Get Vector version
    ansible.builtin.command: "vector --version"
    changed_when: false
    register: vector_version
  - name: Assert Vector instalation
    assert:
      that: "'{{ vector_version.rc }}' == '0'"

  - name: Validation Vector configuration
    ansible.builtin.command: "vector validate --no-environment --config-yaml {{ vector_config_path }}"
    changed_when: false
    register: vector_validate
  - name: Assert Vector validate config
    assert:
      that: "'{{ vector_validate.rc }}' == '0'"
```

5. Запустите тестирование роли повторно и проверьте, что оно прошло успешно.

### Решение:

```bash
PLAY [Verify] ******************************************************************

TASK [Get Vector version] ******************************************************
ok: [instance]

TASK [Assert Vector instalation] ***********************************************
ok: [instance] => {
    "changed": false,
    "msg": "All assertions passed"
}

TASK [Validation Vector configuration] *****************************************
ok: [instance]

TASK [Assert Vector validate config] *******************************************
ok: [instance] => {
    "changed": false,
    "msg": "All assertions passed"
}

PLAY RECAP *********************************************************************
instance                   : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Running ubuntu_latest > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running ubuntu_latest > destroy

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item=instance)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
```

6. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

### Решение:

[Ссылка на vector tag-1.0.2](https://github.com/Sergey-Klimov/vector-role/tree/v1.0.2)

### Tox

1. Добавьте в директорию с vector-role файлы из [директории](./example).

### Решение:

```console
vagrant@vagrant:~/.ansible/roles/vector-role$ ls -la
total 80
drwxrwxr-x 12 vagrant vagrant 4096 Mar 28 14:02  .
drwxrwxr-x  8 vagrant vagrant 4096 Mar 28 13:55  ..
-rw-rw-r--  1 vagrant vagrant    0 Mar 28 14:02 '{'
drwxrwxr-x  2 vagrant vagrant 4096 Mar 28 13:55  defaults
-rw-rw-r--  1 vagrant vagrant    0 Mar 28 14:03  destroy
-rw-rw-r--  1 vagrant vagrant  962 Mar 28 13:55  Dockerfile
drwxrwxr-x  8 vagrant vagrant 4096 Mar 28 13:55  .git
drwxrwxr-x  2 vagrant vagrant 4096 Mar 28 13:55  handlers
drwxrwxr-x  3 vagrant vagrant 4096 Mar 28 13:55  .idea
-rw-rw-r--  1 vagrant vagrant  651 Mar 28 13:55  Jenkinsfile
drwxrwxr-x  2 vagrant vagrant 4096 Mar 28 13:55  meta
drwxrwxr-x  5 vagrant vagrant 4096 Mar 28 13:55  molecule
-rw-rw-r--  1 vagrant vagrant 1555 Mar 28 13:55  README.md
-rw-rw-r--  1 vagrant vagrant  585 Mar 28 13:55  ScriptedJenkinsfile
drwxrwxr-x  2 vagrant vagrant 4096 Mar 28 13:55  tasks
drwxrwxr-x  2 vagrant vagrant 4096 Mar 28 13:55  templates
drwxrwxr-x  2 vagrant vagrant 4096 Mar 28 13:55  tests
-rw-rw-r--  1 vagrant vagrant  280 Mar 28 13:55  tox.ini
-rw-rw-r--  1 vagrant vagrant   90 Mar 28 13:55  tox-requirements.txt
-rw-rw-r--  1 vagrant vagrant  539 Mar 28 13:55  .travis.yml
drwxrwxr-x  2 vagrant vagrant 4096 Mar 28 13:55  vars
-rw-rw-r--  1 vagrant vagrant  598 Mar 28 13:55  .yamllint
```

2. Запустите `docker run --privileged=True -v <path_to_repo>:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash`, где path_to_repo — путь до корня репозитория с vector-role на вашей файловой системе.

### Решение:

```bash
vagrant@vagrant:~/.ansible/roles/vector-role$ docker run --privileged=True -v /.ansible/roles/vector-role:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash
[root@5ea16a10b994 vector-role]# 
```

3. Внутри контейнера выполните команду `tox`, посмотрите на вывод.

### Решение:

```bash
[root@45366bc5833d vector-role]# tox
ERROR: tox config file (either pyproject.toml, tox.ini, setup.cfg) not found
[root@45366bc5833d vector-role]# 
```

5. Создайте облегчённый сценарий для `molecule` с драйвером `molecule_podman`. Проверьте его на исполнимость.


6. Пропишите правильную команду в `tox.ini`, чтобы запускался облегчённый сценарий.
8. Запустите команду `tox`. Убедитесь, что всё отработало успешно.
9. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

После выполнения у вас должно получится два сценария molecule и один tox.ini файл в репозитории. Не забудьте указать в ответе теги решений Tox и Molecule заданий. В качестве решения пришлите ссылку на  ваш репозиторий и скриншоты этапов выполнения задания. 

## Необязательная часть

1. Проделайте схожие манипуляции для создания роли LightHouse.
2. Создайте сценарий внутри любой из своих ролей, который умеет поднимать весь стек при помощи всех ролей.
3. Убедитесь в работоспособности своего стека. Создайте отдельный verify.yml, который будет проверять работоспособность интеграции всех инструментов между ними.
4. Выложите свои roles в репозитории.

В качестве решения пришлите ссылки и скриншоты этапов выполнения задания.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.
