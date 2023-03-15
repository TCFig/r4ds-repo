library(nycflights13)
library(tidyverse)


# Exercises 5.2.4 - Filter rows with filter() ============================================================================================================================

# Q1. Find all flights that:
# Had an arrival delay of two or more hours
filter(flights, arr_delay >= 120)

#Flew to Houston (IAH or HOU)
filter(flights, dest == 'IAH' | dest == 'HOU') or filter(flights, dest %in% c('IAH', 'HOU'))

# Were operated by United, American, or Delta
airlines
filter(flights, carrier == 'AA' | carrier == 'UA' | carrier == 'DL') or filter(flights, carrier %in% c('UA', 'AA', 'DL'))

# Departed in summer (July, August, and September)
filter(flights, month == 7 | month == 8 | month == 9) or filter(flights, month >= 7, month <= 9) or filter(flights, month %in% c(7, 8, 9))

# Arrived more than two hours late, but didn’t leave late
filter(flights, arr_delay > 120 & !(dep_delay > 0)) or filter(flights, arr_delay >= 120, dep_delay <= 0)

# Were delayed by at least an hour, but made up over 30 minutes in flight
filter(flights, dep_delay >= 60 & dep_delay - arr_delay >= 30)

# Departed between midnight and 6am (inclusive)
filter(flights, dep_time == 2400 | (dep_time >= 1 & dep_time <= 600)) or filter(flights, dep_time <=600 | dep_time == 2400)

# Q2. Another useful dplyr filtering helper is between(). What does it do? Can you use it to simplify the code needed to answer the previous challenges?
# A. >(between(x, left, right)) is a simplification of >(x >= left & y <= right)

# Q3. How many flights have a missing dep_time? What other variables are missing? What might these rows represent?
filter(flights, is.na(dep_time))
# A. There are 8255 flights without dep_time

# Q4. Why is NA ^ 0 not missing? Why is NA | TRUE not missing? Why is FALSE & NA not missing? Can you figure out the general rule? (NA * 0 is a tricky counterexample!)
# A. NA ^ 0 is not missing because every imaginable number elevated to 0 is 1. NA * 0 is a missing value, because any operation on a missing value (except for the latter one), returns a missing value. 


# Exercises 5.3.1 - Arrange rows with arrange() ============================================================================================================================

# Q1. How could you use arrange() to sort all missing values to the start? (Hint: use is.na()).
# A. 
arrange(flights, desc(is.na(flights))) or arrange(flights, !is.na(x))

# Q2. Sort flights to find the most delayed flights. Find the flights that left earliest.
# A.
arrange(flights, desc(dep_delay))
arrange(flights, dep_delay)

# Q3. Sort flights to find the fastest (highest speed) flights.
# A.
arrange(flights, desc(distance / air_time))

# Q4. Which flights travelled the farthest? Which travelled the shortest?
# A.
arrange(flights, desc(distance))
arrange(flights, distance)


# Exercises 5.4.1 - Select columns with select() ============================================================================================================================

# Q1. Brainstorm as many ways as possible to select dep_time, dep_delay, arr_time, and arr_delay from flights.
# A.
select(flights, dep_time, dep_delay, arr_time, arr_delay) 
select(flights, (dep_time : arr_delay), -sched_dep_time, -sched_arr_time)
select(flights, (starts_with("arr") | starts_with("dep")))

# Q2. What happens if you include the name of a variable multiple times in a select() call?
# A. If you include the name of a variable multiple times it only outputs the variable once.

# Q3. What does the any_of() function do? Why might it be helpful in conjunction with this vector?
vars <- c("year", "month", "day", "dep_delay", "arr_delay")
# A. any_of() selects any variable that matches any of the strings in the vector.
select(flights, any_of(vars))

# Q4. Does the result of running the following code surprise you? How do the select helpers deal with case by default? How can you change that default?
select(flights, contains("TIME"))
# A. This is the same results as >select(flights, contains("time")), since by deafult the function contains() ignores upper cases. To change this use >select(flights, contains("TIME", ignore.case = FALSE))


# Exercises 5.5.2 - Add new variables with mutate() ============================================================================================================================

# Q1. Currently dep_time and sched_dep_time are convenient to look at, but hard to compute with because they’re not really continuous numbers. Convert them to a more convenient representation of number of minutes since midnight.
# A.
exercise_1 <- select(flights, dep_time, sched_dep_time)
mutate(exercise_1,
       min_dep_time = ((dep_time %/% 100) * 60) + (dep_time %% 100),
       min_sched_dep_time = ((sched_dep_time %/% 100) * 60) + (sched_dep_time %% 100)) #%/% gives the dividend of the division. %% gives the remainder of the division

# Q2. Compare air_time with arr_time - dep_time. What do you expect to see? What do you see? What do you need to do to fix it?
# A.
exercise_2 <- select(flights, dep_time, arr_time, air_time)
exercise_2 <- mutate(exercise_2,
                      dep_time_min = ((dep_time %/% 100) * 60) + (dep_time %% 100),
                      arr_time_min = ((arr_time %/% 100) * 60) + (arr_time %% 100),
                      good_air_time = (abs(arr_time_min - dep_time_min)))
					  
transmute(exercise_2, difference = good_air_time - air_time)

# Q3. Compare dep_time, sched_dep_time, and dep_delay. How would you expect those three numbers to be related?
# A. dep_delay = dep_time - sched_dep_time
select(flights, dep_delay, dep_time, sched_dep_time)

# Q4. Find the 10 most delayed flights using a ranking function. How do you want to handle ties? Carefully read the documentation for min_rank().
# A.
delayed <- mutate(flights, most_delayed = min_rank(desc(arr_delay)))
arrange(delayed, most_delayed)

# Q5. What does 1:3 + 1:10 return? Why?
# A. It returns a sequence (2  4  6  5  7  9  8 10 12 11). Since the 2 vectors don't have teh same length R recycles the shorter one until each vector is the same length. Then R sums the 2 vectors.

# Q6. What trigonometric functions does R provide?
# A. >?Trig


# Exercises 5.6.7 - Grouped summaries with summarise() ============================================================================================================================

# Q1. Brainstorm at least 5 different ways to assess the typical delay characteristics of a group of flights. Consider the following scenarios:

#A flight is 15 minutes early 50% of the time, and 15 minutes late 50% of the time.
flights %>%  group_by(flight) %>%
  summarize(early_15_min = sum(arr_delay <= -15, na.rm = TRUE) / n(),
            late_15_min = sum(arr_delay >= 15, na.rm = TRUE) / n()) %>%
  filter(early_15_min == 0.5, late_15_min == 0.5)

#A flight is always 10 minutes late.
flights %>% group_by(flight) %>%
  summarize(late_10 = sum(arr_delay == 10, na.rm = TRUE) / n()) %>%
  filter(late_10 == 1)

#A flight is 30 minutes early 50% of the time, and 30 minutes late 50% of the time.
flights %>% group_by(flight) %>%
  summarize(early_30_min = sum(arr_delay <= -30, na.rm = TRUE) / n(),
            late_30_min = sum(arr_delay >= 30, na.rm = TRUE) / n()) %>%
  filter(early_30_min == 0.5,
         late_30_min == 0.5)

#99% of the time a flight is on time. 1% of the time it’s 2 hours late.
flights %>% group_by(flight) %>%
  summarize(on_time = sum(arr_delay == 0, na.rm = TRUE) / n(),
            late_2_hours = sum(arr_delay >= 120, na.rm = TRUE) / n()) %>%
  filter(on_time == .99,
         late_2_hours == .01)

# Q2. Come up with another approach that will give you the same output as not_cancelled %>% count(dest) and not_cancelled %>% count(tailnum, wt = distance) (without using count()).
# A.
not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_canceled %>% group_by(dest) %>% 
    summarise(count = n())

not_cancelled %>% group_by(tailnum) %>% 
    summarise(n = sum(distance, na.rm = TRUE))
      
# Q3. Our definition of cancelled flights (is.na(dep_delay) | is.na(arr_delay) ) is slightly suboptimal. Why? Which is the most important column?
# A. There are no flights which arrived but did not depart, so we can just use filter(!is.na(dep_delay))

              
# Q4. Look at the number of cancelled flights per day. Is there a pattern?
# A.
flights %>% filter(is.na(dep_delay)) %>%
    count(day) %>% 
    ggplot(aes(x = day, y = n)) + geom_point()
#There is no pattern
# Is the proportion of cancelled flights related to the average delay?
flights %>% group_by(day) %>%
    summarize(prop_canceled = sum(is.na(dep_delay)) / n(),
              avg_delay = mean(dep_delay, na.rm = TRUE)) %>% 
    ggplot(aes(x = prop_canceled, y = avg_delay)) +
        geom_point() +
        geom_smooth(se = FALSE)
#Higher dealy are realted with higher propotions of cancelled flights

# Q5. Which carrier has the worst delays? Challenge: can you disentangle the effects of bad airports vs. bad carriers? Why/why not? (Hint: think about flights %>% group_by(carrier, dest) %>% summarise(n()))
# A.
flights %>% group_by(carrier) %>% 
    summarise(mean_delay = mean(dep_delay, na.rm = TRUE)) %>% 
    arrange(desc(mean_delay))

# Q6. What does the sort argument to count() do. When might you use it?
# A. The sort argument will sort the results of count() in descencending order of n.


# Exercises 5.7.1 - Grouped mutates (and filters) ============================================================================================================================

# Q1. Refer back to the lists of useful mutate and filtering functions. Describe how each operation changes when you combine it with grouping.
# A. It is applied to groups. For example you can use mutate to create new variables by using group statistics specificly or you can filter out an entire group or filter normally.

# Q2. Which plane (tailnum) has the worst on-time record?
# A. 
flights %>% group_by(tailnum) %>%
  summarize(prop_on_time = sum(arr_delay <= 30, na.rm = TRUE) / n(),
            mean_arr_delay = mean(arr_delay, na.rm = TRUE),
            flights = n()) %>%
  arrange(prop_on_time, desc(mean_arr_delay))
# Plane with tail number N844MH 

# Q3. What time of day should you fly if you want to avoid delays as much as possible?
# A. 
flights %>% group_by(hour) %>%
    summarise(count = n(),
              avg_arr_delay = mean(arr_delay,na.rm = TRUE),
              is_on_time_prop = mean(arr_delay <= 0, na.rm = T)) %>%
    filter(count > 30) %>%
    arrange(desc(is_on_time_prop))
# Flying at 7 am is the best choice to avoid arrival delays.

# Q4. For each destination, compute the total minutes of delay. 
flights %>% filter(!is.na(dep_delay)) %>% 
    group_by(dest) %>% 
    summarise(count = n(),
              total_dep_delay = sum(dep_delay > 0, na.rm = T)) %>% 
    arrange(desc(total_dep_delay))

# For each flight, compute the proportion of the total delay for its destination.
flights %>% filter(!is.na(dep_delay)) %>% 
    group_by(tailnum, dest) %>% 
    summarise(count = n(),
              mean_dep_delay = mean(dep_delay > 0, na.rm = T)) %>% 
    arrange(desc(mean_dep_delay))

# Q5. Delays are typically temporally correlated: even once the problem that caused the initial delay has been resolved, later flights are delayed to allow earlier flights to leave. Using lag(), explore how the delay of a flight is related to the delay of the immediately preceding flight.
# A. 
flights %>% group_by(year, month, day) %>%
  filter(!is.na(dep_delay)) %>%
  mutate(lag_delay = lag(dep_delay)) %>%
  filter(!is.na(lag_delay)) %>%
  ggplot(aes(x = dep_delay, y = lag_delay)) +
    geom_point() +
    geom_smooth()

# Q6. Look at each destination. Can you find flights that are suspiciously fast? (i.e. flights that represent a potential data entry error). Compute the air time of a flight relative to the shortest flight to that destination. Which flights were most delayed in the air?
# A. 
flights %>% filter(!is.na(air_time)) %>%
  group_by(dest) %>%
  mutate(med_air_time = median(air_time),
         o_vs_e = (air_time - med_air_time) / med_air_time,
         air_time_diff = air_time - min(air_time)) %>%
  arrange(desc(air_time_diff)) %>%
  select(air_time, o_vs_e, air_time_diff, dep_time, sched_dep_time, arr_time, sched_arr_time) %>%
  head(15)

# Q7. Find all destinations that are flown by at least two carriers. Use that information to rank the carriers.
# A. 
flights %>% group_by(dest) %>% 
  mutate(n_carrier = n_distinct(carrier)) %>% 
  filter(n_carrier > 1) %>% 
  group_by(carrier) %>% 
  summarise(n_dest = n_distinct(dest)) %>% 
  mutate(rank = min_rank(-n_dest)) %>% 
  arrange(rank)

# Q8. For each plane, count the number of flights before the first delay of greater than 1 hour.
# A. did not understand the question














