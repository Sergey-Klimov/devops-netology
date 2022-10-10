# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.

**Решение:**

```bash
vagrant@vagrant:~/data$ ls -la
total 553045
drwxrwxrwx 1 vagrant vagrant         0 Oct 10 18:49 .
drwxr-xr-x 9 vagrant vagrant      4096 Oct  9 13:58 ..
-rwxrwxrwx 1 vagrant vagrant       748 Oct 10 18:21 Dockerfile
-rwxrwxrwx 1 vagrant vagrant 566286512 Oct  8 21:41 elasticsearch-8.4.3-linux-x86_64.tar.gz
-rwxrwxrwx 1 vagrant vagrant        80 Oct  8 23:09 elasticsearch.yml
 ```
vagrant@vagrant:~/data$ cat Dockerfile

```dockerfile
FROM centos:7
COPY elasticsearch-8.4.3-linux-x86_64.tar.gz   /opt
#COPY elasticsearch-8.4.3-linux-x86_64.tar.gz.sha512  /opt
RUN cd /opt && \
    groupadd elasticsearch && \
    useradd -c "elasticsearch" -g elasticsearch elasticsearch &&\
    yum update -y && yum -y install perl-Digest-SHA && \
    #shasum -a 512 -c elasticsearch-8.4.3-linux-x86_64.tar.gz.sha512 && \
    tar -xzf elasticsearch-8.4.3-linux-x86_64.tar.gz && \
    cd elasticsearch-8.4.3/ && \
    mkdir /var/lib/data && chmod -R 777 /var/lib/data && \
    chown -R elasticsearch:elasticsearch /opt/elasticsearch-8.4.3 && \
    yum clean all
USER elasticsearch
WORKDIR /opt/elasticsearch-8.4.3/
COPY elasticsearch.yml  config/
EXPOSE 9200 9300
ENTRYPOINT ["bin/elasticsearch"]
```

vagrant@vagrant:~/data$ cat elasticsearch.yml

```yaml
node:
  name: netology_test
path:
  data: /var/lib/data
xpack.ml.enabled: false
```

[Ссылка на образ](https://hub.docker.com/repository/docker/sergeyklimov/elasticsearch)
