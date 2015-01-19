#
#
#step 1 - Merges the training and the test sets to create one data set.
#
#


#justificar os passos e porque no final estão tidy data.(https://class.coursera.org/getdata-010/forum/thread?thread_id=49#post-185)
#definir um diretorio base (no momento está dentro da pasta extraída do zip baixado: "UCI HAR Dataset")
#justificar porque eu escolhi esses arquivos
X_train <- read.table("./train/X_train.txt")
names(X_train) <- 1:length(X_train)
y_train <- read.table("./train/y_train.txt")
X_test <- read.table("./test/X_test.txt")
names(X_test) <- 1:length(X_test)
y_test <- read.table("./test/y_test.txt")
X <- rbind(X_train, X_test)
y <- rbind(y_train, y_test)


######################################################

#
#
#step 2 - Extracts only the measurements on the mean and standard deviation for each measurement
#
#

features <- read.table("features.txt")

#mas depois decidi usar "grep" com regex
#usei a seguinte regex no inicio: desiredFeatureIndices <- grep("[M|m]ean|std",features$V2) - totalizando 86
#mas, lendo novamente o passo 2, eu entendo que as unicas medidas que tem mean E std são as seguintes:
#desiredFeatureIndices <- grep("-(mean|std)",features$V2) #totalizando 79
#mas o meu argumento falha, porque o numero é impar´
#é por causa dos "meanFreq"
#eu interpreto que meanFreq não faz parte
desiredFeatureIndices <- grep("-(mean|std)\\(\\)",features$V2) #pode ser assim de acordo com o cara do post

X_extracted <- X[,desiredFeatureIndices]



######################################################

#
#
#step 3 - Uses descriptive activity names to name the activities in the data set
#
#

#mudar primeiro o Y
activityLabels <- read.table("activity_labels.txt")
#observando os nomes das atividades que eles mesmos fornecem, eu decidi apenas substituir o '_' pelo ' '.
activityLabels$V2 <- sub("_"," ",activityLabels$V2)
library(dplyr)
y <- mutate(y, activityLabel = activityLabels$V2[V1])

#TODO tornar factor variable






######################################################

#
#
#step 4 - Appropriately labels the data set with descriptive variable names.
#
#
#arrumar um jeito de explicar o que é "descriptive name", i.e. nome por extenso ao inves de abreviado.
desiredFeatures <- features[desiredFeatureIndices,]

#substituições:
#
# t - Time (melhorar) ok
# f - Frequency (melhorar) ok 
# Body - Body ok
# BodyBody - Body ok
# Gravity - Gravity ok
# Acc - Acceleration ok
# Gyro - AngularVelocity
# Jerk - JerkSignal
# Mag - Magnitude
# -mean() - Mean
# -std() - StandardDeviation
# -X - ForXaxis
# -Y - ForYaxis
# -Z - ForZaxis
#
# colocar primeira minuscula

#traduzindo os nomes para mais descritivos
desiredFeatures <- desiredFeatures %>% mutate(descriptiveName=V2) %>% mutate(descriptiveName=gsub("BodyBody","Body",descriptiveName))%>% mutate(descriptiveName=gsub("^t","time",descriptiveName)) %>% mutate(descriptiveName=gsub("^f","frequency",descriptiveName)) %>% mutate(descriptiveName=gsub("Acc","Acceleration",descriptiveName)) %>% mutate(descriptiveName=gsub("Gyro","AngularVelocity",descriptiveName)) %>% mutate(descriptiveName=gsub("Jerk","JerkSignal",descriptiveName)) %>% mutate(descriptiveName=gsub("Mag","Magnitude",descriptiveName)) %>% mutate(descriptiveName=gsub("-mean\\(\\)","Mean",descriptiveName)) %>% mutate(descriptiveName=gsub("-std\\(\\)","StandardDeviation",descriptiveName)) %>% mutate(descriptiveName=gsub("-X","ForXaxis",descriptiveName)) %>% mutate(descriptiveName=gsub("-Y","ForYaxis",descriptiveName)) %>% mutate(descriptiveName=gsub("-Z","ForZaxis",descriptiveName)) 

#renomear variaveis
names(X_extracted) <- desiredFeatures$descriptiveName

#falta juntar X com y para completar o step 1
tidyData <- X_extracted
tidyData$activityLabel <- y$activityLabel
