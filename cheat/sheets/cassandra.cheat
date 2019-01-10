## Keyspaces
Tables are contained in keyspaces (think: MySQL databases).

    DESCRIBE KEYSPACES;

    USE <keyspace>;

Keyspace in a single datacenter

    CREATE  KEYSPACE IF NOT EXISTS <name> WITH REPLICATION = {
      'class' : 'SimpleStrategy', 'replication_factor' : 1
    };

Keyspace for use when running across regions/availability zones.
Replicate each data item onto three nodes within each region.
Nodes should be configured in a 'rack' (set it to the availability zone of
the node, e.g. 'us-east-1a') to help cassandra replicate data in a
fault-tolerant manner (spreading between racks/AZs).

    CREATE KEYSPACE IF NOT EXISTS <name> WITH REPLICATION = {
      'class' : 'NetworkTopologyStrategy', 'us-east-1' : 3, 'us-west-1': 3
    };

Dropping the keyspace deletes all content.

    DROP KEYSPACE <keyspace>;


## Data modelling
Cassandra is a wide column store. As such, it stores its data as a partitioned
row store. Each row is stored in its entirety on a single node (it may also be
replicated onto other nodes) based on the partition key. A single (wide) row
stores a dynamic set of columns (up to 2 billion). Row lookups are fast.

    +---------------------------------------------------+
    | Row key  |  Column Name 1  | ...  | Column Name N |
    |          |  column value   |      | column value  |
    |          |  ttl            |      | ttl           |
    +---------------------------------------------------+

You need to model your data based on the data access pattern: what queries will
it need to support? That is, data modelling is *query-driven*. Table joins are
not allowed in queries so, unlike relational databases, data should not be
normalized but may rather be duplicated to support certain realtionships.

Rows are organized into tables. A table's primary key contains a partition key,
and within a partition, rows are clustered by the remaining columns of the key.
Other columns can be indexed separately from the primary key.

When clustering columns are included in the primary key, a *wide row* is
created where clustering keys are concatenated and prefixed onto the
remaining non-PK columns:

    PRIMARY KEY (pc, c1, c2, ...) (pc=partition col, cX=clustering col)

    +------+----------------------+----------------------+----------------------+----------------------+-----+
    | <pc> | <c1-v1>:<c2-v1>:col1 | <c1-v1>:<c2-v1>:col2 | <c1-v2>:<c2-v2>:col1 | <c1-v2>:<c2-v2>:col2 | ... |
    |      |               value  |                value |                value |                value | ... |
    |      |               ttl    |                ttl   |                ttl   |                ttl   | ... |
    +----------------------------------------------------+----------------------+----------------------+-----+

In essence, data is stored as a map of sorted maps:

  Map<ParitionKey, SortedMap<ColumnKey, ColumnValue>>

Since data is distributed, for fast queries, we need to ensure that we only
query data from a single partition (which resides on one node).



### Primary keys and clustering keys

*Partition key*: the PRIMARY key; the data is divided and stored across nodes by
the unique values in this key. When data is inserted into the cluster, the first
step is to apply a hash function to the partition key. The output is used to
determine what node (and replicas) will get the data.

    CREATE TABLE user (
       username text,
       uid int,
       PRIMARY KEY (username)
    );

    INSERT INTO user (username, uid) VALUES ('root', 0);
    INSERT INTO user (username, uid) VALUES ('foo', 1000);
    nodetool flush;
    # to view internal storage
    sstabledump data/<keyspace>/<table>/mc-1-big-Data.db

                +------+
                | uid  |
    +-----------+------+
    | key: foo  | 1000 |
    +-----------+------+
    | key: root |    0 |
    +-----------+------+

Primary keys can include frozen collections.

*Compound primary key*: consists of more than one column; the first column is
the partition key and the additional columns are clustering keys. The clustering
keys sort data within a partition. This creates a *wide row*.

    PRIMARY KEY (partition_col_name, clustering_col_name, ...)

Example:

    CREATE TABLE logins (
       user text,
       time text,
       host text,
       root boolean,
       PRIMARY KEY (user, time))
    WITH CLUSTERING ORDER BY (time DESC);

    INSERT INTO logins (user,time,host,root) VALUES ('foo','10:00','vm1',false);
    INSERT INTO logins (user,time,host,root) VALUES ('foo','11:00','vm2', false);


                +--------------+--------------+--------------+--------------+
                | '11:00':host | '11:00':root | '10:00':host | '10:00':root |
    +-----------+--------------+--------------+--------------+--------------+
    | key: root | 'vm2'        | false        | 'vm1'        | false        |
    +-----------+--------------+--------------+--------------+--------------+



*Composite partition key*: consists of multiple columns. The partition key is
enclosed in parantheses:

    PRIMARY KEY ((partition_col_1, .., partition_col_N), clustering_col_1, ...)

Example:

    CREATE TABLE cycling.rank_by_year_and_name (
      race_year int,
      race_name text,
      cyclist_name text,
      rank int,
      PRIMARY KEY ((race_year, race_name), rank) );



### Modelling relationships: one-to-many
Created via wide rows, that is by adding clustering column(s) to the PK:

    CREATE TABLE user_video_index (
      username text,
      videoid uuid,
      upload_date timestamp,
      video_name varchar
      PRIMARY KEY (username, videoid)
    );


### Modelling relationships: many-to-many
"A user can comment on many videos, and a video can have multiple comments".
Model both sides of the view and insert into both when a comment is created.
The relationship can then be viewed from either side.

    CREATE TABLE comments_by_video (  |    CREATE TABLE comments_by_user (
     videoid uuid,                    |     username varchar,
     username varchar,                |     videoid uuid,
     comment_ts timestamp,            |     comment_ts timestamp,
     comment varchar,                 |     comment varchar,
     PRIMARY KEY (videoid,username)   |     PRIMARY KEY (username,videoid)
    );                                |   );



### Modelling: avoiding too large rows
A row can have at most 2^32 columns. In some cases (when a lot of data is
appended to an ever-growing series), it may be necessary to divide partition
key into smaller chunks to avoid filling up a row:

  CREATE TABLE temperature_by_day (
    weatherstation_id text,
    date text,
    event_time timestamp,
    temperature text,
    PRIMARY KEY ((weatherstation_id, date), event_time)
  ) WITH CLUSTERING ORDER BY (event_time DESC);

Now, a single row/partition will never hold more than a days worth of data.


### Modelling: user-defined types (UDT)

    CREATE TYPE IF NOT EXISTS tenantdb (
        tenant    text,
        db        text
    );
    CREATE TABLE IF NOT EXISTS metricsdb.databases (
        db           frozen<tenantdb>,
        PRIMARY KEY  (db)
    );
    INSERT INTO metricsdb.databases (db) VALUES ({tenant: 'foo', db: 'bar'})


### Modelling: sets, lists, and maps

    CREATE TABLE songs_by_artist (
      artist text,
      title text,
      recordings set<date>,
      tags map<text,text>,
      PRIMARY KEY(artist, title)
    );
    INSERT INTO songs_by_artist (artist, title, recordings, tags) VALUES 
    ('elvis', 'song1', {'1970-01-01'}, {'grade': '5', 'sold-out': 'true'});
    INSERT INTO songs_by_artist (artist, title, recordings, tags) VALUES 
    ('elvis', 'song2', {'1971-01-01'}, {'grade': '3', 'sold-out': 'false'});
    INSERT INTO songs_by_artist (artist, title, recordings, tags) VALUES 
    ('elvis', 'song3', {'1970-01-01'}, {'grade': '3'});



### Modelling: indexes
An index provides a means to access data in Cassandra using attributes other
than the partition key. The benefit is fast, efficient lookup of data
matching a given condition. The index indexes column values in a separate,
hidden table from the one that contains the values being indexed.

Indexes are implemented as hashmaps, not B-trees, therefore indexes should
*not* be used on columns on high-cardinality columns (with a lot of unique
values). They should neither be used on very low-cardinality columns such
as a boolean.

    CREATE TABLE songs_by_artist (
      artist text,
      title text,
      recordings set<date>,
      tags map<text,text>,
      PRIMARY KEY(artist, title)
    );
    INSERT INTO songs_by_artist (artist, title, recordings, tags) VALUES
    ('elvis', 'song1', {'1970-01-01'}, {'grade': '5', 'sold-out': 'true'});
    INSERT INTO songs_by_artist (artist, title, recordings, tags) VALUES
    ('elvis', 'song2', {'1971-01-01'}, {'grade': '3', 'sold-out': 'false'});
    INSERT INTO songs_by_artist (artist, title, recordings, tags) VALUES
    ('elvis', 'song3', {'1970-01-01'}, {'grade': '3'});

Create index on a column:

    CREATE INDEX title_idx ON songs_by_artist (title);
    SELECT * FROM songs_by_artist WHERE title = 'song2';

Create an index on a list/set column:

    CREATE INDEX recordings_idx ON songs_by_artist (recordings);
    SELECT * FROM songs_by_artist WHERE recordings CONTAINS '1970-01-01';

Create an index on map keys:

    CREATE INDEX tags_key_idx ON songs_by_artist (KEYS(tags));
    SELECT * FROM songs_by_artist WHERE tags CONTAINS KEY 'grade';

Create an index on map entries:

    CREATE INDEX tags_key_idx ON songs_by_artist (ENTRIES(tags));
    SELECT * FROM songs_by_artist WHERE tags['grade'] = '3';




### Consistency
Cassandra uses tunable consistency for both reads and writes. A per-operation
tradeoff between consistency and availability. The available consistency levels
are

- `ONE`|`TWO`|`THREE`: one|two|three replica(s) must respond.
- `QUORUM`: a majority (n/2 + 1) replicas must respond
- `ALL`: all replicas must respond
- `LOCAL_QUORUM`: a majority of replicas in the local datacenter must respond.
- `EACH_QUORUM`: a majority of replicas in each datacenter must respond.
- `LOCAL_ONE`: a single replica must respond. In a multi-datacenter cluster, this
  also gaurantees that reads are not sent to replicas in a remote datacenter.



### References
- partition keys, compound key, composite partition key:
    https://docs.datastax.com/en/cql/3.3/cql/cql_reference/cqlCreateTable.html#cqlCreateTable: 
- data modelling
    https://docs.datastax.com/en/dse/6.0/cql/cql/ddl/dataModelingCQLTOC.html:
- data model
    https://wiki.apache.org/cassandra/DataModel
    http://www.slideshare.net/patrickmcfadin/the-data-model-is-dead-long-live-the-data-model
    http://www.slideshare.net/patrickmcfadin/become-a-super-modeler
    http://www.slideshare.net/patrickmcfadin/the-worlds-next-top-data-model
    http://www.slideshare.net/planetcassandra/c-summit-eu-2013-apache-cassandra-20-data-model-on-fire
    http://www.planetcassandra.org/blog/the-most-important-thing-to-know-in-cassandra-data-modeling-the-primary-key/

