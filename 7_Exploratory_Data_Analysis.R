library(tidyverse)

# Exercise 7.3.4 - Variation ============================================================================================================================================

# Q1. Explore the distribution of each of the x, y, and z variables in diamonds. What do you learn? Think about a diamond and how you might decide which dimension is the length, width, and depth.
# A. 
# summary of data
summary(select(diamonds, x, y, z))

# only distributions of x, y and z
# x - length
ggplot(data = diamonds) +
  geom_histogram(aes(x = x), binwidth = 0.3)
# y - width
ggplot(data = diamonds) +
  geom_histogram(aes(x = y), binwidth = 0.3)
# z - depth
ggplot(data = diamonds) +
  geom_histogram(aes(x = z), binwidth = 0.3)

# zoom in distributions of x, y and z
# x - length
ggplot(data = diamonds) +
  geom_histogram(aes(x = x), binwidth = 0.3) +
  coord_cartesian(ylim = c(0,25))
# y - width
ggplot(data = diamonds) +
  geom_histogram(aes(x = y), binwidth = 0.3) +
  coord_cartesian(ylim = c(0,25))
# z - depth
ggplot(data = diamonds) +
  geom_histogram(aes(x = z), binwidth = 0.3) +
  coord_cartesian(ylim = c(0,25))

# compare x with y and x with z
diamonds %>% sample_n(1000) %>% # we used sample_n() to take just a sample of individuals instead of using the whole dataset
  ggplot() +
  geom_point(aes(x = x, y = y)) + 
  coord_fixed()
diamonds %>% sample_n(1000) %>% 
  ggplot() +
  geom_point(aes(x = x, y = z)) + 
  coord_fixed()
# A. the values of x and y are similiar to each other to all 1000 individuals, so they could be length and width. On the other had, z is always (~60%) smaller than x and y, making it the depth.

# Q2. Explore the distribution of price. Do you discover anything unusual or surprising? (Hint: Carefully think about the binwidth and make sure you try a wide range of values.)
# A. 
ggplot(diamonds) +
  geom_histogram(aes(x = price), binwidth = 50)
# There are a higher number of diamonds with lowcost. After cost > 1000 the number of diamonds decreases exponentially. Distribution is positively skewed
ggplot(diamonds) +
  geom_histogram(aes(x = price), binwidth = 10) +
  coord_cartesian(xlim = c(1450, 1550))
# Theres is an unsual observation in the graph. There are no diamonds with prices between 1450 and 1550

# Q3. How many diamonds are 0.99 carat? How many are 1 carat? What do you think is the cause of the difference?
# A. 
diamonds %>% filter(carat == 0.99) %>% 
  count()
diamonds %>% filter(carat == 1) %>% 
  count()
#by performing an histogram we can see clusters which can justify the differences observed above
ggplot(diamonds) +
  geom_histogram(aes(x = carat), binwidth = 0.01)
#the differences maybe related with the fact that experts like to round up carat from 0.99 to 1
ggplot(diamonds) +
  geom_histogram(aes(x = carat), binwidth = 0.01) +
  coord_cartesian(xlim = c(0.90, 1.10))

# Q4. Compare and contrast coord_cartesian() vs xlim() or ylim() when zooming in on a histogram. What happens if you leave binwidth unset? What happens if you try and zoom so only half a bar shows?
# A. 


# Exercise 7.4.1 - Covariation: A categorical and continuous variable ============================================================================================================================================

# Q1. What happens to missing values in a histogram? What happens to missing values in a bar chart? Why is there a difference?
# A. If a variable is numeric, missing valuesare ignoredin both bar charts and histograms. However, if the variable is categorical, in a bar chart it creates a column with missing values.

# Q2. What does na.rm = TRUE do in mean() and sum()?
# A. na.rm() in sum() and mean(), removes all missing values, making it possible to calculate the sum and mean of variables that may contain missing values.


# Exercise 7.5.1.1 - Covariation: A categorical and continuous variable ============================================================================================================================================

# Q1. Use what you’ve learned to improve the visualisation of the departure times of cancelled vs. non-cancelled flights.
# A. 
library(nycflights13)
# in freq_poly
nycflights13::flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>% 
  ggplot(aes(x = sched_dep_time, y = after_stat(density))) + #..density.. is the same as after_stat(density)
  geom_freqpoly(aes(color = cancelled), binwidth = 1/4)

#OR
#in density plot 
nycflights13::flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>% 
  ggplot(aes(x = sched_dep_time)) +
  geom_density(aes(fill = cancelled), alpha = 0.3)

#OR
#in boxplot (might be better because its more compact)
nycflights13::flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>% 
  ggplot(aes(x = sched_dep_time, y = cancelled)) +
  geom_boxplot()

#The plots show an interesting result that flights that depart later in the day have higher chance of being cancelled.

# Q2. What variable in the diamonds dataset is most important for predicting the price of a diamond? How is that variable correlated with cut? Why does the combination of those two relationships lead to lower quality diamonds being more expensive?
# A. 
#color vs price
ggplot(diamonds) +
  geom_boxplot(aes(x = price, y = reorder(color, price, FUN = median)))
#clarity vs price
ggplot(diamonds) +
  geom_boxplot(aes(x = price, y = reorder(clarity, price, FUN = median)))
#cut vs price
ggplot(diamonds) +
  geom_boxplot(aes(x = price, y = reorder(cut, price, FUN = median)))

#correlation with price
cor(diamonds$price, select(diamonds, carat, depth, table, x, y, z))

#carat has the highest correlation!! it is the best for predicting the price

#carat vs price (carat is dependent on the dimensions of the diamond, since its the weight)
ggplot(diamonds, aes(x = carat, y = price)) +
  geom_point() +
  geom_smooth(se = FALSE)

#how is carat correlated with cut?
ggplot(diamonds) +
  geom_boxplot(aes(x = carat, y = reorder(cut, carat, FUN = median))) +
  labs(y = 'cut')
#Why does the combination of those two relationships lead to lower quality diamonds being more expensive?
#since the fair cut diamonds have a higher carat they are more expensive than premium diamonds with lower carat


# Q3. Install the ggstance package, and create a horizontal boxplot. How does this compare to using coord_flip()?
# A. did not respond


# Q4. One problem with boxplots is that they were developed in an era of much smaller datasets and tend to display a prohibitively large number of “outlying values”. One approach to remedy this problem is the letter value plot. Install the lvplot package, and try using geom_lv() to display the distribution of price vs cut. What do you learn? How do you interpret the plots?
# A. 
ggplot(diamonds, aes(x = cut, y = price)) +
  geom_lv(aes(fill = ..LV..))

# Q5. Compare and contrast geom_violin() with a facetted geom_histogram(), or a coloured geom_freqpoly(). What are the pros and cons of each method?
# A. did not respond

# Q6. If you have a small dataset, it’s sometimes useful to use geom_jitter() to see the relationship between a continuous and categorical variable. The ggbeeswarm package provides a number of methods similar to geom_jitter(). List them and briefly describe what each one does.
# A. did not respond


# Exercise 7.5.2.1 - Covariation: Two categorical variables ============================================================================================================================================

# Q1. How could you rescale the count dataset above to more clearly show the distribution of cut within colour, or colour within cut?
# A. 
diamonds %>% group_by(color) %>% 
  count(color, cut) %>% 
  mutate(prop = n/sum(n)) %>% 
  ggplot(aes(x = color, y = cut)) +
    geom_tile(aes(fill = prop))

# Q2. Use geom_tile() together with dplyr to explore how average flight delays vary by destination and month of year. What makes the plot difficult to read? How could you improve it?
# A. 
flights %>% 
  filter(!is.na(dep_delay)) %>% 
  group_by(dest, month) %>% 
  mutate(
    avg_delay = mean(dep_delay)
  ) %>% 
  ggplot(aes(x = factor(month), y = dest)) +
  geom_tile(aes(fill = avg_delay)) 

#Problem: there are to may desinations which makes the heatmap confusing. To solve it we could filter small groups!
library(viridis)
flights %>% 
  filter(!is.na(dep_delay)) %>% 
  group_by(dest, month) %>% 
  mutate(n = n(),
         avg_delay = mean(dep_delay)) %>% 
  filter(n > 1000) %>% #filter to get groups with more than 1000 samples
  ggplot(aes(x = factor(month), y = dest)) +
    geom_tile(aes(fill = avg_delay)) +
    scale_fill_viridis() #changes color, easier to see, has to use viridis package

# Q3. Why is it slightly better to use aes(x = color, y = cut) rather than aes(x = cut, y = color) in the example above?
# A. Because it is generally good practice to put the variable with more categories on the x-axis (horizontal) making it easier to read. Also, it depends on the results.


# Exercise 7.5.3.1 - Covariation: Two continuous variables ============================================================================================================================================
smaller <- diamonds %>% filter(carat < 3)

# Q1. Instead of summarising the conditional distribution with a boxplot, you could use a frequency polygon. What do you need to consider when using cut_width() vs cut_number()? How does that impact a visualisation of the 2d distribution of carat and price?
# A.
ggplot(smaller, aes(x = price)) +
  geom_freqpoly(aes(color = cut_width(carat, 0.25))) #here you specify width range
ggplot(smaller, aes(x = price)) +
  geom_freqpoly(aes(color = cut_number(carat, 10))) # here you specify how many points you want per bin
# It depends on the number of bins originated from each function. 

# Q2. Visualise the distribution of carat, partitioned by price.
# A.
ggplot(data = diamonds, mapping = aes(x = price, y = carat)) +
  geom_violin(aes(group = cut_width(price, 2500)))

# Q3. How does the price distribution of very large diamonds compare to small diamonds? Is it as you expect, or does it surprise you?
# A.
ggplot(data = diamonds, mapping = aes(x = price)) +
  geom_boxplot(mapping = aes(color = cut_number(carat, 10)))
# This visualization is expected since it is normal that larger diamonds cost more.However, bigger diamonds have higher price variability, which can be related with differences in cut, or derived from it being a smaller sample

# Q4. Combine two of the techniques you’ve learned to visualise the combined distribution of cut, carat, and price.
# A.
ggplot(diamonds, aes(x = carat, y = price))+
  geom_boxplot(aes(group = cut_width(carat, 0.5), colour = cut))+
  facet_grid(. ~ cut)
# or to make it easier to read
diamonds %>% 
  mutate(carat = cut(carat, 5)) %>% 
  ggplot(aes(x = carat, y = price))+
  geom_boxplot(mapping = aes(
                  group = interaction(cut_width(carat, 0.5), cut),
                  fill = cut), 
               position = position_dodge(preserve = "single"))

# Q5. Two dimensional plots reveal outliers that are not visible in one dimensional plots. For example, some points in the plot below have an unusual combination of x and y values, which makes the points outliers even though their x and y values appear normal when examined separately.
ggplot(data = diamonds) +
  geom_point(mapping = aes(x = x, y = y)) +
  coord_cartesian(xlim = c(4, 11), ylim = c(4, 11))
# Why is a scatterplot a better display than a binned plot for this case?
# A. By comparing the above graph with 
ggplot(data = diamonds) +
  geom_hex(mapping = aes(x = x, y = y)) +
  coord_cartesian(xlim = c(4, 11), ylim = c(4, 11))

# We see that by using binned plots, the outliers dissapear since they become grouped in a bin! 














