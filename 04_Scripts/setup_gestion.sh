#!/bin/bash
# ------------------------------------------------------------------
# Script de Gestión de Usuarios y Estructura de Directorios
# Autor: Alejandro Sánchez Abellán
# Objetivo: Creación de estructura de directorios, grupos y usuarios
# ------------------------------------------------------------------

# 1. Creación de grupos operativos
sudo groupadd administracion
sudo groupadd tecnicos 

# 2. Creación de usuarios con carpeta personal y bash 
sudo useradd -ms /bin/bash ana_admin
sudo useradd -ms /bin/bash pepe_tecnico

# 3. Asignación a sus grupos correspondientes 
sudo usermod -aG administracion ana_admin
sudo usermod -aG tecnicos pepe_tecnico 

# 4. Creación de la estructura de carpetas en el volumen LVM
sudo mkdir -p /srv/climair/facturacion
sudo mkdir -p /srv/climair/partes_trabajo 

# 5. Aplicación de Propiedad y Permisos 
sudo chown -R root:administracion /srv/climair/facturacion 
sudo chown -R root:tecnicos /srv/climair/partes_trabajo
sudo chmod 770 /srv/climair/facturacion
sudo chmod 770 /srv/climair/partes_trabajo 

# 6. Aplicación del Sticky Bit por seguridad 
# Evita que técnicos borren partes de otros compañeros
sudo chmod +t /srv/climair/partes_trabajo 

echo "Estructura de ClimAir S.L. creada con éxito."

#NOTAS!!
#Este script automatiza toda la estructura organizativa de ClimAir S.L. en el servidor, asegurando que cada departamento tenga acceso controlado a sus recursos. Es fundamental ejecutar este script con privilegios de superusuario para garantizar la correcta creación de grupos, usuarios y asignación de permisos. Además, se recomienda revisar periódicamente los permisos y la estructura para mantener la seguridad y eficiencia del sistema.

#Está adaptado al caso ejemplo, pero puede ser modificado para otras organizaciones con necesidades similares, simplemente ajustando los nombres de grupos, usuarios y rutas de directorios según corresponda.