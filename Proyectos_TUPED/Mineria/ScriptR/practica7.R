#install.packages('arulesSequences')

library(arulesSequences)

#-----11111

#abro los datos ZAKI
data('zaki')
zaki
inspect(zaki)
summary(zaki)
length(zaki)

#B) Encuentre las secuencias frecuentes para los siguientes valores de
#SOPORTE MINIMO de 0,1, 0,25, 0,4 y 0,7.
#secuencias frecuentes = itemsets frecuentes

#0.1
seq1 <- cspade(zaki,
               parameter = list(support = 0.1),
               control = list(verbose = F))
seq1 #3917 secuencias
inspect(seq1[1:10])

#0.25
seq2 <- cspade(zaki,
               parameter = list(support = 0.25),
               control = list(verbose = F))

seq2 #3917 secuencias
inspect(seq2[1:10])

#0.4
seq3 <- cspade(zaki,
               parameter = list(support = 0.4),
               control = list(verbose = F))

seq3 #18 secuencias
inspect(seq3[1:10])

#0.7
seq4 <- cspade(zaki,
               parameter = list(support = 0.7),
               control = list(verbose = F))

seq4 #7 secuencias
inspect(seq4)

#C) Para las secuencias encontradas con un soporte mínimo de 0,4, indique:
#    ¿Cuáles son los ítems individuales más frecuentes?

inspect(sort(seq3)[1:10])

#    ¿Cuáles son los itemsets más frecuentes en los eventos?



#    El conjunto de secuencias encontrado ordenado por el valor de
# soporte.
as(sort(seq3, decreasing = T, by = 'support'), "data.frame")
summary(seq3)

#-----22222
rm(list = ls())
gc()

sequences <- read_baskets(con = "C:/Users/felip/OneDrive/Documentos/TUPED/3erAño/Mineria/Datos/sequences.txt",
                          info = c('sequenceID', 'eventID', 'SIZE'))

inspect(sequences[1:10])  
aux <- as(sequences, "data.frame")
aux
# ¿Cuántas transacciones y cuántos ítems contiene? 
summary(sequences) #7559 transacciones

#¿Cuáles son los ítems más frecuentes?
# most frequent items:
#   design       tools        blog   webdesign inspiration     (Other) 
# 469         301         233         229         220       23949 

# B) Extraiga patrones temporales con el objetivo de generar reglas que
# predigan etiquetas útiles para un usuario específico (para un soporte mínimo de 0,2%)

patrones <- cspade(sequences,
                   parameter = list(support = 0.002),
                   control = list(verbose = T))
inspect(patrones)

pat_ord <- sort(patrones, by = 'support', decreasing = T)[1:5]
inspect(pat_ord)


