# Limpiamos la memoria
rm(list = ls())
gc()
# Cargamos las librerias que necesitamos
library("pdftools") # Para pdf_text()
library("stringr")  # Para str_split_fixed()


"Ejercicio 1"
# Cargamos los datos
datos <- pdf_text("https://bancos.salud.gob.ar/sites/default/files/2022-10/BEN_621_SE_39.pdf")
# La tabla de interés está en la página 11
hoja <- datos[11]
# Separamos por linea
lineas <- strsplit(hoja, "\n") # \n es nueva línea
# Nos quedamos con el primer elemento
lineas <- lineas[[1]]
#
ini <- grep("Región", lineas)[2] # Nos quedamos con la segunda posición que es la que
# queremos
fin <- grep("Región del Pacífico Occidental", lineas)
tabla <- lineas[ini:fin]
head(tabla)
# Eliminamos los espacios en blanco al inicio y final de las cadenas filas
tabla <- trimws(tabla)
# Verificamos
tabla
# Como los números aparece con la "." como divisor de miles, lo eliminamos
tabla <- str_remove_all(tabla,"\\.")
# Vamos a dividir las cadenas de las filas en 3 columnas y usamos como

# patrón en espacio " ", pero que aparezca 2 o más veces
tabla <- str_split_fixed(tabla, " {2,}", 3)
# Armamos un dataframe

# Desde la fila 2, porque la 1 es el encabezado de la tabla
tabla1 <- data.frame(matrix(tabla[2:nrow(tabla),],ncol=3))
# Le damos los nombres
colnames(tabla1) <- tabla[1,]
# Transformamos los datos
tabla1$Casos <- as.numeric(tabla1$Casos)
tabla1$Fallecidos <- as.numeric(tabla1$Fallecidos)
View(tabla1)
# Guardamos los datos
library("data.table")
fwrite(tabla1,"./MineriaDeDatos2024/viruela_OMS_sep_2022.csv", sep=";")

#----

"Ejercicio 2"
# Limpiamos la memoria
rm(list = ls())
gc()

datos <- pdf_text("/usbp_stats_fy2017_sector_profile.pdf")

# La tabla de interés está en la página 1
hoja <- datos[1]

# Separamos por linea
lineas <- strsplit(hoja, "\n") # \n es nueva línea

# Nos quedamos con el primer elemento
lineas <- lineas[[1]]

ini <- grep("Miami", lineas) # Nos quedamos con la segunda posición que es la que
# queremos
fin <- grep("Nationwide Total", lineas)

tabla <- lineas[ini:fin]

head(tabla)

# Eliminamos los espacios en blanco al inicio y final de las cadenas filas
tabla <- trimws(tabla)
# Verificamos
tabla
# Como los números aparecen con "." como divisor de miles, lo eliminamos
tabla <- str_remove_all(tabla,"\\.")

# Vamos a dividir las cadenas de las filas en 3 columnas y usamos como
# patrón en espacio " ", pero que aparezca 2 o más veces
tabla <- str_split_fixed(tabla, " {2,}", 10)

col_names = c('SECTOR','Agent Staffing*','Apprehensions', 'Other Than Mexican Apprehensions', 'Marijuana', 'Cocaine', 'Accepted Prosecutions', 'Assaults', 'Rescues','Deaths')

colnames(tabla) <- col_names

#----
"Ejercicio 3"


rm(list = ls())
gc()

datos <- pdf_text("C:/Users/alumno/Documents/MineriaDeDatos2024/rep_covid-19_er_01_06_2022.pdf")

"Departamento de Residencia"
hoja <- datos[4]

# Separamos por linea
lineas <- strsplit(hoja, "\n") # \n es nueva línea

# Nos quedamos con el primer elemento
lineas <- lineas[[1]]
#
ini <- grep("Colón", lineas)

fin <- grep("Total", lineas)[2]

tabla <- lineas[ini:fin]
head(tabla)

# Eliminamos los espacios en blanco al inicio y final de las cadenas filas
tabla <- trimws(tabla)
# Verificamos
tabla
# Como los números aparece con la "." como divisor de miles, lo eliminamos
tabla <- str_remove_all(tabla,"\\.")

# Vamos a dividir las cadenas de las filas en 5 columnas y usamos como
tabla <- str_split_fixed(tabla, " {2,}", 5)
#borro las filas con NA
tabla <- tabla[!apply(tabla == "", 1, all),]

col_residentes <- c('Deptos', 'Confirmados: total acum', 'Confirmados: ult 14 días', 'Fallecidos: Total acum', 'Fallecidos: ult 14 días')
colnames(tabla) <- col_residentes
# Transformamos los datos
tabla1$Casos <- as.numeric(tabla1$Casos)
tabla1$Fallecidos <- as.numeric(tabla1$Fallecidos)
View(tabla1)
# Guardamos los datos
library("data.table")
fwrite(tabla1,"./MineriaDeDatos2024/viruela_OMS_sep_2022.csv", sep=";")


"Localidad de Residencia"

rm(list = ls())
gc()

datos <- pdf_text("C:/Users/alumno/Documents/MineriaDeDatos2024/rep_covid-19_er_01_06_2022.pdf")

hojaL <- datos[5]
lineas <- strsplit(hojaL, "\n") # \n es nueva línea



