#dependencias
from sqlalchemy import create_engine, Column, Integer, String, Date, Float, ForeignKey
from sqlalchemy.orm import declarative_base, relationship
from DW_CentroSalud.scripts.conexion_bd import Base

"""Definición de modelos para las tablas en la base de datos PostgreSQL usando SQLAlchemy ORM."""

class Pacientes(Base):
    __tablename__ = 'pacientes'
    id = Column(Integer, primary_key=True)
    nombre = Column(String)
    genero = Column(String)
    fecha_nacimiento = Column(Date)
    telefono = Column(String(15))
    dni = Column(String(10), unique=True)
    id_departamento = Column(Integer, ForeignKey('departamentos.id'))
    departamento = relationship("Departamentos")
    id_provincia = Column(Integer, ForeignKey('provincias.id'))
    provincia = relationship("Provincias")
    id_obra_social = Column(Integer, ForeignKey('obras_sociales.id'))
    obra_social = relationship("ObrasSociales")

class Medicos(Base):
    __tablename__ = 'medicos'
    id = Column(Integer, primary_key=True, autoincrement=True)
    nombre = Column(String)
    id_especialidad = Column(Integer, ForeignKey('especialidades.id'))
    especialidad = relationship("Especialidades")
    id_area = Column(Integer, ForeignKey('areas.id'))
    area = relationship("Areas")
    tipo_contrato = Column(String(50))

class Procedimientos(Base):
    __tablename__ = 'procedimientos'
    id = Column(Integer, primary_key=True, autoincrement=True)
    nombre_procedimiento = Column(String(100))
    id_tipo_procedimiento = Column(Integer, ForeignKey('tipos_procedimientos.id'))
    tipo_procedimiento = relationship("TiposProcedimientos")
    id_categoria_procedimiento = Column(Integer, ForeignKey('categorias_procedimientos.id'))
    categoria_procedimiento = relationship("CategoriasProcedimientos")
    nivel_complejidad = Column(String(50))

class Fechas(Base):
    __tablename__ = 'fechas'
    id = Column(Integer, primary_key=True, autoincrement=True)
    fecha = Column(Date)
    anio = Column(Integer)
    mes = Column(Integer)
    dia = Column(Integer)
    trimestre = Column(Integer)

class Atenciones(Base):
    __tablename__ = 'atenciones'
    id = Column(Integer, primary_key=True, autoincrement=True)
    id_paciente = Column(Integer, ForeignKey('pacientes.id'))
    id_medico = Column(Integer, ForeignKey('medicos.id'))
    id_procedimiento = Column(Integer, ForeignKey('procedimientos.id'))
    id_fecha = Column(Integer, ForeignKey('fechas.id'))
    resultado = Column(String(100))
    costo = Column(Float)
    duracion = Column(Integer)  #duración en minutos
    observaciones = Column(String)

    #relaciones con dimensiones
    paciente = relationship("Pacientes")
    medico = relationship("Medicos")
    procedimiento = relationship("Procedimientos")
    fecha = relationship("Fechas")

class ObrasSociales(Base):
    __tablename__ = 'obras_sociales'
    id = Column(Integer, primary_key=True, autoincrement=True)
    obra_social = Column(String(100))
    
class Departamentos(Base):
    __tablename__ = 'departamentos'
    id = Column(Integer, primary_key=True, autoincrement=True)
    departamento = Column(String(100))
    id_provincia = Column(Integer, ForeignKey('provincias.id'))
    provincia = relationship("Provincias")

class Provincias(Base):
    __tablename__ = 'provincias'
    id = Column(Integer, primary_key=True, autoincrement=True)
    provincia = Column(String(100))
    
class Especialidades(Base):
    __tablename__ = 'especialidades'
    id = Column(Integer, primary_key=True, autoincrement=True)
    especialidad = Column(String(100))

class Areas(Base):
    __tablename__ = 'areas'
    id = Column(Integer, primary_key=True, autoincrement=True)
    area = Column(String(100))

class TiposProcedimientos(Base):
    __tablename__ = 'tipos_procedimientos'
    id = Column(Integer, primary_key=True, autoincrement=True)
    tipo_procedimiento = Column(String(100))

class CategoriasProcedimientos(Base):
    __tablename__ = 'categorias_procedimientos'
    id = Column(Integer, primary_key=True, autoincrement=True)
    categoria_procedimiento = Column(String(100))