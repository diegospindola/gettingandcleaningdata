# Getting and Cleaning Data Course Project Repository
The repository for the Coursera's Getting and Cleaning Data Course Project [[1]][1]

The project requests to make a tidy data set out of the data from the work by Anguita et al. [[2]][2]. This work collected measurements from accelerometer and gyroscope from Samsung smartphones tied to 30 subjets performing 6 types of activities.

This repo includes three files:  

* __"run_analysis.R"__ - R script for creating a tidy data set from Anguita et al. data.  
* __"README.md"__ - file that describes the repository.  
* __"CodeBook.md"__ - file that describes the variables in the tidy data set.  

Additional R library required to run the script:  

* __dplyr__  

#What does the script do?

The script is run on the data [[3]][3] provided by the work by Anguita et al. This zip file should be decompressed and the R working directory set to the folder "UCI HAR Dataset" inside of it.

The script binds training and test data sets (contained in the files "X_train.txt", "y_train.txt", "subject_train.txt", "X_test.txt", "y_test.txt" and "subject_test.txt"), taking only the mean and standard deviation variables, corresponding to the features whose names end either in __"-mean()"__ or __"-std()"__.

The activity names used were almost the same as those included in the "activity_labels.txt" file, except for the substitution of the underscore '_' for a white space ' '.

The script takes the previously selected feature names from file "features.txt" and then changes the names in a series of substitutions, in order to make them more descriptive.

The substitutions are the following:

* __"t"__ - [empty string]
* __"f"__ - Frequency (changing the word position)
* __"Body"__ - body
* __"BodyBody"__ - body
* __"Gravity"__ - gravity
* __"Acc"__ - Acceleration
* __"Gyro"__ - AngularVelocity
* __"Jerk"__ - Jerk (changing the word position)
* __"Mag"__ - Magnitude
* __"-mean()"__ - Mean
* __"-std()"__ - StandardDeviation
* __"-X"__ - ForXAxis
* __"-Y"__ - ForYAxis
* __"-Z"__ - ForZAxis

Then the data is summarized using `summarise_each` function [[4]][4][, [5]][5]. This way, we end up with a table with 180 rows (representing 30 subjects performing 6 activities each) and 68 columns (2 for activity label and subject identification, and 66 for the AVERAGE of measurements selected for the corresponding subject performing the corresponding activity).

After that, tidy data set with summarized data has been written to the file using `write.table` command, with row.names parameter set to FALSE, following the instructions in the course project description.

This data set file can be loaded using the command [[6]][6]: 
```
data <- read.table("tidyData2.txt", header = TRUE)
View(data)
```

#Why is the resulting data set tidy?

According to the "Components of tidy data" course lecture notes [[7]][7], there are some tips or guidelines to achieve the tidy data that we can pick to point out that this last table is tidy data:

* _"Each variable you measure should be in one column"_ - that is the case in our data: we have 68 columns, each one with a single variable.
* _"Each different observation of that variable should be in a different row"_ - in our data set, every combination (Subject,Activity) is in a single row.
* _"Include a row at the top of each file with variable names."_ - the names of the columns are included in the first line of the file
* _"Make variable names human readable AgeAtDiagnosis instead of AgeDx"_ - the names of the variables are human readable, e.g. "bodyAccelerationMeanForXAxis"
* _"In general data should be saved in one file per table."_ - we save the table in the one file named "tidyData2.txt"


#References

[1]: https://class.coursera.org/getdata-010 "Getting and Cleaning Data by Jeff Leek, PhD, Roger D. Peng, PhD, Brian Caffo, PhD (accessed in January 23th, 2015)"

[2]: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones "Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012 (accessed in January 23th, 2015)"

[3]: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "Zip file including the data from the work by Anguita et al. (accessed in January 23th, 2015)"

[4]: https://class.coursera.org/getdata-010/forum/thread?thread_id=263 "Tip taken from a course discussion forum post (accessed in January 23th, 2015)"

[5]: http://stackoverflow.com/questions/21644848/summarizing-multiple-columns-with-dplyr "Tip taken from a Stackoverflow answer (accessed in January 23th, 2015)"

[6]: https://class.coursera.org/getdata-010/forum/thread?thread_id=49#post-185 "Tip taken from a David Hood's course discussion forum post (accessed in January 23th, 2015)"

[7]: http://jtleek.com/modules/03_GettingData/01_03_componentsOfTidyData/#4 "Components of Tidy Data course lecture note, page 4 (accessed in January 23th, 2015)"

[[1]][1] Getting and Cleaning Data by Jeff Leek, PhD, Roger D. Peng, PhD, Brian Caffo, PhD (accessed in January 23th, 2015, through the URL: https://class.coursera.org/getdata-010)

[[2]][2] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012 (accessed in January 23th, 2015, through the URL: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

[[3]][3] Zip file including the data from the work by Anguita et al. (accessed in January 23th, 2015, through the URL: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

[[4]][4] Tip taken from a course discussion forum post (accessed in January 23th, 2015, through the URL: https://class.coursera.org/getdata-010/forum/thread?thread_id=263), 

[[5]][5] Tip take from a Stackoverflow answer (accessed in January 23th, 2015, through the URL:http://stackoverflow.com/questions/21644848/summarizing-multiple-columns-with-dplyr)

[[6]][6] Tip taken from a David Hood's course discussion forum post (accessed in January 23th, 2015, through the URL: https://class.coursera.org/getdata-010/forum/thread?thread_id=49#post-185)

[[7]][7] Components of Tidy Data course lecture note, page 4 (accessed in January 23th, 2015, through the URL: http://jtleek.com/modules/03_GettingData/01_03_componentsOfTidyData/#4)
