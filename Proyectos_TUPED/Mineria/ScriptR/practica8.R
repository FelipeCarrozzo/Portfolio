rm(list = ls())
gc()
library(data.table)
library(dplyr)
library(arulesSequences)
library(readxl)
library(ggplot2)

datos <- read_excel("C:/Users/felip/OneDrive/Documentos/TUPED/3erAño/Mineria/Datos/Assignment-1_Data.xlsx")
colnames(datos)
summary(datos)

datos <- na.omit(datos)

# a) Explore los datos y presente sus características principales.
# Acomodamos los datos, agrupando por cliente y ordenando para cada cliente por fecha
# Pasamos a tipo de dato fecha la fecha de compra
datos$Date <- as.Date(datos$Date, "%m/%d/%y")
summary(datos)
# b) Utilizando las gráficas que considere adecuadas, muestre: compras por
# cliente, compras por país e ítems por compra.

# Compras por cliente
ggplot(datos, aes(x = CustomerID)) +
  geom_bar() +
  labs(title = "Compras por cliente") +
  ylim(limits = c(0, 1500))

# Compras por país
ggplot(datos, aes(x = Country)) +
  geom_bar() +
  labs(title = "Compras por país") +
  ylim(limits = c(0, 1500)) +
  #en el eje X, los países que superen el 100
  coord_flip()

#items por compra
ggplot(datos, aes(x = BillNo)) +
  geom_bar() +
  labs(title = "Items por compra") +
  ylim(limits = c(0, 1500))

# c) Encuentre el número de transacciones e ítems.
#TRANSACCIONES
#convertir TODAS las columnas a factor
datos <- mutate_all(datos, as.factor)
transacciones <- as(datos, "transactions")

#Encontrar cantidad de transacciones
inspect(transacciones)
#Hay 18163 transacciones y 3846 items (nose)
#ITEMS
#Encontrar cantidad de items
length(itemLabels(transacciones))
#hay 27376 items

# d) Encuentre un conjunto de secuencias frecuentes para un soporte
# mínimo de 2%
secuencias <- cspade(transacciones, 
                     parameter = list(support = 0.002), 
                     control = list(verbose = FALSE))


df2 <- datos %>% 
  group_by(CustomerID, BillNo) %>% 
  arrange(Date) %>%
  # Eliminamos los eventos donde aparecen productos repetidos
  distinct(CustomerID, Itemname, .keep_all = TRUE) %>%
  summarise(Items = list(Itemname)) %>%
  # Creamos un ItemID dentro de cada CustomerID
  mutate(ItemID = row_number()) %>% 
  select(CustomerID, BillNo, ItemID, Items) %>% 
  ungroup()
# Ordenamos por CustomerID
df2 <- df2[order(df2$CustomerID),]

# Obtenemos las transacciones
transacciones <- as(df2$Items, "transactions")
transacciones # Hay 18163 transacciones y 3846 items
# Le agregamos sequenceID y eventID
transactionInfo(transacciones) <- data.frame(sequenceID = df2$CustomerID,
                                             eventID = df2$ItemID)

# d) Encuentre un conjunto de secuencias frecuentes para un soporte

# mínimo de 2%.
seqset <- cspade(transacciones, 
                     parameter = list(support = 0.02), 
                     control = list(verbose = FALSE))

seqset <- sort(secuencias, by = "support", decreasing = T)
# 
inspect(seqset[1:10])
# e) Encuentre las secuencias más frecuentes que tienen 2 o más elementos y un soporte mayor a 3%.
subset(seqset, subset = size(x) > 2 &
         support > 0.03)


