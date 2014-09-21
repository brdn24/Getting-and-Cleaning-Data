if (getwd() != "/Users/bd/Documents/R/Getting_and_Cleaning_data/Project") {
	setwd("../R/Getting_and_Cleaning_data/Project")
}
library('plyr')

get_data <- function(dataset_type = "test"){
	get_x <- paste0(getwd(), '/UCI HAR Dataset', '/', dataset_type, '/x_', dataset_type, '.txt')
	get_y <- paste0(getwd(), '/UCI HAR Dataset', '/', dataset_type, '/y_', dataset_type, '.txt')
	get_subject <- paste0(getwd(), '/UCI HAR Dataset', '/', dataset_type, '/subject_', dataset_type, '.txt')
	
	x <- read.table(get_x, header=FALSE)
	y <- read.table(get_y, header=FALSE)
	subject <- read.table(get_subject, header=FALSE, sep=' ')
	
	features <- read.table(paste0(getwd(),"/UCI HAR Dataset/features.txt"))
	colnames(subject) <- 'subject'
	colnames(x) <- features[,2]
	colnames(y) <- 'y'

	return (data.frame(y=y, subject=subject, x))
	
}

test_data <- get_data("test")
train_data <- get_data("train")
combined_data <- rbind(test_data, train_data)
dim(combined_data)
head(combined_data)

combined_data_columns <- colnames (combined_data)
mean_std <- grep('mean[^F]|std', combined_data_columns, ignore.case = TRUE)
n_combined_data <- combined_data[, c(1,2,mean_std[1:66])]

nn_combined_data <- ddply(n_combined_data, .(subject,y), function(x){
	unlist(lapply(x, mean, na.rm=TRUE))
})

activity_labels <- read.csv(paste0(getwd(),"/UCI HAR Dataset/activity_labels.txt"), sep = " ", header=FALSE)
nn_combined_data$y <- activity_labels[nn_combined_data$y, 2]
colnames(nn_combined_data)[1] <- 'Activity'
write.table(nn_combined_data, file=paste0(getwd(),"/cleaned_data.txt"), row.name = FALSE)