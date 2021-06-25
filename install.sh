#!/bin/bash
# Ce script vas installer Docker sur le system (+ prérequis pour l'outils)
# et vas pul les images/services pour utiliser le systeme de log Graylog
#
#   Methodes tirer du site officiel Graylog.org
#
#   commande officiel tirer sur site Graylog.org
#

sudo docker run --name mongo -d mongo:4.2

sudo docker run --name elasticsearch \
    -e "http.host=0.0.0.0" \
    -e "discovery.type=single-node" \
    -e "ES_JAVA_OPTS=-Xms512m -Xmx512m" \
    -d docker.elastic.co/elasticsearch/elasticsearch-oss:7.10.2

sudo docker run --name graylog --link mongo --link elasticsearch \
    -p 9000:9000 -p 12201:12201 -p 1514:1514 \
    -e GRAYLOG_HTTP_EXTERNAL_URI="http://127.0.0.1:9000/" \
    -d graylog/graylog:4.1

sudo docker run --link mongo --link elasticsearch \
    -p 9000:9000 -p 12201:12201 -p 1514:1514 -p 5555:5555 \
    -e GRAYLOG_HTTP_EXTERNAL_URI="http://127.0.0.1:9000/" \
    -d graylog/graylog:4.1

ip a | grep "eth0"