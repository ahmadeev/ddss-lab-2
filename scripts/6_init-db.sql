-- $HOME=/var/db/postgres3

CREATE TABLESPACE tableSpace1 LOCATION '/var/db/postgres3/vja47';
CREATE TABLESPACE tableSpace2 LOCATION '/var/db/postgres3/vso93';
CREATE TABLESPACE tableSpace3 LOCATION '/var/db/postgres3/znb64';

-- \db+

CREATE DATABASE goodyellowdisk TEMPLATE template0;

-- \l

CREATE ROLE s367839 WITH LOGIN;
GRANT ALL ON SCHEMA public TO s367839;
GRANT CONNECT ON DATABASE goodyellowdisk TO s367839;
GRANT CREATE ON DATABASE goodyellowdisk TO s367839;
GRANT CREATE ON TABLESPACE tableSpace1 TO s367839;
GRANT CREATE ON TABLESPACE tableSpace2 TO s367839;
GRANT CREATE ON TABLESPACE tableSpace3 TO s367839;

-- \du

CREATE TABLE table1 (id serial PRIMARY KEY, name text) TABLESPACE tableSpace1;
CREATE TABLE table2 (id serial PRIMARY KEY, value integer) TABLESPACE tableSpace2;
CREATE TABLE table3 (id serial PRIMARY KEY, info text) TABLESPACE tableSpace3;
INSERT INTO table1 (name) SELECT 'Имя ' || g FROM generate_series(1, 100) g;
INSERT INTO table2 (value) SELECT g * 10 FROM generate_series(1, 100) g;
INSERT INTO table3 (info) SELECT 'Инфо ' || g FROM generate_series(1, 100) g;

-- \dt