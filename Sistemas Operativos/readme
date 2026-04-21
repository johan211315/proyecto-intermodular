# 🚀 Proyecto Intermodular: Infraestructura PROMETEO - Editorial ArticWolves

Este repositorio contiene la documentación y detalles técnicos de la infraestructura de red diseñada para una editorial de 60 empleados. El proyecto combina entornos **Windows** y **Linux** para ofrecer una solución robusta, escalable y segura.

## 📊 Descripción del Proyecto
Se ha diseñado una red empresarial que centraliza la gestión de usuarios, la seguridad de los datos y la monitorización de servicios mediante la virtualización.

## 🛠️ Análisis del Sistema (Stack Tecnológico)

### Servidores Locales
| Servidor | Sistema Operativo | Rol Principal |
| :--- | :--- | :--- |
| **SRV-CORE** | Windows Server 2022 | Controlador de Dominio (AD DS), DNS, DHCP y Servidor de Archivos (SMB). |
| **SRV-BBDD** | Debian GNU/Linux | Motor de Base de Datos Relacional (MariaDB/MySQL). |
| **SRV-SCRIPT** | Ubuntu Server | Servidor Web Frontend y automatización de backups mediante Bash/Cron. |
| **SRV-MONITOR** | Ubuntu Server | Monitorización proactiva con Prometheus y Grafana. |

### Equipos de Usuario
- **S.O:** Windows 11 Pro.
- **Justificación:** Compatibilidad total con herramientas ofimáticas y unión nativa al Dominio para gestión de directivas (GPO).

---

## ⚙️ Plan de Implantación

La implantación se ha realizado de forma **manual** mediante el uso de imágenes ISO y la plataforma de virtualización **Oracle VM VirtualBox**.

### Pasos del Proceso:
1.  **Configuración del Hipervisor:** Creación de máquinas virtuales asignando recursos de CPU, RAM y almacenamiento (VDI).
2.  **Red Virtual:** Configuración de una red interna para aislar el tráfico de la infraestructura del exterior.
3.  **Instalación Manual:** Ejecución de los asistentes de instalación de cada S.O., configurando particiones, usuarios administrativos y ajustes regionales.
4.  **Post-Instalación:** Instalación de *Guest Additions* para optimización de rendimiento y conectividad.

---

## 🔒 Características Destacadas
- **Gestión Centralizada:** Control de 60 usuarios mediante Active Directory.
- **Seguridad:** Aplicación de políticas NTFS estrictas y GPOs para restringir dispositivos USB.
- **Mantenimiento Proactivo:** Paneles visuales en Grafana para supervisar el consumo de recursos en tiempo real.
- **Automatización:** Scripts en Bash para auditoría de logs y copias de seguridad automáticas de la base de datos.

---

## 📸 Capturas de Pantalla
*(Sugerencia: Sube tus imágenes a una carpeta llamada `img` en este repositorio y enlázalas aquí)*

Ejemplo:
`![Instalación Windows Server](./img/instalacion_srv_core.png)`

---

**Autor:** Johan Mauricio Aricapa Velasco  
**Curso:** Proyecto Intermodular - Sistemas Operativos
