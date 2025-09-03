library(arules)
library(dplyr)
library(data.table)

rm( list=ls() )
gc()

datos = read.transactions("C:/Users/felip/OneDrive/Documentos/TUPED/3erAño/Mineria/Datos/groceries.csv",
                        sep = ",", format = "basket", header = FALSE, cols = NULL)
class(datos)
summary(datos)
str(datos)

#a) Explore los datos. ¿En qué forma están representados los datos?
# ¿Cuántas transacciones y cuántos ítems contienen los datos?

head(datos) #6 trans y 169 items
inspect(datos) #total: 9835 transacciones

#b) Con el resultado de la función itemFrequency puede encontrar el
#soporte de cada elemento en el conjunto de datos. Utilice un criterio
#estadístico adecuado (la mediana en este caso) para definir el soporte mínimo 
#y encuentre los 5 itemsets frecuentes de mayor soporte.

items_freq <-itemFrequency(datos)

#grafico la distribucion con un boxplot
boxplot(items_freq)
# como tiene outliers uso el valor central como soporte
soporte <- median(items_freq)

# ahora busco los itemsets frecuentes usandO ECLAT
itemsets_freq <- eclat(datos,
                       parameter = list(support = soporte,
                                        target = 'frequent itemsets'),
                       control = list(verbose = F))


# Vemos los 5 itemsets frecuentes de mayor soporte
itemsets <- sort(itemsets_freq, by = "support", decreasing = TRUE)
inspect(itemsets[1:5])
# items              support   count
# [1] {whole milk}       0.2555160 2513 
# [2] {other vegetables} 0.1934926 1903 
# [3] {rolls/buns}       0.1839349 1809 
# [4] {soda}             0.1743772 1715 
# [5] {yogurt}           0.1395018 1372


#c) Obtenga las reglas de asociación para todas las transacciones del
#supermercado para una confianza mínima de 0,5 y de 0,25. ¿Cuántas
#reglas encuentra en cada caso? ¿Qué puede decir de las reglas
#obtenidas para el caso de menor confianza?

conf05 <- 0.5

reglas05 <- apriori(datos,
                    parameter = list(support = soporte,
                                     confidence = conf05,
                                     target = "rules"),
                    control = list(verbose = F))
reglas05 

conf025 <- 0.25

reglas025 <- apriori(datos,
                    parameter = list(support = soporte,
                                     confidence = conf025,
                                     target = "rules"),
                    control = list(verbose = F))

reglas025

# Ordenamos las reglas por confianza y las mostramos
inspect(sort(reglas05, decreasing = TRUE, by = "confidence"))

# Ordenamos las reglas por confianza y las mostramos
inspect(sort(reglas025, decreasing = TRUE, by = "confidence"))

#d) Para las reglas obtenidas con una confianza de 0,25, obtenga:
#- las reglas que tienen un lift mayor a 2;
#- las reglas que contienen el elemento “other vegetables” en el consecuente con un lift mayor a 2;
#- las reglas que contienen solamente “other vegetables" y "yogurt” en el antecedente y un lift mayor a 2; y
#- las reglas que contienen “other vegetables" o "yogurt” en el consecuente y un lift mayor a 2.

#veo reglas ordenadas por lift:
inspect(sort(reglas025, decreasing=TRUE, by= "lift"))

#- las reglas que tienen un lift mayor a 2;
reglas025.lift <- subset(reglas025, subset = lift > 2)
reglas025.lift #set of 49 rules

#veo ordenadas por lift:
inspect(sort(reglas025.lift, decreasing=TRUE, by= "lift"))

#- las reglas que contienen el elemento “other vegetables” en el consecuente con un lift mayor a 2;
reglas025.veglift <- subset(reglas025, subset=rhs%in%c("other vegetables") & lift>2)

reglas025.veglift

#veo ordenadas por lift:
inspect(sort(reglas025.veglift, decreasing=TRUE, by= "lift"))

#- las reglas que contienen solamente “other vegetables" y "yogurt” en el antecedente y un lift mayor a 2;
reglas025.veg_yog_lift <- subset(reglas025.lift, subset=lhs%oin%c("other vegetables", "yogurt") & lift>2)

reglas025.veg_yog_lift # set of 3 rules 

#veo ordenadas por lift:
inspect(sort(reglas025.veg_yog_lift, decreasing=TRUE, by= "lift"))

#- las reglas que contienen “other vegetables" o "yogurt” en el consecuente y un lift mayor a 2.
reglas025.veg_o_yog_lift <- subset(reglas025.lift, subset=rhs%oin%c("other vegetables", "yogurt") & lift>2)

reglas025.veg_o_yog_lift #set of 28 rules
#veo ordenadas por lift:
inspect(sort(reglas025.veg_o_yog_lift, decreasing=TRUE, by= "lift"))


#----22222222

rm( list=ls() )
gc()

datos_ord = read.transactions("C:/Users/felip/OneDrive/Documentos/TUPED/3erAño/Mineria/Datos/orders.csv",
                              header = TRUE, 
                              sep = ";", 
                              format = "single", 
                              cols = c("order_id", "product_name"))

#A
#Los itemsets frecuentes con el algoritmo Eclat, para un soporte mínimo
#de 0.1% y una longitud mínima de 3 ítems

itemsets0.1 = eclat(datos_ord, parameter = list(supp = 0.001, minlen = 3))
itemsets0.1

#b) Encuentre las reglas de asociación para una confianza mínima del 70%,
#con los itemsets frecuentes obtenidos anteriormente y ordenelas por lift.

## Create rules from the frequent itemsets
rules <- ruleInduction(itemsets0.1, datos_ord, confidence = 0.7)
rules #set of 7 rules

#veo ordenadas por lift:
inspect(sort(rules, decreasing=TRUE, by= "lift"))

#c) Compare las reglas obtenidas con el algoritmo Eclat, con las obtenidas
#para los mismos valores de soporte y confianza con el algoritmo Apriori

reglas_apriori <- apriori(datos_ord,
                          parameter = list(support = 0.001,
                                           confidence = 0.7,
                                           target = "rules",
                                           minlen = 3),
                          control = list(verbose = F))

reglas_apriori #set of 7 rules

# Ordenamos las reglas por confianza y las mostramos
inspect(sort(reglas_apriori, decreasing = TRUE, by = "confidence"))

#d) Compare las métricas comentadas en la teoría (coverage, test exacto de Fisher y lift) 
#para los dos conjuntos de reglas encontrados en el punto anterior

interestMeasure(rules, measure = c("lift", "coverage", "fishersExactTest"))
interestMeasure(reglas_apriori, measure = c("lift", "coverage", "fishersExactTest"))




