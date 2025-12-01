#dependencias
from DW_CentroSalud.scripts.conexion_bd import Base, engine

"""Script para crear las tablas en la base de datos"""
print("Creando tablas...")
Base.metadata.create_all(bind=engine)
print("Tablas creadas exitosamente")
