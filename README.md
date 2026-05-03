# 🐺 Arctic Wolves - Infraestructura IT y Administración de Sistemas

Este repositorio contiene la documentación, scripts y configuración del diseño y despliegue de la infraestructura tecnológica completa para **Arctic Wolves**, una innovadora editorial de libros digitales.

El proyecto abarca la creación de una arquitectura híbrida (On-Premise + Cloud) desde cero, priorizando la seguridad, la alta disponibilidad y la continuidad del negocio.

## 🎯 Objetivos del Proyecto
* **Arquitectura Híbrida:** Integración de un Centro de Proceso de Datos (CPD) local con servicios en la nube de Amazon Web Services (AWS).
* **Seguridad y Hardening:** Segmentación de red mediante VLANs, listas de control de acceso (ACLs) y configuración de firewalls (UFW y Windows).
* **Continuidad de Negocio:** Implementación estricta de la regla de backups 3-2-1 con rotación GFS (Abuelo-Padre-Hijo) automatizada mediante scripts de Bash.
* **Monitorización Proactiva:** Telemetría en tiempo real de todos los nodos usando el ecosistema Prometheus + Grafana.
* **Gestión Centralizada:** Documentación exhaustiva del hardware (DCIM) y direccionamiento IP (IPAM) utilizando NetBox.

---

## 🏗️ Topología y Arquitectura de Red

La red local ha sido diseñada y simulada en Cisco Packet Tracer siguiendo el modelo jerárquico de tres capas de Cisco:
1. **Core (Núcleo):** Router Cisco 4331 Perimetral (NAT/Firewall) y Switch de Capa 3 para el enrutamiento Inter-VLAN y backbone de fibra óptica a 10Gbps.
2. **Distribución:** Switches TP-Link TL-SG3452 en cada planta.
3. **Acceso:** Switches Omada L2+ con tecnología PoE+ para alimentar Teléfonos IP, cámaras CCTV y Puntos de Acceso Wifi (Ubiquiti UniFi U7).
### 📊 Segmentación Lógica (Subnetting VLSM)
El direccionamiento se basa en la red `192.168.0.0/24`, segmentada estratégicamente por departamentos para aislar el tráfico[cite: 4]:
* `VLAN 10` - Almacén y Recepción
* `VLAN 20` - IT (Administración de red)
* `VLAN 30` - Recursos Humanos
* `VLAN 40` - Marketing
* `VLAN 50` - Finanzas
* `VLAN 60` - Servidores Críticos
* `VLAN 99` - Gestión Nativa

---

## 🖥️ Entorno de Servidores (On-Premise & Cloud)

La infraestructura de servidores virtuales y físicos está dividida para maximizar la eficiencia y seguridad:

### 🏢 On-Premise (Local)
* **`SRV-CORE` (Windows Server 2022):** Actúa como Controlador de Dominio (Active Directory), servidor DHCP (con zonas IP por VLAN), DNS interno y Servidor de Archivos (SMB) con permisos NTFS estrictos gestionados por Grupos de Seguridad.
* **`SRV-BBDD` (Debian GNU/Linux):** Motor de base de datos relacional (MariaDB) operando sobre un arreglo físico RAID 5 para garantizar tolerancia a fallos de hardware.
* **`SRV-WEB / SRV-SCRIPT` (Ubuntu Server):** Frontend web local (Apache HTTP/HTTPS con certificados SSL) y nodo central de automatización mediante tareas Cron (scripts de auditoría y copias de seguridad).
* **`SRV-MONITOR` (Ubuntu Server):** Servidor de telemetría y visualización con Prometheus y Grafana.

### ☁️ Cloud (AWS)
* **Instancia EC2 (Ubuntu):** Servidor Web público de alta disponibilidad.
* **Route 53:** Gestión de resolución de nombres de dominio (DNS) de cara a internet.
* **S3 Bucket:** Repositorio externo cifrado para el almacenamiento de los backups automatizados, cumpliendo el requisito "Off-site" de la regla 3-2-1.

---

## ⚙️ Automatización y Scripts

El mantenimiento y protección de los datos se realiza sin intervención humana:
1. **Backup Automático (Bash):** Extracción de tablas SQL (`mysqldump`), compresión (`tar.gz`) con estampado de fecha, envío seguro al NAS/Windows Server, y sincronización hacia el Bucket de AWS S3 mediante `aws cli`.
2. **Rotación GFS:** El script identifica el día de ejecución y clasifica el backup como Hijo (diario, retención 7 días), Padre (semanal, retención 4 semanas) o Abuelo (mensual, retención 12 meses).
3. **Auditoría:** Monitoreo del archivo `/var/log/auth.log` para registrar accesos SSH y posibles intentos de intrusión.
4. **GPOs (Windows):** Despliegue automático de mapeo de unidades de red, tapiz de escritorio corporativo y políticas de auditoría de archivos locales.

---

## 👨‍💻 Autor
**Johan Mauricio Aricapa**  
*Administrador de Sistemas Informáticos en Red (ASIR)*  
📍 Barcelona | ✉️ Johanaricapa@gmail.com  
🔗 [LinkedIn](https://www.linkedin.com/in/johan-aricapa2113/) | 💻 [GitHub](https://github.com/johan211315) |
*Pagina Web* https://johan211315.github.io/Proyecto/
