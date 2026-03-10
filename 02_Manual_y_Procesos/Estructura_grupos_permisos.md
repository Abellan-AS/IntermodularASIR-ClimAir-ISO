# Proyecto Intermodular: ClimAir S.L. — Implantación de Sistemas Operativos (ISO)

<aside>
📌

***PROYECTO INTERMODULAR: ClimAir S.L.***

*Implantación de Sistemas Operativos (ISO)*

***Responsable:** Alejandro Sánchez Abellán*

*2025-2026*

</aside>

---

<aside>
> # 🧭 Índice interactivo

**[A. Estructura de carpetas de la empresa](#a-estructura-de-carpetas-de-la-empresa)**

**[B. Creación de grupos y usuarios](#b-creación-de-grupos-y-usuarios)**

1.  **[1. Crear los grupos operativos:](#1-crear-los-grupos-operativos)**
2.  **[2. Creamos los usuarios (Ana y Pepe):](#2-creamos-los-usuarios-ana-y-pepe)**
3.  **[3. Asignamos contraseñas:](#3-asignamos-contraseñas)**
4.  **[4. Metemos a cada uno en su grupo:](#4-metemos-a-cada-uno-en-su-grupo)**

**[C. Configuración de permisos](#c-configuración-de-permisos)**

1.  **[1. Cambiar el propietario y el grupo:](#1-cambiar-el-propietario-y-el-grupo)**
2.  **[2. Establecer los permisos:](#2-establecer-los-permisos)**
3.  **[3. Verificación Final](#3-verificación-final)**

---

</aside>

---

Después de la creación de nuestro servidor, viene una parte muy importante para la gestión del entorno, los grupos de usuarios y permisos. Esto garantizará seguridad por jerarquía y blindará la integridad de los datos permitiendo una gestión eficiente.

## A. Estructura de carpetas de la empresa

Vamos a crear físicamente las carpetas donde la administrativa y los técnicos **guardarán su trabajo**, dentro de ese volumen de 6GB que preparamos en `/srv`.

1. **Creamos la carpeta raíz del proyecto y sus subcarpetas:**
    
    `sudo mkdir -p /srv/climair/facturacion
    sudo mkdir -p /srv/climair/partes_trabajo`
    
2. **Verificamos que se han creado:**
    
    `ls -l /srv/climair`
    

<img width="561" height="111" alt="image" src="https://github.com/user-attachments/assets/e2469163-308f-48da-9ea8-74da96a4a842" />


---

## B. Creación de grupos y usuarios

Llegamos a un punto muy importante en nuestro proceso de configuración, en una empresa, nunca asignamos permisos a personas sueltas, siempre a **grupos**. Así, si mañana contratamos a otro técnico, solo hay que meterlo en el grupo y heredará todo automáticamente.

Seguimos una serie de pasos:

### 1. Crear los grupos operativos:

Usamos los siguientes comandos

`sudo groupadd administracion
sudo groupadd tecnicos`

### 2. Creamos los usuarios (Ana y Pepe):

Utilizaremos el comando `useradd` con los flags adecuados para que tengan su carpeta personal

(`-m`) y su terminal por defecto (`-s`).

`# Creamos a Ana (Administrativa)
sudo useradd -m -s /bin/bash ana_admin`

`# Creamos a Pepe (Técnico de campo)
sudo useradd -m -s /bin/bash pepe_tecnico`

### 3. Asignamos contraseñas:

`sudo passwd ana_admin      # Ponle por ej: ClimaAna26*
sudo passwd pepe_tecnico   # Ponle por ej: ClimaPepe26*`

<img width="1280" height="800" alt="image" src="https://github.com/user-attachments/assets/cc602bce-b82d-49da-8011-954bade822c1" />

### 4. Metemos a cada uno en su grupo:

`sudo usermod -aG administracion ana_admin
sudo usermod -aG tecnicos pepe_tecnico`

Y con el comando `grep -E 'administracion|tecnicos' /etc/group` podemos ver los grupos y quien pertenece a cada uno, es una prueba de que la estructura está bien.

<img width="567" height="143" alt="image" src="https://github.com/user-attachments/assets/c73552c4-84d4-41d3-a7a0-67df4b5ce9b8" />

---

## C. Configuración de permisos

El siguiente punto es decirle a nuestro sistema **quien manda** en cada carpeta.

### 1. Cambiar el propietario y el grupo:

Queremos que la carpeta de facturación sea del grupo `administracion` y la de partes del grupo `tecnicos`.

`sudo chown -R root:administracion /srv/climair/facturacion
sudo chown -R root:tecnicos /srv/climair/partes_trabajo`

### 2. Establecer los permisos:

Aquí  vamos a usar la jerarquia de octales. Usaremos el código numérico:

- **770** para Facturación: El dueño (root) y el grupo (administracion) pueden hacer todo. El resto del mundo (Pepe) no puede ni entrar.
- **770** para Partes de Trabajo: El dueño y los técnicos pueden trabajar.

`sudo chmod 770 /srv/climair/facturacion
sudo chmod 770 /srv/climair/partes_trabajo`

Y le vamos a meter un Sticky Bit, para que no haya borrados accidentales para que los técnicos no puedan borrar archivos que no hayan creado, aunque tengan permisos en la carpeta.

`sudo chmod +t /srv/climair/partes_trabajo`

<img width="695" height="142" alt="image" src="https://github.com/user-attachments/assets/1443c1c4-aa8d-42fb-b184-7407859be299" />


### 3. Verificación Final

Para comprobar que todo está perfecto, usamos el comando:

`ls -la /srv/climair`

Y comprobamos los permisos RWX que tiene cada uno, incluso la T de los técnicos

<img width="532" height="124" alt="image" src="https://github.com/user-attachments/assets/714d6352-e17c-472f-961a-dfb01cd8257c" />

