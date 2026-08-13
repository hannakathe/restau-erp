-- Demo de Atomicidad (dada por la guía): un error fuerza el ROLLBACK completo de la transacción
BEGIN;

-- Paso 1: registramos la factura de la Hamburguesa ($25.000)
INSERT INTO facturas (total_venta, metodo_pago)
VALUES (25000.00, 'Tarjeta');

-- Paso 2: fallo intencional -> texto en un campo numérico
INSERT INTO registro_impuestos (id_factura, tipo_impuesto, monto_impuesto)
VALUES (1, 'Impoconsumo 8%', 'ERROR_DE_CALCULO');
-- PostgreSQL lanza: "invalid input syntax for type numeric"

ROLLBACK;

-- Verificación: la factura de 25.000 NO debe existir (la transacción se deshizo por completo)
SELECT * FROM facturas WHERE total_venta = 25000.00;
