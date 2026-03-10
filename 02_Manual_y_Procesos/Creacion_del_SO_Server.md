# Proyecto Intermodular: ClimAir S.L. — Implantación de Sistemas Operativos (ISO)

<aside>
📌

***PROYECTO INTERMODULAR: ClimAir S.L.***

*Implantación de Sistemas Operativos (ISO)*

***Responsable:** Alejandro Sánchez Abellán*

*2025-2026*

</aside>

Después del análisis técnico de la estructura necesaria para la empresa con la que vamos a trabajar, llega el momento de ponernos en funcionamiento, en este apartado vamos a poner en práctica nuestros conocimientos y vamos a llevarlo a cabo en un entorno virtual, pero simulando perfectamente lo que sería un caso de uso real.
En nuestro caso (ISO) vamos a montar un servidor Ubuntu sin interfaz gráfica para gestionar grupos y usuarios, permisos, servicio Samba y tanto la seguridad como el servicio remoto SSH.
Además nos servirá para después enlazar con los proyectos de las demás asignaturas.

---

<aside>
🧭

# **Índice interactivo**

</aside>

---

## A. Creación de la Máquina Virtual

En este caso voy a trabajar con VirtualBox, que es lo que hemos estado utilizando en clase.

1. **Nombre:** `Clima-SRV`
2. **Tipo:** Linux / **Versión:** Ubuntu (64-bit).
3. **Memoria RAM:** **2048 MB (2 GB)**. Suficiente para servicios sin entorno gráfico.
4. **Disco Duro:** Disco virtual  (VDI) de 25 **GB**, reservado dinámicamente.

---

## B. Configuración de Red

Para que el servidor sea accesible desde mi PC, vamos a usar Adaptador puente como configuración de red.

- Vamos a **Configuración** -> **Red**.
- En "Conectado a:", seleccionamos **Adaptador Puente (Bridged Adapter)**.

<aside>
🖼️

Captura de pantalla (VirtualBox)

</aside>

<img width="833" height="912" alt="image" src="https://github.com/user-attachments/assets/bca167a6-b295-41a2-9e49-eb1e5abd8f5b" />


---

## C. Instalación de Ubuntu Server:

Arrancamos la máquina con la ISO de Ubuntu Server 24.04, y proseguimos paso a paso:

### 1. Idioma y Teclado

- **Language:** Spanish (en mi caso)

### 2. Tipo de Instalación

- **Ubuntu Server**

### 3. Configuración de Red (Importante)

El instalador detectará una IP por DHCP, pero vamos a ponerla fija.

1. Selección de la interfaz (`np0s3`) -> **Edit IPv4**.
2. Cambio a **Manual**.
3. **Subnet:** `192.168.1.0/24` 
4. **Address:** `192.168.1.18`
5. **Gateway:** La IP de tu router (ej. `192.168.1.1`).
6. **Name servers:** `8.8.8.8, 1.1.1.1`.

<aside>
🖼️

Captura de pantalla (configuración de red)

</aside>

<img width="1280" height="800" alt="image" src="https://github.com/user-attachments/assets/eeae32ad-97ac-41a8-86fe-5aa9d80b0655" />


### 4. Almacenamiento

Vamos a crear particiones con LVM para administrar el servidor:

1. Quitamos  "Set up this disk as an LVM group" que viene por defecto. Vamos a hacerlo **manualmente**.
2. **Custom storage layout**.
3. La **estructura** va a ser :
    - **Partición /boot:** 2 GB (Formato ext4).
    - **Espacio restante:**  un **LVM Group** llamado `vg_clima`.
    - Dentro del grupo,  los **LV**:
        - `lv_root`: 12 GB (Montado en `/`).
        - `lv_data`: 6 GB (Montado en `/srv`). Aquí van los datos de la empresa, de momento es una empresa pequeña pero dejamos dejamos otros 5GB para poder escalar.

![VirtualBox_Climair-SVR_09_03_2026_19_44_20.png](attachment:4f50efa1-07c0-4fc9-83e4-73a3e8bcd520:VirtualBox_Climair-SVR_09_03_2026_19_44_20.png)

### 5.Configuración del Perfil

- Nombre `Administrador Clima`
- **Your server's name:** `climair-srv`
- **Username:** `adminclima`
- **Password:** (definida durante la instalación; no se incluye en la memoria por seguridad).

![VirtualBox_Climair-SVR_09_03_2026_20_07_32.png](attachment:502570ba-b197-447e-88d3-e6ad55adba2f:VirtualBox_Climair-SVR_09_03_2026_20_07_32.png)

### 6.Configuración de SSH

Queremos  **SSH** para poder gestionar el servidor **remotamente**:

1. Pulsa la barra espaciadora para marcar **`[X] Install OpenSSH server`**.
2. Sin llaves
3. En este caso no voy a instalar ninguna función, lo quiero limpio

Llegaremos a la pantalla en la que nos pida Reiniciar, dando por finalizada la parte de instalación de nuestro Servidor.

![VirtualBox_Climair-SVR_09_03_2026_20_15_26.png](attachment:024c1f54-c77b-4785-a7fd-9135f8ab4090:VirtualBox_Climair-SVR_09_03_2026_20_15_26.png)

---

## 7. Comprobaciones y verificación final

Vamos a realizar una serie de **verificaciones** para ver que todo funciona:

1. Comprobación de Red: 
- Ejecutamos el comando `ip a` para ver que aparece nuestra ip. 
- Ping a [google.com](http://google.com) por ejemplo para ver si recibimos paquetes.
2. Verificación del LVM:
- Usamos el comando `lsblk` para ver el árbol de montaje.
- Usamos el comando `df -h`  para ver el tamaño real y el uso de disco de las particiones.

<aside>
✅

Comprobación básica tras la instalación

</aside>

![45.png](attachment:539e76dd-dbe2-47f3-b34a-56db3e9a5d69:45.png)

### 8. Actualización del sistema

Antes de configurar nada, actualizamos el sistema:

1. **Sincronización**
    
    `sudo apt update`
    
2. **Actualización**
    
    `sudo apt upgrade -y`
    
    Tenemos nuestro servidor instalado y montado listo para trabajar en él los parámetros que vamos a implementar en la empresa.
