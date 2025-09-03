#Liberamos la memoria
rm(list = ls())
gc()
library("data.table")
library("dplyr")
library("arulesSequences")
datos <- fread("C:/Users/felip/OneDrive/Documentos/TUPED/3erAño/Mineria/Datos/input_data2024.csv")
#datos <- input_data2024
colnames(datos)
summary(datos)
# Preprocesamiento
# Acomodamos los datos, agrupando por cliente y ordenando para cada cliente por fecha
# Pasamos a tipo de dato fecha la fecha de compra
datos$purchase.date <- as.Date.character(datos$purchase.date, "%m/%d/%y")

datos2 <- datos %>% 
  group_by(customer.identifier) %>% 
  arrange(purchase.date) %>% 
  #Eliminamos los registros donde aparece repetidamente el mismo producto 
  #(en eventos consecutivos) Si no, nos quedaríamos con patrones como: A -> A -> A, etc
  # Y no es intreresante
  distinct(customer.identifier, product, .keep_all = TRUE) %>%
  # Creamos un ID de item para cada ID de cliente
  mutate(item_id = row_number()) %>% 
  # Seleccionamos las columnas y desagrupamos
  select(customer.identifier, purchase.date, item_id, product) %>% 
  ungroup() %>% 
  # Convertimos a factor el ID de cliente y el producto
  mutate(across(.cols = c("customer.identifier", "product"), .f = as.factor))

datos2 <- datos2 %>% arrange(customer.identifier) # ordenamos por cliente

#----
# # Si tuvieramos el caso de clientes que compraran más de un producto en el mismo momento
# datos3 <- datos2
# # Creamos un ID unico para cada par cliente-fecha
# datos3$unico <- paste0(as.character(datos2$customer.identifier)," ",
#                       as.character(datos2$purchase.date))
# datos3 <- datos3 %>%
#   # Necesitamos unir estos productos en formato basket: (A,B)
#   group_by(unico) %>%
#   summarise(product = paste(product, collapse = ","))
# # Restablecemos el ID de cliente que perdimos en el paso anterior
# datos3$customer.identifier <- word(datos3$unico, 1)
# # Restablecemos la fecha
# datos3$purchase.date <- word(datos3$unico, 2)
#----
library("stringr")
# Generamos un objeto de tipo transactions
# Los productos comprados son los items
transacciones <-  as(datos2 %>% transmute(items = product), "transactions")
# Le cambiamos los nombres a las variables, agregandolas al objeto transactions
# para que lo entienda el algorito cSPADE
transactionInfo(transacciones)$sequenceID <- datos2$customer.identifier
transactionInfo(transacciones)$eventID <- datos2$item_id
# Acomodamos los nombres de los items
itemLabels(transacciones) <- str_replace_all(itemLabels(transacciones), "items=", "")
# Vemos las transacciones
inspect(head(transacciones,10))
# Encontramos las secuencias frecuentes
# Con un soporte de 0.002: sólo quiero ver las secuencias que se produjeron en al menos 
# el 0,2% de todos los clientes. Aumentando el soporte, restringimos el n° de secuencias 
# de salida
secuencias <- cspade(transacciones, 
                     parameter = list(support = 0.002), 
                     control = list(verbose = FALSE))
# Ordenamos por soporte
secuencias <- sort(secuencias, by = "support", decreasing = T)
# 
inspect(secuencias[1:10])
# Pasamos a dataframe para guardar
secuencias.df <- secuencias
secuencias.df <- as(secuencias.df, "data.frame")
# Agregamos el tamaño de cada secuecnia
secuencias.df$SIZE <- (str_count(secuencias.df$sequence, ",") + 1)
# Guardamos las salidas
write.csv(x=secuencias.df, file="secuenciasEjemplo.csv", row.names=FALSE)







