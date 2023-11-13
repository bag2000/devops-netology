# Домашнее задание к занятию "6.2. SQL"
## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

'docker-compose.yaml'

```
version: '3.1'

services:

  db:
    image: postgres:12
    container_name: postgres
    restart: always
    ports:
      - 5432:5432
    environment:
      POSTGRES_PASSWORD: postgres
    volumes:
      - ~/postgres/data:/var/lib/postgresql/data
      - ~/postgres/backups:/backups
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
```
\l
```
```
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
(4 rows)
```
- описание таблиц (describe)
```

```sql
SELECT table_catalog, table_schema, table_name, column_name, data_type FROM information_schema.columns WHERE table_name in ('orders', 'clients')
```
```
 table_catalog | table_schema | table_name | column_name |     data_type
---------------+--------------+------------+-------------+-------------------
 postgres      | public       | orders     | id          | integer
 postgres      | public       | orders     | name        | character varying
 postgres      | public       | orders     | price       | integer
 postgres      | public       | clients    | id          | integer
 postgres      | public       | clients    | lastname    | character varying
 postgres      | public       | clients    | country     | character varying
 postgres      | public       | clients    | orders_id   | integer
```
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
```
SELECT * FROM information_schema.table_privileges WHERE grantee IN ('test-simple-user', 'test-admin-user');
```
- список пользователей с правами над таблицами test_db.
```
 grantor  |     grantee      | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy
----------+------------------+---------------+--------------+------------+----------------+--------------+----------------
 postgres | test-simple-user | postgres      | public       | clients    | INSERT         | NO           | NO
 postgres | test-simple-user | postgres      | public       | clients    | SELECT         | NO           | YES
 postgres | test-simple-user | postgres      | public       | clients    | UPDATE         | NO           | NO
 postgres | test-simple-user | postgres      | public       | clients    | DELETE         | NO           | NO
 postgres | test-admin-user  | postgres      | public       | clients    | INSERT         | NO           | NO
 postgres | test-admin-user  | postgres      | public       | clients    | SELECT         | NO           | YES
 postgres | test-admin-user  | postgres      | public       | clients    | UPDATE         | NO           | NO
 postgres | test-admin-user  | postgres      | public       | clients    | DELETE         | NO           | NO
 postgres | test-admin-user  | postgres      | public       | clients    | TRUNCATE       | NO           | NO
 postgres | test-admin-user  | postgres      | public       | clients    | REFERENCES     | NO           | NO
 postgres | test-admin-user  | postgres      | public       | clients    | TRIGGER        | NO           | NO
 postgres | test-simple-user | postgres      | public       | orders     | INSERT         | NO           | NO
 postgres | test-simple-user | postgres      | public       | orders     | SELECT         | NO           | YES
 postgres | test-simple-user | postgres      | public       | orders     | UPDATE         | NO           | NO
 postgres | test-simple-user | postgres      | public       | orders     | DELETE         | NO           | NO
 postgres | test-admin-user  | postgres      | public       | orders     | INSERT         | NO           | NO
 postgres | test-admin-user  | postgres      | public       | orders     | SELECT         | NO           | YES
 postgres | test-admin-user  | postgres      | public       | orders     | UPDATE         | NO           | NO
 postgres | test-admin-user  | postgres      | public       | orders     | DELETE         | NO           | NO
 postgres | test-admin-user  | postgres      | public       | orders     | TRUNCATE       | NO           | NO
 postgres | test-admin-user  | postgres      | public       | orders     | REFERENCES     | NO           | NO
 postgres | test-admin-user  | postgres      | public       | orders     | TRIGGER        | NO           | NO
(22 rows)

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

Запросы на добавление данных в таблицы:
```
INSERT INTO orders (Name, Price) VALUES ('Шоколад', '10'), ('Принтер', '3000'), ('Книга', '500'), ('Монитор', '7000'), ('Гитара', '4000');
INSERT INTO clients (LastName, Country) VALUES ('Иванов Иван Иванович', 'USA'), ('Петров Петр Петрович', 'Canada'), ('Иоганн Себастьян Бах', 'Japan'), ('Ронни Джеймс Дио', 'Russia'), ('Ritchie Blackmore', 'Russia');
```

Запросы вычисляющие количество записей в каждой таблице:

```
select count(1) from clients

count|
-----+
    5|

select count(1) from orders

count|
-----+
    5|
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
```
update clients set Orders_Id = (select id from orders where "name" = 'Книга') where LastName = 'Иванов Иван Иванович';
update clients set Orders_Id = (select id from orders where "name" = 'Монитор') where LastName = 'Петров Петр Петрович';
update clients set Orders_Id = (select id from orders where "name" = 'Гитара') where LastName = 'Иоганн Себастьян Бах';
```
Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
 
Подсказка - используйте директиву `UPDATE`.
```
SELECT c.lastname, c.country, o."name" FROM clients c JOIN orders o ON c.Id = o.Id;
```
```
       lastname       | country |  name
----------------------+---------+---------
 Иванов Иван Иванович | USA     | Шоколад
 Петров Петр Петрович | Canada  | Принтер
 Иоганн Себастьян Бах | Japan   | Книга
 Ронни Джеймс Дио     | Russia  | Монитор
 Ritchie Blackmore    | Russia  | Гитара
(5 rows)
```

## Задача 4
Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.
```
EXPLAIN SELECT c.lastname, c.country, o."name" FROM clients c JOIN orders o ON c.Id = o.Id;
```
Результат:
```
                                QUERY PLAN
--------------------------------------------------------------------------
 Hash Join  (cost=19.45..38.42 rows=420 width=234)
   Hash Cond: (o.id = c.id)
   ->  Seq Scan on orders o  (cost=0.00..17.10 rows=710 width=82)
   ->  Hash  (cost=14.20..14.20 rows=420 width=160)
         ->  Seq Scan on clients c  (cost=0.00..14.20 rows=420 width=160)
(5 rows)
```
1. Построчно прочитана таблица orders
2. Создан кеш по полю id для таблицы orders
3. Прочитана таблица clients
4. Для каждой строки по полю "заказ" будет проверено, соответствует ли она чему-то в кеше orders
- если соответствия нет - строка будет пропущена
- если соответствие есть, то на основе этой строки и всех подходящих строках кеша СУБД сформирует вывод

## Задача 6
Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).
Остановите контейнер с PostgreSQL (но не удаляйте volumes).
Поднимите новый пустой контейнер с PostgreSQL.
Восстановите БД test_db в новом контейнере.
Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

```
root@dde1dce640e6:/backups# pg_dumpall -U postgres > /backups/001.bak
root@dde1dce640e6:/# ls /backups/
001.bak
root@dde1dce640e6:/backups# exit
exit
adm2@server1:~/postgres$ docker compose stop
[+] Stopping 2/2
 ✔ Container admin-postgres  Stopped                                                                                                                                                                         0.0s
 ✔ Container postgres2       Stopped                                                                                                                                                                           0.1s
adm2@server1:~/postgres$ docker compose -f docker-compose.yaml up -d
[+] Running 3/3
 ✔ Container admin-postgres  Started                                                                                                                                                                           0.4s
 ✔ Container postgres2       Recreated                                                                                                                                                                         0.0s
 ✔ Container postgres        Started                                                                                                                                                                           0.4s
adm2@server1:~/postgres$ docker exec -it postgres /bin/bash
root@a0667c2ace80:/# ls /backups/
001.bak
root@a0667c2ace80:/# psql -h localhost -U postgres -f /backups/001.bak test_db
```



