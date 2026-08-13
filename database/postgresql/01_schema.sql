-- Ejecutar en Neon.tech / Supabase (proyecto erp_restaurante)

-- 1. Tabla de Facturas (Cabecera) — dada por la guía
CREATE TABLE facturas (
    id_factura SERIAL PRIMARY KEY,
    fecha_emision TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_venta NUMERIC(10, 2) NOT NULL,
    metodo_pago VARCHAR(50) CHECK (metodo_pago IN ('Efectivo', 'Tarjeta', 'Transferencia')),
    estado VARCHAR(20) DEFAULT 'Pagada'
);

-- 2. Tabla de Impuestos — dada por la guía
CREATE TABLE registro_impuestos (
    id_impuesto SERIAL PRIMARY KEY,
    id_factura INT REFERENCES facturas(id_factura) ON DELETE CASCADE,
    tipo_impuesto VARCHAR(20) NOT NULL,
    monto_impuesto NUMERIC(10, 2) NOT NULL
);

-- 3. Tabla de Detalle de Factura (Reto 2): FK a facturas + referencia al SKU de MongoDB
CREATE TABLE detalle_factura (
    id_detalle SERIAL PRIMARY KEY,
    id_factura INT REFERENCES facturas(id_factura) ON DELETE CASCADE,
    codigo_sku_producto VARCHAR(20) NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    subtotal NUMERIC(10, 2) NOT NULL
);
