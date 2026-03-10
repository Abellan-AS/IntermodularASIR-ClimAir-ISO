# Proyecto Intermodular: ClimAir S.L. —Implantación de Sistemas Operativos (ISO)

<aside>
📌

***PROYECTO INTERMODULAR: ClimAir S.L.***

*Memoria de Implantación de Sistemas Operativos (ISO)*

**Responsable:** Alejandro Sánchez Abellán

*2025-2026*

</aside>

Después de blindar nuestra seguridad perimetral y filtrar protocolos, vamos a tomar una medida eficiente para el guardado de datos, el backup.

Lo vamos a gestionar de tal manera que se guarde y genere automáticamente y se borre y actualice cada 7 días para evitar la congestión.

Se van a utilizar una serie de scripts detallas y explicados en el proceso.

---

> ### 🧭 Índice interactivo
> 
> **A. [Automatización con Backup.](#a-automatización-con-backup)**
> 1. [Crear el directorio de copias:](#1-crear-el-directorio-de-copias)
> 2. [Crear el script:](#2-crear-el-script)
> 3. [Dar permisos de ejecución:](#3-dar-permisos-de-ejecución)
> 4. [Probar el script:](#4-probar-el-script)
> 5. [¿Cómo funciona Cron?:](#5-cómo-funciona-cron)
> 6. [Programando el Backup:](#6-programando-el-backup)
---

## A. Automatización con Backup.

En ISO, los **scripts** son obligatorios. Vamos a crear una herramienta que comprima la carpeta de facturación todas las noches.

### 1. Crear el directorio de copias:

Como tenemos espacio en el LVM, crearemos una carpeta de seguridad:

`sudo mkdir /srv/backups`

### 2. Crear el script:

1. Abrimos el editor: `sudo nano /usr/local/bin/backup_climair.sh`
2. Montamos este script(Explicación del script al final de la presentación):
`# Script de Backup para Climair SVR
# Autor: [Alejandro]

FECHA=$(date +%Y-%m-%d_%H%M)
DESTINO="/srv/backups"
ORIGEN="/srv/climair/facturacion"

echo "Iniciando copia de seguridad de Climair..."

# Comprimimos la carpeta de facturación en un archivo .tar.gz
tar -czf $DESTINO/backup_facturas_$FECHA.tar.gz $ORIGEN

# Borramos copias de más de 7 días para no llenar el disco (Mantenimiento)
find $DESTINO -type f -mtime +7 -name "*.tar.gz" -delete

echo "Backup finalizado con éxito en $DESTINO"`
3. Guardamos y salimos (`Ctrl+O`, `Enter`, `Ctrl+X`).

<img width="598" height="331" alt="image" src="https://github.com/user-attachments/assets/b889a0ae-e809-4199-ae7c-e5f82fc602f1" />


### 3. Dar permisos de ejecución:

`sudo chmod +x /usr/local/bin/backup_climair.sh`

### 4. Probar el script:

`sudo /usr/local/bin/backup_climair.sh
ls -lh /srv/backups`

<img width="1030" height="218" alt="image" src="https://github.com/user-attachments/assets/ff597888-c391-4d02-8d61-b76bba0729d2" />

Ya tenemos en funcionamiento nuestro backup pero queremos automatizarlo para no tener que ejcutarlo a mano, lo haremos mediante Cron, que es el encargado de ejecutar tareas en segundo plano a intervalos regulares en Linux.

### 5. ¿Cómo funciona Cron?:

El archivo donde se guardan estas tareas se llama **crontab**. Cada línea tiene 5 campos de tiempo seguidos del comando:
`Minuto Hora Día Mes Día_de_la_semana Comando`

### 6. Programando el Backup:

Vamos a configurar el script para que se ejecute **todos los días a las 03:00 AM**, una hora de baja actividad en la empresa.

1. **Abrimos el editor de crontab para el usuario root** (ya que el script necesita `sudo` para acceder a `/srv/backups`)
    
    `sudo crontab -e`
    
    *Si es la primera vez, te preguntará qué editor usar. Elige 1 (nano), que es el que ya dominas.*
    
2. **Bajamos hasta el final del archivo y añadimos esta línea exactamente:**
    
    `00 03 * * * /usr/local/bin/backup_climair.sh >> /var/log/backup_climair.log 2>&1`
    
3. **Guardamos y salimos:** (`Ctrl+O`, `Enter`, `Ctrl+X`).

<img width="749" height="549" alt="image" src="https://github.com/user-attachments/assets/b39a3ff0-3678-43a0-b810-307231554afd" />


* Explicación técnica de la línea:

- **`00 03 * * *`**: Ejecutar al minuto 0, de la hora 3, todos los días del mes, todos los meses, todos los días de la semana.
- **`/usr/local/bin/backup_climair.sh`**: La ruta absoluta hacia nuestro script.
- **`>> /var/log/backup_climair.log 2>&1`**: Estamos redirigiendo la salida del script y los posibles errores a un archivo de log propio. Así, si un día el backup falla, podremos auditar qué pasó consultando `/var/log/backup_climair.log`.

**Script de Backup:

1.(`#!/bin/bash`)

Es la primera línea. Le dice al servidor que **es una lista de órdenes para el intérprete de comandos Bash**.

1. Variables

Creamos etiquetas para que sea más fácil leer y cambiar:

- **`FECHA`**: Guarda el momento exacto del backup . Así, cada copia tiene un nombre distinto y no borras la anterior por accidente.
- **`DESTINO`**: La carpeta donde guardamos las copias (`/srv/backups`).
- **`ORIGEN`**: La carpeta que queremos proteger (`/srv/climair/facturacion`).
1. El comando (`tar -czf`)

El comando `tar` hace tres cosas a la vez:

1. Mete todo en una caja  `c`(empaqueta).
2. Lo comprime con `z`, que es gzip.
3. Le pone un nombre `f`.
4. El comando (`find ... -delete`)

Si hacemos copias todos los días y nunca borramos nada, el disco del servidor de Climair se llenaría en un mes.
Esta línea lo que hace es borrar todos los backups de más de 7 días para garantizar espacio en disco.
