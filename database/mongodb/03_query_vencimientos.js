// Reto 1: insumos de bodega que caducan en los próximos 7 días (incluye hoy)
use("erp_restaurante");

const hoy = new Date();
const limite = new Date();
limite.setDate(hoy.getDate() + 7);

db.bodega.find(
  { fecha_vencimiento: { $gte: hoy, $lte: limite } },
  { _id: 0, ingrediente: 1, lote: 1, fecha_vencimiento: 1, cantidad_actual: 1, unidad: 1 }
).sort({ fecha_vencimiento: 1 });
