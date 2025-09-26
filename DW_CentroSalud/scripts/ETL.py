#dependencias
import pandas as pd
# from sqlalchemy.exc import IntegrityError
from sqlalchemy.dialects.postgresql import insert
from conexion_bd import SessionLocal
from models import (Pacientes, Provincias, Departamentos, ObrasSociales, 
                    Especialidades, Areas, TiposProcedimientos, CategoriasProcedimientos,
                    Medicos, Procedimientos, Fechas, Pacientes, Atenciones)

#extraer datos
df_areas = pd.read_csv("data/areas.csv", encoding="utf-8")
df_atenciones = pd.read_csv("data/atenciones.csv", encoding="utf-8")
df_cat_procedimientos = pd.read_csv("data/cat_procedimientos.csv", encoding="utf-8")
df_deptos_prov = pd.read_csv("data/departamentos_provincias.csv", encoding="utf-8")
df_especialidades = pd.read_csv("data/especialidades.csv", encoding="utf-8")
df_medicos = pd.read_csv("data/medicos.csv", encoding="utf-8")
df_oss = pd.read_csv("data/oss.csv", encoding="utf-8")
df_pacientes = pd.read_csv("data/pacientes.csv", encoding="utf-8")
df_procedimientos = pd.read_csv("data/procedimientos.csv", encoding="utf-8")
df_tipos_proced = pd.read_csv("data/tipos_procedimientos.csv", encoding="utf-8")

#cargar sesion desde la conexion a la BD
db = SessionLocal()

#cargo datos de provincias
def etl_provincias():
    try:
        for _, row in df_deptos_prov.iterrows():
            stmt = insert(Provincias).values(
                provincia=row['nombre_provincia']
            ).on_conflict_do_nothing(index_elements=['provincia'])  # evita duplicados según la columna 'provincia'
            
            db.execute(stmt)

        db.commit()
        print("Datos de provincias cargados correctamente (sin duplicados)")

    except Exception as e:
        db.rollback()
        print("Error al cargar datos:", e)

    finally:
        db.close()

#cargo datos de departamentos
try:
    for _, row in df_deptos_prov.iterrows():
        stmt = insert(Departamentos).values(
            departamento=row['nombre_departamento'],
            id_provincia=row['id_provincia']
        ).on_conflict_do_nothing(index_elements=['departamento', 'id_provincia'])  # evita duplicados por depto+provincia
        
        db.execute(stmt)

    db.commit()
    print("Datos de departamentos cargados correctamente (sin duplicados)")

except Exception as e:
    db.rollback()
    print("Error al cargar datos:", e)

finally:
    db.close()

#cargo datos de obras sociales
try:
    for _, row in df_oss.iterrows():
        oss = ObrasSociales(
            obra_social = row['nombre_obra_social']
        ).on_conflict_do_nothing(index_elements = ['obra_social'])
        db.execute(stmt)

    db.commit()
    print("Datos de obra social cargados correctamente")
except Exception as e:
    db.rollback()
    print("Error al cargar datos:", e)
finally:
    db.close()

#cargo datos de especialidades
try:
    for _, row in df_especialidades.iterrows():
        esp = Especialidades(
            especialidad = row['nombre_especialidad']
        ).on_conflict_do_nothing(index_elements=['especialidad'])
        db.execute(stmt)

    db.commit()
    print("Datos de especialidades cargados correctamente")
except Exception as e:
    db.rollback()
    print("Error al cargar datos:", e)
finally:
    db.close()

#cargo datos de areas
try:
    for _, row in df_areas.iterrows():
        area = Areas(
            area = row['nombre_area']
        ).on_conflict_do_nothing(index_elements=['area'])
        db.execute(stmt)

    db.commit()
    print("Datos de areas cargados correctamente")
except Exception as e:
    db.rollback()
    print("Error al cargar datos:", e)
finally:
    db.close()

# cargo datos de tipos procedimientos
try:
    for _, row in df_tipos_proced.iterrows():
        tipo_procedimiento = TiposProcedimientos(
            tipo_procedimiento = row['nombre_tipo_procedimiento']
        ).on_conflict_do_nothing(index_elements = ['tipo_procedimiento'])
        db.execute(stmt)

    db.commit()
    print("Datos de tipos_proced cargados correctamente")
except Exception as e:
    db.rollback()
    print("Error al cargar datos:", e)
finally:
    db.close()

# cargo datos de cat procedimientos
try:
    for _, row in df_cat_procedimientos.iterrows():
        categoria_procedimiento = CategoriasProcedimientos(
            categoria_procedimiento = row['nombre_categoria_procedimiento']
        ).on_conflict_do_nothing(index_elements=['categoria_procedimiento'])
        db.execute(stmt)

    db.commit()
    print("Datos de categoria_procedimiento cargados correctamente")
except Exception as e:
    db.rollback()
    print("Error al cargar datos:", e)
finally:
    db.close()

# cargo datos de medicos
try:
    for _, row in df_medicos.iterrows():
        medicos = Medicos(
            nombre = row['nombre'],
            id_especialidad = row['id_especialidad'],
            id_area = row['id_area'],
            tipo_contrato = row['tipo_contrato']
        ).on_conflict_do_nothing(index_elements=['nombre','id_especialidad','id_area'])
        db.execute(stmt)

    db.commit()
    print("Datos de medicos cargados correctamente")
except Exception as e:
    db.rollback()
    print("Error al cargar datos:", e)
finally:
    db.close()

#cargo datos de procedimientos
try:
    for _, row in df_procedimientos.iterrows():
        procedimientos = Procedimientos(
            nombre_procedimiento = row['nombre_procedimiento'],
            id_tipo_procedimiento = row['id_tipo_procedimiento'],
            id_categoria_procedimiento = row['id_categoria_procedimiento'],
            nivel_complejidad = row['nivel_complejidad']
        ).on_conflict_do_nothing(index_elements=['nombre_procedimiento','id_tipo_procedimiento'])
        db.execute(stmt)

    db.commit()
    print("Datos de procedimientos cargados correctamente")
except Exception as e:
    db.rollback()
    print("Error al cargar datos:", e)
finally:
    db.close()

#cargo datos de pacientes
try:
    for _, row in df_pacientes.iterrows():
        stmt = insert(Pacientes).values(
            id=row["id_paciente"],        # ID del CSV
            nombre=row["nombre"],
            genero=row["genero"],
            fecha_nacimiento=row["fecha_nacimiento"],
            telefono=row["telefono"],
            dni=row["dni"],
            id_departamento=row["id_departamento"],
            id_provincia=row["id_provincia"],
            id_obra_social=row["id_obra_social"]
        ).on_conflict_do_nothing(index_elements=['id']) # evita duplicados por ID
        db.execute(stmt)

    db.commit()
    print("Datos de pacientes cargados correctamente (sin duplicados)")
except Exception as e:
    db.rollback()
    print("Error al cargar pacientes:", e)

#cargo datos de atenciones
paciente_ids = set(df_pacientes["id_paciente"])

try:
    for _, row in df_atenciones.iterrows():
        # Buscamos el id de la fecha en la tabla Fechas
        fecha_obj = db.query(Fechas).filter(Fechas.fecha == row['fecha_atencion']).first()
        if not fecha_obj:
            print(f"Fecha {row['fecha_atencion']} no encontrada en Fechas")
            continue

        atencion = Atenciones(
            id_paciente=row['id_paciente'],
            id_medico=row['id_medico'],
            id_procedimiento=row['id_procedimiento'],
            id_fecha=fecha_obj.id,  # <-- usamos el id autoincremental real
            resultado=row['resultado'],
            costo=row['costo'],
            duracion=row['duracion'],
            observaciones=row['observacion']
        )
        db.add(atencion)
    db.commit()
    print("Datos de atenciones cargados correctamente (sin duplicados)")
except Exception as e:
    db.rollback()
    print("Error al cargar atenciones:", e)
finally:
    db.close()
