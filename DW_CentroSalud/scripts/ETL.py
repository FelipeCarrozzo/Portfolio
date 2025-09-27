#dependencias
import pandas as pd
from sqlalchemy.dialects.postgresql import insert
from conexion_bd import SessionLocal
from models import (Pacientes, Provincias, Departamentos, ObrasSociales, 
                    Especialidades, Areas, TiposProcedimientos, CategoriasProcedimientos,
                    Medicos, Procedimientos, Fechas, Pacientes, Atenciones)

"""
ETL: Extrae, transforma y carga datos desde archivos CSV a la base de datos PostgreSQL.
Utiliza SQLAlchemy para manejar las operaciones de la base de datos.

"""
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


#cargo datos de provincias
def etl_provincias(df, db):
    insertadas = 0
    try:
        for _, row in df.iterrows():
            stmt = insert(Provincias).values(
                provincia=row['nombre_provincia']
            ).on_conflict_do_nothing(index_elements=['provincia'])

            result = db.execute(stmt)
            insertadas += result.rowcount if result.rowcount else 0

        db.commit()
        print(f"Provincias cargadas: {insertadas}")
        return insertadas
    except Exception as e:
        db.rollback()
        print("Error en provincias:", e)
        return 0

#cargo datos de fechas
def etl_fechas(df, db):
    insertadas = 0
    try:
        fechas_unicas = pd.to_datetime(df['fecha_atencion']).dt.date.unique()
        for fecha in fechas_unicas:
            stmt = insert(Fechas).values(
                fecha=fecha
            ).on_conflict_do_nothing(index_elements=['fecha'])

            result = db.execute(stmt)
            insertadas += result.rowcount if result.rowcount else 0

        db.commit()
        print(f"Fechas cargadas: {insertadas}")
        return insertadas
    except Exception as e:
        db.rollback()
        print("Error en fechas:", e)
        return 0

#etl departamentos
def etl_departamentos(df, db):
    insertadas = 0
    try:
        for _, row in df.iterrows():
            stmt = insert(Departamentos).values(
                departamento=row['nombre_departamento'],
                id_provincia=row['id_provincia']
            ).on_conflict_do_nothing(index_elements=['departamento', 'id_provincia'])

            result = db.execute(stmt)
            insertadas += result.rowcount if result.rowcount else 0

        db.commit()
        print(f"Departamentos cargados: {insertadas}")
        return insertadas
    except Exception as e:
        db.rollback()
        print("Error en departamentos:", e)
        return 0

#etl obras sociales
def etl_oss(df, db):
    insertadas = 0
    try:
        for _, row in df.iterrows():
            stmt = insert(ObrasSociales).values(
                obra_social=row['nombre_obra_social']
            ).on_conflict_do_nothing(index_elements=['obra_social'])

            result = db.execute(stmt)
            insertadas += result.rowcount if result.rowcount else 0

        db.commit()
        print(f"Obras sociales cargadas: {insertadas}")
        return insertadas
    except Exception as e:
        db.rollback()
        print("Error en obras sociales:", e)
        return 0

#etl especialidades
def etl_especialidades(df, db):
    insertadas = 0
    try:
        for _, row in df.iterrows():
            stmt = insert(Especialidades).values(
                especialidad=row['nombre_especialidad']
            ).on_conflict_do_nothing(index_elements=['especialidad'])

            result = db.execute(stmt)
            insertadas += result.rowcount if result.rowcount else 0

        db.commit()
        print(f"Especialidades cargadas: {insertadas}")
        return insertadas
    except Exception as e:
        db.rollback()
        print("Error en especialidades:", e)
        return 0

#etl areas
def etl_areas(df, db):
    insertadas = 0
    try:
        for _, row in df.iterrows():
            stmt = insert(Areas).values(
                area=row['nombre_area']
            ).on_conflict_do_nothing(index_elements=['area'])

            result = db.execute(stmt)
            insertadas += result.rowcount if result.rowcount else 0

        db.commit()
        print(f"Áreas cargadas: {insertadas}")
        return insertadas
    except Exception as e:
        db.rollback()
        print("Error en áreas:", e)
        return 0

#etl tipos procedimientos
def etl_tipos_procedimientos(df, db):
    insertadas = 0
    try:
        for _, row in df.iterrows():
            stmt = insert(TiposProcedimientos).values(
                tipo_procedimiento=row['nombre_tipo_procedimiento']
            ).on_conflict_do_nothing(index_elements=['tipo_procedimiento'])

            result = db.execute(stmt)
            insertadas += result.rowcount if result.rowcount else 0

        db.commit()
        print(f"Tipos de procedimientos cargados: {insertadas}")
        return insertadas
    except Exception as e:
        db.rollback()
        print("Error en tipos de procedimientos:", e)
        return 0

#etl categorias procedimientos
def etl_cat_procedimientos(df, db):
    insertadas = 0
    try:
        for _, row in df.iterrows():
            stmt = insert(CategoriasProcedimientos).values(
                categoria_procedimiento=row['nombre_categoria_procedimiento']
            ).on_conflict_do_nothing(index_elements=['categoria_procedimiento'])

            result = db.execute(stmt)
            insertadas += result.rowcount if result.rowcount else 0

        db.commit()
        print(f"Categorías de procedimientos cargadas: {insertadas}")
        return insertadas
    except Exception as e:
        db.rollback()
        print("Error en categorías de procedimientos:", e)
        return 0

#etl medicos
def etl_medicos(df, db):
    insertadas = 0
    try:
        for _, row in df.iterrows():
            stmt = insert(Medicos).values(
                nombre=row['nombre'],
                id_especialidad=row['id_especialidad'],
                id_area=row['id_area'],
                tipo_contrato=row['tipo_contrato']
            ).on_conflict_do_nothing(index_elements=['nombre', 'id_especialidad', 'id_area'])

            result = db.execute(stmt)
            insertadas += result.rowcount if result.rowcount else 0

        db.commit()
        print(f"Médicos cargados: {insertadas}")
        return insertadas
    except Exception as e:
        db.rollback()
        print("Error en médicos:", e)
        return 0

#etl procedimientos
def etl_procedimientos(df, db):
    insertadas = 0
    try:
        for _, row in df.iterrows():
            stmt = insert(Procedimientos).values(
                nombre_procedimiento=row['nombre_procedimiento'],
                id_tipo_procedimiento=row['id_tipo_procedimiento'],
                id_categoria_procedimiento=row['id_categoria_procedimiento'],
                nivel_complejidad=row['nivel_complejidad']
            ).on_conflict_do_nothing(index_elements=['nombre_procedimiento', 'id_tipo_procedimiento'])

            result = db.execute(stmt)
            insertadas += result.rowcount if result.rowcount else 0

        db.commit()
        print(f"Procedimientos cargados: {insertadas}")
        return insertadas
    except Exception as e:
        db.rollback()
        print("Error en procedimientos:", e)
        return 0

#cargo datos de pacientes
def etl_pacientes(df, db):
    insertadas = 0
    try:
        for _, row in df.iterrows():
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
            ).on_conflict_do_nothing(index_elements=['id'])

            result = db.execute(stmt)
            insertadas += result.rowcount if result.rowcount else 0

        db.commit()
        print(f"Pacientes cargados: {insertadas}")
        return insertadas
    except Exception as e:
        db.rollback()
        print("Error en pacientes:", e)
        return 0

#cargo datos de atenciones
def etl_atenciones(df, db):
    insertadas = 0
    try:
        for _, row in df.iterrows():
            # Validar que el paciente exista
            paciente_existe = db.query(Pacientes.id_paciente).filter(
                Pacientes.id_paciente == row['id_paciente']
            ).first()
            if not paciente_existe:
                print(f"Paciente {row['id_paciente']} no encontrado. Se omite la atención.")
                continue

            # Buscar id_fecha en la tabla Fechas
            fecha_obj = db.query(Fechas).filter(
                Fechas.fecha == row['fecha_atencion']
            ).first()
            if not fecha_obj:
                print(f"Fecha {row['fecha_atencion']} no encontrada en Fechas")
                continue

            # Insert con control de duplicados
            stmt = insert(Atenciones).values(
                id_paciente=row['id_paciente'],
                id_medico=row['id_medico'],
                id_procedimiento=row['id_procedimiento'],
                id_fecha=fecha_obj.id,  # usamos el id real de Fechas
                resultado=row['resultado'],
                costo=row['costo'],
                duracion=row['duracion'],
                observaciones=row['observacion']
            ).on_conflict_do_nothing(
                index_elements=['id_paciente', 'id_medico', 'id_procedimiento', 'id_fecha']
            )

            result = db.execute(stmt)
            insertadas += result.rowcount if result.rowcount else 0

        db.commit()
        print(f"Atenciones cargadas: {insertadas}")
        return insertadas

    except Exception as e:
        db.rollback()
        print("Error al cargar atenciones:", e)
        return 0

if __name__ == "__main__":
    #cargar CSVs
    df_deptos_prov = pd.read_csv("data/departamentos_provincias.csv", encoding="utf-8")
    df_atenciones = pd.read_csv("data/atenciones.csv", encoding="utf-8")
    df_pacientes = pd.read_csv("data/pacientes.csv", encoding="utf-8")

    #abrir sesión
    db = SessionLocal()

    #ejecutar ETLs
    etl_provincias(df_deptos_prov, db)
    etl_fechas(df_atenciones, db)
    etl_pacientes(df_pacientes, db)

    #cerrar sesión
    db.close()