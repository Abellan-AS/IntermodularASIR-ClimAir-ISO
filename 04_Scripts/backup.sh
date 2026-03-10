  

#!/bin/bash
# ------------------------------------------------------------------
# Script de Backup 
# Autor: Alejandro Sánchez Abellán
# Objetivo: Copia de seguridad comprimida de facturación con rotación
# ------------------------------------------------------------------

# 1. Definición de Variables 
FECHA=$(date +%Y-%m-%d_%H%M)
DESTINO="/srv/backups" 
ORIGEN="/srv/climair/facturacion" 

echo "Iniciando copia de seguridad de Climair..." 

# 2. Creación del empaquetado comprimido (tar -czf) 
# c: crear, z: comprimir (gzip), f: nombre del archivo 
tar -czf $DESTINO/backup_facturas_$FECHA.tar.gz $ORIGEN 

# 3. Mantenimiento y Rotación (Borrado de copias > 7 días) 
# Evita que el volumen lógico LVM se llene por acumulación 
find $DESTINO -type f -mtime +7 -name "*.tar.gz" -delete 

echo "Backup finalizado con éxito en $DESTINO" 

#NOTAS!! 
#Permisos: Es fundamental otorgar permisos de ejecución con sudo chmod +x /usr/local/bin/backup_climair.sh.

#Programación (Cron): El script está diseñado para ejecutarse diariamente a las 03:00 AM mediante la siguiente línea en el crontab de root:00 03 * * * /usr/local/bin/backup_climair.sh >> /var/log/backup_climair.log 2>&1.

#Auditabilidad: Las salidas y errores se redirigen a un log para permitir auditorías en caso de fallo.
