
--- CREACION DE ROLES, USUARIOS Y ASIGNACIÓN DE PERMISOS (OPCIONAL, DEPENDIENDO DE LA CONFIGURACIÓN DE USUARIOS)

-- CREACIÓN DE ROLES
CREATE ROLE 'rol_auditor_db';
CREATE ROLE 'rol_app_logistica';
CREATE ROLE 'rol_departamento_finanzas';
CREATE ROLE 'rol_gestor_editorial';


-- 2. CREACIÓN DE USUARIOS (Con acceso restringido al dominio local)
CREATE USER 'Johan_gestor'@'articwolves.local' IDENTIFIED BY 'wn2o2fm6Ld4e!';
CREATE USER 'Luz_finanzas'@'articwolves.local' IDENTIFIED BY 'rRt21aBvY9tO!';
CREATE USER 'Auditor_ext'@'articwolves.local' IDENTIFIED BY 'WjOvHqRWCt4!';
CREATE USER 'antoni_operario'@'articwolves.local' IDENTIFIED BY 'Vx_t=IBTPhsD!';


-- ====================================================================
-- 3. ASIGNACIÓN DE PERMISOS A LOS ROLES
-- ====================================================================

-- AUDITOR
GRANT SELECT ON db_articwolves.* TO 'rol_auditor_db';

-- LOGISTICA

-- Permisos de SOLO LECTURA (Consultar qué preparar y a dónde enviarlo)
GRANT SELECT ON db_articwolves.PEDIDO TO 'rol_app_logistica';
GRANT SELECT ON db_articwolves.DETALLE_PEDIDO TO 'rol_app_logistica';
GRANT SELECT ON db_articwolves.EDICION_LIBRO TO 'rol_app_logistica';
GRANT SELECT ON db_articwolves.CLIENTE TO 'rol_app_logistica'; 
GRANT SELECT ON db_articwolves.ALMACEN_FISICO TO 'rol_app_logistica';

-- Permisos de ESCRITURA Y MODIFICACIÓN 
-- Pueden descontar libros del inventario
GRANT SELECT, UPDATE ON db_articwolves.INVENTARIO TO 'rol_app_logistica';
-- Pueden crear nuevos envíos y cambiar su empresa de transporte
GRANT SELECT, INSERT, UPDATE ON db_articwolves.ENVIO TO 'rol_app_logistica';
-- Pueden añadir nuevos estados al paquete (ej: "En reparto", "Entregado")
GRANT SELECT, INSERT, UPDATE ON db_articwolves.TRACKING_ESTADO TO 'rol_app_logistica';

-- FINANZAS

-- Permisos de ESCRITURA Y MODIFICACIÓN (Su trabajo diario con el dinero)
-- Control total sobre la facturación y los cobros/pagos
GRANT SELECT, INSERT, UPDATE, DELETE ON db_articwolves.FACTURA TO 'rol_departamento_finanzas';
GRANT SELECT, INSERT, UPDATE, DELETE ON db_articwolves.PAGO TO 'rol_departamento_finanzas';


-- Permisos de SOLO LECTURA (Consultar qué se ha vendido, a quién y los royalties)
-- Necesitan ver las ventas y los clientes para poder facturar
GRANT SELECT ON db_articwolves.PEDIDO TO 'rol_departamento_finanzas';
GRANT SELECT ON db_articwolves.DETALLE_PEDIDO TO 'rol_departamento_finanzas';
GRANT SELECT ON db_articwolves.CLIENTE TO 'rol_departamento_finanzas';

-- Necesitan ver los libros y los contratos para calcular cuánto pagar a los escritores
GRANT SELECT ON db_articwolves.EDICION_LIBRO TO 'rol_departamento_finanzas';
GRANT SELECT ON db_articwolves.CONTRATO TO 'rol_departamento_finanzas';
GRANT SELECT ON db_articwolves.AUTOR TO 'rol_departamento_finanzas';


-- Gestor editorial 

-- Permisos de ESCRITURA Y MODIFICACIÓN 
-- Pueden gestionar altas, bajas y modificaciones de todo el catálogo y autores
GRANT SELECT, INSERT, UPDATE, DELETE ON db_articwolves.AUTOR TO 'rol_gestor_editorial';
GRANT SELECT, INSERT, UPDATE, DELETE ON db_articwolves.OBRA_LITERARIA TO 'rol_gestor_editorial';
GRANT SELECT, INSERT, UPDATE, DELETE ON db_articwolves.CONTRATO TO 'rol_gestor_editorial';
GRANT SELECT, INSERT, UPDATE, DELETE ON db_articwolves.CATEGORIA TO 'rol_gestor_editorial';
GRANT SELECT, INSERT, UPDATE, DELETE ON db_articwolves.OBRA_CATEGORIA TO 'rol_gestor_editorial';
GRANT SELECT, INSERT, UPDATE, DELETE ON db_articwolves.EDICION_LIBRO TO 'rol_gestor_editorial';

-- Permisos de SOLO LECTURA 
-- Necesitan ver el inventario para saber si un libro se ha agotado y hay que mandar a imprimir más
GRANT SELECT ON db_articwolves.INVENTARIO TO 'rol_gestor_editorial';

-- ====================================================================
-- 4. VINCULAR LOS USUARIOS A SUS ROLES
-- ====================================================================

-- Asignamos los roles a cada persona
GRANT 'rol_gestor_editorial' TO 'Johan_gestor'@'articwolves.local';
GRANT 'rol_departamento_finanzas' TO 'Luz_finanzas'@'articwolves.local';
GRANT 'rol_auditor_db' TO 'Auditor_ext'@'articwolves.local';
GRANT 'rol_app_logistica' TO 'antoni_operario'@'articwolves.local';

-- Forzamos a que el rol se active automáticamente cuando inicien sesión
SET DEFAULT ROLE 'rol_gestor_editorial' FOR 'Johan_gestor'@'articwolves.local';
SET DEFAULT ROLE 'rol_departamento_finanzas' FOR 'Luz_finanzas'@'articwolves.local';
SET DEFAULT ROLE 'rol_auditor_db' FOR 'Auditor_ext'@'articwolves.local';
SET DEFAULT ROLE 'rol_app_logistica' FOR 'antoni_operario'@'articwolves.local';

-- Guardar y aplicar todos los cambios de seguridad
FLUSH PRIVILEGES;


