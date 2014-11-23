---
Processing UCI HAR Data
  (Data Science Coursera; Getting and Cleaning Data; Peer Assessment Project
   author: "judson"
date: "Sunday, November 23, 2014"
output: pdf_document
---

The first step is to find and download the raw data sets.

```{r}
setwd("./3. GettingandCleaningData")
create.file("UCI HAR Dataset")
```

The data were download as a folder of zipped data and explanatory text files from this url.

        urlHARData <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectiles%UFCI%20HAR%20dataset.zip"
        download.file(urlHARData, destfile= "HARData.zip")
        
The files were unzipped into the HARData subfolder of the working directory \Users\judson\documents\R\3. GettingandCleaningData. The download occurred on November 21, 2014 at 3:42pm PST.

We then extract (from zipped files) and access the indivdual data and text files. The text (explanatory files) are in the main subdirectory and most of the data files are in test or train subdirectories. First we read a table to test the connection (paths) to the files of interest and the default paramenters o0f the read.table() function.

```{r}
read.table(./UCI HAR Dataset/test/X_test.txt)
```

We then address the main data loading in individual file imports for each of the pieces we need: X-test (detailed HAR data, test set); Y-test (activity data column for the test set); Subject-test (subject identifier column for the test set). The X, Y, and Subject datasets for the training set were then downloaded. Finally, the names for the interim data dataset are downloaded from the features.txt file.


```{r}
XTest <- read.table("./UCI HAR Dataset/test/X_test.txt")
dim(XTest)
YTest <- read.table("./UCI HAR Dataset/test/Y_test.txt")
dim(YTest)
SubjectTest <- read.table("./UCI HAR Dataset/test/Subject_test.txt")
dim(SubjectTest)
XTrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
YTrain <- read.table("./UCI HAR Dataset/train/Y_train.txt")
SubjectTrain <- read.table("./UCI HAR Dataset/train/Subject_train.txt")
dim(XTrain)
dim(YTrain)
dim(SubjectTrain)
X <- rbind(XTest, XTrain)
Y <- rbind(YTest, YTrain)
class(X)
class(Y)
dim(Y)
dim(X)
ls()
namesHARData <- read.table("./UCI HAR Dataset/features.txt")
```

Exploratory data analysis was performed sufficient to ascertain successful data loading and and that dimensions of the data sets were appropriate for combining the sets.

A high level summary (compliments of the dim() function: test sets have 2,947 rows and training sets have 7,352 rows. The "X" sets have 561 activity variables while the "Y" and "Subject" sets are columnar with the correct number of rows.

We then set about to create 1 big (interim) dataset from all 7 (7th = "names", see below) partial sets. The process is clear from the r code.

```{r}
AllX <- rbind(XTest, XTrain)
AllY <- rbind(Ytest, Ytrain)
AllSubject <- rbind(SubjectTest, SubjectTrain)
AllData <- cbind(AllSubject, AllY, AllX)
dim(AllData)
```

The AllData data.frame has the expected 10,299 rows and 563 columns (but no names so let's fix that). The code is straightforward.

```{r}
names <- namesHARData[,2]
names <- as.character(names)
names <- c("Subject", "Activity", names)
length(names)
names[1:20]
```

We experienced some initial trouble in names because namesHARData[,2] was (unkown to us) a factor. The code solution above shows each individual step therefore and not a one-line condensation.
We still have to apply the names to the AllData dataframe.

```{r}
head(AllData)
names(AllData) <- names
head(AllData)
```
This essentially completes step 1 of the assignment. We must now extract the mean and standard deviation column data as required by step 2.

A NOTE ON OUR CHOICES IN VARIABLE SELECTION. This assignment is about getting and cleaning data and presenting a tidy, human readable dataset derived from the original UCI HAR Datasets. It is NOT ABOUT significant follow-up analyses of those data. To facilitate a tidy, readable dataset WE CHOSE TO DROP ALL FAST FOURIER TRANSFORM variables (the "f..." variables) and the angular data at the end of the original data set to allow us to focus on the data extracted from the instrumentation untransformed and the required statistics dervied directly therefrom (the "t... variables", means and standard deviations). Below we simply lop off the variables we wish to drop using numerical indices.

Selecting ONLY "t..." variables for further processing.

```{r}
names_tVar <- names[1:267]
AllData_tVar <- AllData[,1:267]
length(names_tVar)
dim(AllData_tVar)
```
Selecting "mean" and "standrad deviation" variables (remember to keep "Subject" and "Activity).

```{r}
meanVars <- grep("-mean", names_tVar)
stdVars <- grep("-std", names_tVar)
retainedVars <- sort(c(1, 2, meanVars, stdVars))
workingNames <- names_tVar[retainedVars]
workingData <- AllData_tVar[,retainedVars]
```

Drop the leading "t" on the variable names (no longer needed) but fix the problem that creates with the first 2 names.

```{r}
workingNames <- sub("t", "", workingNames)
workingNames[1:2] <- c("Subject", "Activity")
```

We respect the general need for readable code to have descriptive variable names. We want to balance this, however, against the highly unaesthetic and impractical solution involving very long variable names with variable values of short length, e.g.:
      very_long_variable_name_readable_but_making_viewing_the_data_difficult another_long_name_with_short_data
                                                                        1.0                                MD 
The basic variable names are reasonably dexcriptive and can be further underrstood by consulting the "features" list and "README" file provided with the data. Hence, our balanced approach leads to accept the leading variable text descriptor but clean up the training characters a bit.

```{r}
workingNames <- gsub("-mean", "Mn", workingNames)
workingNames <- gsub("-std", "Std" workingNames)
workingNames <- gsub("-", "", workingNames)
workingNames
```

In our view the names are now reasonably readable, especially with the reference material provided, but not too long. Note please that we have retained the "()" following the mean and std functions to help that part of description stand out from the original data descriptors.

Create a tidy data set with the average of each variable for each subject and activity. Note: we used the "reshape" package.

```{r}
library(reshape)
meltedData <- melt(workingData, id.vars = c("Subject", "Activity"))
RecastData <- cast(Subject + Activity ~ variable, data=meltedData, fun=mean)
RecastData$Activity <- as.factor(RecastData$Activity)
levels(RecastData$Activity) <- c("walk", "walkUp", "walkDn", "sit", "stand", "lay")
FinalHARTidyDataset <- RecastData
```

Although the activity labels (levels) are shortened, they are easily understood in context.

```{r}
FinalHARTidyDataset
```





                      
                      