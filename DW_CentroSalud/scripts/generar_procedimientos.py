import pandas as pd
import random
from faker import Faker

fake = Faker('es_AR')

class Procedimiento:
    def __init__(self, id_procedimiento, nombre_procedimiento,
                 id_tipo_procedimiento, nombre_tipo_procedimiento,
                 id_categoria_procedimiento, nombre_categoria_procedimiento,
                 nivel_complejidad):
        self.id_procedimiento = id_procedimiento
        self.nombre_procedimiento = nombre_procedimiento
        self.id_tipo_procedimiento = id_tipo_procedimiento
        self.nombre_tipo_procedimiento = nombre_tipo_procedimiento
        self.id_categoria_procedimiento = id_categoria_procedimiento
        self.nombre_categoria_procedimiento = nombre_categoria_procedimiento
        self.nivel_complejidad = nivel_complejidad

    def to_dict(self):
        return {
            'id_procedimiento': self.id_procedimiento,
            'nombre_procedimiento': self.nombre_procedimiento,
            'id_tipo_procedimiento': self.id_tipo_procedimiento,
            'nombre_tipo_procedimiento': self.nombre_tipo_procedimiento,
            'id_categoria_procedimiento': self.id_categoria_procedimiento,
            'nombre_categoria_procedimiento': self.nombre_categoria_procedimiento,
            'nivel_complejidad': self.nivel_complejidad
        }

# Parámetros
N_PROCEDIMIENTOS = 30
niveles_complejidad = ['Baja', 'Media', 'Alta']

# Cargar dimensiones
df_tipo = pd.read_csv('data/tipos_procedimientos.csv')
df_cat = pd.read_csv('data/cat_procedimientos.csv')

# Posibles nombres base para procedimientos (puedes extender la lista)
nombres_base = [
    'Consulta médica',
    'Electrocardiograma',
    'Hemograma',
    'Radiografía',
    'Resonancia magnética',
    'Cirugía menor',
    'Cirugía mayor',
    'Ecografía obstétrica',
    'Terapia respiratoria',
    'Implante dental',
    'Biopsia',
    'Colocación de yeso',
    'Endoscopía',
    'Papanicolau',
    'Consulta pediátrica',
    'Consulta ginecológica',
    'Consulta traumatológica',
    'Consulta neurológica',
    'Análisis de glucosa',
    'Tomografía axial computada',
    'Consulta odontológica',
    'Extracción de muela',
    'Consulta cardiológica',
    'Tratamiento oncológico',
    'Consulta dermatológica',
    'Consulta de laboratorio',
    'Ecografía abdominal',
    'Estudio de sangre',
    'Consulta de control',
    'Consulta de guardia'
]

procedimientos = []
for i in range(1, N_PROCEDIMIENTOS + 1):
    nombre_procedimiento = nombres_base[i % len(nombres_base)]
    tipo_row = df_tipo.sample().iloc[0]
    id_tipo_procedimiento = tipo_row.id_tipo_procedimiento
    nombre_tipo_procedimiento = tipo_row.nombre_tipo_procedimiento

    cat_row = df_cat.sample().iloc[0]
    id_categoria_procedimiento = cat_row.id_categoria_procedimiento
    nombre_categoria_procedimiento = cat_row.nombre_categoria_procedimiento

    nivel_complejidad = random.choice(niveles_complejidad)

    procedimiento = Procedimiento(
        id_procedimiento=i,
        nombre_procedimiento=nombre_procedimiento,
        id_tipo_procedimiento=id_tipo_procedimiento,
        nombre_tipo_procedimiento=nombre_tipo_procedimiento,
        id_categoria_procedimiento=id_categoria_procedimiento,
        nombre_categoria_procedimiento=nombre_categoria_procedimiento,
        nivel_complejidad=nivel_complejidad
    )
    procedimientos.append(procedimiento)

# Convertir a DataFrame y guardar
df_procedimientos = pd.DataFrame([p.to_dict() for p in procedimientos])
df_procedimientos.to_csv('data/procedimientos.csv', index=False)
print(f"Se generó el archivo data/procedimientos.csv con {N_PROCEDIMIENTOS} procedimientos.")

