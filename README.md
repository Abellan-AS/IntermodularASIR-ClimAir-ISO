# IntermodularASIR-ClimAir-ISO
Sección de Implantación de Sistemas Operativos, del Proyecto Intermodular ASIR 25-26.

Informe de Implantación: Proyecto ClimAir S.L.

Resumen Ejecutivo

El proyecto ClimAir S.L. detalla la implementación técnica de un servidor profesional basado en Ubuntu Server 24.04 para la gestión de servicios críticos empresariales. El despliegue se ha realizado en un entorno virtualizado utilizando VirtualBox, configurando un sistema sin interfaz gráfica para optimizar recursos. Los pilares fundamentales de esta implantación incluyen una gestión avanzada de almacenamiento mediante LVM, la interoperabilidad entre sistemas Linux y Windows a través de Samba, y una robusta capa de seguridad perimetral y de acceso. Además, se ha establecido un sistema de automatización para el mantenimiento y respaldo de datos, garantizando la continuidad del negocio frente a posibles desastres técnicos.


--------------------------------------------------------------------------------


1. Configuración del Entorno y Sistema Operativo

La base del proyecto es un servidor Ubuntu Server configurado para actuar como el núcleo de operaciones de la empresa.

Especificaciones de la Máquina Virtual

Se utilizó VirtualBox para la creación del nodo denominado Climair-SVR con las siguientes características:

* Sistema Operativo: Ubuntu (64-bit).
* Memoria RAM: 2048 MB (2 GB), considerada suficiente para servicios sin entorno gráfico.
* Almacenamiento: Disco virtual VDI de 25 GB con reserva dinámica.
* Red: Configurada como "Adaptador Puente" (Bridged Adapter) para garantizar la visibilidad del servidor en la red local.

Instalación y Red

Durante el proceso de instalación de Ubuntu Server 24.04, se establecieron parámetros críticos para la estabilidad del servicio:

* Idioma: Español.
* Configuración de Red (Manual):
  * Subred: 192.168.1.0/24
  * Dirección IP Fija: 192.168.1.18
  * Puerta de enlace: 192.168.1.1 (IP del router).
  * Servidores de nombres (DNS): 8.8.8.8, 1.1.1.1.
* Servicios adicionales: Instalación de OpenSSH Server para gestión remota.


--------------------------------------------------------------------------------


2. Gestión de Almacenamiento (LVM) y Estructura de Datos

Para permitir la escalabilidad y una administración eficiente del disco, se optó por un esquema de particionamiento manual utilizando LVM (Logical Volume Manager).

Estructura de Particiones

Punto de Montaje	Tipo / Formato	Tamaño	Descripción
/boot	Ext4	2 GB	Partición de arranque del sistema.
lv_root (/)	LVM (Ext4)	12 GB	Sistema operativo y archivos de configuración.
lv_data (/srv)	LVM (Ext4)	6 GB	Almacenamiento de datos de la empresa (ClimAir).
Espacio libre	LVM	5 GB	Reservado en el grupo vg_clima para futuras ampliaciones.

Dentro de /srv, se creó la estructura jerárquica para la operatividad de la empresa:

* /srv/climair/facturacion: Destinada a tareas administrativas.
* /srv/climair/partes_trabajo: Destinada a los informes de los técnicos.


--------------------------------------------------------------------------------


3. Administración de Usuarios, Grupos y Permisos

El sistema implementa una política de seguridad basada en grupos para facilitar la herencia de permisos y la escalabilidad de la plantilla.

Configuración de Usuarios y Grupos

Se crearon dos grupos operativos y sus respectivos usuarios:

1. Grupo administracion: Usuario ana_admin.
2. Grupo tecnicos: Usuario pepe_tecnico.

Asignación de Permisos y Propiedad

La seguridad a nivel de archivos se configuró mediante códigos octales y bits especiales:

* Propietario: Todos los directorios pertenecen a root.
* Facturación: Permisos 770 (Lectura, escritura y ejecución para root y el grupo administracion; acceso nulo para el resto).
* Partes de Trabajo: Permisos 770 para root y el grupo tecnicos.
* Sticky Bit (+t): Aplicado a la carpeta de partes de trabajo para evitar que los técnicos borren accidentalmente archivos creados por otros compañeros.


--------------------------------------------------------------------------------


4. Interoperabilidad: Servidor de Archivos Samba

Samba actúa como el "traductor universal" para permitir que estaciones de trabajo Windows accedan a los recursos del servidor Linux.

Configuración del Servicio

* Sincronización: Los usuarios del sistema (Ana y Pepe) fueron dados de alta en la base de datos de Samba mediante el comando smbpasswd.
* Recursos Compartidos (smb.conf): Se definieron dos recursos específicos con control de acceso por grupo:

Recurso	Ruta	Usuarios Válidos	Permisos Máscara
[Facturacion_Climair]	/srv/climair/facturacion	@administracion	0770
[Partes_Climair]	/srv/climair/partes_trabajo	@administracion, @tecnicos	0770

Ambos recursos están configurados como no públicos (guest ok = no) y son navegables (browseable = yes).


--------------------------------------------------------------------------------


5. Seguridad Perimetral y Endurecimiento (Hardening)

La protección del servidor se aborda desde dos frentes: el control de tráfico y el aseguramiento del acceso remoto.

Firewall UFW (Uncomplicated Firewall)

Se implementó una política de denegación por defecto, permitiendo únicamente el tráfico estrictamente necesario:

* Puerto 22 (TCP): SSH para administración.
* Puertos Samba: 137, 138 (UDP) y 139, 445 (TCP).

Endurecimiento de SSH

Para mitigar ataques de fuerza bruta y reducir la superficie de ataque, se modificó el archivo sshd_config:

* PermitRootLogin no: Prohíbe el acceso remoto como superusuario.
* MaxAuthTries 3: Bloquea la conexión tras tres intentos fallidos de contraseña.
* LoginGraceTime 30: Cierra la conexión si el login no se completa en 30 segundos.
* AllowUsers adminclima: Solo permite el acceso por red al usuario administrador específico.


--------------------------------------------------------------------------------


6. Automatización y Continuidad del Negocio

Se diseñó una estrategia de respaldo automatizada para proteger los datos críticos de facturación.

Script de Backup (backup_climair.sh)

El script realiza las siguientes funciones:

1. Empaquetado y Compresión: Utiliza tar -czf para crear archivos .tar.gz con la fecha actual en el nombre.
2. Destino: Almacena las copias en /srv/backups.
3. Mantenimiento Automático: Localiza y elimina archivos de respaldo con más de 7 días de antigüedad para evitar el llenado del disco.

Programación con Cron

La tarea se programó en el crontab de root para ejecutarse en horas de baja actividad:

* Horario: Todos los días a las 03:00 AM.
* Registro (Logging): La salida y los errores se redirigen a /var/log/backup_climair.log para permitir auditorías en caso de fallo.


--------------------------------------------------------------------------------


7. Verificación Final de Sistemas

Tras la implementación, se realizaron comprobaciones críticas para validar el éxito del proyecto:

* Red: Verificación de conectividad mediante ip a y pruebas de ping.
* Almacenamiento: Uso de lsblk y df -h para confirmar el correcto montaje de los volúmenes LVM.
* Samba: Acceso exitoso desde exploradores de archivos Windows mediante la ruta UNC \\192.168.1.18.
* Servicios: Verificación del estado "activo" de smbd, sshd y ufw.
