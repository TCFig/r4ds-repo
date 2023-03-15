library(tidyverse)

# Exercise 3.2.4 =======================================================================================================================================================

# Q1. Run ggplot(data = mpg). What do you see?
# A. There is no plot since we did not define any x or y variables or any geom.

# Q2. How many rows are in mpg? How many columns?
# A. 11 columns and 234 rows.

# Q3. What does the drv variable describe? Read the help for ?mpg to find out.
# A.
?mpg # drv means type of drive train

# Q4. Make a scatterplot of hwy vs cyl.
# A.
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, x = cyl)
             
# Q5. What happens if you make a scatterplot of class vs drv? Why is the plot not useful?
# A. 
ggplot(mpg, aes(class, drv)) +
    geom_point()
# The plot is not useful since both variables have no relation with each other
             
# Exercise 3.3.1 =======================================================================================================================================================


             
