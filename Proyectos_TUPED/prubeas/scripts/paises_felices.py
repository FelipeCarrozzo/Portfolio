import pandas as pd

# import statsmodels.api as sn 

archi = pd.read_csv("C:/Users/usr/Documents/TUPED/prubeas/datasets/world-happiness-2016.csv")
variables = archi.columns()
print(variables)
#variable independiente (X)
x = archi[['PIB per cápita', 'Esperanza de vida', 'Apoyo social', 'Generosidad', 'Libertad para tomar decisiones de vida', 'Corrupción percibida', 'Distribución de la felicidad']]