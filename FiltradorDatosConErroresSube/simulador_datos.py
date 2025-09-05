import pandas as pd
import numpy as np
import os
from datetime import datetime, timedelta

# Configuración
num_archivos = 5
filas_por_archivo = 100
carpeta_destino = "data"

# Fechas para los nombres de los archivos (últimos 5 días)
hoy = datetime.now()
fechas = [(hoy - timedelta(days=i)).strftime("%Y-%m-%d") for i in range(num_archivos)]

for fecha in fechas:
    # Generar datos aleatorios
    data = {
        "id": np.arange(1, filas_por_archivo+1),
        "estado": np.random.choice(["ok", "ok", "error_timeout", "ok", "error_conexion"], size=filas_por_archivo),
        "monto": np.round(np.random.uniform(10, 1000, size=filas_por_archivo), 2),
        "descripcion": np.random.choice(["operación exitosa", "fallo en operación", "reintentar", "completado"], size=filas_por_archivo)
    }
    df = pd.DataFrame(data)
    # Guardar el archivo CSV
    nombre_archivo = os.path.join(carpeta_destino, f"{fecha}.csv")
    df.to_csv(nombre_archivo, index=False)
    print(f"Archivo generado: {nombre_archivo}")