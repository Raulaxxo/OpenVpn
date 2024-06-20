#!/bin/bash

nombre_imagen=`grep container_name: docker-compose.yml`
my_arr=($(echo $nombre_imagen | tr ":" "\n"))
nombre_imagen=${my_arr[1]}

docker logs -f $nombre_imagen

