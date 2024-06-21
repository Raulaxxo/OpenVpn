#!/bin/bash

# Instalación de Docker en CentOS 8 con yum

# 1. Actualizar el sistema
sudo yum -y update

# 2. Instalar dependencias
sudo yum -y install yum-utils device-mapper-persistent-data lvm2

# 3. Configurar el repositorio de Docker
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# 4. Instalar Docker Engine
sudo yum -y install docker-ce docker-ce-cli containerd.io

# 5. Iniciar y habilitar Docker
sudo systemctl start docker
sudo systemctl enable docker

# 6. Agregar el usuario actual al grupo docker para evitar el uso de sudo
sudo usermod -aG docker $USER

# Instalación de Docker Compose

# 1. Descargar la versión estable actual de Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://github.com/docker/compose/releases/latest | grep -oP 'tag/\K.*?(?=")')/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# 2. Dar permisos de ejecución a Docker Compose
sudo chmod +x /usr/local/bin/docker-compose

# 3. Crear un enlace simbólico para el acceso global
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# 4. Verificar la instalación
docker --version
docker-compose --version

# Mensaje de finalización
echo "Docker y Docker Compose se han instalado correctamente."
echo "Por favor, cierre sesión y vuelva a iniciar sesión para aplicar los cambios de grupo de Docker."

