def calcular_impuestos(subtotal: float) -> dict[str, float]:
    return {
        "IVA 19%": round(subtotal * 0.19, 2),
        "Impoconsumo 8%": round(subtotal * 0.08, 2),
    }
