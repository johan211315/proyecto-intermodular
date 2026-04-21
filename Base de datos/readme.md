# 🗄️ Diseño y Administración de Base de Datos - ArticWolves

Este apartado del proyecto documenta la infraestructura de datos de la editorial **ArticWolves**, centrada en un servidor robusto **Debian GNU/Linux** ejecutando **MariaDB**.

## 📑 Descripción del Sistema de Datos
La base de datos `arcticwolves_db` ha sido diseñada para gestionar de manera integral el ciclo de vida de la editorial:

### Áreas Clave de Información:
* **Catálogo:** Autores, obras, categorías y ediciones (físico/digital).
* **Finanzas:** Clientes, pedidos, facturas y métodos de pago.
* **Logística:** Inventario en tiempo real, almacenes físicos y tracking de envíos.

---

## 📐 Modelo Entidad-Relación (E-R)
El diseño se basa en la integridad referencial para evitar duplicidad y errores humanos.

* **Integridad:** Uso de claves foráneas (FK) con restricciones para evitar la eliminación de registros con dependencias activas.
* **Normalización:** Aplicación de las formas normales para optimizar el almacenamiento y la velocidad de consulta.



---

## 🛠️ Administración y Seguridad

### 1. Gestión de Usuarios y Accesos
Se aplica el principio de **menor privilegio**:
* **Acceso Restringido:** El usuario `root` está deshabilitado para conexiones remotas.
* **Roles Específicos:** Creación de usuarios como `admin_artic` con permisos limitados a rangos de IP de la red interna.
* **Auditoría:** Control de accesos mediante el firewall del servidor Debian (Puerto 3306).

### 2. Exportación y Portabilidad
Para garantizar la movilidad de los datos y la generación de informes:
* **SQL Dump:** Extracción de estructura y datos para migraciones.

### 3. Estrategia de Backup (Regla 3-2-1) 🛡️
Contamos con un sistema de respaldo crítico automatizado mediante un script en Bash (`backup_mariadb.sh`):
1.  **Local:** Backup diario a las 02:00 AM guardado en el servidor Debian.
2.  **Redundancia:** Copia automática mediante `rsync` al **NAS** y al servidor **Windows Server 2022**.
3.  **Nube:** Réplica cifrada en un **Bucket S3 de AWS** mediante AWS CLI.
4.  **Monitorización:** Cualquier fallo en el backup genera una alerta inmediata en el panel de **Grafana**.

---

## 🚀 Tecnologías Utilizadas
* **Motor:** MariaDB 10 (sobre Debian 12).
* **Gestión:** MySQL Workbench.
* **Automatización:** Bash Scripting + Cron.
* **Nube:** Amazon Web Services (S3).

---
**Diseñado por:** Johan Mauricio Aricapa Velasco  
**Módulo:** Gestión de Bases de Datos
