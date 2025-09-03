library(dplyr)
library(datasets)
#Obtengo el dataset
data("Orange")
#exploro el dataset
str(Orange)
plot(circumference~age, Orange, pch = 16, col = rainbow(4))
boxplot(Orange$age, Orange$circumference)

#compruebo si tienen distribucion normal
shapiro.test(Orange$age)
shapiro.test(Orange$circumference)

qqnorm(Orange$circumference)
qqline(Orange$circumference)

qqnorm(Orange$age)
qqline(Orange$age)

var.test(Orange$age,Orange$circumference)
#correlacion de spearman porque es no parametrica, y una de mis variables no es normal
cor.test(Orange$age,Orange$circumference, method = "spearman")
