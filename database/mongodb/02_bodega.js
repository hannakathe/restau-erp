// Ejecutar en mongosh o consola de MongoDB Atlas conectado a la base erp_restaurante
// Reto 1: lotes de insumos con proveedores_aprobados[] y fecha_vencimiento
use("erp_restaurante");

db.bodega.insertMany([
  {
    id_bodega: "INS-022",
    ingrediente: "Carne de Res",
    lote: "L-2026-081",
    cantidad_actual: 15000,
    unidad: "gramos",
    fecha_ingreso: ISODate("2026-08-10"),
    fecha_vencimiento: ISODate("2026-08-15"),
    proveedores_aprobados: [
      { nombre: "Frigorífico La Sabana", telefono: "+57 310 555 0110" },
      { nombre: "Carnes Premium UMB", telefono: "+57 320 555 0199" }
    ]
  },
  {
    id_bodega: "INS-010",
    ingrediente: "Pan Brioche",
    lote: "L-2026-082",
    cantidad_actual: 200,
    unidad: "unidad",
    fecha_ingreso: ISODate("2026-08-11"),
    fecha_vencimiento: ISODate("2026-08-14"),
    proveedores_aprobados: [
      { nombre: "Panadería Central", telefono: "+57 315 555 0234" }
    ]
  },
  {
    id_bodega: "INS-005",
    ingrediente: "Queso Cheddar",
    lote: "L-2026-083",
    cantidad_actual: 8000,
    unidad: "gramos",
    fecha_ingreso: ISODate("2026-08-05"),
    fecha_vencimiento: ISODate("2026-08-25"),
    proveedores_aprobados: [
      { nombre: "Lácteos del Valle", telefono: "+57 300 555 0456" }
    ]
  },
  {
    id_bodega: "INS-030",
    ingrediente: "Gaseosa Botella 400ml",
    lote: "L-2026-084",
    cantidad_actual: 500,
    unidad: "unidad",
    fecha_ingreso: ISODate("2026-07-20"),
    fecha_vencimiento: ISODate("2027-02-01"),
    proveedores_aprobados: [
      { nombre: "Distribuidora Bebidas UMB", telefono: "+57 301 555 0678" }
    ]
  },
  {
    id_bodega: "INS-040",
    ingrediente: "Caldo de Pollo",
    lote: "L-2026-085",
    cantidad_actual: 10000,
    unidad: "mililitros",
    fecha_ingreso: ISODate("2026-08-09"),
    fecha_vencimiento: ISODate("2026-08-18"),
    proveedores_aprobados: [
      { nombre: "Insumos Gourmet SAS", telefono: "+57 312 555 0789" }
    ]
  }
]);
