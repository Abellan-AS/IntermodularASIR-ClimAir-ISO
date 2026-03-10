#!/bin/bash
# Script de mantenimiento preventivo (Esto es un básico ejemplo, se recomienda personalizar según necesidades específicas)

echo "Sincronizando repositorios..."
sudo apt update 

echo "Aplicando actualizaciones de seguridad..."
sudo apt upgrade -y 

echo "Limpiando paquetes innecesarios..."
sudo apt autoremove -y

