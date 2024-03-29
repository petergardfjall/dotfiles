## psql

To pass a password over command-line without being prompted run

    export PGUSER=postgres PGPASSWORD=password PGHOST=localhost PGDATABASE=mydb
    psql ...

To turn off psql's pager (`\pset pager off`) you can set

    export PAGER=

To use postgres over SSL the following environment variables can be used:

    PGSSLMODE="verify-ca"
    PGSSLCERT="client-cert.pem"
    PGSSLKEY="client-key.pem"
    PGSSLROOTCERT="server-ca.pem"

Useful `psql` command-line flags:

- `-t`: tuples only (don't show headers nor footers)

Useful prompt commands:

- Turn off paging: `\pset pager 0`
- No column headers: `\pset tuples_only`
- No query footer: `\pset footer off`
- List databases: `\l`
- Connect to database: `\c <database>`
- List tables: `\d`
- Show table schema: `\d <table>`

## Types

A few common data types:

- `bigint` (`int8`): signed eight-byte integer
- `boolean`(`bool`): logical Boolean (`true`/`false`)
- `bytea`: binary data ("byte array")
- `character [n]` (`char [n]`): fixed-length character string
- `character varying [n]` (`varchar [n]`): variable-length character string
- `cidr`: IPv4 or IPv6 network address
- `date`: calendar date (year, month, day)
- `double precision` (`float8`): double precision floating-point number
- `inet`: IPv4 or IPv6 host address
- `integer`(`int`, `int4`): signed four-byte integer
- `json`: textual JSON data
- `jsonb`: binary JSON data, decomposed
- `text`: variable-length character string
- `time [p] [without time zone]`: time of day (no time zone)
- `time [p] with time zone` (`timetz`): time of day, including time zone
- `timestamp [p] [without time zone]`: date and time (no time zone)
- `timestamp [p] with time zone`(`timestamptz`): date + time, with time zone

## Creation

Create database:

    CREATE DATABASE somedb;

Create table:

    CREATE TABLE IF NOT EXISTS films (
      title            TEXT,
      country          TEXT NOT NULL,
      distributor      TEXT,
      ...

      release_date     DATE NOT NULL,

      PRIMARY KEY(title),
      FOREIGN KEY (country) REFERENCES countries(country) ON DELETE CASCADE
    );

### Access rights/Permissions

Grant all privileges on a database to a given user:

    GRANT ALL PRIVILEGES ON DATABASE ${db} TO ${username};

Grant all privileges on all tables in a schema:

    GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA ${schema_name} TO ${username};

Grant select statement privileges access on tables:

    GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA ${schema_name} TO ${username};
    GRANT SELECT ON ALL TABLES IN SCHEMA public TO read_only;

### Indices

    CREATE [ UNIQUE ] INDEX [ CONCURRENTLY ] [ name ] ON table_name [ USING method ]
        ( { column_name | ( expression ) } [ COLLATE collation ] [ opclass ] [ ASC | DESC ] [ NULLS { FIRST | LAST } ] [, ...] )
        [ WITH ( storage_parameter = value [, ... ] ) ]
        [ TABLESPACE tablespace_name ]
        [ WHERE predicate ]

The `USING method` can specify one of the built-in index types: `btree`
(default), `hash`, `gist`, `spgist`, `gin`, and `brin`.

Examples:

- Hash indexes handle equality comparisons (`=`). A hash index is considered
  whenever an indexed column is involved in a comparison using the `=` operator.

        CREATE INDEX download_url_idx ON downloads USING HASH (url);

        -- apply index to a particular string field in a JSONB column
        CREATE INDEX prop_name_idx ON matches USING HASH ((props->>'name'));

- B-tree indexes can handle a wide range of queries and orderings. The index is
  used whenever an indexed column is involved in a comparison using either of
  operators `<` `<=` `=` `>=` `>`.

        CREATE INDEX download_site_idx ON downloads USING BTREE (site);

        -- apply index to a particular int field in a JSONB column
        CREATE INDEX prop_byte_start_idx ON matches USING BTREE (((props->'byteStart')::int4));

- A GIN index can for example be used for many columns containing multiple
  component values, such as `ARRAY`, `HSTORE` or `JSONB` columns. It is
  considered for operators testing for presence of component values like: `<@`,
  `@>`, `=`, `&&`.

        -- Apply index to a JSONB column. This allows "contains queries" like:
        --   WHERE tools @> '{"dia": "0.97"}'
        CREATE INDEX sys_tools_idx ON system USING GIN (tools);

## Destruction

    DROP DATABASE <database>;
    DROP TABLE downloads CASCADE;

## Alter schema

- add a column

        ALTER TABLE downloads ADD COLUMN end_time TIMESTAMPTZ;

- drop a column

        ALTER TABLE downloads DROP COLUMN end_time;

- drop a PK column

        -- drop PK
        ALTER TABLE downloads DROP CONSTRAINT downloads_pkey;
        -- drop PK column
        ALTER TABLE downloads DROP COLUMN start_time;
        -- reconstruct PK
        ALTER TABLE downloads ADD PRIMARY KEY (id, url);

- change column type

        -- note requires id column type to be castable to TEXT
        ALTER TABLE downloads ALTER COLUMN id TYPE TEXT;

        -- use explicit conversion: <expr> can for example be a function
        ALTER TABLE downloads ALTER COLUMN id TYPE JSON USING <expr>;

        -- change column type for a PK column
        ALTER TABLE downloads DROP CONSTRAINT downloads_pkey;
        ALTER TABLE downloads ALTER COLUMN id TYPE TEXT;
        ALTER TABLE downloads ADD PRIMARY KEY (id);

- add/drop foreign key constraint:

        ALTER TABLE the_table ADD CONSTRAINT constraint_name FOREIGN KEY (col1, col2);
        ALTER TABLE the_table DROP CONSTRAINT IF EXISTS constraint_name;

- add/drop unique constraint (note that for `UNIQUE` constraints `NULL` values
  count as distinct):

        ALTER TABLE the_table ADD CONSTRAINT constraint_name UNIQUE (col1, col2);
        ALTER TABLE the_table DROP CONSTRAINT IF EXISTS constraint_name;

- create index

        CREATE INDEX downloads_url_idx ON downloads(url);
        CREATE INDEX download_url_idx ON downloads USING HASH (url);

- a more complex modification that uses PL/pgSQL (a procedural language)
  normally used to create functions and triggers.

        -- set release_year for any movie missing one
        DO
        $$
        DECLARE
            it record;
            it_year text;
        BEGIN
            FOR it IN SELECT id, title FROM movies
                WHERE release_year IS NULL
            LOOP

            -- get release year from a different table
            it_year := (SELECT release_year
                        FROM movie_metadata
                        WHERE title=it.title);

            UPDATE movies SET release_year=it_year WHERE id=it.id;
            END LOOP;
        END;
        $$;

## Queries

    [ WITH [ RECURSIVE ] with_query [, ...] ]
    SELECT [ ALL | DISTINCT [ ON ( expression [, ...] ) ] ]
        [ * | expression [ [ AS ] output_name ] [, ...] ]
        [ FROM from_item [, ...] ]
        [ WHERE condition ]
        [ GROUP BY grouping_element [, ...] ]
        [ HAVING condition [, ...] ]
        [ WINDOW window_name AS ( window_definition ) [, ...] ]
        [ { UNION | INTERSECT | EXCEPT } [ ALL | DISTINCT ] select ]
        [ ORDER BY expression [ ASC | DESC | USING operator ] [ NULLS { FIRST | LAST } ] [, ...] ]
        [ LIMIT { count | ALL } ]
        [ OFFSET start [ ROW | ROWS ] ]
        [ FETCH { FIRST | NEXT } [ count ] { ROW | ROWS } ONLY ]
        [ FOR { UPDATE | NO KEY UPDATE | SHARE | KEY SHARE } [ OF table_name [, ...] ] [ NOWAIT | SKIP LOCKED ] [...] ]

where `from_item` can be one of:

    [ ONLY ] table_name [ * ] [ [ AS ] alias [ ( column_alias [, ...] ) ] ]
                [ TABLESAMPLE sampling_method ( argument [, ...] ) [ REPEATABLE ( seed ) ] ]
    [ LATERAL ] ( select ) [ AS ] alias [ ( column_alias [, ...] ) ]
    with_query_name [ [ AS ] alias [ ( column_alias [, ...] ) ] ]
    [ LATERAL ] function_name ( [ argument [, ...] ] )
                [ WITH ORDINALITY ] [ [ AS ] alias [ ( column_alias [, ...] ) ] ]
    [ LATERAL ] function_name ( [ argument [, ...] ] ) [ AS ] alias ( column_definition [, ...] )
    [ LATERAL ] function_name ( [ argument [, ...] ] ) AS ( column_definition [, ...] )
    [ LATERAL ] ROWS FROM( function_name ( [ argument [, ...] ] ) [ AS ( column_definition [, ...] ) ] [, ...] )
                [ WITH ORDINALITY ] [ [ AS ] alias [ ( column_alias [, ...] ) ] ]
    from_item [ NATURAL ] join_type from_item [ ON join_condition | USING ( join_column [, ...] ) ]

and `grouping_element` can be one of:

    ( )
    expression
    ( expression [, ...] )
    ROLLUP ( { expression | ( expression [, ...] ) } [, ...] )
    CUBE ( { expression | ( expression [, ...] ) } [, ...] )
    GROUPING SETS ( grouping_element [, ...] )

and `with_query` is:

    with_query_name [ ( column_name [, ...] ) ] AS ( select | values | insert | update | delete )

    TABLE [ ONLY ] table_name [ * ]

Examples:

To (inner) join the table `films` with the table `distributors`:

    SELECT f.title, f.did, d.name, f.date_prod, f.kind
        FROM distributors d, films f
        WHERE f.did = d.did

A `JOIN` (`INNER JOIN`) selects all rows from both tables as long as there is a
match between the columns:

    SELECT column_name(s)
    FROM table1 INNER JOIN table2 ON table1.column_name = table2.column_name;

A `LEFT JOIN` ( `LEFT OUTER JOIN`) returns all records from the left table
(table1), and the matched records from the right table (table2). The result is
NULL from the right side, if there is no match.

    SELECT column_name(s)
    FROM table1 LEFT JOIN table2 ON table1.column_name = table2.column_name;

`GROUP BY` groups rows that have the same values into summary rows and is often
combined with aggregate functions (`COUNT`, `MAX`, `MIN`, `SUM`, `AVG`) to group
the result-set by one or more columns.

    SELECT COUNT(CustomerID), Country FROM Customers GROUP BY Country;

`HAVING` can be used as a group-level filter for aggregate functions:

    SELECT COUNT(CustomerID), Country FROM Customers
    GROUP BY Country HAVING COUNT(CustomerID) > 5;

Use `UNION` to combine result sets (with identical column types):

    SELECT column_name(s) FROM table1
    UNION
    SELECT column_name(s) FROM table2;

## Inserts

    [ WITH [ RECURSIVE ] with_query [, ...] ]
    INSERT INTO table_name [ AS alias ] [ ( column_name [, ...] ) ]
        { DEFAULT VALUES | VALUES ( { expression | DEFAULT } [, ...] ) [, ...] | query }
        [ ON CONFLICT [ conflict_target ] conflict_action ]
        [ RETURNING * | output_expression [ [ AS ] output_name ] [, ...] ]

where `conflict_target` can be one of:

    ( { index_column_name | ( index_expression ) } [ COLLATE collation ] [ opclass ] [, ...] ) [ WHERE index_predicate ]
    ON CONSTRAINT constraint_name

and `conflict_action` is one of:

    DO NOTHING
    DO UPDATE SET { column_name = { expression | DEFAULT } |
                    ( column_name [, ...] ) = ( { expression | DEFAULT } [, ...] ) |
                    ( column_name [, ...] ) = ( sub-SELECT )
                  } [, ...]
              [ WHERE condition ]

Examples:

    INSERT INTO pkgs (pkg) VALUES ('pkg:purl');
    INSERT INTO pkg_downloads (id, pkg, pkg_rev, status) VALUES (1, 'pkg:purl', 'r1', 0);

### Inserts with auto-generated column values

`RETURNING` can be used to retrieve an auto-generated column.

    INSERT INTO users (name, age) VALUES ('john', 45) RETURNING id;

### Insert into with select

For example, moving values from a `{id, enable_cache, enable_tls}` table to a
`{id, key, value}` table.

    INSERT INTO opts (id, key, value)
        (SELECT id, 'enable_cache', enable_cache FROM config);
    INSERT INTO opts (id, key, value)
        (SELECT id, 'enable_tls', enable_tls FROM config);

## Updates

    [ WITH [ RECURSIVE ] with_query [, ...] ]
    UPDATE [ ONLY ] table_name [ * ] [ [ AS ] alias ]
        SET { column_name = { expression | DEFAULT } |
              ( column_name [, ...] ) = [ ROW ] ( { expression | DEFAULT } [, ...] ) |
              ( column_name [, ...] ) = ( sub-SELECT )
            } [, ...]
        [ FROM from_item [, ...] ]
        [ WHERE condition | WHERE CURRENT OF cursor_name ]
        [ RETURNING * | output_expression [ [ AS ] output_name ] [, ...] ]

## Work queues

Work queues can be implemented using `SELECT .. SKIP LOCKED`. Should it be
rolled back (or the process crash), the job gets placed in the queue again and
is eligble for consumption by another worker.

    BEGIN;

    -- Pop job from queue (if one is available).
    DELETE FROM jobs j WHERE id = (
        SELECT j.id FROM jobs j
        ORDER BY j.id
         FOR UPDATE SKIP LOCKED
         LIMIT 1
     ) RETURNING j.id, j.url;

    -- On ROLLBACK the job j would be replaced in the queue.
    -- It will be removed only on COMMIT, but since it is locked
    -- no other worker will pop j due to the use of SKIP LOCKED.

    -- Do work with job ...

    COMMIT;

## Show table creation DDL

    pg_dump -t 'schema-name.table-name' --schema-only database-name

## Backup/restore

Dumping a local database:

    # Note: --clean produces clean (drop) statements prior to each create
    # statement. This prevents the need to DROP and re-CREATE the database.
    pg_dump --no-owner --clean --host localhost --username=admin db > db.dump

    # or dumping all databases
    export PGPASSWORD=password  # avoid repeating password for every db
    pg_dumpall --no-owner --no-role-passwords --clean --host=localhost --username=postgres > db.dump

Dump with SSL credentials:

    pg_dump "sslmode=verify-ca sslrootcert=server-ca.pem \
             sslcert=client-cert.pem sslkey=client-key.pem \
             hostaddr=<IP/host> port=5432 \
             user=postgres dbname=db" --no-owner --clean > db.dump

    pg_dumpall -d "sslmode=verify-ca sslrootcert=server-ca.pem \
             sslcert=client-cert.pem sslkey=client-key.pem \
             hostaddr=<IP/host> port=5432 \
             user=postgres dbname=postgres" --no-owner --no-role-passwords --clean > all.dump

Restore database from dump (if created with `--clean`):

    psql --host localhost --username=admin -f db.dump db

## System

A few useful system queries:

### current settings:

        select name, setting, short_desc from pg_settings where name like '%time%';

        select * from pg_settings where name like '%log%';

### locks in use

        select * from pg_locks;
        select * from pg_locks where locktype = 'advisory';

### active connections

        SELECT sum(numbackends) FROM pg_stat_database;

### show connection status

        select * from pg_stat_activity;

### column size

To get some size metrics for a column `col` in table `tab`:

    SELECT pg_size_pretty(SUM(pg_column_size(col))) AS total_size,
           pg_size_pretty(MAX(pg_column_size(col))::numeric) AS max_size,
           pg_size_pretty(MIN(pg_column_size(col))::numeric) AS min_size,
           pg_size_pretty(AVG(pg_column_size(col))) AS average_size,
           pg_size_pretty(SUM(pg_column_size(col)) / pg_relation_size('tab'))
              AS table_fraction
           FROM tab;

## Scripting with PL/pgSQL procedural language

Sometimes it is useful to write SQL-based scripts. A good example is when doing
schema migrations. A convoluted example (a real migration would likely populate
a field with one or more `UPDATE` or `INSERT` statements):

    DO
    $$
    DECLARE
        -- Note: declare variables.
        it record;
        cancelled_count int;
        running_count int;
        done_time timestamptz := '0001-01-01 00:00:00+00';
    BEGIN
        FOR it IN SELECT id, created_at FROM jobs;
        LOOP
            -- Note: outputs a log statement.
            RAISE INFO job % created at %', it.id, it.created_at;

            -- Note: select a value into a variable.
            SELECT COUNT(*) INTO cancelled_count FROM task_statuses
                   WHERE job_id=it.id AND state='Cancelled';

            SELECT COUNT(*) INTO running_count FROM task_statuses
                   WHERE job_id=it.id AND state='Running';

            IF running_count > 0 THEN
               RAISE INFO 'job % still has running tasks', it.id;
            ELSIF cancelled_count > 0 THEN
               done_time := (SELECT MAX(done_at) FROM task_statuses WHERE job_id=it.id);
               RAISE INFO 'job % appears to have been cancelled', it.id;
            ELSE
               done_time := (SELECT MAX(done_at) FROM task_statuses WHERE job_id=it.id);
               job_state := 'Done';
               RAISE INFO 'job % is done', it.id;
            END IF;

            RAISE INFO 'completion time: %', done_time;
        END LOOP;
    END;
    $$;

While developing it is often useful to output values. This can be done with the
`RAISE` statement (`raise level format;`).

    RAISE INFO 'the row id was %', it.id;
