# 🚀 Infraestructura de Hardware - ArticWolves
Este documento detalla la configuración, justificación y estrategia de escalabilidad del hardware diseñado para ArticWolves Editorial.

---

## 🏢 Distribución por Departamentos

La empresa se divide en unidades funcionales con hardware adaptado a sus necesidades específicas:

### 1. Usuario y Ofimática (Recepción, Almacén, Finanzas y RRHH)
* **Modelo:** ThinkPad E14 Gen 6 (AMD)
* **Cantidad:** 10 unidades.
* **Justificación:** Portátiles con alta autonomía y rendimiento eficiente para tareas administrativas y flujos de trabajo de oficina.

### 2. Administración y Soporte Técnico (IT)
* **Modelo:** ThinkPad E14 Gen 7 (AMD)
* **Cantidad:** 8 unidades.
* **Especificaciones Clave:** Procesador Intel Core Ultra 7 155H.
    * 64 GB RAM DDR5 @ 5600 MHz.
    * Placa base con **Intel vPro** para gestión remota.
* **Uso:** Virtualización de entornos, soporte de red y pruebas de laboratorio.

### 3. Marketing
* **Modelo:** HP Z2 SFF G1
* **Cantidad:** 3 Workstations.
* **Mejora de Hardware:** Se ha integrado la **NVIDIA RTX A400 (4 GB GDDR6)**
* **Justificación:** Estabilidad profesional certificada para edición de video, diseño gráfico y renderizado, optimizando el espacio del chasis SFF.

### 4. Logística y Movilidad (Almacén)
* **Dispositivos:** Tablets Zebra ET40 y lectores PDA.
* **Uso:** Escaneo de inventario, gestión de entradas/salidas y resistencia a entornos industriales.

---

## 🗄️ Servidores y Almacenamiento Central

| Equipo | Sistema Operativo | Función Principal |
| :--- | :--- | :--- |
| **Dell R640 8SFF (x2)** | Windows / Ubuntu Server | Controlador de Dominio (AD), DHCP, DNS y Web. |
| **HPE Proliant Dl20 Gen11** | Debian Server | Motor de Base de Datos MariaDB. |
| **NAS Synology DS925+** | DSM | Almacenamiento central y repositorio de backups. |

---

## 🛡️ Estrategia de Respaldo y Seguridad

### Regla de Oro 3-2-1
Para garantizar que la información nunca se pierda ante un desastre físico o Ransomware:
*  **3 Copias:** Los datos originales y dos backups.
*  **2 Medios:** Almacenamiento en los discos locales del servidor y en el NAS (RAID 5).
*  **1 Copia Off-site:** Sincronización cifrada con la nube (**AWS S3**).

### Política de Rotación GFS (Grandfather-Father-Son)
* **Son (Hijo):** Backups diarios con retención de 7 días.
* **Father (Padre):** Backups semanales con retención de 4 semanas.
* **Grandfather (Abuelo):** Backup mensual con retención de 12 meses.

---

## 📈 Escalabilidad futura a Cloud

El diseño planea migrar los servicios a **Amazon Web Services (AWS)** para mejorar la disponibilidad y escalabilidad.
* **Escalado Vertical/Horizontal:** Uso de instancias **EC2** para ajustar la potencia según la demanda.
* **Alta Disponibilidad:** Implementación de **Multi-AZ** para replicar servicios en distintos centros de datos.
* **Optimización de Gastos:** Cambio de modelo CAPEX (inversión en hardware físico) a OPEX (pago por uso).

---
**Documentación generada por:** Johan Mauricio Aricapa Velasco  
**Proyecto:** PROMETEO - Fundamentos de Hardware
