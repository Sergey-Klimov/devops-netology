# Домашнее задание к занятию "6.2. SQL"

## Задача 1
   
Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.
   
**Решение:**
```bash
vagrant@vagrant:~$ cat docker-compose.yml
version: '3.5'
services:
  postgres:
    image: postgres:12
    environment:
      PGDATA: /var/lib/postgresql/data/some_name/
      POSTGRES_HOST_AUTH_METHOD: "trust"
    ports:
    - "5432"
    restart: always
    volumes:
    - /etc/postgresql/12/postgresql.conf:/var/lib/postgresql/data/postgresql.conf
    - db_data:/var/lib/postgresql/data
    - ./backup:/data/backup/postgres
volumes:
  db_data:
vagrant@vagrant:~$ docker compose ps
NAME                 COMMAND                  SERVICE             STATUS              PORTS
vagrant-postgres-1   "docker-entrypoint.s…"   postgres            running             0.0.0.0:5432->5432/tcp, :::5432->5432/tcp


vagrant@vagrant:~$ docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS          PORTS                                         NAMES
76d4406c0b35   postgres:12   "docker-entrypoint.s…"   22 minutes ago   Up 22 minutes   0.0.0.0:49163->5432/tcp, :::49163->5432/tcp   vagrant-postgres-1
```

## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user  
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше,
- описание таблиц (describe)
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db   
   
**Решение:** 
```cql
CREATE USER "test-admin-user" WITH LOGIN;
CREATE DATABASE test_db;
CREATE TABLE orders (id SERIAL PRIMARY KEY, наименование TEXT, цена INT);
CREATE TABLE clients (id SERIAL PRIMARY KEY, фамилия TEXT,"страна проживания" TEXT, заказ INT REFERENCES orders (id));
CREATE INDEX ON clients ("страна проживания");
GRANT ALL ON TABLE clients, orders TO "test-admin-user";
CREATE USER "test-simple-user" WITH LOGIN;
GRANT SELECT,INSERT,UPDATE,DELETE ON TABLE clients,orders TO "test-simple-user";
```
- итоговый список БД после выполнения пунктов выше

```bash
postgres=# \l+
                                                                   List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   |  Size   | Tablespace |                Description
-----------+----------+----------+------------+------------+-----------------------+---------+------------+--------------------------------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |                       | 8121 kB | pg_default | default administrative connection database
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +| 7825 kB | pg_default | unmodifiable empty database
           |          |          |            |            | postgres=CTc/postgres |         |            |
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +| 7825 kB | pg_default | default template for new databases
           |          |          |            |            | postgres=CTc/postgres |         |            |
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 |                       | 7825 kB | pg_default |
(4 rows)
```

- описание таблиц (describe)

```bash
test_db=# \d+
                            List of relations
 Schema |      Name      |   Type   |  Owner   |    Size    | Description
--------+----------------+----------+----------+------------+-------------
 public | clients        | table    | postgres | 8192 bytes |
 public | clients_id_seq | sequence | postgres | 8192 bytes |
 public | orders         | table    | postgres | 8192 bytes |
 public | orders_id_seq  | sequence | postgres | 8192 bytes |
(4 rows)

test_db=# \d+ clients
                                                      Table "public.clients"
      Column       |  Type   | Collation | Nullable |               Default               | Storage  | Stats target | Description
-------------------+---------+-----------+----------+-------------------------------------+----------+--------------+-------------
 id                | integer |           | not null | nextval('clients_id_seq'::regclass) | plain    |              |
 фамилия           | text    |           |          |                                     | extended |              |
 страна проживания | text    |           |          |                                     | extended |              |
 заказ             | integer |           |          |                                     | plain    |              |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
    "clients_страна проживания_idx" btree ("страна проживания")
Foreign-key constraints:
    "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
Access method: heap

test_db=# \d+ orders
                                                   Table "public.orders"
    Column    |  Type   | Collation | Nullable |              Default               | Storage  | Stats target | Description
--------------+---------+-----------+----------+------------------------------------+----------+--------------+-------------
 id           | integer |           | not null | nextval('orders_id_seq'::regclass) | plain    |              |
 наименование | text    |           |          |                                    | extended |              |
 цена         | integer |           |          |                                    | plain    |              |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
Access method: heap
```

SQL-запрос для выдачи списка пользователей с правами над таблицами test_db

```cql
test_db=# SELECT table_name, array_agg(privilege_type), grantee
FROM information_schema.table_privileges
WHERE table_name = 'orders' OR table_name = 'clients'
GROUP BY table_name, grantee;
```
 список пользователей с правами над таблицами test_db

```bash
 table_name |                         array_agg                         |     grantee
------------+-----------------------------------------------------------+------------------
 clients    | {INSERT,TRIGGER,REFERENCES,TRUNCATE,DELETE,UPDATE,SELECT} | postgres
 clients    | {INSERT,TRIGGER,REFERENCES,TRUNCATE,DELETE,UPDATE,SELECT} | test-admin-user
 clients    | {DELETE,INSERT,SELECT,UPDATE}                             | test-simple-user
 orders     | {INSERT,TRIGGER,REFERENCES,TRUNCATE,DELETE,UPDATE,SELECT} | postgres
 orders     | {INSERT,TRIGGER,REFERENCES,TRUNCATE,DELETE,UPDATE,SELECT} | test-admin-user
 orders     | {DELETE,SELECT,UPDATE,INSERT}                             | test-simple-user
(6 rows)
```


## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.
  
**Решение:**

```sql
INSERT INTO orders (наименование, цена )
VALUES 
    ('Шоколад', '10'),
    ('Принтер', '3000'),
    ('Книга', '500'),
    ('Монитор', '7000'),
    ('Гитара', '4000')
;
```   
```sql
INSERT INTO clients ("фамилия", "страна проживания")
VALUES 
    ('Иванов Иван Иванович', 'USA'),
    ('Петров Петр Петрович', 'Canada'),
    ('Иоганн Себастьян Бах', 'Japan'),
    ('Ронни Джеймс Дио', 'Russia'),
    ('Ritchie Blackmore', 'Russia')
;
```

```sql
SELECT 'orders' AS name_table,  COUNT(*) AS number_rows FROM orders
UNION ALL
SELECT 'clients' AS name_table,  COUNT(*) AS number_rows  FROM clients;
```

```bash
 name_table | number_rows
------------+-------------
 orders     |           5
 clients    |           5
(2 rows)
```
## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.   
   
**Решение:**

```sql
UPDATE clients SET "заказ"=3 WHERE id=1; 
UPDATE clients SET "заказ"=4 WHERE id=2; 
UPDATE clients SET "заказ"=5 WHERE id=3; 
```
```sql
est_db=# SELECT "фамилия","заказ",orders."наименование"
test_db-# FROM clients
test_db-# INNER JOIN orders ON "заказ"=orders."id";
       фамилия        | заказ | наименование
----------------------+-------+--------------
 Иванов Иван Иванович |     3 | Книга
 Петров Петр Петрович |     4 | Монитор
 Иоганн Себастьян Бах |     5 | Гитара
(3 rows)
```

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

**Решение:**

```sql
test_db=# EXPLAIN SELECT * FROM clients
test_db-# WHERE "заказ" IS NOT null;
                        QUERY PLAN
-----------------------------------------------------------
 Seq Scan on clients  (cost=0.00..18.10 rows=806 width=72)
   Filter: ("заказ" IS NOT NULL)
(2 rows)
```
Читаем последовательно данные из таблицы `clients` \
Стоимость получения первого значения `0.00`. \
Стоимость получения всех строк `18.10`. \
Приблизительное количество проверенных строк `806` \
Средний размер каждой строки
в байтах составил `72` \
Используется фильтр `"заказ" IS NOT NULL`


## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).
```bash
pg_dump -U postgres -F t test_db > /data/backup/postgres/test_db.tar
```
Остановите контейнер с PostgreSQL (но не удаляйте volumes).

```bash
vagrant@vagrant:~$ docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS          PORTS                                         NAMES
76d4406c0b35   postgres:12   "docker-entrypoint.s…"   52 minutes ago   Up 52 minutes   0.0.0.0:49163->5432/tcp, :::49163->5432/tcp   vagrant-postgres-1
vagrant@vagrant:~$ docker stop vagrant-postgres-1
vagrant-postgres-1
vagrant@vagrant:~$ docker ps -a
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS                     PORTS     NAMES
76d4406c0b35   postgres:12   "docker-entrypoint.s…"   54 minutes ago   Exited (0) 6 seconds ago             vagrant-postgres-1
```
Поднимите новый пустой контейнер с PostgreSQL.
```bash
vagrant@vagrant:~/test_db$ docker compose up -d
[+] Running 3/3
 ⠿ Network test_db_default       Created                                                                                                                                                        0.1s
 ⠿ Volume "test_db_db_data"      Created                                                                                                                                                        0.0s
 ⠿ Container test_db-postgres-1  Started                                                                                                                                                        1.2s
vagrant@vagrant:~/test_db$ docker compose ps -a
NAME                 COMMAND                  SERVICE             STATUS              PORTS
test_db-postgres-1   "docker-entrypoint.s…"   postgres            running             0.0.0.0:49164->5432/tcp, :::49164->5432/tcp

vagrant@vagrant:~/test_db$ docker  ps
CONTAINER ID   IMAGE         COMMAND                  CREATED              STATUS              PORTS                                         NAMES
b9f53c4b249e   postgres:12   "docker-entrypoint.s…"   About a minute ago   Up About a minute   0.0.0.0:49164->5432/tcp, :::49164->5432/tcp   test_db-postgres-1
```
Восстановите БД test_db в новом контейнере.
Приведите список операций, который вы применяли для бэкапа данных и восстановления. 
```bash
vagrant@vagrant:~/test_db$ psql -h localhost -p 49164 -U postgres -W
Password:
psql (12.12 (Ubuntu 12.12-0ubuntu0.20.04.1))
Type "help" for help.
postgres=# CREATE USER "test-admin-user" WITH LOGIN;
CREATE ROLE
postgres=# CREATE USER "test-simple-user" WITH LOGIN;
CREATE ROLE
postgres=# \q
vagrant@vagrant:~/test_db$ docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS          PORTS                                         NAMES
b9f53c4b249e   postgres:12   "docker-entrypoint.s…"   19 minutes ago   Up 19 minutes   0.0.0.0:49164->5432/tcp, :::49164->5432/tcp   test_db-postgres-1
vagrant@vagrant:~/test_db$ docker exec -it test_db-postgres-1 bash
root@b9f53c4b249e:/# pg_restore -U postgres --verbose -C -d postgres /data/backup/postgres/test_db.tar
pg_restore: connecting to database for restore
pg_restore: creating DATABASE "test_db"
pg_restore: connecting to new database "test_db"
pg_restore: creating TABLE "public.clients"
pg_restore: creating SEQUENCE "public.clients_id_seq"
pg_restore: creating SEQUENCE OWNED BY "public.clients_id_seq"
pg_restore: creating TABLE "public.orders"
pg_restore: creating SEQUENCE "public.orders_id_seq"
pg_restore: creating SEQUENCE OWNED BY "public.orders_id_seq"
pg_restore: creating DEFAULT "public.clients id"
pg_restore: creating DEFAULT "public.orders id"
pg_restore: processing data for table "public.clients"
pg_restore: processing data for table "public.orders"
pg_restore: executing SEQUENCE SET clients_id_seq
pg_restore: executing SEQUENCE SET orders_id_seq
pg_restore: creating CONSTRAINT "public.clients clients_pkey"
pg_restore: creating CONSTRAINT "public.orders orders_pkey"
pg_restore: creating INDEX "public.clients_страна проживания_idx"
pg_restore: creating FK CONSTRAINT "public.clients clients_заказ_fkey"
pg_restore: creating ACL "public.TABLE clients"
pg_restore: creating ACL "public.TABLE orders"
postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 
postgres=# \c test_db
You are now connected to database "test_db" as user "postgres".
test_db=# \d orders
                               Table "public.orders"
    Column    |  Type   | Collation | Nullable |              Default
--------------+---------+-----------+----------+------------------------------------
 id           | integer |           | not null | nextval('orders_id_seq'::regclass)
 наименование | text    |           |          |
 цена         | integer |           |          |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
test_db=# \d clients
                                  Table "public.clients"
      Column       |  Type   | Collation | Nullable |               Default
-------------------+---------+-----------+----------+-------------------------------------
 id                | integer |           | not null | nextval('clients_id_seq'::regclass)
 фамилия           | text    |           |          |
 страна проживания | text    |           |          |
 заказ             | integer |           |          |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
    "clients_страна проживания_idx" btree ("страна проживания")
Foreign-key constraints:
    "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
 
```