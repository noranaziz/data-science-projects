# install packages
install.packages(c("tidyverse", "readxl"))

# load packages
library(tidyverse)
library(readxl)
library(ggplot2)

# read books.xlsx
books <- read_excel("books.xlsx")
# has 11127 observations


# 1. remove all entries that have books that are not in english.
english_books <- books %>%
  filter(language_code == "eng" | language_code == "en-US" | language_code == "en-GB")
# save cleaned data to new csv file
write_csv(english_books, "EnglishBooks.csv")
# OUTPUT: EnglishBooks.csv file with 10530 observations
# this file will be used for steps 2-10.

# 2. select only books that have a 4 star rating or higher.
high_rated_books <- english_books %>%
  filter(average_rating >= 4)
# save cleaned data to new csv file
write_csv(high_rated_books, "HighRatedBooks.csv")
# OUTPUT: HighRatedBooks.csv with 4664 observations

# 3. randomly select 100 rows.
random_books <- english_books %>%
  sample_n(100, replace = FALSE)
# save random to new csv file
write_csv(random_books, "RandomBooks.csv")
# OUTPUT: RandomBooks.csv with 100 observations

# 4. select books that have authors that start with J
authors_starting_with_J <- english_books %>%
  filter(grepl("^J", authors, ignore.case = TRUE))
# save data frame to new csv file
write_csv(authors_starting_with_J, "AuthorsStartingWithJ.csv")
# OUTPUT: AuthorsStartingWithJ.csv with 1432 observations

# 5. select a single book that has the highest average rating
# with the highest number of pages.
# find the book with the highest average rating
highest_rating <- max(english_books$average_rating)
# filter books with the highest average rating
highest_rated_books <- english_books %>%
  filter(average_rating == highest_rating)
# among books with the highest rating, find the one with the highest # of pages
highest_rated_highest_pages_book <- highest_rated_books %>%
  filter(num_pages == max(num_pages))
# print title and author
cat(paste(highest_rated_highest_pages_book$title, "by ", highest_rated_highest_pages_book$authors), "\n")
# OUTPUT: Colossians and Philemon: A Critical and Exegetical Commentary (International Critical Commentary) by  R. McL. Wilson

# 6. select a single book that has the lowest average rating
# with the lowest number of pages.
# find the book with the lowest average rating
lowest_rating <- min(english_books$average_rating)
# filter books with the lowest average rating
lowest_rated_books <- english_books %>%
  filter(average_rating == lowest_rating)
# among books with the lowest rating, find the one with the lowest # of pages
lowest_rated_lowest_pages_book <- lowest_rated_books %>%
  filter(num_pages == min(num_pages))
# print title and author
cat(paste(lowest_rated_lowest_pages_book$title, "by ", lowest_rated_lowest_pages_book$authors), "\n")
# OUTPUT: American Film Guide by  Frank N. Magill

# 7. select books published in the 2000s with a title starting with D.
selected_books <- english_books %>%
  filter(
    between(as.numeric(substr(publication_date, 1, 4)), 2000, 2009) &
    substr(title, 1, 1) == "D"
  )
# save data frame to new csv file
write_csv(selected_books, "BooksPublished2000sStartingWithD.csv")
# OUTPUT: BooksPublished2000sStartingWithD.csv with 266 observations

# 8. use a chart to compare average ratings of books with titles starting with A-M and N-Z.
english_books %>%
  mutate(title_group = ifelse(substr(title, 1, 1) %in% c("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M"), "A-M", "N-Z")) %>%
  ggplot(aes(x = title_group, y = average_rating, fill = title_group)) +
  geom_boxplot() +
  labs(title = "Comparison of Average Ratings for Books with Titles A-M and N-Z",
       x = "Title Group",
       y = "Average Rating") +
  scale_fill_manual(values = c("A-M" = "blue", "N-Z" = "red")) +
  theme_minimal()
# OUTPUT: boxplot with 2 boxes for group (A-M and N-Z). Each group has around the same average rating (4).

# 9. create a chart to compare average ratings of books written by jane austen.
# filter books written by jane austen
jane_austen_books <- english_books %>%
  filter(authors == "Jane Austen")
jane_austen_books <- jane_austen_books %>%
  distinct(title, average_rating, .keep_all = TRUE)
jane_austen_books <- jane_austen_books %>%
  filter(nchar(title) < max(nchar(title)))
# bar graph
ggplot(jane_austen_books, aes(x = title, y = average_rating, fill = title)) +
  geom_bar(stat = "identity") +
  labs(title = "Ratings of Books Written by Jane Austen",
       x = "Book Title",
       y = "Average Rating") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
# OUTPUT: bar graph with 9 bars comparing the average rating.

#10. create a scatter plot to compare number of pages vs average ratings.
ggplot(english_books, aes(x = num_pages, y = average_rating, color = as.factor(round(average_rating)))) +
  geom_point() +
  labs(title = "Number of Pages vs. Average Rating for Books",
       x = "Number of Pages",
       y = "Average Rating",
       color = "Average Rating") +
  scale_color_viridis_d() +
  theme_minimal()
# OUTPUT: scatter plot showing the distribution of pages and average ratings.
# it seems like books with more pages typically have higher ratings.