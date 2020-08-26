fileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
download.file(fileUrl,destfile = 'data.zip',method = 'curl')

#unzip the files
unzip(zipfile = "data.zip")

# labels
# - 'features_info.txt': Shows information about the variables used on the feature vector.
# - 'features.txt': List of all features.
# - 'activity_labels.txt': Links the class labels with their activity name.
# - 'train/X_train.txt': Training set.
# - 'train/y_train.txt': Training labels.
# - 'test/X_test.txt': Test set.
# - 'test/y_test.txt': Test labels.

path <- getwd()
fileName <-paste0(path,'/UCI HAR Dataset/activity_labels.txt')
fileName

library(data.table)
# Read activity names
activityNames <- read.table(fileName,col.names = c('activity','activityName'))
activityNames

fileName <-paste0(path,'/UCI HAR Dataset/features.txt')
featuresNames <- read.table(fileName,col.names = c('featNum','featName'))
featuresNames
# Select only the features with mean and standard deviation (mean|std)
temp<-grep(".(mean|std)\\(", featuresNames$featName)
features<-featuresNames[temp,]

# Read train dataset
fileName <-paste0(path,'/UCI HAR Dataset/train/X_train.txt')
X_train<-fread(fileName,col.names = featuresNames$featName)
head(X_train,2)

View(X_train)

featuresNames[,"featName"]

# Read test dataset

filter only ######

acs <- as_tibble(acs) ## For better printing
acs

names(acs)
