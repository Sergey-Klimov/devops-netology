# Домашнее задание к занятию 6 «Создание собственных модулей»

## Подготовка к выполнению

1. Создайте пустой публичный репозиторий в своём любом проекте: `my_own_collection`.

### Решение:

Сделано. [my_own_collection](https://github.com/Sergey-Klimov/my_own_collection)

2. Скачайте репозиторий Ansible: `git clone https://github.com/ansible/ansible.git` по любому, удобному вам пути.

### Решение:

```bash
vagrant@vagrant:~/08-ansible-06-module$ git clone https://github.com/ansible/ansible.git
Cloning into 'ansible'...
remote: Enumerating objects: 594104, done.
remote: Counting objects: 100% (146/146), done.
remote: Compressing objects: 100% (120/120), done.
remote: Total 594104 (delta 34), reused 104 (delta 19), pack-reused 593958
Receiving objects: 100% (594104/594104), 227.99 MiB | 592.00 KiB/s, done.
Resolving deltas: 100% (395579/395579), done.
Updating files: 100% (5667/5667), done.
```

3. Зайдите в директорию Ansible: `cd ansible`.

### Решение:

```bash
vagrant@vagrant:~/08-ansible-06-module$ cd ansible
vagrant@vagrant:~/08-ansible-06-module/ansible$ ls -la
total 114
drwxrwxrwx 1 vagrant vagrant  4096 Mar 29 12:31 .
drwxrwxrwx 1 vagrant vagrant     0 Mar 29 12:23 ..
drwxrwxrwx 1 vagrant vagrant  4096 Mar 29 12:30 .azure-pipelines
drwxrwxrwx 1 vagrant vagrant  4096 Mar 29 12:30 bin
drwxrwxrwx 1 vagrant vagrant  4096 Mar 29 12:30 changelogs
-rwxrwxrwx 1 vagrant vagrant   202 Mar 29 12:30 .cherry_picker.toml
-rwxrwxrwx 1 vagrant vagrant 35148 Mar 29 12:30 COPYING
drwxrwxrwx 1 vagrant vagrant     0 Mar 29 12:30 docs
drwxrwxrwx 1 vagrant vagrant  4096 Mar 29 12:30 examples
drwxrwxrwx 1 vagrant vagrant  4096 Mar 29 12:31 .git
-rwxrwxrwx 1 vagrant vagrant    23 Mar 29 12:30 .gitattributes
-rwxrwxrwx 1 vagrant vagrant   138 Mar 29 12:30 .git-blame-ignore-revs
drwxrwxrwx 1 vagrant vagrant  4096 Mar 29 12:30 .github
-rwxrwxrwx 1 vagrant vagrant  2871 Mar 29 12:30 .gitignore
drwxrwxrwx 1 vagrant vagrant  4096 Mar 29 12:30 hacking
drwxrwxrwx 1 vagrant vagrant     0 Mar 29 12:30 lib
drwxrwxrwx 1 vagrant vagrant  4096 Mar 29 12:31 licenses
-rwxrwxrwx 1 vagrant vagrant  2200 Mar 29 12:30 .mailmap
-rwxrwxrwx 1 vagrant vagrant  4153 Mar 29 12:30 Makefile
-rwxrwxrwx 1 vagrant vagrant  2469 Mar 29 12:30 MANIFEST.in
drwxrwxrwx 1 vagrant vagrant     0 Mar 29 12:31 packaging
-rwxrwxrwx 1 vagrant vagrant   193 Mar 29 12:31 pyproject.toml
-rwxrwxrwx 1 vagrant vagrant  5697 Mar 29 12:30 README.rst
-rwxrwxrwx 1 vagrant vagrant   995 Mar 29 12:31 requirements.txt
-rwxrwxrwx 1 vagrant vagrant  2477 Mar 29 12:31 setup.cfg
-rwxrwxrwx 1 vagrant vagrant  1116 Mar 29 12:31 setup.py
drwxrwxrwx 1 vagrant vagrant     0 Mar 29 12:31 test
```

4. Создайте виртуальное окружение: `python3 -m venv venv`.

### Решение:

Выполнено.

<details><summary></summary>

```bash
vagrant@vagrant:~/08-ansible-06-module/ansible$ python3 -m venv venv
The virtual environment was not created successfully because ensurepip is not
available.  On Debian/Ubuntu systems, you need to install the python3-venv
package using the following command.

    apt install python3.8-venv

You may need to use sudo with that command.  After installing the python3-venv
package, recreate your virtual environment.

Failing command: ['/home/vagrant/08-ansible-06-module/ansible/venv/bin/python3', '-Im', 'ensurepip', '--upgrade', '--default-pip']

vagrant@vagrant:~/08-ansible-06-module/ansible$ sudo apt install python3.8-venv
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following packages were automatically installed and are no longer required:
  libxmlb1 linux-image-5.4.0-110-generic linux-image-5.4.0-135-generic linux-modules-5.4.0-110-generic linux-modules-5.4.0-135-generic linux-modules-extra-5.4.0-110-generic linux-modules-extra-5.4.0-135-generic   
Use 'sudo apt autoremove' to remove them.
The following NEW packages will be installed:
  python3.8-venv
0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
Need to get 5,452 B of archives.
After this operation, 27.6 kB of additional disk space will be used.
Get:1 http://in.archive.ubuntu.com/ubuntu focal-updates/universe amd64 python3.8-venv amd64 3.8.10-0ubuntu1~20.04.7 [5,452 B]
Fetched 5,452 B in 0s (11.1 kB/s)
Selecting previously unselected package python3.8-venv.
(Reading database ... 106708 files and directories currently installed.)
Preparing to unpack .../python3.8-venv_3.8.10-0ubuntu1~20.04.7_amd64.deb ...
Unpacking python3.8-venv (3.8.10-0ubuntu1~20.04.7) ...
Setting up python3.8-venv (3.8.10-0ubuntu1~20.04.7) ...

vagrant@vagrant:~/08-ansible-06-module/ansible$ python3 -m venv venv
vagrant@vagrant:~/08-ansible-06-module/ansible$
```
<details>

5. Активируйте виртуальное окружение: `. venv/bin/activate`. Дальнейшие действия производятся только в виртуальном окружении.

### Решение:

```bash
vagrant@vagrant:~/08-ansible-06-module/ansible$ . venv/bin/activate
(venv) vagrant@vagrant:~/08-ansible-06-module/ansible$
```

6. Установите зависимости `pip install -r requirements.txt`.

### Решение:

Выполнено.

<details><summary></summary>

```bash
(venv) vagrant@vagrant:~/08-ansible-06-module/ansible$ pip install -r requirements.txt
Collecting jinja2>=3.0.0
  Using cached Jinja2-3.1.2-py3-none-any.whl (133 kB)
Collecting PyYAML>=5.1
  Downloading PyYAML-6.0-cp38-cp38-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_12_x86_64.manylinux2010_x86_64.whl (701 kB)
     |████████████████████████████████| 701 kB 1.1 MB/s
Collecting cryptography
  Downloading cryptography-40.0.1-cp36-abi3-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (3.7 MB)
     |████████████████████████████████| 3.7 MB 508 kB/s 
Collecting packaging
  Downloading packaging-23.0-py3-none-any.whl (42 kB)
     |████████████████████████████████| 42 kB 848 kB/s 
Collecting importlib_resources<5.1,>=5.0
  Downloading importlib_resources-5.0.7-py3-none-any.whl (24 kB)
Collecting resolvelib<1.1.0,>=0.5.3
  Downloading resolvelib-1.0.1-py2.py3-none-any.whl (17 kB)
Collecting MarkupSafe>=2.0
  Downloading MarkupSafe-2.1.2-cp38-cp38-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (25 kB)
Collecting cffi>=1.12
  Downloading cffi-1.15.1-cp38-cp38-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (442 kB)
     |████████████████████████████████| 442 kB 5.9 MB/s
Collecting pycparser
  Downloading pycparser-2.21-py2.py3-none-any.whl (118 kB)
     |████████████████████████████████| 118 kB 3.8 MB/s
Installing collected packages: MarkupSafe, jinja2, PyYAML, pycparser, cffi, cryptography, packaging, importlib-resources, resolvelib
Successfully installed MarkupSafe-2.1.2 PyYAML-6.0 cffi-1.15.1 cryptography-40.0.1 importlib-resources-5.0.7 jinja2-3.1.2 packaging-23.0 pycparser-2.21 resolvelib-1.0.1
```
</details>

7. Запустите настройку окружения `. hacking/env-setup`.

### Решение:

Выполнено.

<details><summary></summary>

```bash
(venv) vagrant@vagrant:~/08-ansible-06-module/ansible$ . hacking/env-setup
running egg_info
creating lib/ansible_core.egg-info
writing lib/ansible_core.egg-info/PKG-INFO
writing dependency_links to lib/ansible_core.egg-info/dependency_links.txt
writing entry points to lib/ansible_core.egg-info/entry_points.txt
writing requirements to lib/ansible_core.egg-info/requires.txt
writing top-level names to lib/ansible_core.egg-info/top_level.txt
writing manifest file 'lib/ansible_core.egg-info/SOURCES.txt'
reading manifest file 'lib/ansible_core.egg-info/SOURCES.txt'
reading manifest template 'MANIFEST.in'
warning: no previously-included files found matching 'docs/docsite/rst_warnings'
warning: no previously-included files found matching 'docs/docsite/rst/conf.py'
warning: no previously-included files found matching 'docs/docsite/rst/index.rst'
warning: no previously-included files found matching 'docs/docsite/rst/dev_guide/index.rst'
warning: no previously-included files matching '*' found under directory 'docs/docsite/_build'
warning: no previously-included files matching '*.pyc' found under directory 'docs/docsite/_extensions'
warning: no previously-included files matching '*.pyo' found under directory 'docs/docsite/_extensions'
warning: no files found matching '*.ps1' under directory 'lib/ansible/modules/windows'
warning: no files found matching '*.yml' under directory 'lib/ansible/modules'
warning: no files found matching 'validate-modules' under directory 'test/lib/ansible_test/_util/controller/sanity/validate-modules'
writing manifest file 'lib/ansible_core.egg-info/SOURCES.txt'

Setting up Ansible to run out of checkout...

PATH=/home/vagrant/08-ansible-06-module/ansible/bin:/home/vagrant/08-ansible-06-module/ansible/venv/bin:/home/vagrant/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
PYTHONPATH=/home/vagrant/08-ansible-06-module/ansible/test/lib:/home/vagrant/08-ansible-06-module/ansible/lib
MANPATH=/home/vagrant/08-ansible-06-module/ansible/docs/man:/usr/local/man:/usr/local/share/man:/usr/share/man

Remember, you may wish to specify your host file with -i

Done!
```
</details>

8. Если все шаги прошли успешно — выйдите из виртуального окружения `deactivate`.

### Решение:

```bash
(venv) vagrant@vagrant:~/08-ansible-06-module/ansible$ deactivate
vagrant@vagrant:~/08-ansible-06-module/ansible$
```

9. Ваше окружение настроено. Чтобы запустить его, нужно находиться в директории `ansible` и выполнить конструкцию `. venv/bin/activate && . hacking/env-setup`.

## Основная часть

Ваша цель — написать собственный module, который вы можете использовать в своей role через playbook. Всё это должно быть собрано в виде collection и отправлено в ваш репозиторий.

**Шаг 1.** В виртуальном окружении создайте новый `my_own_module.py` файл.

**Шаг 2.** Наполните его содержимым:

```python
#!/usr/bin/python

# Copyright: (c) 2018, Terry Jones <terry.jones@example.org>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)
from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

DOCUMENTATION = r'''
---
module: my_test

short_description: This is my test module

# If this is part of a collection, you need to use semantic versioning,
# i.e. the version is of the form "2.5.0" and not "2.4".
version_added: "1.0.0"

description: This is my longer description explaining my test module.

options:
    name:
        description: This is the message to send to the test module.
        required: true
        type: str
    new:
        description:
            - Control to demo if the result of this module is changed or not.
            - Parameter description can be a list as well.
        required: false
        type: bool
# Specify this value according to your collection
# in format of namespace.collection.doc_fragment_name
extends_documentation_fragment:
    - my_namespace.my_collection.my_doc_fragment_name

author:
    - Your Name (@yourGitHubHandle)
'''

EXAMPLES = r'''
# Pass in a message
- name: Test with a message
  my_namespace.my_collection.my_test:
    name: hello world

# pass in a message and have changed true
- name: Test with a message and changed output
  my_namespace.my_collection.my_test:
    name: hello world
    new: true

# fail the module
- name: Test failure of the module
  my_namespace.my_collection.my_test:
    name: fail me
'''

RETURN = r'''
# These are examples of possible return values, and in general should use other names for return values.
original_message:
    description: The original name param that was passed in.
    type: str
    returned: always
    sample: 'hello world'
message:
    description: The output message that the test module generates.
    type: str
    returned: always
    sample: 'goodbye'
'''

from ansible.module_utils.basic import AnsibleModule


def run_module():
    # define available arguments/parameters a user can pass to the module
    module_args = dict(
        name=dict(type='str', required=True),
        new=dict(type='bool', required=False, default=False)
    )

    # seed the result dict in the object
    # we primarily care about changed and state
    # changed is if this module effectively modified the target
    # state will include any data that you want your module to pass back
    # for consumption, for example, in a subsequent task
    result = dict(
        changed=False,
        original_message='',
        message=''
    )

    # the AnsibleModule object will be our abstraction working with Ansible
    # this includes instantiation, a couple of common attr would be the
    # args/params passed to the execution, as well as if the module
    # supports check mode
    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    # if the user is working with this module in only check mode we do not
    # want to make any changes to the environment, just return the current
    # state with no modifications
    if module.check_mode:
        module.exit_json(**result)

    # manipulate or modify the state as needed (this is going to be the
    # part where your module will do what it needs to do)
    result['original_message'] = module.params['name']
    result['message'] = 'goodbye'

    # use whatever logic you need to determine whether or not this module
    # made any modifications to your target
    if module.params['new']:
        result['changed'] = True

    # during the execution of the module, if there is an exception or a
    # conditional state that effectively causes a failure, run
    # AnsibleModule.fail_json() to pass in the message and the result
    if module.params['name'] == 'fail me':
        module.fail_json(msg='You requested this to fail', **result)

    # in the event of a successful module execution, you will want to
    # simple AnsibleModule.exit_json(), passing the key/value results
    module.exit_json(**result)


def main():
    run_module()


if __name__ == '__main__':
    main()
```
Или возьмите это наполнение [из статьи](https://docs.ansible.com/ansible/latest/dev_guide/developing_modules_general.html#creating-a-module).

**Шаг 3.** Заполните файл в соответствии с требованиями Ansible так, чтобы он выполнял основную задачу: module должен создавать текстовый файл на удалённом хосте по пути, определённом в параметре `path`, с содержимым, определённым в параметре `content`.

**Шаг 4.** Проверьте module на исполняемость локально.

**Шаг 5.** Напишите single task playbook и используйте module в нём.

**Шаг 6.** Проверьте через playbook на идемпотентность.

**Шаг 7.** Выйдите из виртуального окружения.

**Шаг 8.** Инициализируйте новую collection: `ansible-galaxy collection init my_own_namespace.yandex_cloud_elk`.

**Шаг 9.** В эту collection перенесите свой module в соответствующую директорию.

**Шаг 10.** Single task playbook преобразуйте в single task role и перенесите в collection. У role должны быть default всех параметров module.

**Шаг 11.** Создайте playbook для использования этой role.

**Шаг 12.** Заполните всю документацию по collection, выложите в свой репозиторий, поставьте тег `1.0.0` на этот коммит.

**Шаг 13.** Создайте .tar.gz этой collection: `ansible-galaxy collection build` в корневой директории collection.

**Шаг 14.** Создайте ещё одну директорию любого наименования, перенесите туда single task playbook и архив c collection.

**Шаг 15.** Установите collection из локального архива: `ansible-galaxy collection install <archivename>.tar.gz`.

**Шаг 16.** Запустите playbook, убедитесь, что он работает.

**Шаг 17.** В ответ необходимо прислать ссылки на collection и tar.gz архив, а также скриншоты выполнения пунктов 4, 6, 15 и 16.

## Необязательная часть

1. Реализуйте свой модуль для создания хостов в Yandex Cloud.
2. Модуль может и должен иметь зависимость от `yc`, основной функционал: создание ВМ с нужным сайзингом на основе нужной ОС. Дополнительные модули по созданию кластеров ClickHouse, MySQL и прочего реализовывать не надо, достаточно простейшего создания ВМ.
3. Модуль может формировать динамическое inventory, но эта часть не является обязательной, достаточно, чтобы он делал хосты с указанной спецификацией в YAML.
4. Протестируйте модуль на идемпотентность, исполнимость. При успехе добавьте этот модуль в свою коллекцию.
5. Измените playbook так, чтобы он умел создавать инфраструктуру под inventory, а после устанавливал весь ваш стек Observability на нужные хосты и настраивал его.
6. В итоге ваша коллекция обязательно должна содержать: clickhouse-role (если есть своя), lighthouse-role, vector-role, два модуля: my_own_module и модуль управления Yandex Cloud хостами и playbook, который демонстрирует создание Observability стека.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
