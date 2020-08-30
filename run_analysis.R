library(data.table)
fileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'

if (!file.exists('./data.zip')){
    download.file(fileUrl,destfile = 'data.zip',method = 'wb')
    unzip(zipfile = "data.zip")    
}
#unzip the files


# labels
# - 'features_info.txt': Shows information about the variables used on the feature vector.
# - 'features.txt': List of all features.
# - 'activity_labels.txt': Links the class labels with their activity name.
# - 'train/X_train.txt': Training set.
# - 'train/y_train.txt': Training labels.
# - 'test/X_test.txt': Test set.
# - 'test/y_test.txt': Test labels.
path <- getwd()
fileXTrain <- paste0(path,'/UCI HAR Dataset/train/X_train.txt')
fileYTrain <- paste0(path,'/UCI HAR Dataset/train/Y_train.txt') #represents the activity to predict
fileSTrain <- paste0(path,'/UCI HAR Dataset/train/subject_train.txt')
fileXTest <- paste0(path,'/UCI HAR Dataset/test/X_test.txt')
fileYTest <- paste0(path,'/UCI HAR Dataset/test/Y_test.txt') #represents the activity to predict
fileSTest <- paste0(path,'/UCI HAR Dataset/test/subject_test.txt')

###################################################################################
# Task1: Merge training and test sets
###################################################################################

# Read features
filename <-paste0(path,'/UCI HAR Dataset/features.txt')
featuresNames <- read.table(filename,col.names = c('featNum','featName'))
View(featuresNames)

# Read train dataset
data.train.x<-read.table(fileXTrain,col.names = featuresNames[,'featName']) #select only the features names
data.train.y<-read.table(fileYTrain,col.names = c('activity'))
data.train.subject<-read.table(fileSTrain,col.names = c('subject'))

data.train <- data.frame(data.train.subject,data.train.y,data.train.x) #Combine all data
View(data.train)

# Read test data
data.test.x<-read.table(fileXTest,col.names = featuresNames[,'featName'])
data.test.y<-read.table(fileYTest,col.names = c('activity'))
data.test.subject<-read.table(fileSTest,col.names = c('subject'))
data.test <- data.frame(data.test.subject,data.test.y,data.test.x) #Combine all data

# Merge the data.train and data.test
data.train_test <- rbind.data.frame(data.train,data.test)

###################################################################################
# Task2: Select only the features with mean and standard deviation (mean|std)
###################################################################################

temp<-grep(".(mean|std)\\(", featuresNames$featName)
data_final <- data.train_test[,c(1,2,temp+2)] #add 2 because the first two columns
features<-featuresNames[temp,]

###################################################################################
# Task 3: Label activity with their values 
###################################################################################
# Read activity names
filename <-paste0(path,'/UCI HAR Dataset/activity_labels.txt')
activityNames <- read.table(filename,col.names = c('activity','activityName'))
View(activityNames)

#Using factor replace number with their labels
data_final$activity<-factor(x = data_final$activity,levels = activityNames$activity,labels = activityNames$activityName)

###################################################################################
# Task 4: Label dataset with descriptive var names 
###################################################################################
# From features_info.txt
# prefix 't' to denote time
# prefix 'f' frequency 

new_names<-names(data_final)
View(new_names)
new_names<-gsub("^t","time",new_names)
new_names<-gsub("^f","frequency",new_names)

names(data_final)<-new_names

###################################################################################
# Task 5: Create a second tidy dataset with the average of each variable
#         for each activity and subject
###################################################################################
# group_by activity and subject
tidy_dataset<-aggregate(data_final[,-c(1,2)],by=list(data_final$activity,data_final$subject),FUN = mean)
xlsx::write.xlsx(x = tidy_dataset,file = 'tidy_dataset.xlsx')
