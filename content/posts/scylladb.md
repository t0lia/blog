---
title: "Scylladb"
date: 2022-08-30T16:18:31+03:00
---

# ScyllaDB

{{< columns >}} 
{{< toc >}}
<--->
![](https://pbs.twimg.com/media/EaKgI1VWoAIHa9-.jpg)
{{< /columns >}}


## Docker 
```bash
docker run --name scyllaU -d scylladb/scylla:4.5.0 --overprovisioned 1 --smp 1
docker exec -it scyllaU nodetool status
docker exec -it scyllaU cqlsh
```

``` sql
CREATE KEYSPACE mykeyspace WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 1};
use mykeyspace; 
CREATE TABLE users ( user_id int, fname text, lname text, PRIMARY KEY((user_id))); 
insert into users(user_id, fname, lname) values (1, 'rick', 'sanchez'); 
insert into users(user_id, fname, lname) values (4, 'rust', 'cohle'); 
select * from users;
```

## Docker 3 nodes
```bash
docker run --name Node_X -d scylladb/scylla:4.5.0 --overprovisioned 1 --smp 1
docker run --name Node_Y -d scylladb/scylla:4.5.0 --seeds="$(docker inspect --format='{{ .NetworkSettings.IPAddress }}' Node_X)" --overprovisioned 1 --smp 1
docker run --name Node_Z -d scylladb/scylla:4.5.0 --seeds="$(docker inspect --format='{{ .NetworkSettings.IPAddress }}' Node_X)" --overprovisioned 1 --smp 1
docker exec -it Node_Z nodetool status  
```

## Useful links
- [habr paper](https://habr.com/ru/company/stm_labs/blog/669270/)
- [scylla university](https://university.scylladb.com/#nosql-courses)



