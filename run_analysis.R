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
#falta juntar X com y para completar o step 1 (a ser completado no passo 4.

######################################################

#
#
#step 2 - Extracts only the measurements on the mean and standard deviation for each measurement
#
#

features <- read.table("features.txt")

#mas depois decidi usar "grep" com regex
#mas, lendo novamente o passo 2, eu entendo que as unicas medidas que tem mean E std são as seguintes:
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
# t - <vazio> ok
# f - Frequency (depois) ok 
# Body - body ok
# BodyBody - body ok
# Gravity - gravity ok
# Acc - Acceleration ok
# Gyro - AngularVelocity
# Jerk - Jerk ok
# Mag - Magnitude
# -mean() - Mean
# -std() - StandardDeviation
# -X - ForXaxis
# -Y - ForYaxis
# -Z - ForZaxis
#
# colocar primeira minuscula

#traduzindo os nomes para mais descritivos
desiredFeatures <- desiredFeatures %>% mutate(descriptiveName=V2) %>% mutate(descriptiveName=gsub("(Body)+","body",descriptiveName)) %>% mutate(descriptiveName=gsub("Gravity","gravity",descriptiveName)) %>% mutate(descriptiveName=gsub("^t","",descriptiveName)) %>% mutate(descriptiveName=gsub("^f(\\w+)Mag","\\1FrequencyMag",descriptiveName)) %>% mutate(descriptiveName=gsub("^f(\\w+)-","\\1Frequency-",descriptiveName)) %>% mutate(descriptiveName=gsub("bodyAccJerkMag","JerkBodyAccelerationMagnitude",descriptiveName)) %>% mutate(descriptiveName=gsub("bodyAccJerk","JerkBodyAcceleration",descriptiveName)) %>% mutate(descriptiveName=gsub("bodyGyroJerkMag","JerkBodyAngularVelocityMagnitude",descriptiveName)) %>% mutate(descriptiveName=gsub("bodyGyroJerk","JerkBodyAngularVelocity",descriptiveName)) %>% mutate(descriptiveName=gsub("Acc([A-Z]|-)","Acceleration\\1",descriptiveName)) %>% mutate(descriptiveName=gsub("Gyro","AngularVelocity",descriptiveName)) %>% mutate(descriptiveName=gsub("Mag","Magnitude",descriptiveName)) %>% mutate(descriptiveName=gsub("-mean\\(\\)","Mean",descriptiveName)) %>% mutate(descriptiveName=gsub("-std\\(\\)","StandardDeviation",descriptiveName)) %>% mutate(descriptiveName=gsub("-([X|Y|Z])","For\\1Axis",descriptiveName)) 

#discussão: https://class.coursera.org/getdata-010/forum/thread?thread_id=233

#dúvida: posso deixar sem espaços (camel coding)
#renomear variaveis
names(X_extracted) <- desiredFeatures$descriptiveName

#falta juntar X com y para completar o step 1
tidyData <- X_extracted
tidyData$activityLabel <- y$activityLabel



######################################################

#
#
#step 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. (usar o summary talvez?)
#
#

#primeiro: agrupar as linhas pela atividade
#segundo: agrupar por sujeito (cade ele?)
#terceiro: tirar as medias das colunas

#antes de tudo, vou ter de juntar a identificação da galera que fez os testes.
subjectsTrain <- read.table("train/subject_train.txt")
subjectsTest <- read.table("test/subject_test.txt")
subjects <- rbind(subjectsTrain,subjectsTest)
tidyData$subject <- subjects$V1

#agora vamos agrupar
groupedTidyData <- group_by(tidyData, activityLabel, subject)


#fazer o summary
#summarize(groupedTidyData, a = mean(bodyAccelerationFrequencyMeanForXAxis))

#falta incluir todas as colunas
tidyData2 <- summarise_each(groupedTidyData, funs(mean)) #post do cara que deu essa dica: https://class.coursera.org/getdata-010/forum/thread?thread_id=263
 #que veio dessa resposta no stackoverflow: http://stackoverflow.com/questions/21644848/summarizing-multiple-columns-with-dplyr

#outro jeito:
#meltedTidyData <- melt(tidyData, id=c("activityLabel","subject"))
#dcast(meltedTidyData, activityLabel + subject ~ variable, mean)

#das duas maneiras, todas as colunas são incluidas, mas sempre repete a atividade. Seria legal uma tabela tridimensional eu acho
#xtabs e ftable parecem ser boas alternativas, mas eu não consegui fazer funcionar ainda.

#abind cria um array tridimensional, mas inclui a coluna de atividades
#library(abind)
#abind(split(a,a$activityLabel), along = 3)

#ainda não tenho certeza, mas acho que, pelo post que eu li do TA, está ok deixar assim
#ref: https://class.coursera.org/getdata-010/forum/thread?thread_id=241
#inclusive o cubo, ele disse que estava "clearly untidy", não sei porque. Talvez porque profundidade não é uma coluna e a tidydata diz que cada variavel deve estar em uma coluna:
# http://jtleek.com/modules/03_GettingData/01_03_componentsOfTidyData/#4
#The tidy data
#
#    Each variable you measure should be in one column
#    Each different observation of that variable should be in a different row
#    There should be one table for each "kind" of variable
#    If you have multiple tables, they should include a column in the table that allows them to be linked
#
#Some other important tips
#
#    Include a row at the top of each file with variable names.
#    Make variable names human readable AgeAtDiagnosis instead of AgeDx
#    In general data should be saved in one file per table.
#
#https://github.com/jtleek/datasharing

#dito isso, precisamos agora exportar o dataset
#falta exportar o dataset

#salvar o artigo sobre tidy data.
#salvei segundo as instruções do assignment [https://class.coursera.org/getdata-010/human_grading/view/courses/973497/assessments/3/submissions]
write.table(tidyData2,"tidyData2.txt", row.names = FALSE)
#explicar aos revisores como carregar a tabela.
