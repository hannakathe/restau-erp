# RestauERP — Checklist técnico (fuente: guía del taller)

Pesos de rúbrica entre paréntesis. Orden de ejecución: Mongo → Postgres/ACID → APIs → PlantUML → Docker → Azure.

## Fase 1 — Figma (15%) + PlantUML (15%)
- [ ] Wireframe Cajero/POS (grid 12 col, escala de grises, frame 1440x1024)
- [ ] Mockup Cajero/POS (paleta, tipografía Inter/Roboto, badge stock bajo)
- [ ] Prototipo Cajero/POS (Smart Animate agregar producto, modal COBRAR con overlay)
- [ ] Wireframe + Mockup + Prototipo Contador (dashboard, tabla facturas → panel lateral impuestos)
- [ ] Wireframe + Mockup + Prototipo Bodeguero (semáforo stock, flujo "Registrar Compra a Proveedor")
- [ ] `diagrams/venta_exitosa.puml` (dado por la guía, solo versionar)
- [ ] `diagrams/rollback_error.puml` (Escenario 1: alt/else, compensación Inventario)
- [ ] `diagrams/recepcion_mercancia.puml` (Escenario 2: Bodeguero → Gateway → Inventario → Contabilidad, sin pasar por Ventas)

## Fase 2 — Persistencia políglota + ACID (20%)
**MongoDB Atlas** (`erp_restaurante`)
- [ ] Clúster M0 creado (pendiente: acción manual del estudiante en Atlas)
- [x] Colección `productos`: documento maestro + 2 productos adicionales (receta_insumos, opciones_personalizacion, schema-less) — `database/mongodb/01_productos.js`
- [x] Colección `bodega` (Reto 1): 5 lotes con `proveedores_aprobados[]` y `fecha_vencimiento` — `database/mongodb/02_bodega.js`
- [x] Query: insumos que vencen en próximos 7 días — `database/mongodb/03_query_vencimientos.js`

**PostgreSQL Neon/Supabase** (`erp_restaurante`)
- [ ] Proyecto Postgres creado en Neon/Supabase (pendiente: acción manual del estudiante)
- [x] Tabla `facturas` + `registro_impuestos` + `detalle_factura` (Reto 2, FK a `facturas`) — `database/postgresql/01_schema.sql`
- [x] Demo ROLLBACK (dado por la guía) — `database/postgresql/02_rollback_demo.sql`
- [x] Demo COMMIT (Reto 3): factura + detalle + impuestos en una sola transacción con CTEs — `database/postgresql/03_commit_demo.sql`

## Fase 3 — Backend / Microservicios
- [x] `microservicio_contabilidad/` — FastAPI + PostgreSQL: `POST /facturas` (transacción factura+detalle+impuestos), `GET /health`
- [x] `microservicio_inventario/` — FastAPI + MongoDB: `GET /productos`, `GET /inventario/vencimientos`, `POST /inventario/descontar`, `GET /health`
- [x] Pruebas locales: unitarias (lógica pura) + integración con dependencias simuladas (mongomock / conexión Postgres mockeada) + arranque real de ambos `uvicorn` con `/docs` respondiendo 200
- [ ] Pruebas contra Neon/Atlas reales (pendiente: requiere credenciales del estudiante, ver `.env.example` de cada servicio)

## Fase 4 — Docker (20%)
- [ ] `microservicio_contabilidad/Dockerfile` (python:3.10-slim, dado por la guía)
- [ ] `microservicio_inventario/Dockerfile` (Reto 1)
- [ ] `docker-compose.yml` raíz: `db_postgres`, `api_contabilidad`, `db_mongo`, `api_inventario` (Reto 2) — 4 contenedores, volumen `postgres_data`
- [ ] Prueba `docker compose up -d` + `/docs` de ambas APIs
- [ ] Respuesta corta: impacto de quitar el volumen `postgres_data` (Reto 3)

## Fase 5 — Azure (20%)
- [ ] `az group create` (ERPRestauranteRG)
- [ ] `az acr create` + push imagen `api-contabilidad:v1`
- [ ] `az appservice plan create` (F1, Linux)
- [ ] `az webapp create` + `az webapp config appsettings set` (DATABASE_URL → Neon)
- [ ] Prueba pública `/docs` contabilidad
- [ ] Repetir para `api-inventario:v1` con `MONGO_URI` → Atlas (Reto 1 Fase 4 guía)
- [ ] Ensayo API Gateway (Azure API Management vs Application Gateway) — solo documento, no implementación (Reto 2)
- [ ] `az group delete` + evidencia (Reto 3 / FinOps, 10%)

## Fase 6 — Final
- [ ] Evidencias (capturas, URLs, .puml, scripts)
- [ ] Cuestionario (22 preguntas conceptuales de la guía)
- [ ] Revisión final contra rúbrica

---

## Decisiones ya tomadas por alcance de la guía (no inventar de más)
- **No se requiere** microservicio de Ventas como código ni API Gateway implementado: en la guía solo aparecen en el diagrama PlantUML y como ensayo (Fase 4 Reto 2). Docker Compose exige exactamente **2 APIs backend** (contabilidad + inventario) + 2 bases de datos = 4 contenedores.
- **No se requiere** frontend en código (React/Angular/Flutter): la guía pide únicamente diseño/prototipo en Figma para las 3 pantallas.
- Persistencia: Inventario/catálogo → MongoDB. Facturación/Contabilidad → PostgreSQL. Confirmado por la guía.
- Lenguaje de `microservicio_inventario`: **Python/FastAPI** (mismo stack que contabilidad; la guía permitía Node.js/Java pero no lo exige).
