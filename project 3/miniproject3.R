# Step 1: Data Preprocessing
# Load the dataset
url <- "https://raw.githubusercontent.com/datasciencedojo/datasets/master/titanic.csv"
titanic <- read.csv(url)

# Handle missing values
titanic$Age[is.na(titanic$Age)] <- median(titanic$Age, na.rm = TRUE)
titanic$Embarked[is.na(titanic$Embarked)] <- names(sort(-table(titanic$Embarked)))[1]

# Remove unnecessary columns
titanic <- titanic[, !(names(titanic) %in% c("Cabin", "Name", "Ticket"))]

# Encoding categorical variables
titanic <- model.matrix(~ . -1, data = titanic)


# Step 2: Split Data
set.seed(42)
split_index <- sample(1:nrow(titanic), 0.8 * nrow(titanic)) # 80% train, 20% test
train_data <- titanic[split_index, ]
test_data <- titanic[-split_index, ]


# Step 3: Train Models
library(randomForest)
library(nnet)
rf_model <- randomForest(factor(Survived) ~ ., data = train_data, ntree = 500, mtry = 4)
nn_model <- nnet(Survived ~ ., data = train_data, size = 10, maxit = 2000)

# Function to print summary of predictions
print_prediction_summary <- function(model, data) {
  predictions <- predict(model, data)
  summary(predictions)
}

# Print prediction summary for random forest
print("Random Forest Prediction Summary:")
print_prediction_summary(rf_model, test_data)

# Print prediction summary for neural network
print("Neural Network Prediction Summary:")
print_prediction_summary(nn_model, test_data)

# Step 4: Evaluate Performance
# Define protected variable
protected_variable <- "Sexmale"

# Get unique values of the protected variable in the test data
protected_groups <- unique(test_data[, protected_variable])

# Function to calculate accuracy
calculate_accuracy <- function(model, data, response_variable) {
  predictions <- predict(model, data)
  confusion_matrix <- table(predictions, response_variable)
  print(confusion_matrix)
  accuracy <- sum(diag(confusion_matrix)) / sum(confusion_matrix)
  return(accuracy)
}

# Subset the test data for each unique value of the protected variable
subset_data_list <- lapply(protected_groups, function(group) {
  subset_data <- test_data[test_data[, protected_variable] == group, ]
  survived_col <- as.numeric(subset_data[, "Survived"])
  return(list(subset_data = subset_data, survived_col = survived_col))
})

# Calculate accuracies for each model
accuracies_rf <- sapply(subset_data_list, function(subset_data) {
  calculate_accuracy(rf_model, subset_data$subset_data, subset_data$survived_col)
})

accuracies_nn <- sapply(subset_data_list, function(subset_data) {
  calculate_accuracy(nn_model, subset_data$subset_data, subset_data$survived_col)
})

# Print accuracies
print("Random Forest Accuracies:")
print(accuracies_rf)

print("Neural Network Accuracies:")
print(accuracies_nn)

# Visualize Results
barplot(rbind(accuracies_rf, accuracies_nn), beside = TRUE, col = c("blue", "red"),
        names.arg = protected_groups, legend.text = c("Random Forest", "Neural Network"),
        xlab = "Protected Group", ylab = "Accuracy", main = "Prediction Accuracies on Different Subsets")
