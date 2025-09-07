import pandas as pd
import random
from faker import Faker

fake = Faker('es_AR')

class Paciente:
    def __init__(self, id_paciente, nombre, genero, fecha_nacimiento, telefono, dni,
                 id_departamento, nombre_departamento,
                 id_provincia, nombre_provincia,
                 id_obra_social, nombre_obra_social):
        self.id_paciente = id_paciente
        self.nombre = nombre
        self.genero = genero
        self.fecha_nacimiento = fecha_nacimiento
        self.telefono = telefono
        self.dni = dni
        self.id_departamento = id_departamento
        self.nombre_departamento = nombre_departamento
        self.id_provincia = id_provincia
        self.nombre_provincia = nombre_provincia
        self.id_obra_social = id_obra_social
        self.nombre_obra_social = nombre_obra_social

    def to_dict(self):
        return {
            'id_paciente': self.id_paciente,
            'nombre': self.nombre,
            'genero': self.genero,
            'fecha_nacimiento': self.fecha_nacimiento,
            'telefono': self.telefono,
            'dni': self.dni,
            'id_departamento': self.id_departamento,
            'nombre_departamento': self.nombre_departamento,
            'id_provincia': self.id_provincia,
            'nombre_provincia': self.nombre_provincia,
            'id_obra_social': self.id_obra_social,
            'nombre_obra_social': self.nombre_obra_social
        }

# Parámetros
N_PACIENTES = 1000
generos = ['Masculino', 'Femenino', 'Otro']

# Cargar dimensiones
df_deptos = pd.read_csv('data/dependences/departamentos_provincias.csv')
df_obras = pd.read_csv('data/dependences/oss.csv')

# Generar pacientes
pacientes = []
dni_usados = set()
for i in range(1, N_PACIENTES + 1):
    nombre = fake.first_name() + ' ' + fake.last_name()
    genero = random.choice(generos)
    fecha_nac = fake.date_of_birth(minimum_age=0, maximum_age=90).strftime('%Y-%m-%d')

    # DNI único de 8 dígitos
    while True:
        dni = str(random.randint(10000000, 99999999))
        if dni not in dni_usados:
            dni_usados.add(dni)
            break
    
    # Teléfono único de 7 dígitos que empieza con 15
    while True:
        telefono = '15' + str(random.randint(1000000, 9999999))[1:]
        if not hasattr(globals(), 'telefonos_usados'):
            telefonos_usados = set()
            globals()['telefonos_usados'] = telefonos_usados
        else:
            telefonos_usados = globals()['telefonos_usados']
        if telefono not in telefonos_usados:
            telefonos_usados.add(telefono)
            break

    depto_row = df_deptos.sample().iloc[0]
    id_departamento = depto_row.id_departamento
    nombre_departamento = depto_row.nombre_departamento
    id_provincia = depto_row.id_provincia
    nombre_provincia = depto_row.nombre_provincia

    obra_row = df_obras.sample().iloc[0]
    id_obra_social = obra_row.id_obra_social
    nombre_obra_social = obra_row.nombre_obra_social

    paciente = Paciente(
        id_paciente=i,
        nombre=nombre,
        genero=genero,
        fecha_nacimiento=fecha_nac,
        telefono=telefono,
        dni=dni,
        id_departamento=id_departamento,
        nombre_departamento=nombre_departamento,
        id_provincia=id_provincia,
        nombre_provincia=nombre_provincia,
        id_obra_social=id_obra_social,
        nombre_obra_social=nombre_obra_social
    )
    pacientes.append(paciente)

# Convertir a DataFrame y guardar
df_pacientes = pd.DataFrame([p.to_dict() for p in pacientes])
df_pacientes.to_csv('data/pacientes.csv', index=False)
print(f"Se generó el archivo data/pacientes.csv con {N_PACIENTES} pacientes y columna DNI.")