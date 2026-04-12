# 🐺 Arctic Wolves - Inventario de Infraestructura IT

Este directorio contiene la esctructura del inventario de hardware y topología de red de la editorial Arctic Wolves, diseñado como un sistema Base de Datos de gestión de la Configuración.

### 📊 ¿Qué datos representa el XML?

El archivo principal (`inventario.xml`) almacena todos los dispositivos activos fisicos y logicos de la red corporativa. Cada nodo del documento representa un equipo de infraestructura (Servidores, Routers, Switches L2/L3, Puntos de Acceso, Impresoras y UPS). 

Por cada equipo, el XML muestra la siguiente información técnica:

* **ID (Atributo):** El nombre de host o identificador único del equipo en la red (ej. `SRV-WEB`, `SW-CORE-01`).
* **Categoría (Atributo):** El tipo de hardware (ej. Servidor, Router, Switch Acceso, etc.).
* **Sistema Operativo:** El SO o firmware que ejecuta la máquina (ej. *Ubuntu Server*, *Cisco IOS*).
* **IP:** La dirección IPv4 asignada dentro de la red local. Si el equipo no es gestionable por IP o actúa como dispositivo no destinado para la conexión de la red, se registra como `None`.
* **Rol:** Una breve descripción de la función del equipo dentro de la red empresarial (ej. *Enrutamiento Inter-VLAN*, *Motor MariaDB*).
* **Estado:** El estado actual en el que se encuentra el dispositivo (*Activo* o *Inactivo*).

### 🛠️ Cómo validar y visualizar los datos

Para comprobar el correcto funcionamiento de la estructura XML, las reglas de validación (XSD) y la plantilla de diseño (XSL), puedes seguir estos métodos:

#### 1. Validación Estructural (XML contra XSD)
El archivo `inventario.xml` está enlazado internamente a `inventario.xsd`. Para comprobar que los datos cumplen las reglas establecidas:
* **Mediante Visual Studio Code:** Abre el archivo XML en un editor como *Visual Studio Code* con la extensión `XML`. Si introduces un error a propósito (ej. borrar un atributo `categoria`), el editor subrayará el código en rojo instantáneamente.
* **Por Línea de Comandos:** Si estás en un servidor Debian/Ubuntu, puedes usar la herramienta `xmllint` ejecutando el siguiente comando en la terminal:
  ```bash
  xmllint --noout --schema inventario.xsd inventario.xml

* Si todo es correcto, la terminal devolverá: inventario.xml validates).

####  Herramientas Online: Puedes copiar y pegar el contenido del XML y el XSD en validadores web gratuitos como FreeFormatter (XML Schema Validator) para obtener un reporte instantáneo.

#### 2. Visualización del Reporte (Transformación XSLT)
El archivo XML tiene lo siguiente: <?xml-stylesheet type="text/xsl" href="inventario.xsl"?>, lo que significa que la transformación a HTML es automática en el lado del cliente:

* Usando un Navegador Web: Simplemente haz doble clic sobre inventario.xml y ábrelo con cualquier navegador como Firefox, Safari o Edge. El navegador leerá el XML, aplicará el diseño del archivo inventario.xsl y te mostrará una tabla ordenada y con estilos para poder visualizarla perfectamente.
* En el Servidor de Producción: Al subir estos tres archivos al directorio /var/www/html/ del servidor Ubuntu, cualquier equipo de la red podrá visualizar el inventario accediendo a la ip del servidor web.


## ⚙️ Integración de Tecnologías

La creacion del XML encaja perfectamente a la hora de implementarlo como **"formato de configuracion, intercambio y reporte"**, aplicado a la gestión del inventario de hardware de red.
Esto es una ayuda muy grande para el despartamento de IT para mantener la infraestructura documentada y controlada de forma dinámica. 

### 🎯 El Caso de Uso
En una la infraestructura de red empresarial (servidores Linux/Windows, switches Cisco/TP-Link, routers y puntos de acceso), es vital tener un inventario actualizado. En lugar de usar documentos estáticos de texto, se genera automaticamente un inventario de los dispositivos de red en formato estructurado a partir del programas como netbox o lansweeper.

### 🔄 El Flujo Técnico Implementado

1. **Extracción y Almacenamiento**
   Los datos del hardware (ID, categoría, sistema operativo, IP de gestión, rol y estado) se exportan y estructuran en el documento `inventario.xml`. Este archivo es fácil de interpretar por cualquier máquina o software de monitorización.

2. **Validación Estricta**
   Para garantizar que el inventario no contiene errores humanos antes de publicarse, el archivo se valida con el archivo `inventario.xsd`. Este archivo obliga, por ejemplo, a que todo nodo tenga asignada una categoría obligatoria, una dirección IP de gestión válida, un estado previamente enumerado, rechazando automáticamente registros incorrectos o incompletos.

3. **Transformación y Visualización**
   Para que los administradores de sistemas y auditores externos puedan consultar la topología de la red de un vistazo, se aplica la hoja de fromato de estilos `inventario.xsl`. Este script convierte los datos del XML en una tabla HTML interactiva y formateada, con etiquetas visuales por tipo de dispositivo, está pensado para publicarse en un servidor web interno sin necesidad de escribir código HTML manualmente.

