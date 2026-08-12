// Ejecutar en mongosh o consola de MongoDB Atlas conectado a la base erp_restaurante
use("erp_restaurante");

db.productos.insertMany([
  // Documento maestro dado por la guía: sub-documentos (receta_insumos) + arreglos (opciones_personalizacion)
  {
    codigo_sku: "BGM-001",
    nombre: "Hamburguesa Doble UMB",
    categoria: "Platos Fuertes",
    precio_venta: 25000,
    disponible: true,
    receta_insumos: [
      { ingrediente: "Pan Brioche", cantidad: 1, unidad: "unidad", id_bodega: "INS-010" },
      { ingrediente: "Carne de Res", cantidad: 300, unidad: "gramos", id_bodega: "INS-022" },
      { ingrediente: "Queso Cheddar", cantidad: 2, unidad: "tajada", id_bodega: "INS-005" }
    ],
    opciones_personalizacion: [
      { tipo: "Termino Carne", opciones: ["Medio", "Tres Cuartos", "Bien Asado"] },
      { tipo: "Adiciones", opciones: ["Tocineta", "Huevo", "Salsa Xcrump"] }
    ],
    metadatos: { fecha_creacion: new Date(), creado_por: "Chef Ejecutivo" }
  },
  // Bebida: receta simple, SIN opciones_personalizacion -> demuestra schema-less
  {
    codigo_sku: "BEB-010",
    nombre: "Gaseosa 400ml",
    categoria: "Bebidas",
    precio_venta: 5000,
    disponible: true,
    receta_insumos: [
      { ingrediente: "Gaseosa Botella 400ml", cantidad: 1, unidad: "unidad", id_bodega: "INS-030" }
    ],
    metadatos: { fecha_creacion: new Date(), creado_por: "Chef Ejecutivo" }
  },
  // Sopa del día: tiene receta_insumos pero tampoco opciones_personalizacion
  {
    codigo_sku: "SOP-004",
    nombre: "Sopa del Día",
    categoria: "Entradas",
    precio_venta: 12000,
    disponible: true,
    receta_insumos: [
      { ingrediente: "Caldo de Pollo", cantidad: 400, unidad: "mililitros", id_bodega: "INS-040" },
      { ingrediente: "Verduras Mixtas", cantidad: 150, unidad: "gramos", id_bodega: "INS-041" }
    ],
    metadatos: { fecha_creacion: new Date(), creado_por: "Chef Ejecutivo" }
  }
]);
