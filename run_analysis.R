# Downloading the file from the URL

if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="libcurl")


## Unzip the file

unzip(zipfile="./data/Dataset.zip",exdir="./data")

## List of files in the dataset
path_sa <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_sa, recursive=TRUE)
files

# Reading the X Train and Test Data

dataXTrain = read.table(file.path(path_sa, "train" , "X_Train.txt" ),header = FALSE)
dataXTest = read.table(file.path(path_sa, "test" , "X_Test.txt" ),header = FALSE)

# Reading the subject Files
dataSubTrain = read.table(file.path(path_sa, "train" , "subject_Train.txt" ),header = FALSE)
dataSubTest = read.table(file.path(path_sa, "test" , "subject_Test.txt" ),header = FALSE)


# Reading the Y Files
dataYTrain = read.table(file.path(path_sa, "train" , "Y_Train.txt" ),header = FALSE)
dataYTest = read.table(file.path(path_sa, "test" , "Y_Test.txt" ),header = FALSE)

str(dataYTrain)
str(dataYTest)
str(dataXTrain)
str(dataXTest)
str(dataSubTrain)
str(dataSubTest)

# Merges the test and training sets into one dataset

dataX = rbind(dataXTrain,dataXTest)
dataY = rbind(dataYTrain,dataYTest)
dataSub = rbind(dataSubTrain,dataSubTest)

# Assigning names to variables

names(dataSub)<-c("subject")
names(dataY)<- c("activity")

str(dataY)
str(dataSub)
dataFeaturesNames <- read.table(file.path(path_sa, "features.txt"),head=FALSE)
names(dataX)<- dataFeaturesNames$V2

# Creating one overall Dataset

dataSubAct = cbind (dataY,dataSub)
dataoverall = cbind (dataX,dataSubAct)

#2 Extracts measurements on standard deviation and mean 

str(dataoverall)

subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
data1<-subset(dataoverall,select=selectedNames)

str(data1)

#3 Reading descriptive activity label names from the dataset

activityLabels <- read.table(file.path(path_sa, "activity_labels.txt"),header = FALSE)
dataoverall$activity = factor(dataoverall$activity);

# Adding labels to the factor numbers in the activity dataset
dataoverall$activity<- factor(dataoverall$activity,labels=as.character(activityLabels$V2))

#4 Labels the data set with descriptive variable names.

names(dataoverall)<-gsub("^t", "time", names(dataoverall))
names(dataoverall)<-gsub("^f", "frequency", names(dataoverall))
names(dataoverall)<-gsub("Acc", "Accelerometer", names(dataoverall))
names(dataoverall)<-gsub("Gyro", "Gyroscope", names(dataoverall))
names(dataoverall)<-gsub("Mag", "Magnitude", names(dataoverall))
names(dataoverall)<-gsub("BodyBody", "Body", names(dataoverall))

#5 data set in step 4, creates a second, independent tidy data set with the average of each variable 
#for each activity and each subject.

install.packages('plyr')
library(plyr)

(dataoverall)
datatidy = aggregate( .~ subject + activity, dataoverall,mean)
datatidy<-datatidy[order(datatidy$subject,datatidy$activity),]
datatidy

write.table(datatidy, file = "C:/Users/swastikaa/Documents/DataScience/tidydata.txt",row.name=FALSE)

# Writing to a codebook
capture.output(r, file="tidydata.txt")

install.packages('knitr',repos="http://cran.rstudio.com/")
install.packages('markdown')

require(knitr)
require(markdown)
setwd("C:/Users/swastikaa/Documents/DataScience/")
knit("run_analysis.Rmd", encoding="ISO8859-1")
markdownToHTML("run_analysis.md", "run_analysis.html")


