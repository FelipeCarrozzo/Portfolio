library(readxl)
library(dplyr)
#Encuentre si existe una relación lineal entre las variables “age” y “balance”.
plot(balance~age, bank, col = "red")
str(bank)

hist(bank$age)
hist(bank$balance)

shapiro.test(bank$age)
shapiro.test(bank$balance)
 
#test de correlación
cor.test(bank$age, bank$balance, method =  "spearman")
