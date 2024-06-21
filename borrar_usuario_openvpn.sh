#!/bin/bash

##parametros
me=`basename "$0"`

nombre_imagen=`grep container_name: docker-compose.yml`
my_arr=($(echo $nombre_imagen | tr ":" "\n"))
nombre_imagen=${my_arr[1]}

modo_de_uso="
modo de uso ./$me [usuario]

./$me client-jtest

"

if [ $# -eq 0 ]
  then
    echo "Falta Usuario. $modo_de_uso "
    exit
fi

NOMBRE_DEL_USUARIO=$1

docker exec -it openvpn-server sh -cc "  ovpn_revokeclient $NOMBRE_DEL_USUARIO remove "

rm  openvpn-data/conf/ccd/$NOMBRE_DEL_USUARIO
