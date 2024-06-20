#!/bin/bash -e

## parametros
nombre_imagen=`grep container_name: docker-compose.yml`
my_arr=($(echo $nombre_imagen | tr ":" "\n"))
nombre_imagen=${my_arr[1]}

## fin parametros inciales ##

## destruyo container y vuelvo a crear
docker compose down
docker compose up -d


