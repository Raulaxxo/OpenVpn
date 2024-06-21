#!/bin/bash
clear

# Definir colores ANSI
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m' # No Color

# Función para imprimir mensajes con formato
print_message() {
    echo -e "✔ -- ${YELLOW}$(tput bold)$1$(tput sgr0)${NC} -- ${GREEN}$(tput bold)OK$(tput sgr0)${NC}"
}

# Función para imprimir mensajes de error
print_error() {
    echo -e "✔ -- ${YELLOW}$(tput bold)$1$(tput sgr0)${NC} -- ${RED}$(tput bold)ERROR$(tput sgr0)${NC}"
}

# Texto ASCII
echo "
  ____               __      _______       
 / __ \              \ \    / /  __ \      
| |  | |_ __   ___ _ _\ \  / /| |__) | __  
| |  | | '_ \ / _ \ '_ \ \/ / |  ___/ '_ \ 
| |__| | |_) |  __/ | | \  /  | |   | | | |
 \____/| .__/ \___|_| |_|\/   |_|   |_| |_| 
       | |                                 
       |_|                                 
"

print_message "Script Creado Por: Raul SIlva Gotterban"
print_message "Reenvio de packetes Linux IPV4"
#reenvio de packetes Linux IPV4
sysctl -w net.ipv4.ip_forward=1
print_message "Tarea completada: Se ha realizado la acción Reenvio de packetes"

# Longitud de la contraseña
LENGTH=8

# Nombre del archivo
FILE="password.txt"

# Generar la contraseña
PASSWORD=$(tr -dc 'A-Za-z0-9!@#$%&*' < /dev/urandom | head -c $LENGTH)

# Guardar la contraseña en un archivo (reemplazando el archivo si ya existe)
echo "$PASSWORD" > "$FILE"
print_message "La contraseña ha sido generada y guardada en $FILE"

# Imprimir el contenido del archivo en rojo y negrita
echo -e "${RED}$(tput bold)Contenido de $FILE:$(tput sgr0)${NC}"
cat $FILE

print_message "Ingrese la IP Publica del Servidor OpenVPN:"

read IPSERVER

#Instalando OpenVPN 
print_message "Tarea completada: Se ha realizado la acción Ingresar IP Publica"

docker compose run --rm openvpn-server ovpn_genconfig -u udp://$IPSERVER
print_message "Tarea completada: Se ha realizado la acción ovpn_genconfig"

docker compose run --rm openvpn-server ovpn_initpki
print_message "Tarea completada: Se ha realizado la acción ovpn_initpki"

sudo chown -R $(whoami): ./openvpn-data

cp docker-compose.yml.base docker-compose.yml

./levantar_servicio.sh
print_message "Tarea completada: Se ha realizado la acción levantar_servicio"

docker ps 

#Configurando openvpn.conf
rm ./openvpn-data/conf/openvpn.conf
print_message "Tarea completada: Se ha realizado la acción Eliminar archivo .conf anterior"

cp ./openvpn-data/conf/openvpn.conf.base ./openvpn-data/conf/openvpn.conf
print_message "Tarea completada: Se ha realizado la acción Creando archivo .conf nuevo"


sed -i '3s|.*|key /etc/openvpn/pki/private/'"$IPSERVER"'.key|' ./openvpn-data/conf/openvpn.conf
sed -i '5s|.*|cert /etc/openvpn/pki/issued/'"$IPSERVER"'.crt|' ./openvpn-data/conf/openvpn.conf


print_message "Ingrese la IP Privada del Server:"
read IPPRIVADA
print_message "Tarea completada: Se ha realizado la acción Ingresar IP Privada"

echo "### Debo dejar fuera de este ruteo la ip publica del servidor donde esta la VPN" >> ./openvpn-data/conf/openvpn.conf
echo "push \"route $IPSERVER 255.255.255.255 net_gateway\"" >> ./openvpn-data/conf/openvpn.conf
print_message "Tarea completada: Se ha realizado la acción Push IP Publica Server"

echo "### Rutas de VPN" >> ./openvpn-data/conf/openvpn.conf
echo 'push "route 10.16.48.0 255.255.255.0"' >> ./openvpn-data/conf/openvpn.conf
print_message "Tarea completada: Se ha realizado la acción Push Red VPN"

echo "### IP Privada del servidor de la VPN" >> ./openvpn-data/conf/openvpn.conf
echo "push \"route $IPPRIVADA 255.255.255.255\"" >> ./openvpn-data/conf/openvpn.conf
print_message "Tarea completada: Se ha realizado la acción Push IP privada Server"


#instalar Iptables Centos
print_message "Instalando Iptables y net-tools en CentOS..."
yum install iptables-services net-tools -y
print_message "Instalación completada"

systemctl enable iptables
systemctl start iptables
systemctl status iptables
print_message "Firewall configurado"

ifconfig 
print_message "Interfaces de red disponibles"

print_message "¿Qué interfaz es la que usará?"
ifconfig 
print_message "Ingrese el nombre de la interfaz a continuación:"
read interface

iptables -t nat -A POSTROUTING -s 10.16.48.0/24 -o $interface -j MASQUERADE

#iptables -t nat -L

iptables -t nat -L -n -v


print_message "Configuración de NAT"

service iptables save
print_message "Configuración guardada"

