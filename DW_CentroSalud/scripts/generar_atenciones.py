import pandas as pd
import random
from faker import Faker
from datetime import datetime, timedelta

fake = Faker('es_AR')

class Atencion:
    def __init__(self, id_atencion, id_paciente, id_medico, id_procedimiento,
                 id_fecha, fecha_atencion, resultado, costo, duracion, observacion):
        self.id_atencion = id_atencion
        self.id_paciente = id_paciente
        self.id_medico = id_medico
        self.id_procedimiento = id_procedimiento
        self.id_fecha = id_fecha
        self.fecha_atencion = fecha_atencion
        self.resultado = resultado
        self.costo = costo
        self.duracion = duracion
        self.observacion = observacion

    def to_dict(self):
        return {
            'id_atencion': self.id_atencion,
            'id_paciente': self.id_paciente,
            'id_medico': self.id_medico,
            'id_procedimiento': self.id_procedimiento,
            'id_fecha': self.id_fecha,
            'fecha_atencion': self.fecha_atencion,
            'resultado': self.resultado,
            'costo': self.costo,
            'duracion': self.duracion,
            'observacion': self.observacion
        }

# Parámetros
N_ATENCIONES = 1000
min_fecha = datetime(2019, 1, 1)
max_fecha = datetime(2024, 12, 31)

# Cargar dimensiones
df_pacientes = pd.read_csv('data/pacientes.csv')
df_medicos = pd.read_csv('data/medicos.csv')
df_procedimientos = pd.read_csv('data/procedimientos.csv')

resultados_posibles = ['Normal', 'Patológico', 'En tratamiento', 'Derivado', 'Alta médica', 'Pendiente']
observaciones_posibles = ['Sin observaciones', 'Requiere seguimiento', 'Paciente estable', 
                          'Requiere estudios adicionales','Se recomienda consulta especializada',
                          'Recetado tratamiento', 'Paciente derivado']

# Generar atenciones
atenciones = []
for i in range(1, N_ATENCIONES + 1):
    id_paciente = random.choice(df_pacientes['id_paciente'])
    id_medico = random.choice(df_medicos['id_medico'])
    id_procedimiento = random.choice(df_procedimientos['id_procedimiento'])

    # Fecha aleatoria
    delta = max_fecha - min_fecha
    fecha_random = min_fecha + timedelta(days=random.randint(0, delta.days))
    fecha_atencion = fecha_random.strftime('%Y-%m-%d')
    id_fecha = int(fecha_random.strftime('%Y%m%d'))  # clave sustituta AAAAMMDD

    resultado = random.choice(resultados_posibles)
    costo = round(random.uniform(1000, 50000), 2)  # Costo simulado en pesos
    duracion = random.randint(10, 240)  # Duración entre 10 y 240 minutos
    observacion = random.choice(observaciones_posibles)

    atencion = Atencion(
        id_atencion=i,
        id_paciente=id_paciente,
        id_medico=id_medico,
        id_procedimiento=id_procedimiento,
        id_fecha=id_fecha,
        fecha_atencion=fecha_atencion,
        resultado=resultado,
        costo=costo,
        duracion=duracion,
        observacion=observacion
    )
    atenciones.append(atencion)

# Guardar en CSV
df_atenciones = pd.DataFrame([a.to_dict() for a in atenciones])
df_atenciones.to_csv('data/atenciones.csv', index=False)
print(f"Se generó el archivo data/atenciones.csv con {N_ATENCIONES} atenciones.")