# Titanic Survival Prediction Project

This project involves building predictive models to classify whether a passenger survived the Titanic disaster based on their demographic and ticket information.

## Dataset

The dataset used in this project is publicly available and can be found [here](https://raw.githubusercontent.com/datasciencedojo/datasets/master/titanic.csv). It contains 891 rows and several features such as passenger details, ticket information, and survival outcome.

## Project Overview

1. **Load Necessary Libraries**
    ```r
    library(readr)
    library(caret)
    library(nnet)
    library(rpart)
    ```
   
2. **Load the Titanic Dataset**
    ```r
    url <- "https://raw.githubusercontent.com/datasciencedojo/datasets/master/titanic.csv"
    titanic_data <- read.csv(url)
    ```

3. **Data Preprocessing**
    - Dropped irrelevant columns (`PassengerId`, `Name`, `Ticket`, `Cabin`).
    - Filled missing `Age` values with the median.
    - Filled missing `Embarked` values with the mode (most frequent value).

4. **Handling Categorical Variables**
    - Converted categorical variables (`Sex` and `Embarked`) to numerical values using one-hot encoding.
   
5. **Data Splitting**
    - Split the dataset into 80% training and 20% testing sets.
    - Features (`X`) and target (`y`) were separated.

6. **Models Implemented**
   - Logistic Regression
   - Shallow Neural Networks
   - Decision Trees

### Model Details

#### Model 1: Logistic Regression
   - Fitted a logistic regression model to predict survival.
   - Summarized the model for p-values and goodness of fit.
   - Generated a confusion matrix and calculated the model's accuracy.
   
   ```r
   logistic_model <- glm(Survived ~ ., data = titanic_data[train_index, ], family = "binomial")
   logistic_predictions <- predict(logistic_model, newdata = titanic_data[-train_index, ], type = "response") > 0.5
   logistic_accuracy <- mean(logistic_predictions == y_test)
   ```

   **Confusion Matrix and Accuracy**
   ```r
   print(logistic_confusion)
   cat("Accuracy of Logistic Regression:", logistic_accuracy)
   ```

#### Model 2: Shallow Neural Networks
   - Fitted a shallow neural network model with 10 hidden units and 1000 iterations.
   - Evaluated the model's performance on the test data.
   
   ```r
   nn_model <- nnet(Survived ~ ., data = titanic_data[train_index, ], size = 10, maxit = 1000)
   nn_accuracy <- mean(nn_predictions == titanic_data$Survived[-train_index])
   ```

   **Confusion Matrix and Accuracy**
   ```r
   print(nn_confusion)
   cat("Accuracy of Shallow Neural Networks:", nn_accuracy)
   ```

#### Model 3: Decision Trees
   - Built a decision tree model to classify survival.
   - Visualized the decision tree and evaluated the model’s accuracy.
   
   ```r
   dt_model <- rpart(Survived ~ ., data = titanic_data[train_index, ], method = "class")
   dt_accuracy <- mean(dt_predictions == y_test)
   ```

   **Confusion Matrix and Accuracy**
   ```r
   print(dt_confusion)
   cat("Accuracy of Decision Trees:", dt_accuracy)
   ```

## Results

- **Logistic Regression Accuracy**: 0.758427 | **75.84%**
- **Shallow Neural Network Accuracy**: 0.7865169 | **78.65%**
- **Decision Tree Accuracy**: 0.7865169 | **78.65%**

## Visualization

- The decision tree model is visualized using the `prp()` function, which provides a graphical representation of the decision rules.
