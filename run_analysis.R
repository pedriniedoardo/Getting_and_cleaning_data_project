###################################################################
# load the libraries
library(tidyverse)
library(rebus)
################################################################################################################
# data were downloaded from:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# extracted and saved in the working directory of the project.
################################################################################################################

################################################################################################################
# 1 MERGES THE TRAINING AND THE TEST SETS TO CREATE ONE DATA SET.
# 
# locate the data folder and files containing the data
folder_test <- "UCI HAR Dataset/test/"
file_test <- str_subset(dir(folder_test),pattern = ".txt")
folder_train <- "UCI HAR Dataset/train/"
file_train <- str_subset(dir(folder_train),pattern = ".txt")

# read the test files in a list. [1]: user, [2]: measurement, [3]: activity
list_test <- lapply(paste0(folder_test,"/",file_test),function(x){
  read_table(x,col_names = F)
})
# read the train files in a list. [1]: user, [2]: measurement, [3]: activity
list_train <- lapply(paste0(folder_train,"/",file_train),function(x){
  read_table(x,col_names = F)
})
# merge the data from test and train in a single list. [1]: user, [2]: measurement, [3]: activity
list_merge <- pmap(list(list_train,list_test), function(x,y){
  bind_rows(x,y)
})
################################################################################################################

################################################################################################################
# 2 EXTRACT ONLY THE MEASUREMENTS ON THE MEAN AND STANDATD DEVIATION FOR THE MEAUSREMENT
#
# read the accessory information to identify the variable names
var_names <- read_table("UCI HAR Dataset/features.txt",col_names = F)%>%
  separate(col = X1,into = c("ID_var","var"),sep = " ")

# save index of the variable of interest, the one involving mean and std
id <- str_detect(var_names$var,pattern = "mean|std")

# save dataframe with the name of the variable of intrest (var_OI)
var_OI <- data.frame(var = var_names$var[id])

# save a dataset with the measurement of interest
df <- list_merge[[2]][,id]

################################################################################################################

################################################################################################################
# 3 USE DESCRIPTIVE ACTIVIY NAMES TO NAME THE ACTIVITIES IN THE DATA SET
#
# read the accessory information to identify lookuptable for the activity ID
activity_ID <- read_tsv("UCI HAR Dataset/activity_labels.txt",col_names = F)%>%
  separate(col = X1,into = c("ID_activity","Activity"),sep = " ")%>%
  mutate(ID_activity=as.integer(ID_activity))
# add the activity description to the activity_ID
list_merge[[3]] <- inner_join(list_merge[[3]],activity_ID,by=c("X1"="ID_activity"))
################################################################################################################

################################################################################################################
# 4 APPROPRIATELY LABEL THE DATASET WITH DESCRIPTOVE VARIABLE NAMES
#
# fix the naming of the variables in the measurement
var_OI$var_fix <- 
  str_replace_all(var_OI$var,pattern = "[\\(\\)]", "")%>%
  # the structure of -Y, -X, -Z is the same therfore I can use the capture() from rebus instead of calling three independent functions
  str_replace(pattern = "-" %R% capture(ANY_CHAR) %R% END, replacement = "_" %R% REF1)%>%
  str_replace_all(pattern = "-", "")%>%
  str_replace(pattern = "^f", replacement = "Frequency")%>%
  str_replace(pattern = "^t", replacement = "Time")%>%
  str_replace(pattern = "mean", replacement = "Mean")%>%
  str_replace(pattern = "std", replacement = "Std")

# rename df with the new var names
colnames(df)<-var_OI$var_fix

# fix the name of the user variable as subject
colnames(list_merge[[1]])<-"Subject"
################################################################################################################

################################################################################################################
# 5 FROM THE DATASET IN STEO 4, CREATES A SECONG INDEPENDET TIDY DATA SET WITH THE AVERAGE OF EACH VARIABLE FOR EACH ACTIVITY AND SUBJECT

# put together the subject, activity and measures and make the summary
df_summary <- bind_cols(list_merge[[1]],list_merge[[3]][,"Activity"],df)%>%
  group_by(Subject,Activity)%>%
  summarise_all(mean,na.rm = T)%>%
  ungroup()

# save the output as requested
write.table(df_summary,file = "tidy_df.txt",row.names = FALSE)
################################################################################################################
