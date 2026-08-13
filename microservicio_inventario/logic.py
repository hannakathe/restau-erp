from datetime import datetime, timedelta


def filtro_vencimiento(dias: int, hoy: datetime | None = None) -> dict:
    hoy = hoy or datetime.utcnow()
    limite = hoy + timedelta(days=dias)
    return {"fecha_vencimiento": {"$gte": hoy, "$lte": limite}}
