# **Proyecto Intermodular: ClimAir S.L. — Implantación de Sistemas Operativos (ISO)**

<aside>
📌

***PROYECTO INTERMODULAR: ClimAir S.L.***

*Implantación de Sistemas Operativos (ISO)*

***Responsable:** Alejandro Sánchez Abellán*

*2025-2026*

</aside>

Después de poner a punto nuestro servidor, ahora toca convertirlo en un servidor de archivos de grado profesional.

En **ISO**, configurar Samba no es solo hacer que se vea la carpeta, es gestionar las **interacciones** entre Linux y Windows manteniendo la seguridad.

Como ya tenemos los directorios creados, nos ponemos manos a la obra con la instalación y configuración del servicio.

---

<aside>
🧭  Indice interactivo

1.  **[1. Instalación del Servicio Samba](#1-instalación-del-servicio-samba)**
    * **[Sus funciones principales](#sus-funciones-principales)**
2.  **[2. Gestión de Usuarios de Red (Samba)](#2-gestión-de-usuarios-de-red-samba)**
3.  **[3. Configuración del Recurso Compartido (smb.conf)](#3-configuración-del-recurso-compartido-smbconf)**
    * **[3. Aplicar los cambios (Reiniciar el servicio)](#3-aplicar-los-cambios-reiniciar-el-servicio)**
4.  **[4. ¿Cómo entrar desde Windows?](#4-cómo-entrar-desde-windows)**

---

</aside>

---

## 1. Instalación del Servicio Samba

**Samba** es el "traductor universal" que permite que computadoras con sistemas operativos diferentes se entiendan y compartan recursos en una misma red.

### Sus funciones principales

- Compartir archivos
    - Es su uso más famoso. Permite que un servidor Linux actúe como si fuera un servidor de archivos de Windows.
    - Puedes ver carpetas alojadas en un servidor Linux desde tu explorador de archivos de Windows como si fueran una unidad de red común (`Z:`).
- Controlador de Dominio (Active Directory)
    - Puede gestionar inicios de sesión, políticas de grupo (GPOs) y autenticación de usuarios en una red de computadoras Windows, eliminando la necesidad de pagar licencias costosas de Windows Server para esta tarea.

Para instalarlo seguimos los comandos comunes en nuestro servidor:

`sudo apt update
sudo apt install samba -y`

## 2. Gestión de Usuarios de Red (Samba)

**Samba gestiona su propia base de datos de contraseñas**. Aunque el usuario exista en Linux, hay que darle de alta en Samba.

`# Sincronizamos a Ana con la base de datos de Samba
sudo smbpasswd -a ana_admin`

# Si quieres que Pepe también entre a los partes:
`sudo smbpasswd -a pepe_tecnico`

En nuestro caso simulado vamos a poner la misma contraseña que en linux, pero la realidad es asignar contraseñas diferentes a cada usuario.

## 3. Configuración del Recurso Compartido (smb.conf)

Vamos a editar el cerebro de Samba con  una configuración limpia y segura.

1. **Copia de seguridad del original**
    
    `sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.bak`
    
2. **Edita el archivo**
    
    `sudo nano /etc/samba/smb.conf`
    
3. **Vamos al final del archivo y añadimos esto (explicado después de la captura):**

`# Configuración específica para Climair S.L.`

`[Facturacion_Climair]
   comment = Carpeta de Contabilidad y Facturas
   path = /srv/climair/facturacion
   browseable = yes
   read only = no
   guest ok = no
   valid users = @administracion
   create mask = 0770
   directory mask = 0770`

`[Partes_Climair]
   comment = Registro de instalaciones y mantenimiento
   path = /srv/climair/partes_trabajo
   browseable = yes
   read only = no
   guest ok = no
   valid users = @administracion, @tecnicos
   create mask = 0770
   directory mask = 0770 `

Una vez que hayas pegado o escrito ese texto al final del archivo `/etc/samba/smb.conf`:

1. **Guardar:** Presiona la combinación de teclas `Ctrl` + `O` (la letra O de *Output*).
2. **Confirmar:** Verás que abajo pone el nombre del archivo. Simplemente pulsa **`Enter`**.
3. **Salir:** Presiona `Ctrl` + `X` para volver a la terminal (donde sale el prompt `$`).
    
  <img width="597" height="800" alt="image" src="https://github.com/user-attachments/assets/04baa1e5-174f-48c7-9513-fe0618ea57f3" />

    

Para entender lo que estamos piqueando, básicamente:

`valid users = @grupo`: Solo los miembros de ese grupo pueden entrar.

`create mask = 0770`: Asegura que cualquier archivo nuevo creado desde Windows herede los permisos que configuramos en ISO (dueño y grupo con todo, otros nada).

### 3. Aplicar los cambios (Reiniciar el servicio)

En Linux, los cambios en los archivos de configuración no se aplican solos. Hay que decirle al servicio de Samba que vuelva a leer el archivo:

`sudo systemctl restart smbd nmbd`

Y para verificar (como siempre en todo lo que vamos haciendo):

`sudo systemctl status smbd` 

Si nos sale en verde, lo tenemos.

<img width="1127" height="398" alt="image" src="https://github.com/user-attachments/assets/92563ea1-ecfb-4f05-85ee-5440f485e2a8" />

### 4. ¿Cómo entrar desde Windows?

Ahora viene la magia. Vamos a nuestro PC real (o a otra máquina virtual con Windows):

1. Abrimos una carpeta cualquiera.
2. En la barra de arriba (donde pone la ruta), escribimos la IP de tu servidor precedida de dos barras invertidas: `\\192.168.1.18`
3. Usuario y contraseña. 
    - **Usuario:** `ana_admin`
    - **Contraseña:** (no se incluye en la memoria por seguridad)

<img width="1490" height="502" alt="image" src="https://github.com/user-attachments/assets/3903081d-b857-42dc-b599-d7919da08a57" />


Y si vemos las carpetas de nuestro Server, es que lo hemos conseguido. 

<img width="666" height="252" alt="image" src="https://github.com/user-attachments/assets/6059a668-0fc9-4b22-963c-20dba57a0abe" />


Hemos conseguido a través de Samba, hacer que nuestras máquinas se entiendan entre sí, ahora podemos gestionar todo desde ambas, manteniendo la seguridad y generando interoperabilidad.
