# Data Warehouse - Centro de Salud (simulado)

# 📂 Carpeta `data`

Esta carpeta contiene los **archivos CSV de datos simulados** utilizados en el proyecto **Data Warehouse - Centro de Salud**.

## 📌 Contenido

- **`areas.csv`** → Contiene las áreas existentes en el centro de salud (id,nombre_area)
- **`atenciones.csv`** → Datos simulados de pacientes (id,id_paciente,id_medico,id_procedimiento,fecha_atencion,resultado,costo,duracion,observacion).
- **`cat_procedimientos.csv`** → Contiene las categorías de procedimientos disponibles en el centro de salud (id_categoria_procedimiento,nombre_categoria_procedimiento).
- **`departamentos.csv`** → Contiene la lista de departamentos de cada provincia (id_departamento,nombre_departamento).
- **`especialidades.csv`** → Contiene las especialidades médicas que se ofrecen en el centro de salud (id_especialidad,nombre_especialidad).
- **`medicos.csv`** → Datos de médicos y sus especialidades (id,nombre,id_especialidad,especialidad,id_area,area,tipo_contrato).
- **`oss.csv`** → Contiene las obras sociales que tienen convenio con el centro de salud (id_obra_social,nombre_obra_social).
- **`pacientes.csv`** → Datos de los pacientes admitidos en el centro de salud (id_paciente,nombre,genero,fecha_nacimiento,telefono,dni,id_departamento,nombre_departamento,id_provincia,nombre_provincia,id_obra_social,nombre_obra_social). 
- **`procedimientos.csv`** → Contiene los procedimientos explicitos que se realizan en el centro de salud (id,procedimiento,id_tipo_procedimiento,tipo_procedimiento,id_categoria_procedimiento,categoria_procedimiento,nivel_complejidad).
- **`provincias.csv`** → Contiene la lista de provincias a las que pertecen los pacientes (id_provincia,nombre_provincia).
- **`tipos_procedimientos.csv`** → Contiene los tipos de procedimientos realizados en el centro de salud (id_tipo_procedimiento,nombre_tipo_procedimiento).

## ⚙️ Generación de datos

Los datos fueron **simulados** con la librería [Faker](https://faker.readthedocs.io/en/master/) (configurada en español/Argentina: `es_AR`) 

> 📌 **Nota:** Los datos son **ficticios** y se usan únicamente con fines académicos/demostrativos.  

## 📊 Uso dentro del proyecto

- Los CSV sirven como **fuente de datos** para poblar las tablas del Data Warehouse en PostgreSQL.  
- Se cargan con **Pandas** en Python y luego se insertan en la BD con **SQLAlchemy ORM**.  
- Permiten separar la **generación de datos** (scripts en `scripts/`) de la **persistencia de datos** (tablas en PostgreSQL).  

## ✅ Buenas prácticas

- Cada archivo CSV está en **formato plano y delimitado por comas**.  
- Se recomienda **no editar manualmente** estos archivos; en su lugar, volver a ejecutar los scripts de generación si se necesitan cambios.  
- Antes de cargar los datos en la BD, verificar:
  - Cantidad de registros esperada.  
  - Que los identificadores (DNI, teléfono, IDs) sean únicos.  