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
read -p "Ingrese la ip a agregar: " IP

# Verifica si la palabra existe en el archivo
if grep -q "$IP" "$ruta"; then
    echo "La palabra '$IP' ya existe en el archivo '$ruta'."
else
    # Agrega la palabra al archivo
   echo "push \"route $IP 255.255.255.255\"" >> "$ruta"
    echo "La palabra '$IP' se ha agregado al archivo '$ruta'."
    tail $ruta
fi


