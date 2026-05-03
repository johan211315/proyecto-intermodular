<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
        <html>
        <head>
            <title>Inventario NetBox - Arctic Wolves</title>
            
        </head>
        <body>
            <div class="container">
                <h2>Documentación Técnica: Inventario de Infraestructura</h2>
                <p>Generado automáticamente mediante transformación XSLT (Extracción de NetBox / Packet Tracer).</p>
                <table>
                    <tr>
                        <th>ID Equipo</th>
                        <th>Categoría</th>
                        <th>Sistema Operativo / Firmware</th>
                        <th>IP de Gestión</th>
                        <th>Rol Asignado</th>
                        <th>Estado</th>
                    </tr>
                    
                    <xsl:for-each select="inventario/equipo">
                    <tr>
                        <td><strong><xsl:value-of select="@id"/></strong></td>
                        <td>
                            <span>
                                <xsl:attribute name="class">tag tag-<xsl:value-of select="substring-before(concat(@categoria, ' '), ' ')"/></xsl:attribute>
                                <xsl:value-of select="@categoria"/>
                            </span>
                        </td>
                        <td><xsl:value-of select="sistema_operativo"/></td>
                        <td><xsl:value-of select="ip"/></td>
                        <td><xsl:value-of select="rol"/></td>
                        <td><xsl:value-of select="estado"/></td>
                    </tr>
                    </xsl:for-each>
                </table>
            </div>
        </body>
        </html>
    </xsl:template>
</xsl:stylesheet>