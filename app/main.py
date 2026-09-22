import os
import psycopg2
from fastapi import FastAPI
app = FastAPI()
DB = dict(
    host=os.getenv("DB_HOST", "db"),
    dbname=os.getenv("DB_NAME", "appdb"),
    user=os.getenv("DB_USER", "appuser"),
    password=os.getenv("DB_PASSWORD", "apppass"),
)
@app.get("/")
def root():
    return {"service": "lab5", "env": os.getenv("APP_ENV", "dev")}
@app.get("/health")
def health():
    try:
        conn = psycopg2.connect(**DB, connect_timeout=2)
        conn.close()
        return {"status": "ok", "db": "up"}
    except Exception as e:
        return {"status": "degraded", "db": str(e)}