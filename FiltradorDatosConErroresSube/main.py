import os
import re
import pandas as pd
from tkinter import Tk, filedialog

# Oculta la ventana principal de Tkinter
root = Tk()
root.withdraw()

# Muestra un cuadro de diálogo para seleccionar carpeta
carpeta_raiz = filedialog.askdirectory(title="Selecciona la carpeta donde buscar los archivos CSV")

if not carpeta_raiz:
    print("No se seleccionó ninguna carpeta. Saliendo del programa.")
    exit()

columna_error = "estado"  # Cambia esto por el nombre real de la columna a filtrar
patron = re.compile(r".*\.csv$")  # Puedes ajustar el patrón según nombres de archivos

errores_todos = pd.DataFrame()

for carpeta_actual, subcarpetas, archivos in os.walk(carpeta_raiz):
    for archivo in archivos:
        if patron.match(archivo):
            ruta = os.path.join(carpeta_actual, archivo)
            try:
                df = pd.read_csv(ruta)
                errores = df[df[columna_error].astype(str).str.startswith("error")]
                errores_todos = pd.concat([errores_todos, errores], ignore_index=True)
            except Exception as e:
                print(f"No se pudo procesar el archivo {ruta}: {e}")

if not errores_todos.empty:
    salida = os.path.join(carpeta_raiz, "errores_todos.csv")
    errores_todos.to_csv(salida, index=False)
    print(f"Archivo generado: {salida}")
else:
    print("No se encontraron errores en los archivos procesados.")