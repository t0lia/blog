---
title: "Elasticsearch API"
date: 2022-08-26T10:37:03+02:00
---

![](https://images.contentstack.io/v3/assets/bltefdd0b53724fa2ce/blt5d10f3a91df97d15/620a9ac8849cd422f315b83d/logo-elastic-vertical-reverse.svg ) 

Table of contents

{{< toc >}}


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
- Show all indexes
```
GET _cat/indices
```  
- create an index
```
PUT /books
{
   "settings": {
        "number_of_shards": 1,
        "number_of_replicas": 1
   }
}
```
- delete the index
```
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
```
GET books/_mapping
```

- retrieving mapping for a field
```
GET books/_mapping/field/book
```

- creation with mapping
```
PUT /books
{
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 1
  },
  "mappings": {
    "dynamic": "strict",
    "properties": {
      "author": {
        "type": "text"
      },
      "book": {
        "type": "text"
      },
      "cite": {
        "type": "text"
      },
      "created": {
        "type": "date"
      },
      "length": {
        "type": "long"
      }
    }
  }
}
```


```
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

- create and appoint an id
```
POST books/_doc 
{
  "message" : "test example message"
}
```
- update if exist or create new with given id
```
POST books/_doc/100/
{
  "message" : "id = 100"
}
```
- retrieve by id
```
GET books/_doc/100/
```


---

## Analize
![](https://www.elastic.co/guide/en/elasticsearch/client/net-api/current/analysis-chain.png)

```
POST _analyze
{
  "text": "Learning a little each day adds up",
  "analyzer": "standard"
}
```
```
POST _analyze
{
  "text": "Learning a little each day adds up",
  "analyzer": "standard"
}
```
```
POST _analyze
{
  "text": "Learning a little each day adds up",
  "analyzer": "keyword"
}
```

```
POST _analyze
{
  "text": "Learning a little each day adds up",
  "char_filter": [],
  "tokenizer": "standard",
  "filter": ["lowercase"]
}
```


---

## Search

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
