import os

from dotenv import load_dotenv
from fastapi import Depends, FastAPI, HTTPException
from pymongo import MongoClient
from pydantic import BaseModel

from logic import filtro_vencimiento

load_dotenv()
MONGO_URI = os.getenv("MONGO_URI", "mongodb://localhost:27017")

app = FastAPI(title="Microservicio de Inventario")


class InsumoConsumido(BaseModel):
    id_bodega: str
    cantidad: float


def get_db():
    client = MongoClient(MONGO_URI)
    try:
        yield client["erp_restaurante"]
    finally:
        client.close()


@app.get("/health")
def health():
    return {"status": "ok"}


@app.get("/productos")
def listar_productos(db=Depends(get_db)):
    return list(db.productos.find({}, {"_id": 0}))


@app.get("/inventario/vencimientos")
def proximos_a_vencer(dias: int = 7, db=Depends(get_db)):
    items = list(
        db.bodega.find(
            filtro_vencimiento(dias),
            {"_id": 0, "ingrediente": 1, "lote": 1, "fecha_vencimiento": 1, "cantidad_actual": 1, "unidad": 1},
        ).sort("fecha_vencimiento", 1)
    )
    return items


@app.post("/inventario/descontar")
def descontar_insumos(receta: list[InsumoConsumido], db=Depends(get_db)):
    for insumo in receta:
        resultado = db.bodega.update_one(
            {"id_bodega": insumo.id_bodega},
            {"$inc": {"cantidad_actual": -insumo.cantidad}},
        )
        if resultado.matched_count == 0:
            raise HTTPException(status_code=404, detail=f"Insumo {insumo.id_bodega} no existe en bodega")
    return {"status": "descontado", "items": len(receta)}
