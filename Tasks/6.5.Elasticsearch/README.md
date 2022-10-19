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

vagrant@vagrant:~/data$ cat Dockerfile

```dockerfile
FROM centos:7
RUN cd /opt && \
    groupadd elasticsearch && \
    useradd -c "elasticsearch" -g elasticsearch elasticsearch &&\
    yum update -y && yum -y install wget perl-Digest-SHA && \
    wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.17.6-linux-x86_64.tar.gz &&\
    wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.17.6-linux-x86_64.tar.gz.sha512 &&\
    shasum -a 512 -c elasticsearch-7.17.6-linux-x86_64.tar.gz.sha512 &&\
    tar -xzf elasticsearch-7.17.6-linux-x86_64.tar.gz &&\
	rm elasticsearch-7.17.6-linux-x86_64.tar.gz elasticsearch-7.17.6-linux-x86_64.tar.gz.sha512 && \
	mkdir /var/lib/data && chmod -R 777 /var/lib/data && \
	chown -R elasticsearch:elasticsearch /opt/elasticsearch-7.17.6 && \
	yum -y remove wget perl-Digest-SHA && \
	yum clean all

COPY elasticsearch.yml /elasticsearch/config
RUN chmod -R 777 /elasticsearch && \
    chmod -R 777 /var/lib/data
USER elasticsearch

CMD ["/elasticsearch/bin/elasticsearch"]

EXPOSE 9200
EXPOSE 9300
```

[elasticsearch.yml](https://github.com/Sergey-Klimov/devops-netology/blame/main/Tasks/6.5.Elasticsearch/elasticsearch.yml)

[Ссылка на образ. Tag:7.17.6](https://hub.docker.com/repository/docker/sergeyklimov/elasticsearch)

```bash
vagrant@vagrant:~/data$ docker exec -it elasticsearch bash
root@26b475353a8b:/usr/share/elasticsearch# curl http://localhost:9200
{
  "name" : "26b475353a8b",
  "cluster_name" : "docker-cluster",
  "cluster_uuid" : "qPt9AbZfSO-S5HOGVsvAZw",
  "version" : {
    "number" : "7.17.6",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "f65e9d338dc1d07b642e14a27f338990148ee5b6",
    "build_date" : "2022-08-23T11:08:48.893373482Z",
    "build_snapshot" : false,
    "lucene_version" : "8.11.1",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
```

## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

Получите состояние кластера `elasticsearch`, используя API.

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Удалите все индексы.

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

**Решение:**

Комманды для создания индексов согласно заданию:

```bash
root@26b475353a8b:/usr/share/elasticsearch# curl -X PUT "localhost:9200/ind-1?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 0
  }
}
'
{
  "acknowledged" : true,
  "shards_acknowledged" : false,
  "index" : "ind-1"
}
root@26b475353a8b:/usr/share/elasticsearch# curl -X PUT "localhost:9200/ind-2?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "number_of_shards": 2,
    "number_of_replicas": 1
  }
}
'
{
  "acknowledged" : true,
  "shards_acknowledged" : false,
  "index" : "ind-2"
}
root@26b475353a8b:/usr/share/elasticsearch# curl -X PUT "localhost:9200/ind-3?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "number_of_shards": 4,
    "number_of_replicas": 2
  }
}
'
{
  "acknowledged" : true,
  "shards_acknowledged" : false,
  "index" : "ind-3"
}
```
Получение списка индексов и их параметров:

```bash
root@26b475353a8b:/usr/share/elasticsearch# curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases _lTmYZ_rTHqOu-LOJduD4g   1   0         41            0       39mb           39mb
green  open   ind-1            4daw6V9PS1WHMsasnVx5WQ   1   0          0            0       226b           226b
yellow open   ind-3            G22MGlqYT26F3KIaZEl78g   4   2          0            0       904b           904b
yellow open   ind-2            UVD7wAMsRg6ASKKMzSO69A   2   1          0            0       452b           452b

root@26b475353a8b:/usr/share/elasticsearch# curl -X GET 'http://localhost:9200/_cluster/health/ind-1?pretty'
{
  "cluster_name" : "docker-cluster",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 1,
  "active_shards" : 1,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 100.0
  
root@26b475353a8b:/usr/share/elasticsearch# curl -X GET 'http://localhost:9200/_cluster/health/ind-2?pretty'
{
  "cluster_name" : "docker-cluster",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 2,
  "active_shards" : 2,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 2,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
  
root@26b475353a8b:/usr/share/elasticsearch# curl -X GET 'http://localhost:9200/_cluster/health/ind-3?pretty'
{
  "cluster_name" : "docker-cluster",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 4,
  "active_shards" : 4,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 8,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}
```

Состояние кластера:

```bash
root@26b475353a8b:/usr/share/elasticsearch# curl -XGET localhost:9200/_cluster/health/?pretty=true
{
  "cluster_name" : "docker-cluster",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 10,
  "active_shards" : 10,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}
```
Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Два индекса в статусе Yellow потому что у них указано число реплик больше 0,
а в задании один сервер и по этому реплицировать некуда.

Удалите все индексы:

```bash
root@26b475353a8b:/usr/share/elasticsearch# curl -X DELETE 'http://localhost:9200/ind-1?pretty'
{
  "acknowledged" : true
}
root@26b475353a8b:/usr/share/elasticsearch# curl -X DELETE 'http://localhost:9200/ind-2?pretty'
{
  "acknowledged" : true
}

root@26b475353a8b:/usr/share/elasticsearch# curl -X DELETE 'http://localhost:9200/ind-3?pretty'
{
  "acknowledged" : true
}

root@26b475353a8b:/usr/share/elasticsearch# curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases _lTmYZ_rTHqOu-LOJduD4g   1   0         41            0       39mb           39mb
```

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

**Решение:**

**Приведите в ответе** запрос API и результат вызова API для создания репозитория:

```bash
root@26b475353a8b:/usr/share/elasticsearch# curl -XPOST localhost:9200/_snapshot/netology_backup?pretty -H 'Content-Type: application/json' -d'{"type": "fs", "settings": { "location":"/elasticsearch/snapshots" }}'
{
  "acknowledged" : true
}
```
Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов:
```bash
root@26b475353a8b:/usr/share/elasticsearch# curl -X PUT "localhost:9200/test?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 0
  }
}
'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test"
}
curl -X GET 'http://localhost:9200/_cat/indices?v' 
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases _lTmYZ_rTHqOu-LOJduD4g   1   0         41            0       39mb           39mb
green  open   test             pE2OF8MrRqmJ_P7QhByI6w   1   0          0            0       208b           208b
```

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.
```bash
root@26b475353a8b:/usr/share/elasticsearch# curl -X PUT localhost:9200/_snapshot/netology_backup/elasticsearch?wait_for_completion=true
{"snapshot":{"snapshot":"elasticsearch","uuid":"ed0U73ORTpylzoL0sKeG4g","repository":"netology_backup","version_id":7150299,"version":"7.17.6","indices":["test",".geoip_databases"],"data_streams":[],"include_global_state":true,"state":"SUCCESS","start_time":"2022-10-19T020:56:10.048Z","start_time_in_millis":1639032972048,"end_time":"2022-10-19T020:56:52.018Z","end_time_in_millis":1639032973050,"duration_in_millis":1002,"failures":[],"shards":{"total":2,"failed":0,"successful":2},"feature_states":[{"feature_name":"geoip","indices":[".geoip_databases"]}]}}
[root@26b475353a8b snapshots]$ ll
total 44
-rw-r--r-- 1 elasticsearch root   831 Oct  19 20:56 index-0
-rw-r--r-- 1 elasticsearch root     8 Oct  19 20:56 index.latest
drwxr-xr-x 4 elasticsearch root  4096 Oct  19 20:56 indices
-rw-r--r-- 1 elasticsearch root 27702 Oct  19 20:56 meta-ed0U73ORTpylzoL0sKeG4g.dat
-rw-r--r-- 1 elasticsearch root   440 Oct  19 20:56 snap-ed0U73ORTpylzoL0sKeG4g.dat
```

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов:
```bash
root@26b475353a8b:/usr/share/elasticsearch# curl -X DELETE 'http://localhost:9200/test?pretty'
{
  "acknowledged" : true
}
root@26b475353a8b:/usr/share/elasticsearch# curl -X PUT "localhost:9200/test-2?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 0
  }
}
'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test-2"
}
root@26b475353a8b:/usr/share/elasticsearch# curl -X GET 'http://localhost:9200/_cat/indices?v' 
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases _lTmYZ_rTHqOu-LOJduD4g   1   0         41            0       39mb           39mb
green  open   test-2           9oPRa-AySV6jk0K8TfKn7g   1   0          0            0       208b           208b
```
[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов:
```bash
root@26b475353a8b:/usr/share/elasticsearch# curl -X POST "localhost:9200/_snapshot/netology_backup/elasticsearch/_restore?pretty" -H 'Content-Type: application/json' -d'
{
  "indices": "test"
}
'
{
  "accepted" : true
}
vagrant@vagrant:~$ curl -X GET 'http://localhost:9200/_cat/indices?v' 
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases _lTmYZ_rTHqOu-LOJduD4g   1   0         41            0       39mb           39mb
green  open   test-2           9oPRa-AySV6jk0K8TfKn7g   1   0          0            0       208b           208b
green  open   test             FWMVL6j4QHmwCwci5YVDcQ   1   0          0            0       208b           208b
```