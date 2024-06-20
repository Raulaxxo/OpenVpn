# openvpn-server

<b>IMPORTANTE:</b> Antes de "levantar este docker" se debe realizar la inicialización del sistema

Puede que se requieran estos parametros en el servidor host:

* sysctl -w net.ipv6.conf.all.disable_ipv6=0
* sysctl -w net.ipv6.conf.default.forwarding=1
* sysctl -w net.ipv6.conf.all.forwarding=1

 

Inicializar el sistema
-------------------------

(Base en : https://github.com/kylemanna/docker-openvpn/blob/master/docs/docker-compose.md )

<b>Nota:</b> [VPN.SERVERNAME.COM] es el nombre del dominio del servidor de vpn que se esta instalando. 

<b>Nota2:</b> con el comando de mas abajo: "ovpn_initpki" , se debe colocar cualquier clave. Se recomienda sobre 8 caracteres. En el mismo proceso de este comando pregunta <b>"Common Name (eg: your user, host, or server name)"</b> , ahi se debe colocar lo mismo que se coloca en [VPN.SERVERNAME.COM]. Despues el proceso vuelve a pregunta la clave y se coloca la misma que se ingreso al comienzo. 

Ejecutar:

	docker-compose run --rm openvpn-server ovpn_genconfig -u udp://[VPN.SERVERNAME.COM]

	docker-compose run --rm openvpn-server ovpn_initpki

Luego ejecutar esto:

	vi password.txt

y dentro del archivo colocar el password ingresado cuando se ejecuta el comando "ovpn_initpki"


Luego, corregir cualquier problema de permiso ejecutando:

	sudo chown -R $(whoami): ./openvpn-data



Levantar el servicio
-----------------------

Ejecutar:

	./levantar_servicio.sh



Generar un certificado de cliente
------------------------------------

<b>Paso 1: Crear el certificado</b>

Crear certificado sin clave, ejecutar:


	docker exec -it openvpn-server sh -cc " easyrsa build-client-full [NOMBRE_DEL_USUARIO] nopass "


Nota: Si se desea una configuracion extra de seguridad, se debe colocar una clave al certificado de la siguiente manera: 

	docker exec -it openvpn-server sh -cc " easyrsa build-client-full [NOMBRE_DEL_USUARIO] "


<b>Paso 2: Generar el archivo .ovpn</b>

Ejecutar:

	docker exec -it openvpn-server sh -cc " ovpn_getclient [NOMBRE_DEL_USUARIO] " > [NOMBRE_DEL_USUARIO].ovpn

En la carpeta donde se ejecutó el comando anterior se encontrará el archivo <b>[NOMBRE_DEL_USUARIO].ovpn</b> que es el necesario para el cliente openvpn


Si se desea los archivos .crt creados para este cliente, se encuentran en la carpeta

	cd ./openvpn-data/conf/pki/issued

dentro de este mismo GIT



Eliminar un certificado de cliente
---------------------------------



<b>Opcion 1:</b> Eliminar el certificado , pero manteniendo los archivos crt, key y req


	docker exec -it openvpn-server sh -cc " ovpn_revokeclient [NOMBRE_DEL_USUARIO] "


<b>Opcion 2:</b> Eliminar el certificado , pero eliminando los archivos crt, key y req

	docker exec -it openvpn-server sh -cc "  ovpn_revokeclient [NOMBRE_DEL_USUARIO] remove "




Realizar un Debug del servidor
---------------------------------

En vez de utilizar "levantar_servicio.sh" para levantar este docker, utilizar el siguiente comando con el parametro DEBUG=1 (usando "docker -e")

	docker-compose down

	docker-compose run -e DEBUG=1 -p 1194:1194/udp openvpn-server



Documentacion de origen
--------------------------

* base : https://github.com/kylemanna/docker-openvpn

* docker-compose : https://github.com/kylemanna/docker-openvpn/blob/master/docs/docker-compose.md


