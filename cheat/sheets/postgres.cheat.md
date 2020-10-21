## psql

- Turn off paging:     `\pset pager 0`
- List databases:      `\l`
- Connect to database: `\c <database>`
- List tables:         `\d`
- Show table schema:   `\d <table>`

## Types
A few common data types:

- `bigint` (`int8`): signed eight-byte integer
- `boolean`(`bool`): logical Boolean (`true`/`false`)
- `bytea`: binary data ("byte array")
- `character [n]` (`char [n]`): fixed-length character string
- `character varying [n]` (`varchar [n]`): variable-length character string
- `cidr`: IPv4 or IPv6 network address
- `date`: calendar date (year, month, day)
- `double precision` (`float8`):  double precision floating-point number
- `inet`: IPv4 or IPv6 host address
- `integer`(`int`, `int4`):   signed four-byte integer
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


### Indices

    CREATE [ UNIQUE ] INDEX [ CONCURRENTLY ] [ name ] ON table_name [ USING method ]
        ( { column_name | ( expression ) } [ COLLATE collation ] [ opclass ] [ ASC | DESC ] [ NULLS { FIRST | LAST } ] [, ...] )
        [ WITH ( storage_parameter = value [, ... ] ) ]
        [ TABLESPACE tablespace_name ]
        [ WHERE predicate ]

The `USING method` can specify one of the built-in index types: `btree`
(default), `hash`, `gist`, `spgist`, `gin`, and `brin`.

Examples:

Create a B-tree index on the `download` table's `url` column (will be named
`downloads_url_idx`).

    CREATE INDEX ON downloads(url)

Explicit naming of index:

    CREATE INDEX url_idx ON downloads(url);

Create a unique index (no duplicate values) on a column:

    CREATE UNIQUE INDEX title_idx ON films (title);


## Destruction

    DROP DATABASE <database>;
    DROP TABLE downloads CASCADE;


## Alter schema

- change PK column type

        ALTER TABLE downloads DROP CONSTRAINT downloads_pkey;
        ALTER TABLE downloads ALTER COLUMN id TYPE TEXT;
        ALTER TABLE downloads ADD PRIMARY KEY (id);

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

    insert into pkgs (pkg) values ('pkg:purl');
    insert into  pkg_downloads (id, pkg, pkg_rev, status) values (1, 'pkg:purl', 'r1', 0);



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


## System

A few useful system queries:

- view current settings:

        select name, setting, short_desc from pg_settings where name like '%time%';

        select * from pg_settings where name like '%log%';

- show locks in use

        select * from pg_locks;
        select * from pg_locks where locktype = 'advisory';

- show active connections

        SELECT sum(numbackends) FROM pg_stat_database;

- show connection status

        select * from pg_stat_activity;
