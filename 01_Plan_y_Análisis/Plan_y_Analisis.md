# Proyecto Intermodular: ClimAir S.L. — Implantación de Sistemas Operativos (ISO)

<aside>
📌

***PROYECTO INTERMODULAR: ClimAir S.L.***

*Implantación de Sistemas Operativos (ISO)*

**Responsable:** Alejandro Sánchez Abellán

*2025-2026*

</aside>

<aside>
🧭

**Índice interactivo**

</aside>

---

## 0. Introducción

En nuestro proyecto vamos a trabajar en torno a una PYME del sector de climatización, una empresa llamada **ClimAir S.L.** que está recién formada y requiere de una gestión informática y tecnológica moderna, sin mucho coste, pero eficiente.

En este punto nos vamos a centrar en la **Implantación de Sistemas Operativos**, unido con el conjunto de las demás asignaturas impartidas en nuestro grado ASIR, por lo que todo lo que vamos a tratar estará a su vez enlazado con los demás ámbitos del bloque del proyecto.

---

## 1. Análisis de necesidades de ClimAir S.L.

ClimAir S.L., como cualquier empresa, no es solo de climatización; es una entidad que maneja datos de clientes y técnicos en campo. Sus necesidades técnicas principales son:

- **Escalabilidad:** el almacenamiento debe poder crecer sin reinstalar el sistema.
- **Continuidad de negocio:** el sistema debe sobrevivir a borrados accidentales y fallos críticos mediante automatización.
- **Interoperabilidad:** los administrativos usan Windows 11, pero los datos deben residir en un entorno Linux seguro.
- **Seguridad de la información:** necesitan cumplir con controles de la **ISO/IEC 27001** para proteger facturas y partes de trabajo.

---

## 2. Plan de implantación ejecutado

El despliegue se ha estructurado en cuatro pilares fundamentales para garantizar un entorno de producción robusto y eficiente.

### Fase I: Cimentación y gestión de almacenamiento (LVM)

En lugar de una instalación estándar, hemos optado por un esquema de **LVM (Logical Volume Manager)**.

- **Por qué:** permite redimensionar particiones en caliente.
- **Decisión:** se separa `/srv` (datos) de `/` (sistema) para que un llenado de datos no bloquee el sistema operativo.

### Fase II: Control de acceso basado en roles

Se ha implementado una jerarquía estricta de usuarios y grupos:

- **Grupos:** `administracion` y `tecnicos`.
- **Seguridad especial:** cada grupo tiene permisos diferenciados sobre sus carpetas de trabajo.

### Fase III: Interoperabilidad con Samba

Para que la oficina (Windows) pueda trabajar con el servidor (Linux), se configuró Samba como “traductor universal”.

- **Configuración crítica:** se definieron máscaras de creación y permisos para mantener el control de acceso por grupo.

### Fase IV: Blindaje y automatización

A través de un procedimiento de **hardening**, se blindó la estructura.

- **Firewall (UFW):** política “deny by default”. Solo se abren SSH (22) y los puertos estrictamente necesarios para Samba.
- **Endurecimiento SSH:** se prohíbe el acceso a `root` y se aplican medidas para reducir superficie de ataque.
- **Backups con Cron:** script automatizado en Bash con rotación (7 días) y limpieza de copias antiguas.

---

## 3. Justificación de tecnologías elegidas

| **Tecnología** | **Elección** | **Razón técnica** |
| --- | --- | --- |
| **S.O. servidor** | **Ubuntu 24.04 LTS** | Estabilidad a largo plazo y repositorio amplio con parches de seguridad. |
| **Almacenamiento** | **LVM** | Flexibilidad para redimensionar volúmenes y añadir discos en el futuro. |
| **Servicio de red** | **Samba** | Estándar para redes híbridas Windows/Linux en entornos de oficina. |
| **Seguridad** | **Hardening SSH + UFW** | Minimiza la superficie de ataque ante intrusiones remotas y controla el tráfico entrante. |

---

Después del análisis y el plan de implantación, nos ponemos manos a la obra con nuestro trabajo en ClimAir S.L.

<aside>
🛠️

En los siguientes apartados se documentará paso a paso la instalación y configuración del servidor: red, almacenamiento, usuarios/grupos, permisos, Samba, SSH y tareas automatizadas.

</aside>
