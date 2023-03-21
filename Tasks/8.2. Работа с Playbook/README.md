# Домашнее задание к занятию "8.2 Работа с Playbook"

## Подготовка к выполнению

1. (Необязательно) Изучите, что такое [clickhouse](https://www.youtube.com/watch?v=fjTNS2zkeBs) и [vector](https://www.youtube.com/watch?v=CgEhyffisLY)
2. Создайте свой собственный (или используйте старый) публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.
4. Подготовьте хосты в соответствии с группами из предподготовленного playbook.

## Основная часть

1. Приготовьте свой собственный inventory файл `prod.yml`.
2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev).
3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, установить vector.
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.

---

## Решение:
### Подготовка к выполнению


1. Что такое [clickhouse](https://www.youtube.com/watch?v=fjTNS2zkeBs) и [vector](https://www.youtube.com/watch?v=CgEhyffisLY) изучил, на канал подписался, палец вверх поставил, было интересно, спасибо за видео.
2. Скачал из репозитория с домашним заданием и перенесите его в свой репозиторий: [8.2. Работа с Playbook](https://github.com/Sergey-Klimov/ansiblegit/tree/main/08-ansible-02-playbook)
3. Сделано.
4. Подготовил виртуальную машину с CentOS 7: 
```bash
vagrant@vagrant:~$ docker run --name centos7 -d pycontribs/centos:7 sleep 6000000
Unable to find image 'pycontribs/centos:7' locally
7: Pulling from pycontribs/centos
2d473b07cdd5: Pull complete 
43e1b1841fcc: Pull complete
85bf99ab446d: Pull complete
Digest: sha256:b3ce994016fd728998f8ebca21eb89bf4e88dbc01ec2603c04cc9c56ca964c69
Status: Downloaded newer image for pycontribs/centos:7
82824f810fbe3be8ac83c1242aa3557a398a6c562aef62cbe7551f917cd5d714
vagrant@vagrant:~$ docker ps -a
CONTAINER ID   IMAGE                      COMMAND           CREATED          STATUS          PORTS     NAMES
82824f810fbe   pycontribs/centos:7        "sleep 6000000"   2 minutes ago    Up 2 minutes              centos7

```

### Основная часть

