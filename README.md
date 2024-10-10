# Data Science Project in R: Book Analysis

This project analyzes data from a dataset of books using various R packages and techniques. Below are the steps and transformations performed on the dataset.

## Installation and Setup

First, install the necessary packages:

```r
install.packages(c("tidyverse", "readxl"))
```

Then, load the required libraries:

```r
library(tidyverse)
library(readxl)
library(ggplot2)
```

## Dataset

The dataset used in this project is stored in an Excel file named `books.xlsx`, which contains 11,127 observations. The data is loaded into R as follows:

```r
books <- read_excel("books.xlsx")
```

## Data Cleaning and Transformation Steps

1. **Filter English Language Books**  
   We filter out all books that are not in English:

   ```r
   english_books <- books %>%
     filter(language_code == "eng" | language_code == "en-US" | language_code == "en-GB")
   write_csv(english_books, "EnglishBooks.csv")
   ```
   - **Output:** `EnglishBooks.csv` (10,530 observations)

2. **Select Books with 4+ Star Ratings**  
   We select books that have an average rating of 4 stars or higher:

   ```r
   high_rated_books <- english_books %>%
     filter(average_rating >= 4)
   write_csv(high_rated_books, "HighRatedBooks.csv")
   ```
   - **Output:** `HighRatedBooks.csv` (4,664 observations)

3. **Randomly Select 100 Books**  
   A random sample of 100 books is selected:

   ```r
   random_books <- english_books %>%
     sample_n(100, replace = FALSE)
   write_csv(random_books, "RandomBooks.csv")
   ```
   - **Output:** `RandomBooks.csv` (100 observations)

4. **Select Authors Starting with J**  
   We filter books whose authors' names start with the letter "J":

   ```r
   authors_starting_with_J <- english_books %>%
     filter(grepl("^J", authors, ignore.case = TRUE))
   write_csv(authors_starting_with_J, "AuthorsStartingWithJ.csv")
   ```
   - **Output:** `AuthorsStartingWithJ.csv` (1,432 observations)

5. **Find Book with Highest Rating and Most Pages**  
   We identify the book with the highest average rating and the greatest number of pages:

   ```r
   highest_rating <- max(english_books$average_rating)
   highest_rated_books <- english_books %>%
     filter(average_rating == highest_rating)
   highest_rated_highest_pages_book <- highest_rated_books %>%
     filter(num_pages == max(num_pages))
   cat(paste(highest_rated_highest_pages_book$title, "by ", highest_rated_highest_pages_book$authors), "\n")
   ```
   - **Output:** `Colossians and Philemon: A Critical and Exegetical Commentary (International Critical Commentary) by R. McL. Wilson`

6. **Find Book with Lowest Rating and Fewest Pages**  
   We find the book with the lowest average rating and the fewest pages:

   ```r
   lowest_rating <- min(english_books$average_rating)
   lowest_rated_books <- english_books %>%
     filter(average_rating == lowest_rating)
   lowest_rated_lowest_pages_book <- lowest_rated_books %>%
     filter(num_pages == min(num_pages))
   cat(paste(lowest_rated_lowest_pages_book$title, "by ", lowest_rated_lowest_pages_book$authors), "\n")
   ```
   - **Output:** `American Film Guide by Frank N. Magill`

7. **Select Books Published in the 2000s Starting with D**  
   We filter books published in the 2000s (2000-2009) whose titles start with the letter "D":

   ```r
   selected_books <- english_books %>%
     filter(between(as.numeric(substr(publication_date, 1, 4)), 2000, 2009) &
            substr(title, 1, 1) == "D")
   write_csv(selected_books, "BooksPublished2000sStartingWithD.csv")
   ```
   - **Output:** `BooksPublished2000sStartingWithD.csv` (266 observations)

## Visualization Steps

8. **Compare Average Ratings of Titles A-M vs N-Z**  
   A boxplot compares average ratings of books with titles starting from A-M versus N-Z:

   ```r
   english_books %>%
     mutate(title_group = ifelse(substr(title, 1, 1) %in% c("A":"M"), "A-M", "N-Z")) %>%
     ggplot(aes(x = title_group, y = average_rating, fill = title_group)) +
     geom_boxplot() +
     labs(title = "Comparison of Average Ratings for Books with Titles A-M and N-Z",
          x = "Title Group",
          y = "Average Rating") +
     scale_fill_manual(values = c("A-M" = "blue", "N-Z" = "red")) +
     theme_minimal()
   ```
   - **Output:** A boxplot showing the average ratings for both groups.

9. **Compare Average Ratings of Jane Austen's Books**  
   A bar chart compares average ratings of Jane Austen's books:

   ```r
   jane_austen_books <- english_books %>%
     filter(authors == "Jane Austen") %>%
     distinct(title, average_rating, .keep_all = TRUE) %>%
     filter(nchar(title) < max(nchar(title)))
   
   ggplot(jane_austen_books, aes(x = title, y = average_rating, fill = title)) +
     geom_bar(stat = "identity") +
     labs(title = "Ratings of Books Written by Jane Austen",
          x = "Book Title",
          y = "Average Rating") +
     theme_minimal() +
     theme(axis.text.x = element_text(angle = 45, hjust = 1))
   ```
   - **Output:** A bar chart of ratings for Jane Austen's books.

10. **Scatter Plot: Pages vs Average Rating**  
   A scatter plot compares the number of pages and average ratings:

   ```r
   ggplot(english_books, aes(x = num_pages, y = average_rating, color = as.factor(round(average_rating)))) +
     geom_point() +
     labs(title = "Number of Pages vs. Average Rating for Books",
          x = "Number of Pages",
          y = "Average Rating",
          color = "Average Rating") +
     scale_color_viridis_d() +
     theme_minimal()
   ```
   - **Output:** A scatter plot showing the relationship between book length and average rating.