
# Ubicamos desde donde se ejecuta el Programa
path <- getwd()
path

#Se descarga el archivo y se descomprime en una carpeta llamada "Proyecto"
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, file.path(path, "Files.zip"))
unzip(zipfile = "Files.zip", , exdir = "./Proyecto")


# Se crean variables para los datos de entrenamiento
x_entrenamiento <- read.table("./Proyecto/UCI HAR Dataset/train/X_train.txt")
y_entrenamiento <- read.table("./Proyecto/UCI HAR Dataset/train/y_entrenamiento.txt")
sujeto_entrenamiento <- read.table("./Proyecto/UCI HAR Dataset/train/sujeto_entrenamiento.txt")


# Se crean variables para los datos de prueba
x_prueba <- read.table("./Proyecto/UCI HAR Dataset/test/X_test.txt")
y_prueba <- read.table("./Proyecto/UCI HAR Dataset/test/y_prueba.txt")
sujeto_prueba <- read.table("./Proyecto/UCI HAR Dataset/test/sujeto_prueba.txt")

# Se crean variables para el vector de caracterisicas
caracteristicas <- read.table("./Proyecto/UCI HAR Dataset/caracteristicas.txt")
colnames(caracteristicas)
nombres<-caracteristicas[,2]
      
# Se crean variables para las etiquetas de las actividades
activityLabels = read.table("./Proyecto/UCI HAR Dataset/activity_labels.txt")

# Se asignan los nombres de las columnas a las variables
colnames(x_entrenamiento)
colnames(x_entrenamiento) <- nombres
colnames(y_entrenamiento)
colnames(y_entrenamiento) <- "activityID"
colnames(sujeto_entrenamiento) <- "subjectID"
colnames(x_prueba) <- caracteristicas[,2]
colnames(y_prueba) <- "activityID"
colnames(sujeto_prueba) <- "subjectID"
colnames(activityLabels) <- c("activityID", "activityType")

# Comparacion de todos los datos de entrenamiento
Todo_entrenamiento <- cbind(y_entrenamiento, sujeto_entrenamiento, x_entrenamiento)
dim(Todo_entrenamiento)
colnames(Todo_entrenamiento)
rownames(Todo_entrenamiento)

# Comparacion de todos los datos de prueba
Todo_prueba <- cbind(y_prueba, sujeto_prueba, x_prueba)
dim(Todo_prueba)
colnames(Todo_prueba)
rownames(Todo_prueba)

# Creamos un solo arreglo con todos los datos de entrenamiento y de prueba
Conjunto_final <- rbind(Todo_entrenamiento, Todo_prueba)
dim(Conjunto_final)
colnames(Conjunto_final)
rownames(Conjunto_final)

# Extraer solo las medidas en la media y sd para cada medida

# Se asignan los nombre de las columnas a una variable
colNames <- colnames(Conjunto_final)

# Se crear un vector para definir ID, media y sd
mean_y_std <- (grepl("activityID", colNames) | grepl("subjectID", colNames) |
                 grepl("mean..", colNames) | grepl("std...", colNames))

# Tomando solo los que tienen "activityID", "subjectID", "mean..", "std..." (TRUE). 
Conjunto_Mean_Std <- Conjunto_final[ , mean_y_std == TRUE] 
dim(Conjunto_Mean_Std)
colnames(Conjunto_Mean_Std) 
 
# Se une "Conjunto_Mean_Std" y "activityLabels" por "activityID"
Final <- merge(Conjunto_Mean_Std, activityLabels,by = "activityID", all.x = TRUE)
colnames(Final)

library(reshape2)

# Se seleccionan Los elementos que concuerdan
average_columns<-colnames(Final[,3:68])

#Organizamos los datos con "melt"
Final_Arreglado<- melt(data,id=c("subjectID","activityID"),measure.vars=average_columns)

# Se prepara el archivo final
Final_Ordenado <- dcast(Final_Arreglado, subjectID + activityID ~ variable, mean)

# Escritura Final del Archivo
write.table(Final_Ordenado, "FinalOrdenado.txt", row.names = FALSE)

