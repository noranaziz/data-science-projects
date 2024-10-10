# Titanic Survival Prediction with Protected Group Analysis

This project builds predictive models to classify Titanic passengers based on their survival outcome while also examining the model performance across different groups of the `Sex` variable, a protected characteristic.

## Dataset

The Titanic dataset used is publicly available [here](https://raw.githubusercontent.com/datasciencedojo/datasets/master/titanic.csv). The dataset contains information about the passengers such as age, sex, fare, and survival outcome.

## Project Overview

### Step 1: Data Preprocessing
- **Handling Missing Values**: Missing values in the `Age` column were replaced with the median, and missing `Embarked` values were replaced with the most common value.
  
    ```r
    titanic$Age[is.na(titanic$Age)] <- median(titanic$Age, na.rm = TRUE)
    titanic$Embarked[is.na(titanic$Embarked)] <- names(sort(-table(titanic$Embarked)))[1]
    ```
  
- **Dropping Unnecessary Columns**: Removed columns like `Cabin`, `Name`, and `Ticket`, as they are not useful for prediction.
  
    ```r
    titanic <- titanic[, !(names(titanic) %in% c("Cabin", "Name", "Ticket"))]
    ```

- **Encoding Categorical Variables**: One-hot encoding was applied to convert categorical variables into numerical format.
  
    ```r
    titanic <- model.matrix(~ . -1, data = titanic)
    ```

### Step 2: Split Data
- The dataset was split into 80% training and 20% testing sets using a random sampling method.

    ```r
    split_index <- sample(1:nrow(titanic), 0.8 * nrow(titanic))
    train_data <- titanic[split_index, ]
    test_data <- titanic[-split_index, ]
    ```

### Step 3: Train Models
- **Random Forest Model**: Trained a random forest model with 500 trees and 4 features considered at each split.
  
    ```r
    rf_model <- randomForest(factor(Survived) ~ ., data = train_data, ntree = 500, mtry = 4)
    ```
  
- **Neural Network Model**: Trained a shallow neural network with 10 hidden units and a maximum of 2000 iterations.
  
    ```r
    nn_model <- nnet(Survived ~ ., data = train_data, size = 10, maxit = 2000)
    ```

- **Prediction Summaries**: A function was created to print the prediction summaries for both models on the test data.

    ```r
    print_prediction_summary(rf_model, test_data)
    print_prediction_summary(nn_model, test_data)
    ```

### Step 4: Evaluate Performance by Protected Group
- A performance analysis was conducted for the protected variable `Sexmale` (male/female). Accuracy was calculated for each group in the test dataset to understand how the models perform across different groups.
  
    ```r
    protected_variable <- "Sexmale"
    ```

- **Accuracy Calculation**: A function was created to calculate the accuracy for each group (`Sexmale = 0` for females, `Sexmale = 1` for males) by comparing model predictions to the actual `Survived` values.

    ```r
    calculate_accuracy(rf_model, subset_data$subset_data, subset_data$survived_col)
    ```

- **Model Accuracy Comparisons**: The accuracies of the Random Forest and Neural Network models were calculated and compared for each group.

    ```r
    accuracies_rf <- sapply(subset_data_list, function(subset_data) {
      calculate_accuracy(rf_model, subset_data$subset_data, subset_data$survived_col)
    })
    ```

### Visualization
- A bar plot was created to visually compare the prediction accuracies of the two models across the male and female groups.

    ```r
    barplot(rbind(accuracies_rf, accuracies_nn), beside = TRUE, col = c("blue", "red"),
            names.arg = protected_groups, legend.text = c("Random Forest", "Neural Network"),
            xlab = "Protected Group", ylab = "Accuracy", main = "Prediction Accuracies on Different Subsets")
    ```

## Results

- **Random Forest Accuracies by Group**:
-   Males: 0.7950820 | **79.51%**
-   Females: 0.7894737 | **78.95%**
- **Neural Network Accuracies by Group**:
-   Males: 0.47540984 | **47.54%**
-   Females: 0.01754386 | **1.75%**

## Conclusion

This project not only builds predictive models for the Titanic dataset but also explores the fairness and performance of these models on different subsets of the population, particularly across gender groups. The results show how different models behave in terms of accuracy for males and females, helping to inform fairness and bias considerations in predictive modeling. In this case, decision forests performed well, while neural networks did not.
