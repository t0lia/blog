---
title: "Elasticsearch API"
date: 2022-08-26T10:37:03+02:00
---

{{< columns >}} 
{{< toc >}}
<--->
![](https://images.contentstack.io/v3/assets/bltefdd0b53724fa2ce/blt5d10f3a91df97d15/620a9ac8849cd422f315b83d/logo-elastic-vertical-reverse.svg )
{{< /columns >}}



## Inspecting the cluster

- Instance info
```
GET /
```
- Cluster health
```
GET _cluster/health
```
- Cluster state 
```
GET _cluster/state
```
- Nodes info
```
GET _cat/nodes?v
```

## Index operations

### CRUD index operations

- Show all indexes
```
GET _cat/indices
```  
- create an index
``` js
PUT /books
{
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 1
  },
  "mappings": {
    "properties": {
      "message": {
        "type": "text"
      }
    }
  }
}
```
- delete the index
``` js
DELETE articles
```

### Mapping

#### Types
1. keyword
1. text
1. float
1. double
1. short
1. integer
1. long
1. boolean
1. date



- retrieving mapping for an index
``` js
GET books/_mapping
```

- retrieving mapping for a field
``` js
GET books/_mapping/field/book
```

- creation with mapping
``` js
PUT /books
{
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 1
  },
  "mappings": {
    "properties": {
      "message": {
        "type": "text"
      }
    }
  }
}
```
---

## Documents


### CRUD operations

- create and appoint an id
``` js
POST books/_doc 
{
  "message" : "test example message"
}
```
- update if exist or create new with given id
``` js
PUT books/_doc/100
{
  "message" : "id = 100"
}
```
- update 
``` js
POST books/_update/100
{
  "doc": {
    "message": "value updated"
  }
}
```
- retrieve by id
``` js
GET books/_doc/100
```
- delete by id
``` js
DELETE books/_doc/100
```
### Optimistic concurrency control
- optimistic locking update (checking whether fields *seq_no* and *primary_term* are the same as parameters)
``` js
POST books/_update/100?if_primary_term=1&if_seq_no=4
{
  "doc": {
    "message": "vaule updated"
  }
}
```

### BULK operations
- bulk operation (index - like PUT, create - like POST)
``` js
POST _bulk
{"index":{"_index": "books", "_id":"LbqX2oIBBKykhdTgGVMY"}}
{"message":"bulk insert data"}
{"create":{"_index": "books", "_id":"LbqX2oIBBKykhdTgGVMZ"}}
{"message":"bulk insert data"}
```
- bulk operation (update, delete)
``` js
POST _bulk
{"update":{"_index": "books", "_id":"LbqX2oIBBKykhdTgGVMZ"}}
{"doc":{"message":"bulk update data"}}
{"delete":{"_index": "books", "_id":"LbqX2oIBBKykhdTgGVMZ"}}
```
- bulk operation single index short
``` js
POST books/_bulk
{"update":{"_id":"LbqX2oIBBKykhdTgGVMZ"}}
{"doc":{"message":"bulk update data"}}
{"delete":{"_id":"LbqX2oIBBKykhdTgGVMZ"}}
```
- bulk operation with curl
```bash
bash-3.2$ curl -H "Content-Type: application/x-ndjson" -XPOST http://localhost:9200/product/_bulk --data-binary "@products-bulk.json"
bash-3.2$ head -4 products-bulk.json
{"index":{"_id":1}}
{"name":"Wine - Maipo Valle Cabernet","price":152,"in_stock":38,"sold":47,"tags":["Beverage","Alcohol","Wine"],"description":"Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula.","is_active":true,"created":"2004\/05\/13"}
{"index":{"_id":2}}
{"name":"Tart Shells - Savory","price":99,"in_stock":10,"sold":430,"tags":[],"description":"Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.","is_active":true,"created":"2007\/10\/14"}
```

---

![Example image](/static/analyzer.png)
![Example image](/static/architecture.png)
## Analyze
![](https://www.elastic.co/guide/en/elasticsearch/client/net-api/current/analysis-chain.png)
### Testing analyzers
[analyzers documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-analyzers.html)


- standard analyzer example
``` js
POST _analyze
{
  "text": "2 guys walk into   a bar, but the third... DUCKS! :-) ",
  "analyzer": "standard"
}
```
- the same example
``` js
POST _analyze
{
  "text": "2 guys walk into   a bar, but the third... DUCKS! :-) ",
  "char_filter": [],
  "tokenizer": "standard",
  "filter": ["lowercase"]
}
```
- keyword analyzer
``` js
POST _analyze
{
  "text": "2 guys walk into   a bar, but the third... DUCKS! :-) ",
  "analyzer": "keyword"
}
```

### Language analyzers. Stemming
``` js
POST _analyze
{
  "text": "2 guys walk into   a bar, but the third... DUCKS! :-) ",
  "analyzer": "english"
}
```

``` js
POST _analyze
{
"text": "Покупка цветного лома. Дорого",
"analyzer": "russian"
}
```


- search with stemming
``` js
DELETE /books
PUT /books
{
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 1
  },
  "mappings": {
    "properties": {
      "message": {
        "type": "text",
        "analyzer": "english"
      }
    }
  }
}
PUT books/_doc/100
{
  "message" : "test example message"
}
GET books/_search
{
  "query": {
    "match": {
      "message": {
        "query": "messaging"
      }
    }
  }
}
```

- creating analyzers

``` js
PUT /analyzer_test
{
  "settings": {
    "analysis": {
      "analyzer": {
        "my_custom_analyzer": {
          "type": "custom",
          "char_filter": [
            "html_strip"
          ],
          "tokenizer": "standard",
          "filter": [
            "lowercase",
            "stop",
            "asciifolding"
          ]
        }
      }
    }
  }
}

POST /analyzer_test/_analyze
{
  "analyzer": "my_custom_analyzer",
  "text": "I&apos;m in a <em>good</em> mood&nbsp;-&nbsp;and I <strong>love</strong> açaí!"
}
```

---

## Search
### Term level queries
### Full text queries
- full scan
```
GET books/_search
```

- full scan also
```
GET books/_search
{
  "query": {
    "match_all": {}
  }
}
```

```
# by token
# поиск по включению части фразы
GET books/_search
{
  "query": {
    "match_phrase_prefix": {
      "cite": {
        "query": "the forest is fil"
      }
    }
  }
}

# поиск по набору ключевых слов
GET books/_search
{
  "query": {
    "match": {
      "cite": {
        "query": "lord of the ring"
      }
    }
  }
}
# поиск по длине
GET books/_search
{
  "query": {
    "bool": {
      "filter": [
        {
          "range": {
            "length": {
              "gte": 300,
              "lte": 2000
            }
          }
        },
        {
          "match": {
            "book": {
              "query": "Harry"
            }
          }
        }
      ]
    }
  }
}

GET books/_search
{
  "query": {
    "bool": {
      "filter": [
        {
          "match": {
            "message": "or"
          }
        }
      ]
    }
  }
}

GET books/_search
{
  "query": {
    "match_all": {}
  },
  "sort": [
    {
      "message": {
        "order": "asc"
      }
    }
  ]
}
```
```
GET articles/_search
{
  "query": {
    "bool": {
      "must": [
        
        {
          "match_phrase_prefix": {
            "author.firstName": "jo"
          }
        }
      ]
    }
  }
}
```

## Aggregation

## Useful links
- https://www.youtube.com/watch?v=61MQoSFt2j0o
- [java api](https://www.elastic.co/guide/en/elasticsearch/client/java-api-client/7.17/usage.html)
