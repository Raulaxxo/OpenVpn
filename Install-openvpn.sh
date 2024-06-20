#!/bin/bash

#reenvio de packetes Linux IPV4
sysctl -w net.ipv4.ip_forward=1
echo "Tarea completada: Se ha realizado la acción Reenvio de packetes"


# Longitud de la contraseña
LENGTH=8

# Nombre del archivo
FILE="password.txt"

# Generar la contraseña
PASSWORD=$(tr -dc 'A-Za-z0-9!@#$%&*' < /dev/urandom | head -c $LENGTH)

# Guardar la contraseña en un archivo (reemplazando el archivo si ya existe)
echo "$PASSWORD" > "$FILE"

# Imprimir un mensaje indicando que la contraseña ha sido guardada
echo "La contraseña ha sido generada y guardada en $FILE"

cat $FILE
echo "Ingrese la IP Publica del Servidor OpenVPN:"

read IPSERVER


#Instalando OpenVPN 

echo "Tarea completada: Se ha realizado la acción Ingresar IP Publica"

docker compose run --rm openvpn-server ovpn_genconfig -u udp://$IPSERVER

echo "Tarea completada: Se ha realizado la acción ovpn_genconfig "

docker compose run --rm openvpn-server ovpn_initpki

echo "Tarea completada: Se ha realizado la acción ovpn_initpki "

sudo chown -R $(whoami): ./openvpn-data

cp docker-compose.yml.base docker-compose.yml

./levantar_servicio.sh

echo "Tarea completada: Se ha realizado la acción levantar_servicio "

docker ps 

#Configurando openvpn.conf

rm ./openvpn-data/conf/openvpn.conf
echo "Tarea completada: Se ha realizado la acción Eliminar archivo .conf anterior "

cp ./openvpn-data/conf/openvpn.conf.base ./openvpn-data/conf/openvpn.conf
echo "Tarea completada: Se ha realizado la acción Creando archivo .conf nuevo "


echo "Ingrese la IP Privada del Server:"

read IPPRIVADA

echo "Tarea completada: Se ha realizado la acción Ingresar IP Privada"

echo "### Debo dejar fuera de este ruteo la ip publica del servidor donde esta la VPN" >> ./openvpn-data/conf/openvpn.conf
echo "push \"route $IPSERVER 255.255.255.255 net_gateway\"" >> ./openvpn-data/conf/openvpn.conf

echo "Tarea completada: Se ha realizado la acción Push IP Publica Server "

echo "### Rutas de VPN" >> ./openvpn-data/conf/openvpn.conf
echo 'push "route 10.16.48.0 255.255.255.0"' >> ./openvpn-data/conf/openvpn.conf

echo "Tarea completada: Se ha realizado la acción Push Red VPN "

echo "### IP Privada del servidor de la VPN" >> ./openvpn-data/conf/openvpn.conf
echo "push \"route $IPPRIVADA 255.255.255.255\"" >> ./openvpn-data/conf/openvpn.conf

echo "Tarea completada: Se ha realizado la acción Push IP privada Server "


#instalar Iptables Centos

yum install iptables-services net-tools  -y

systemctl enable iptables
systemctl start iptables
systemctl status iptables

ifconfig 

echo "Que interface es la que usara ?"

ifconfig 

echo "Ingrese el nombre de la interface a continuacion:"

read interface

iptables -t nat -A POSTROUTING -s 10.16.48.0/24 -o $interface -j MASQUERADE


iptables -t nat -L

service iptables save


