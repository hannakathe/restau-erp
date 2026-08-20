from fastapi import FastAPI

app = FastAPI(title="Microservicio de Contabilidad")

@app.get("/")
def home():
    return {"mensaje": "Microservicio de Contabilidad corriendo en Docker"}

@app.get("/health")
def health():
    return {"status": "ok"}