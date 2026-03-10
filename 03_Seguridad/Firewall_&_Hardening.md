# 🛡️ Proyecto Intermodular: ClimAir S.L.
## Memoria de Implantación de Sistemas Operativos (ISO)

**Responsable:** Alejandro Sánchez Abellán  
**Curso:** 2025-2026

---

## 🔒 Fase: Seguridad Perimetral y Robustecimiento (Hardening)

En este punto, el servidor de ClimAir ya es operativo y está organizado. Sin embargo, para cumplir con los estándares de seguridad (basados en **ISO 27001** y guías del **NIST**), procedemos a "blindar" el sistema mediante dos ejes principales:

1.  **Seguridad Perimetral (UFW):** Restricción de tráfico no autorizado.
2.  **Hardening de SSH:** Aseguramiento del acceso remoto para evitar intrusiones.

---


> # 🧭 Índice interactivo
> 
> **[A. Seguridad con UFW](#a-seguridad-con-ufw)**
> 1. [Comprobar estado](#1-comprobar-el-estado-actual)
> 2. [Permitir servicios críticos](#2-permitir-solo-lo-necesario)
> 3. [Activación del Firewall](#3-activar-el-firewall)
> 4. [Verificación técnica](#4-verificar)
>
> **[B. Hardening de SSH](#b-hardening-de-ssh)**
> 1. [Backup de configuración](#1-copia-de-seguridad)
> 2. [Políticas de endurecimiento](#2-edición-de-seguridad)
> 3. [Validación de sintaxis](#3-verificación-de-sintaxis)
> 4. [Despliegue de cambios](#4-aplicar-cambios-y-actualizar-firewall)

---

## A. Seguridad con UFW (Uncomplicated Firewall)

El Firewall es la primera línea de defensa. Implementamos una política de **"Denegación por Defecto"**, permitiendo exclusivamente el tráfico necesario para la operatividad de ClimAir (SSH y Samba).



### 1. Comprobar el estado actual
Antes de configurar, verificamos que no existan reglas previas que causen conflictos:
`sudo ufw status`

### 2. Permitir solo lo necesario
Definimos las excepciones para los servicios configurados en las fases anteriores:
Acceso remoto administrativo
`sudo ufw allow ssh`
Protocolos para el servidor de archivos Samba
`sudo ufw allow samba`
### 3. Activar el Firewall
Procedemos a activar el servicio. 
Nota: Al haber habilitado SSH previamente, no perderemos la conexión actual.
`sudo ufw enable`
### 4. Verificar
Confirmamos que las reglas se han aplicado correctamente con el modificador verbose para ver el detalle de las políticas:
`sudo ufw status verbose`
## B. Hardening de SSH
El servicio SSH es el vector de ataque más común. Aplicamos técnicas de robustecimiento para mitigar ataques de fuerza bruta y reducir la superficie de exposición.
### 1. Copia de seguridad
Siguiendo las mejores prácticas de administración, respaldamos la configuración original:Bashsudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
2. Edición de seguridadModificamos el archivo /etc/ssh/sshd_config con los siguientes parámetros de seguridad:ParámetroValorObjetivo TécnicoPermitRootLoginnoImpide que el superusuario sea atacado directamente.MaxAuthTries3Mitiga ataques de fuerza bruta al cerrar la conexión tras 3 fallos.LoginGraceTime30Reduce el tiempo de espera para un login exitoso (evita DoS).AllowUsersadminclimaLista blanca: solo este usuario tiene permiso de entrada.Aplicación de cambios:Bashsudo nano /etc/ssh/sshd_config
# [Modificar o añadir las líneas mencionadas arriba]
3. Verificación de sintaxisAntes de reiniciar el servicio (lo que podría dejarnos fuera del servidor si hay un error), validamos el archivo:Bashsudo sshd -t
Si no hay salida de error, la sintaxis es correcta.4. Aplicar cambios y actualizar FirewallReiniciamos el demonio para aplicar la nueva política:Bashsudo systemctl restart ssh
