# gettingandcleaningdata
The repository for the Coursera's Getting and Cleaning Data Course Project [https://class.coursera.org/getdata-010]

This repo includes the file "run_analysis.R", for creating a tidy data set from Samsung phone data.


The script is run on the dataset provided by this article

#justificar porque eu escolhi esses arquivos

It binds training and test sets, takes only the mean and standard deviation variables, that is columns ....

The activity names used were almost the same as in the activity_labels.txt file, except for the substitution of the underscore '_' for a white space ' '.


In the script, I took the feature names from file features.txt and selected just the ones chosen. Then I changed the names in a series of substitutions, using camel coding:


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


summarized using summarise_each(groupedTidyData, funs(mean)) #post do cara que deu essa dica: https://class.coursera.org/getdata-010/forum/thread?thread_id=263
 #que veio dessa resposta no stackoverflow: http://stackoverflow.com/questions/21644848/summarizing-multiple-columns-with-dplyr


The tidy data set with summarized data has been written to the file using write.table command, with row.names parameter set to FALSE.#salvei segundo as instruções do assignment [https://class.coursera.org/getdata-010/human_grading/view/courses/973497/assessments/3/submissions]

It can be loaded using the command: 
data <- read.table(file_path, header = TRUE) #if they used some other way of saving the file than a default write.table, this step will be different
    View(data)
#code taken from https://class.coursera.org/getdata-010/forum/thread?thread_id=49#post-185]:	

Why is the resulting data set tidy?

#justificar os passos e porque no final estão tidy data.(https://class.coursera.org/getdata-010/forum/thread?thread_id=49#post-185)
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


Where to run the script?
The script assumes the working directory is the "UCI HAR Dataset" when we extract the zip from the article files.
