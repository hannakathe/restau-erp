-- Reto 3: transacción exitosa -> factura + detalle + impuestos, confirmada con COMMIT
BEGIN;

WITH nueva_factura AS (
    INSERT INTO facturas (total_venta, metodo_pago)
    VALUES (30000.00, 'Efectivo')
    RETURNING id_factura
),
nuevo_detalle AS (
    INSERT INTO detalle_factura (id_factura, codigo_sku_producto, cantidad, subtotal)
    SELECT id_factura, x.sku, x.cant, x.sub
    FROM nueva_factura, (VALUES
        ('BGM-001', 1, 25000.00),  -- Hamburguesa Doble UMB
        ('BEB-010', 1, 5000.00)    -- Gaseosa 400ml
    ) AS x(sku, cant, sub)
    RETURNING id_factura
)
INSERT INTO registro_impuestos (id_factura, tipo_impuesto, monto_impuesto)
SELECT id_factura, x.tipo, x.monto
FROM nueva_factura, (VALUES
    ('IVA 19%', 5700.00),
    ('Impoconsumo 8%', 2400.00)
) AS x(tipo, monto);

COMMIT;

-- Verificación: factura, su detalle y sus impuestos deben quedar persistidos
SELECT f.id_factura, f.total_venta, d.codigo_sku_producto, d.subtotal, i.tipo_impuesto, i.monto_impuesto
FROM facturas f
JOIN detalle_factura d ON d.id_factura = f.id_factura
JOIN registro_impuestos i ON i.id_factura = f.id_factura
WHERE f.total_venta = 30000.00;
