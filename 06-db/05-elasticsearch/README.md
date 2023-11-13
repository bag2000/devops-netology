# Домашнее задание к занятию 5. «Elasticsearch»

## Задача 1

В этом задании вы потренируетесь в:

- установке Elasticsearch,
- первоначальном конфигурировании Elasticsearch,
- запуске Elasticsearch в Docker.

Используя Docker-образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для Elasticsearch,
- соберите Docker-образ и сделайте `push` в ваш docker.io-репозиторий,
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины.

Требования к `elasticsearch.yml`:

- данные `path` должны сохраняться в `/var/lib`,
- имя ноды должно быть `netology_test`.

В ответе приведите:

- текст Dockerfile-манифеста,
- ссылку на образ в репозитории dockerhub,
- ответ `Elasticsearch` на запрос пути `/` в json-виде.

Подсказки:

- возможно, вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum,
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml,
- при некоторых проблемах вам поможет Docker-директива ulimit,
- Elasticsearch в логах обычно описывает проблему и пути её решения.

Далее мы будем работать с этим экземпляром Elasticsearch.

### Ответ к заданию 1:
Текст Dockerfile-манифеста и конфига elasticsearch.yml
```
root@srv1:/home/adm2/elastic# cat elasticsearch.yml
node.name: netology_test
path.data: /var/lib/elasticsearch
path.logs: /var/log/elasticsearch
network.host: 0.0.0.0
discovery.type: single-node
path.repo: /var/lib/elasticsearch
ingest.geoip.downloader.enabled: false
root@srv1:/home/adm2/elastic#
root@srv1:/home/adm2/elastic#
root@srv1:/home/adm2/elastic# cat Dockerfile
FROM ubuntu

EXPOSE 9200 9300

USER 0

RUN apt-get update && \
    apt-get install -y gpg wget && \
    echo "deb [trusted=yes signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] \
    https://mirror.yandex.ru/mirrors/elastic/7/ stable main" > /etc/apt/sources.list.d/elastic-7.x.list && \
    wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | \
    gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg && \
    useradd -m -u 1000 elasticsearch && \
    apt-get update && \
    apt-get install -y elasticsearch

COPY --chown=elasticsearch:elasticsearch ./elasticsearch.yml /etc/elasticsearch/elasticsearch.yml

ENV ES_CONF="/etc/elasticsearch"

USER 1000

CMD ["sh", "-c", "/usr/share/elasticsearch/bin/elasticsearch"]
```

Запуск контейнера
```
docker run --rm -p 9200:9200 -p 9300:9300 my-elastic:latest
```

[Ссылка на образ] (https://hub.docker.com/repository/docker/bagerz2000/my-elastic/general)

## Задача 2

В этом задании вы научитесь:

- создавать и удалять индексы,
- изучать состояние кластера,
- обосновывать причину деградации доступности данных.

Ознакомьтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `Elasticsearch` 3 индекса в соответствии с таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API, и **приведите в ответе** на задание.

Получите состояние кластера `Elasticsearch`, используя API.

Как вы думаете, почему часть индексов и кластер находятся в состоянии yellow?

Удалите все индексы.

**Важно**

При проектировании кластера Elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

### Ответ к заданию 2:

Список индексов и их статусов:
```
root@srv1:/home/adm2# curl -X GET localhost:9200/_cat/indices
green  open .geoip_databases bHqPNoWeQryo6Nueqo_Cyg 1 0 39 0 37.8mb 37.8mb
green  open ind-1            PQ4jBhfJRLyQyQbfwC7oHg 1 0  0 0   226b   226b
yellow open ind-3            6pYZKtWkTryJfewyfqmfBA 4 2  0 0   904b   904b
yellow open ind-2            BHJkrKU-RTSPUZDTRmCjiw 2 1  0 0   452b   452b
```
Cостояние кластера:
```
root@srv1:/home/adm2# curl -X GET localhost:9200/
{
  "name" : "netology_test",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "i14UNUrJSXaZv5I5_8rlmQ",
  "version" : {
    "number" : "7.17.9",
    "build_flavor" : "default",
    "build_type" : "deb",
    "build_hash" : "ef48222227ee6b9e70e502f0f0daa52435ee634d",
    "build_date" : "2023-01-31T05:34:43.305517834Z",
    "build_snapshot" : false,
    "lucene_version" : "8.11.1",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
```
Как вы думаете, почему часть индексов и кластер находятся в состоянии yellow?  
У них должны быть реплики, но в кластере всего одна нода, поэтому размещать их негде. В таком случае кластер помечает их желтыми.


## Задача 3

В этом задании вы научитесь:

- создавать бэкапы данных,
- восстанавливать индексы из бэкапов.

Создайте директорию `{путь до корневой директории с Elasticsearch в образе}/snapshots`.

Используя API, [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
эту директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `Elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`.

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `Elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

### Ответ к заданию 3:

Запрос API и результат вызова API для создания репозитория:
```
root@srv1:/home/adm2# curl -X PUT "localhost:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d'
{
  "type": "fs",
  "settings": {
    "location": "/var/lib/elasticsearch/snapshots"
  }
}'
{
  "acknowledged" : true
}
```
Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов:
```
root@srv1:/home/adm2# curl -X GET localhost:9200/_cat/indices
green open .geoip_databases bHqPNoWeQryo6Nueqo_Cyg 1 0 39 0 37.8mb 37.8mb
green open test             dRj-DorZRNyXLqCv7WI49w 1 0  0 0   226b   226b
```
Cписок файлов в директории со `snapshot`:
```
root@srv1:/home/adm2# docker exec 58016e0ca811 ls -l /var/lib/elasticsearch/snapshots
total 48
-rw-r--r-- 1 elasticsearch elasticsearch  1426 Oct 26 13:30 index-0
-rw-r--r-- 1 elasticsearch elasticsearch     8 Oct 26 13:30 index.latest
drwxr-sr-x 6 elasticsearch elasticsearch  4096 Oct 26 13:30 indices
-rw-r--r-- 1 elasticsearch elasticsearch 29276 Oct 26 13:30 meta-1qzmAiM3R76DLDoN2ZcanA.dat
-rw-r--r-- 1 elasticsearch elasticsearch   713 Oct 26 13:30 snap-1qzmAiM3R76DLDoN2ZcanA.dat
```
Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.
```
root@srv1:/home/adm2# curl -X GET localhost:9200/_cat/indices
green open test-2           S9lrUROBQwKofAZBL8LTlw 1 0  0 0   226b   226b
green open .geoip_databases bHqPNoWeQryo6Nueqo_Cyg 1 0 39 0 37.8mb 37.8mb
```
**Приведите в ответе** запрос к API восстановления и итоговый список индексов.
```
curl -X DELETE "localhost:9200/_all?pretty"
curl -X POST "localhost:9200/.ds-ilm-history-5-2023.10.26-000001/_close?pretty"
curl -X POST "localhost:9200/.ds-.logs-deprecation.elasticsearch-default-2023.10.26-000001/_close?pretty"
curl -X POST "localhost:9200/_snapshot/netology_backup/first-snapshot/_restore?pretty"

root@srv1:/home/adm2/elastic# curl -X GET localhost:9200/_cat/indices
green open .geoip_databases FNJCcFWjSGyzOhDOKykJlA 1 0 39 0 37.8mb 37.8mb
green open test             wf9k01KsRpCRTHKRomwOYA 1 0  0 0   226b   226b
```

Подсказки:

- возможно, вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `Elasticsearch`.

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---

