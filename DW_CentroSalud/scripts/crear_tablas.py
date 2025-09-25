from conexion_bd import Base, engine
import models  # importa para que se registren los modelos

print("Creando tablas...")
Base.metadata.create_all(bind=engine)
print("Tablas creadas exitosamente")
