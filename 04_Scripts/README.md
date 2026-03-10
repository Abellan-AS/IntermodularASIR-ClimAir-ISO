# 📂 Automatización y Scripts - ClimAir S.L.

Este directorio contiene la lógica de automatización empleada para la gestión del servidor **Clima-SRV**.

### 📜 Nota de Uso y Propósito Técnico
> Los scripts contenidos en este repositorio han sido desarrollados y ejecutados como el núcleo de automatización para el proyecto **ClimAir S.L.**, simulando con rigor técnico un escenario de uso real en una PYME. Estas herramientas han sido las empleadas durante la fase de implantación para gestionar la creación de usuarios, la jerarquía de permisos basada en roles y la política de copias de seguridad con rotación de siete días.
>
> Aunque su concepción es de carácter **didáctico y académico**, su estructura técnica está alineada con las necesidades de escalabilidad y continuidad de negocio de una infraestructura moderna. Por ello, son plenamente adaptables a casos reales tras realizar los ajustes de configuración específicos para cada entorno de producción.

### 🛠️ Scripts incluidos:
1. `backup.sh`: Gestión de copias de seguridad comprimidas con rotación.
2. `setup_gestion.sh`: Provisión de usuarios, grupos y permisos.

3. `update_system.sh`: Mantenimiento y parches de seguridad del sistema.
