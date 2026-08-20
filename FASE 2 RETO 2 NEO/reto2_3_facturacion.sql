-- ============================================================
-- RETO 2 y RETO 3 - Relacional (PostgreSQL en Neon.tech)
-- ============================================================

-- ============================================================
-- Tablas base (código de ejemplo entregado en la guía)
-- ============================================================
CREATE TABLE facturas (
    id_factura SERIAL PRIMARY KEY,
    fecha_emision TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_venta NUMERIC(10, 2) NOT NULL,
    metodo_pago VARCHAR(50) CHECK (metodo_pago IN ('Efectivo', 'Tarjeta', 'Transferencia')),
    estado VARCHAR(20) DEFAULT 'Pagada'
);

CREATE TABLE registro_impuestos (
    id_impuesto SERIAL PRIMARY KEY,
    id_factura INT REFERENCES facturas(id_factura) ON DELETE CASCADE,
    tipo_impuesto VARCHAR(20) NOT NULL,
    monto_impuesto NUMERIC(10, 2) NOT NULL
);

-- ============================================================
-- RETO 2: Integridad Relacional -> tabla detalle_factura
-- ============================================================
CREATE TABLE detalle_factura (
    id_detalle SERIAL PRIMARY KEY,
    id_factura INT REFERENCES facturas(id_factura) ON DELETE CASCADE,
    codigo_sku_producto VARCHAR(20) NOT NULL,  -- viene de MongoDB (ej: 'BGM-001')
    cantidad INT NOT NULL CHECK (cantidad > 0),
    subtotal NUMERIC(10, 2) NOT NULL
);

-- ============================================================
-- RETO 3: Transacción exitosa (factura + detalle + impuestos)
-- ============================================================
BEGIN;

WITH nueva_factura AS (
    INSERT INTO facturas (total_venta, metodo_pago)
    VALUES (25000.00, 'Tarjeta')
    RETURNING id_factura
),
nuevo_detalle AS (
    INSERT INTO detalle_factura (id_factura, codigo_sku_producto, cantidad, subtotal)
    SELECT id_factura, 'BGM-001', 1, 25000.00
    FROM nueva_factura
)
INSERT INTO registro_impuestos (id_factura, tipo_impuesto, monto_impuesto)
SELECT id_factura, tipo, monto
FROM nueva_factura,
     (VALUES
        ('IVA 19%', 4750.00),
        ('Impoconsumo 8%', 2000.00)
     ) AS impuestos(tipo, monto);

COMMIT;

-- ============================================================
-- Verificación
-- ============================================================
SELECT * FROM facturas;
SELECT * FROM detalle_factura;
SELECT * FROM registro_impuestos;
