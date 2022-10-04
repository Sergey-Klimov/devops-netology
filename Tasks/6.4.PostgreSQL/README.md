# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
- подключения к БД
- вывода списка таблиц
- вывода описания содержимого таблиц
- выхода из psql

**Решение:**


```bash
vagrant@vagrant:~$ cat docker-compose.yml
version: '3.5'
services:
  postgres:
    image: postgres:13
    environment:
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_USER=postgres
    volumes:
      - ./data:/var/lib/postgresql/data
      - ./backup:/data/backup/postgres
    ports:
      - "5432:5432"
    restart: always    
  
```

- вывода списка БД

```sql
vagrant@vagrant:~$ docker compose ps
NAME                 COMMAND                  SERVICE             STATUS              PORTS
vagrant-postgres-1   "docker-entrypoint.s…"   postgres            running             0.0.0.0:5432->5432/tcp, :::5432->5432/tcp

vagrant@vagrant:~$ docker exec -it test_db-postgres-1 psql -h localhost -p 5432 -U postgres -W
Password:
psql (12.12 (Debian 12.12-1.pgdg110+1))
Type "help" for help.

postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(3 rows)
```

- подключения к БД

```sql
postgres=# \c postgres
Password:
You are now connected to database "postgres" as user "postgres".
postgres=#
```

- вывода списка таблиц

```sql
postgres=# \dt
Did not find any relations.
postgres=# \dt+
Did not find any relations.
```

- вывода описания содержимого таблиц

```sql
postgres=# \d
Did not find any relations.
postgres=# \d pg_database
               Table "pg_catalog.pg_database"
    Column     |   Type    | Collation | Nullable | Default
---------------+-----------+-----------+----------+---------
 oid           | oid       |           | not null |
 datname       | name      |           | not null |
 datdba        | oid       |           | not null |
 encoding      | integer   |           | not null |
 datcollate    | name      |           | not null |
 datctype      | name      |           | not null |
 datistemplate | boolean   |           | not null |
 datallowconn  | boolean   |           | not null |
 datconnlimit  | integer   |           | not null |
 datlastsysoid | oid       |           | not null |
 datfrozenxid  | xid       |           | not null |
 datminmxid    | xid       |           | not null |
 dattablespace | oid       |           | not null |
 datacl        | aclitem[] |           |          |
Indexes:
    "pg_database_datname_index" UNIQUE, btree (datname), tablespace "pg_global"
    "pg_database_oid_index" UNIQUE, btree (oid), tablespace "pg_global"
Tablespace: "pg_global"
```
- выхода из psql

```sql
postgres=# \q
root@fb64993d23b1:/#
```

## Задача 2

Используя `psql` создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

**Решение:**

- Используя `psql` создайте БД `test_database`:

```bash
postgres=# CREATE DATABASE test_database;
CREATE DATABASE

postgres=# \l
                                   List of databases
     Name      |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
---------------+----------+----------+------------+------------+-----------------------
 postgres      | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0     | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
               |          |          |            |            | postgres=CTc/postgres
 template1     | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
               |          |          |            |            | postgres=CTc/postgres
 test_database | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
(4 rows)
```

- Восстановите бэкап БД в `test_database`:

```bash
root@fb64993d23b1:/# ls -l /data/backup/postgres/
total 4
-rwxr-xr-x 1 root root 2082 Oct  4 20:18 test_dump.sql
root@fb64993d23b1:/# psql -U postgres test_database < /data/backup/postgres/test_dump.sql
SET
SET
SET
SET
SET
 set_config
------------

(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval
--------
      8
(1 row)

ALTER TABLE
```

- Перейдите в управляющую консоль `psql` внутри контейнера:

```bash
root@fb64993d23b1:/# psql -h localhost -p 5432 -U postgres -W test_database
Password:
psql (13.8 (Debian 13.8-1.pgdg110+1))
Type "help" for help.
```

- Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице:

```sql
test_database=# \l
                                   List of databases
     Name      |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
---------------+----------+----------+------------+------------+-----------------------
 postgres      | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0     | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
               |          |          |            |            | postgres=CTc/postgres
 template1     | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
               |          |          |            |            | postgres=CTc/postgres
 test_database | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
(4 rows)

test_database=# \d
              List of relations
 Schema |     Name      |   Type   |  Owner
--------+---------------+----------+----------
 public | orders        | table    | postgres
 public | orders_id_seq | sequence | postgres
(2 rows)

test_database=# analyze verbose public.orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
```
- Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

```sql
test_database=# SELECT tablename, attname, avg_width FROM pg_stats WHERE avg_width IN (SELECT MAX(avg_width) FROM pg_stats WHERE tablename = 'orders') and tablename = 'orders';
 tablename | attname | avg_width
-----------+---------+-----------
 orders    | title   |        16
(1 row)
```

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

**Решение**

Что бы выполнить шардирование необходимо:

- переименовать текущую таблицу orders в orders_old:

```sql
test_database=# ALTER TABLE orders RENAME TO orders_old;
ALTER TABLE
test_database=# \d
              List of relations
 Schema |     Name      |   Type   |  Owner
--------+---------------+----------+----------
 public | orders_id_seq | sequence | postgres
 public | orders_old    | table    | postgres
```
- создать пустую таблицу с именем orders:

```sql
test_database=# CREATE TABLE orders AS table orders_old WITH NO DATA;
CREATE TABLE AS
test_database=# \d
              List of relations
 Schema |     Name      |   Type   |  Owner
--------+---------------+----------+----------
 public | orders        | table    | postgres
 public | orders_id_seq | sequence | postgres
 public | orders_old    | table    | postgres
(3 rows)
```
- создаем две пустые таблицы orders_1 и orders_2 с наследованием от orders и задаём ограничения в этих таблицах
- на значение ключа price:

```sql
CREATE TABLE orders_1 (
    CHECK (price > 499)
) INHERITS (orders);
CREATE TABLE orders_2 (
    CHECK (price <= 499)
) INHERITS (orders);
```
- Определяем правила, при котором INSERT в таблицу orders будет заменяться на INSERT в соответствующую дочернюю таблицу:

```sql
CREATE RULE orders_1_insert AS
ON INSERT TO orders WHERE
    (price > 499)
DO INSTEAD
    INSERT INTO orders_1 VALUES (NEW.*);
       
CREATE RULE orders_2_insert AS
ON INSERT TO orders WHERE
    (price <= 499)
DO INSTEAD
    INSERT INTO orders_2 VALUES (NEW.*);
``` 

- Копирование таблицы orders_old в orders через INSERT:
```sql
INSERT INTO orders
SELECT * FROM orders_old;

test_database=# \d
              List of relations
 Schema |     Name      |   Type   |  Owner
--------+---------------+----------+----------
 public | orders        | table    | postgres
 public | orders_1      | table    | postgres
 public | orders_2      | table    | postgres
 public | orders_id_seq | sequence | postgres
 public | orders_old    | table    | postgres
(5 rows)
```

Смотрим, что получилось:

```sql
test_database=# \d
              List of relations
 Schema |     Name      |   Type   |  Owner   
--------+---------------+----------+----------
 public | orders        | table    | postgres
 public | orders_1      | table    | postgres
 public | orders_2      | table    | postgres
 public | orders_id_seq | sequence | postgres
 public | orders_old    | table    | postgres
test_database=# TABLE orders_1;
 id |       title        | price 
----+--------------------+-------
  2 | My little database |   500
  6 | WAL never lies     |   900
  8 | Dbiezdmin          |   501
(3 rows)

test_database=# TABLE orders_2;
 id |        title         | price 
----+----------------------+-------
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  7 | Me and my bash-pet   |   499
(5 rows)

test_database=# TABLE orders;
 id |        title         | price 
----+----------------------+-------
  2 | My little database   |   500
  6 | WAL never lies       |   900
  8 | Dbiezdmin            |   501
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  7 | Me and my bash-pet   |   499
(8 rows)
```

- Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

Да, можно было:

```sql
CREATE TABLE orders (
    id integer NOT NULL,
    title character varying(80) NOT NULL,
    price integer DEFAULT 0
) PARTITION BY RANGE (price);
```
Далее создаем orders_1 и orders_2 с указанными ограничениями ключа price:
```sql
CREATE TABLE orders_1 PARTITION OF orders
    FOR VALUES GREATER THAN ('499');
CREATE TABLE orders_2 PARTITION OF orders
    FOR VALUES FROM ('0') TO ('499');
```

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

**Решение**

- Используя утилиту `pg_dump` создайте бекап БД `test_database:

```bash
test_database=# \q
root@fb64993d23b1:/# pg_dump -U postgres -v -f /data/backup/postgres/test_database.sql
pg_dump: last built-in OID is 16383
pg_dump: reading extensions
pg_dump: identifying extension members
pg_dump: reading schemas
pg_dump: reading user-defined tables
pg_dump: reading user-defined functions
pg_dump: reading user-defined types
pg_dump: reading procedural languages
pg_dump: reading user-defined aggregate functions
pg_dump: reading user-defined operators
pg_dump: reading user-defined access methods
pg_dump: reading user-defined operator classes
pg_dump: reading user-defined operator families
pg_dump: reading user-defined text search parsers
pg_dump: reading user-defined text search templates
pg_dump: reading user-defined text search dictionaries
pg_dump: reading user-defined text search configurations
pg_dump: reading user-defined foreign-data wrappers
pg_dump: reading user-defined foreign servers
pg_dump: reading default privileges
pg_dump: reading user-defined collations
pg_dump: reading user-defined conversions
pg_dump: reading type casts
pg_dump: reading transforms
pg_dump: reading table inheritance information
pg_dump: reading event triggers
pg_dump: finding extension tables
pg_dump: finding inheritance relationships
pg_dump: reading column info for interesting tables
pg_dump: flagging inherited columns in subtables
pg_dump: reading indexes
pg_dump: flagging indexes in partitioned tables
pg_dump: reading extended statistics
pg_dump: reading constraints
pg_dump: reading triggers
pg_dump: reading rewrite rules
pg_dump: reading policies
pg_dump: reading row-level security policies
pg_dump: reading publications
pg_dump: reading publication membership
pg_dump: reading subscriptions
pg_dump: reading large objects
pg_dump: reading dependency data
pg_dump: saving encoding = UTF8
pg_dump: saving standard_conforming_strings = on
pg_dump: saving search_path =
pg_dump: implied data-only restore

root@fb64993d23b1:/# ls -la /data/backup/postgres/
total 16
drwxr-xr-x 2 root root 4096 Oct  4 21:11 .
drwxr-xr-x 3 root root 4096 Oct  4 19:39 ..
-rw-r--r-- 1 root root  621 Oct  4 21:11 test_database.sql
-rwxr-xr-x 1 root root 2082 Oct  4 20:18 test_dump.sql
```

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

- Добавить ограничение `UNIQUE`:

```sql
CREATE TABLE public.orders (
    id integer NOT NULL,
    title character varying(80) NOT NULL UNIQUE,
    price integer DEFAULT 0
);
```