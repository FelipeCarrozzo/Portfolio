import pandas as pd
import random
from faker import Faker

"""Genera datos sintéticos para la tabla de médicos y los guarda en un archivo CSV."""

fake = Faker('es_AR')

class Medico:
    def __init__(self, id_medico, nombre, id_especialidad, nombre_especialidad,
                 id_area, nombre_area, tipo_contrato):
        self.id_medico = id_medico
        self.nombre = nombre
        self.id_especialidad = id_especialidad
        self.nombre_especialidad = nombre_especialidad
        self.id_area = id_area
        self.nombre_area = nombre_area
        self.tipo_contrato = tipo_contrato

    def to_dict(self):
        return {
            'id_medico': self.id_medico,
            'nombre': self.nombre,
            'id_especialidad': self.id_especialidad,
            'nombre_especialidad': self.nombre_especialidad,
            'id_area': self.id_area,
            'nombre_area': self.nombre_area,
            'tipo_contrato': self.tipo_contrato
        }

# Parámetros
N_MEDICOS = 100
tipos_contrato = ['Permanente', 'Temporario', 'Residente', 'Honorarios']

# Cargar dimensiones
df_esp = pd.read_csv('data/especialidades.csv')
df_area = pd.read_csv('data/areas.csv')

# Generar médicos
medicos = []
for i in range(1, N_MEDICOS + 1):
    nombre = fake.first_name() + ' ' + fake.last_name()

    esp_row = df_esp.sample().iloc[0]
    id_especialidad = esp_row.id_especialidad
    nombre_especialidad = esp_row.nombre_especialidad

    area_row = df_area.sample().iloc[0]
    id_area = area_row.id_area
    nombre_area = area_row.nombre_area

    tipo_contrato = random.choice(tipos_contrato)

    medico = Medico(
        id_medico=i,
        nombre=nombre,
        id_especialidad=id_especialidad,
        nombre_especialidad=nombre_especialidad,
        id_area=id_area,
        nombre_area=nombre_area,
        tipo_contrato=tipo_contrato
    )
    medicos.append(medico)

# Convertir a DataFrame y guardar
df_medicos = pd.DataFrame([m.to_dict() for m in medicos])
df_medicos.to_csv('data/medicos.csv', index=False)
print(f"Se generó el archivo data/medicos.csv con {N_MEDICOS} médicos.")