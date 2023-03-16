# The following exercises are not present in R for Data Science. They were taken from other online sources.

# https://anderfernandez.com/en/blog/dplyr-tutorial/

# Exercise 1 - From the gapminder dataframe, choose the variables continent, year and lifeExp.
gapminder %>% 
    select(continent, year, lifeExp)

# Exercise 2 - Keep the observations from the gapminder dataset that: they are from Africa, that the year is 2007 and that the life expectancy is greater than 60 years.
gapminder %>% 
    filter(continent == "Africa" & year == 2007 & lifeExp > 60)

# Exercise 3 - Using the Gapminder dataset and some function of the slice family, find the countries with the highest life expectancy each year.
gapminder %>% 
    group_by(year) %>% 
    slice_max(lifeExp)

# Exercise 4 - Order the gapminder dataset by year (newest first), continent (from Z to A) and by life expectancy (from lowest to highest).
gapminder %>% 
    arrange(desc(year), desc(continent), lifeExp)
	
# Exercise 5 - Using the Gapminder dataframe, calculate the maximum, minimum and mean of the population and life expectancy for each continent and year. 
#The variables should be called lifeExp_min, lifeExp_max, lifeExp_mean and pop_min, pop_max and pop_mean, in that order.
gapminder %>% 
    group_by(continent, year) %>% 
    summarise(
        lifeExp_min = min(lifeExp),
        lifeExp_max = max(lifeExp),
        lifeExp_mean = mean(lifeExp),
        pop_min = min(pop),
        pop_max = max(pop),
        pop_mean = mean(pop)
        )

#Exercise 6 - Repeat the previous exercise by using the across() function.
gapminder %>% 
    group_by(continent, year) %>% 
    summarise(
        across(
            c(lifeExp, pop),
            list(min = min, max = max, mean = mean) #if you want the columns to have the name of the function you have to use function = function
        )
    )

#Exercise 7 - Using the titanic dataset, create a new Boolean column, called adult, which returns TRUE if the person is of legal age or FALSE if he is not.
titanic %>% 
    mutate(
        adult = (Age > 18)
    ) %>% 
    group_by(adult) %>% 
    count()
    
    
#https://www.r-exercises.com/2017/10/03/dplyr-basics-more-smooth-data-exploration/
  
#Exercise 1
library(AER)
library(tidyverse)

data('Fertility')

glimpse(Fertility)

#Exercise 2
Fertility %>% 
  slice(35:50) %>% 
  select(age, work)

#Exercise 3
Fertility %>% 
  slice_tail(n = 1)

#Exercise 4
Fertility %>% 
  count(morekids)

#Exercise 5
Fertility %>% 
  group_by(gender1, gender2) %>% 
  count() %>% 
  arrange(desc(n))

#Exercise 6
Fertility %>% 
  group_by(afam, hispanic, other) %>% 
  summarise(mean(work < 5))

#Exercise 7
Fertility %>% 
  filter(between(age, 22, 24)) %>%
  summarise(
    prop_firstborn_male = mean(gender1 == "male")
  )

#OR

Fertility %>% 
  filter(between(age, 22, 24)) %>%
  group_by(gender1) %>% 
  summarise(
    n = n()
  ) %>% 
  mutate(prop = n/sum(n)) #watchout for the variables

#Exercise 8
Fertility %>% 
  mutate(
    age_squared = age^2
  ) %>% 
  head()

#Exercise 9
Fertility %>% 
  group_by(afam, hispanic, other) %>% 
  summarise(
    prop_first_boy = mean(gender1 == 'male'),
    count = n()
  ) %>% 
  arrange(prop_first_boy)

#OR

Fertility %>% 
  group_by(afam, hispanic, other, gender1) %>% 
  summarise(
    n = n()
  ) %>% 
  mutate(prop_first_boy = n/sum(n)) %>% 
  filter(gender1 == 'male') %>% # to only show the males
  arrange(prop_first_boy)

#Exercise 10
Fertility %>% 
  group_by(gender1, gender2) %>% 
  summarise(
    prop_3rd_child = mean(morekids == "yes")
  )

#OR

Fertility %>% 
  group_by(gender1, gender2, morekids) %>% 
  summarise(n = n()) %>% 
  mutate(prop_3rd_child = n/sum(n)) %>% 
  filter(morekids == 'yes') #to show the proportion that has a 3rd child

