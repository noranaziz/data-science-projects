# Load necessary libraries
library(readr)
library(caret)
library(nnet)
library(rpart)

# Load the dataset
url <- "https://raw.githubusercontent.com/datasciencedojo/datasets/master/titanic.csv"
titanic_data <- read.csv(url)

# Drop irrelevant columns
titanic_data <- titanic_data[, !(names(titanic_data) %in% c("PassengerId", "Name", "Ticket", "Cabin"))]

# Handling missing values
titanic_data$Age[is.na(titanic_data$Age)] <- median(titanic_data$Age, na.rm = TRUE)

# Handling missing values in "Embarked" column
embarked_mode <- names(sort(table(titanic_data$Embarked), decreasing = TRUE))[1]
titanic_data$Embarked[is.na(titanic_data$Embarked)] <- embarked_mode

# Convert categorical variables into numerical
titanic_data <- cbind(titanic_data, model.matrix(~ Sex + Embarked, data = titanic_data)[, -1])

# Define features and target variable
X <- titanic_data[, !(names(titanic_data) %in% "Survived")]
y <- titanic_data$Survived

# Splitting the dataset into training and testing sets
set.seed(42)
train_index <- createDataPartition(y, p = 0.8, list = FALSE)
X_train <- X[train_index, ]
X_test <- X[-train_index, ]
y_train <- y[train_index]
y_test <- y[-train_index]

# Model 1: Logistic Regression
logistic_model <- glm(Survived ~ ., data = titanic_data[train_index, ], family = "binomial")
logistic_predictions <- predict(logistic_model, newdata = titanic_data[-train_index, ], type = "response") > 0.5
# Summarize the model to get variable p-values and model goodness of fit
summary(logistic_model)
# Confusion Matrix for Logistic Regression
logistic_confusion <- table(logistic_predictions, y_test)
# Rename the rows and columns in the confusion matrix
rownames(logistic_confusion) <- c("Predicted Not Survived", "Predicted Survived")
colnames(logistic_confusion) <- c("Not Survived", "Survived")
# Print the confusion matrix with customized labels
cat("Confusion Matrix for Logistic Regression:\n")
print(logistic_confusion)
# Accuracy
logistic_accuracy <- mean(logistic_predictions == y_test)
cat("Accuracy of Logistic Regression:", logistic_accuracy, "\n")

# Model 2: Shallow Neural Networks
titanic_data$Survived <- factor(titanic_data$Survived)
nn_model <- nnet(Survived ~ ., data = titanic_data[train_index, ], size = 10, maxit = 1000)
nn_predictions <- predict(nn_model, newdata = titanic_data[-train_index, ], type = "class")
# Summarize the model to get variable p-values and model goodness of fit
summary(nn_model)
# Accuracy
nn_accuracy <- mean(nn_predictions == titanic_data$Survived[-train_index])
cat("Accuracy of Shallow Neural Networks:", nn_accuracy, "\n")
# Confusion Matrix for Shallow Neural Networks
nn_confusion <- table(nn_predictions, titanic_data$Survived[-train_index])
# Rename the rows and columns in the confusion matrix
rownames(nn_confusion) <- c("Predicted Not Survived", "Predicted Survived")
colnames(nn_confusion) <- c("Not Survived", "Survived")
cat("\nConfusion Matrix for Shallow Neural Networks:\n")
print(nn_confusion)

# Model 3: Decision Trees
dt_model <- rpart(Survived ~ ., data = titanic_data[train_index, ], method = "class")
print(dt_model)
# Plot the decision tree
prp(dt_model, box.palette = "auto", tweak = 1)
dt_predictions <- predict(dt_model, newdata = titanic_data[-train_index, ], type = "class")
# Accuracy
dt_accuracy <- mean(dt_predictions == y_test)
cat("Accuracy of Decision Trees:", dt_accuracy, "\n")
# Confusion Matrix for Decision Trees
dt_confusion <- table(dt_predictions, titanic_data$Survived[-train_index])
# Rename the rows and columns in the confusion matrix
rownames(dt_confusion) <- c("Predicted Not Survived", "Predicted Survived")
colnames(dt_confusion) <- c("Not Survived", "Survived")
cat("\nConfusion Matrix for Decision Trees:\n")
print(dt_confusion)
