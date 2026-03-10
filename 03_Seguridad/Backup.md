# 🛡️ Proyecto Intermodular: ClimAir S.L.
## Memoria de Implantación de Sistemas Operativos (ISO)

**Responsable:** Alejandro Sánchez Abellán  
**Curso:** 2025-2026

---

## 📑 Índice Interactivo
* [1. Automatización con Backup](#1-automatización-con-backup)
* [2. Configuración del Script](#2-configuración-del-script)
* [3. Automatización con Cron](#3-automatización-con-cron)
* [4. Análisis Técnico](#4-análisis-técnico)

---

## 1. Automatización con Backup
En el entorno de **ISO**, la automatización mediante scripts es imperativa. Hemos diseñado una herramienta para comprimir la facturación diariamente y asegurar la disponibilidad de los datos.

### Preparación del Directorio
Como disponemos de espacio en el **LVM**, creamos una carpeta de seguridad dedicada:
```bash
sudo mkdir -p /srv/backups

2. Configuración del ScriptCreamos el script en una ruta del sistema para que sea accesible: sudo nano /usr/local/bin/backup_climair.shCódigo del ScriptBash#!/bin/bash
# Script de Backup para Climair SVR
# Autor: Alejandro Sánchez Abellán

FECHA=$(date +%Y-%m-%d_%H%M)
DESTINO="/srv/backups"
ORIGEN="/srv/climair/facturacion"

echo "Iniciando copia de seguridad de Climair..."

# Comprimimos la carpeta de facturación
tar -czf $DESTINO/backup_facturas_$FECHA.tar.gz $ORIGEN

# Borramos copias de más de 7 días (Mantenimiento)
find $DESTINO -type f -mtime +7 -name "*.tar.gz" -delete

echo "Backup finalizado con éxito en $DESTINO"
Importante: No olvides dar permisos de ejecución con sudo chmod +x /usr/local/bin/backup_climair.sh3. Automatización con CronPara no ejecutarlo manualmente, usamos el demonio Cron.TareaHorarioComandoSalida (Log)Backup Diario03:00 AM/usr/local/bin/backup_climair.sh/var/log/backup_climair.logConfiguración en Crontab (sudo crontab -e):Fragmento de código00 03 * * * /usr/local/bin/backup_climair.sh >> /var/log/backup_climair.log 2>&1
4. Análisis TécnicoA continuación, se detalla el funcionamiento de los comandos utilizados en el proyecto:ComandoFunciónParámetrosUtilidad en ClimAirtarArchivar y comprimir-czfEmpaqueta las facturas en un solo archivo .tar.gz.findBúsqueda de archivos-mtime +7Localiza backups antiguos para rotación de datos.deleteBorrado automático-deleteElimina los archivos encontrados por find para ahorrar espacio.dateGestión de tiempo+%Y-%m-%dEtiqueta cada copia con fecha y hora única.>>RedirecciónappendGuarda el historial de ejecución en un log sin borrar el anterior.
