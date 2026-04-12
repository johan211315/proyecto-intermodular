# Validacion XML Y XSD

## Validacion correcta
Como podemos ver hemos validad el codigo XML para probar que la sintaxis es correcta y esta bien formado, ademas de usar la propiedad `xs:restriction` para que obligatoriamente se respeten los siguiente valores:
* **Estructura:** Que elementos pueden aparecer y donde deben aparecer (dentro del inventario van los equipos y dentro de el sus 4 elementos hijos).
* **Tipo de datos:** Se ha especificado el tipo de dato que se permite ingresar (`tipoIP`, `tipoEstado`, `tipoCategoria`).

* **Restricciones:**
  * **Enumeraciones:** Los atributos `categoria` y `estado` no aceptan texto libre. Solo aceptan valores de una lista cerrada (ej. `Activo`, `Inactivo`, `Switch Core L3`, `Servidor`). Si un operador escribe "Encendido" en lugar de "Activo", el XSD rechaza el archivo.
  * **Patrones:** El dato `<ip>` tiene una restricción de patrón (`xs:pattern`). Solo acepta la palabra exacta `None` o una dirección IPv4 válida.
  
* **Cardinalidades:** Se usa `maxOccurs="unbounded"` para permitir que se almacene una gran cantidad de dispositivos, y `use="required"` en los atributos `id` y `categoria` para impedir que se registre un equipo no identificado.

<img width="994" height="799" alt="Validacion_correcta" src="https://github.com/user-attachments/assets/16321b39-e72a-455e-b2b0-8c0c8201c4f9" />


## Validacion incorrecta
Ahora probaremos que nuestro XSD funcione correctamente agregando valores incorrectos que no respeten las restricciones explicadas anteriormente.

* Primero no agregaremos la categoria del dispositivo rompiendo la `cardinalidad` e ignorando la propiedad `required`
```xsd
<equipo id="SRV-ERROR-01">
        <sistema_operativo>Ubuntu Server Linux</sistema_operativo>
        <ip>192.168.0.99</ip>
        <rol>Servidor de Pruebas</rol>
        <estado>Inactivo</estado>
    </equipo>
```
* Segundo No agregaremos la etiqueta de sistema operativo rompiendo la `jerarquia` y `estructura` previamente establecida

```xsd
<equipo id="SRV-ERROR-02" categoria="Servidor">
        <ip>192.168.0.100</ip>
        <rol>Servidor Roto</rol>
        <estado>Inactivo</estado>
    </equipo>
```

* Tercero Usaremos una IP no valida e incorrecta que no cumple con la estructura de una IPv4.

```xsd
<equipo id="IP_servidor_incorrecta" categoria="Servidor">
        <ip>192.257.300</ip>
        <rol>Servidor Roto</rol>
        <estado>Inactivo</estado>
    </equipo>
```

* Cuarto escribiremos un estado diferente a la que nos permite la  `ennumeracion` del xsd.
  
```xsd
  <equipo id="NO_cumple_validacion" categoria="Servidor">
        <ip>192.168.0.15</ip>
        <rol>Servidor Roto</rol>
        <estado>aceptable</estado>
    </equipo>
```

<img width="986" height="972" alt="image" src="https://github.com/user-attachments/assets/5dcca6c0-ca35-428f-831d-a17ac0bab370" />

