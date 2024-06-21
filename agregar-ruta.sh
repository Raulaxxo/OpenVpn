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

usuario=$1

ruta=./openvpn-data/conf/ccd/$usuario

# Solicita el nombre del archivo y la palabra al usuario
read -p "Ingrese la IP a agregar: " IP
read -p "Comentario de donde es la IP: " comentario

# Verifica si la palabra existe en el archivo
if grep -q "$IP" "$ruta"; then
   echo "La IP '$IP' ya existe en el Usuario '$ruta'."
else
    
   echo "# $comentario" >> "$ruta"
   echo "push \"route $IP 255.255.255.255\"" >> "$ruta"
   echo "La IP '$IP' se ha agregado al Usuario '$ruta'."
   tail $ruta
fi


