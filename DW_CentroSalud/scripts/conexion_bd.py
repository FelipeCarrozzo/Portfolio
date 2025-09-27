from sqlalchemy import create_engine
from sqlalchemy.orm import declarative_base, sessionmaker

"""Configuración de la conexión a PostgreSQL usando SQLAlchemy."""

DATABASE_URL = "postgresql+psycopg2://postgres:repasador@localhost:5433/centro_salud"

#engine
engine = create_engine(DATABASE_URL, echo=False)
Base = declarative_base()

#sesiones
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

try:
    with engine.connect() as connection:
        print("Conexión exitosa a PostgreSQL!")
except Exception as e:
    print("Error de conexión:", e)