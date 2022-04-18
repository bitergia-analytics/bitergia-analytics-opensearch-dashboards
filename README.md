# Bitergia Analytics OpenSearch Dashboards

Docker files for building the Bitergia Analytics image
for OpenSearch Dashboards.

## Using the image

First, pull the image using the following command:

```
docker pull bitergia/bitergia-analytics-opensearch-dashboards:latest
```

To run a container you will also need to run a `bitergia-analytics-opensearch`
image. We recommend to use docker-compose with the next file:

- **bap.yaml**
```
version: '3'
services:
  bap-node1:
    image: bitergia/bitergia-analytics-opensearch:latest
    container_name: bap-node1
    environment:
      - cluster.name=bap-cluster
      - node.name=bap-node1
      - discovery.seed_hosts=bap-node1,bap-node2
      - cluster.initial_master_nodes=bap-node1,bap-node2
      - bootstrap.memory_lock=true # along with the memlock settings below, disables swapping
      - "OPENSEARCH_JAVA_OPTS=-Xms512m -Xmx512m" # minimum and maximum Java heap size, recommend setting both to 50% of system RAM
    ulimits:
      memlock:
        soft: -1
        hard: -1
      nofile:
        soft: 65536 # maximum number of open files for the OpenSearch user, set to at least 65536 on modern systems
        hard: 65536
    volumes:
      - bap-data1:/usr/share/bap/data
    ports:
      - 9200:9200
      - 9600:9600 # required for Performance Analyzer
    networks:
      - bap-net
  bap-node2:
    image: bitergia/bitergia-analytics-opensearch:latest
    container_name: bap-node2
    environment:
      - cluster.name=bap-cluster
      - node.name=bap-node2
      - discovery.seed_hosts=bap-node1,bap-node2
      - cluster.initial_master_nodes=bap-node1,bap-node2
      - bootstrap.memory_lock=true
      - "OPENSEARCH_JAVA_OPTS=-Xms512m -Xmx512m"
    ulimits:
      memlock:
        soft: -1
        hard: -1
      nofile:
        soft: 65536
        hard: 65536
    volumes:
      - bap-data2:/usr/share/bap/data
    networks:
      - bap-net
  bap-dashboards:
    image: bitergia/bitergia-analytics-opensearch-dashboards:latest
    container_name: bap-dashboards
    ports:
      - 5601:5601
    expose:
      - "5601"
    environment:
      OPENSEARCH_HOSTS: '["https://bap-node1:9200","https://bap-node2:9200"]' # must be a string with no spaces when specified as an environment variable
    networks:
      - bap-net

volumes:
  bap-data1:
  bap-data2:

networks:
  bap-net:
```

With the previous file, execute `docker-compose -f bap.yaml up` to run
the containers.
