import os

import psycopg2
from dotenv import load_dotenv
from fastapi import Depends, FastAPI, HTTPException
from pydantic import BaseModel

from logic import calcular_impuestos

load_dotenv()
DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://usuario:password@localhost:5432/erp_restaurante")

app = FastAPI(title="Microservicio de Contabilidad")


class ItemVenta(BaseModel):
    codigo_sku: str
    cantidad: int
    subtotal: float


class FacturaIn(BaseModel):
    metodo_pago: str
    items: list[ItemVenta]


def get_conn():
    conn = psycopg2.connect(DATABASE_URL)
    try:
        yield conn
    finally:
        conn.close()


@app.get("/health")
def health():
    return {"status": "ok"}


@app.post("/facturas", status_code=201)
def crear_factura(payload: FacturaIn, conn=Depends(get_conn)):
    if not payload.items:
        raise HTTPException(status_code=400, detail="La factura debe tener al menos un ítem")

    subtotal_total = sum(item.subtotal for item in payload.items)
    impuestos = calcular_impuestos(subtotal_total)

    try:
        with conn:
            with conn.cursor() as cur:
                cur.execute(
                    "INSERT INTO facturas (total_venta, metodo_pago) VALUES (%s, %s) RETURNING id_factura",
                    (subtotal_total, payload.metodo_pago),
                )
                id_factura = cur.fetchone()[0]

                for item in payload.items:
                    cur.execute(
                        "INSERT INTO detalle_factura (id_factura, codigo_sku_producto, cantidad, subtotal) "
                        "VALUES (%s, %s, %s, %s)",
                        (id_factura, item.codigo_sku, item.cantidad, item.subtotal),
                    )

                for tipo, monto in impuestos.items():
                    cur.execute(
                        "INSERT INTO registro_impuestos (id_factura, tipo_impuesto, monto_impuesto) "
                        "VALUES (%s, %s, %s)",
                        (id_factura, tipo, monto),
                    )
    except Exception as exc:
        raise HTTPException(status_code=500, detail="Transacción revertida: no se pudo registrar la factura") from exc

    return {"id_factura": id_factura, "total_venta": subtotal_total, "impuestos": impuestos}
