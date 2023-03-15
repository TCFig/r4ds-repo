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

# Q1. What’s gone wrong with this code? Why are the points not blue?
# A.
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = "blue"))
# color = "blue" should be outside of aes(). When inside, R defines blue as a varible

# Q2. Which variables in mpg are categorical? Which variables are continuous? (Hint: type ?mpg to read the documentation for the dataset). How can you see this information when you run mpg?
# A. When you print the matrix (>mpg), you can see below the variable names - chr: character vector (categorical); dbl: double vectors (real numbers); int: integer object.
             
# Q3. Map a continuous variable to color, size, and shape. How do these aesthetics behave differently for categorical vs. continuous variables?
# A. Categorical variables can only be mapped to color or shape (shape, if < 6 categories). Continuous variables can only be mapped to size
             
# Q4. What happens if you map the same variable to multiple aesthetics?
# A. 
             
# Q5. What does the stroke aesthetic do? What shapes does it work with? (Hint: use ?geom_point)
# A.              

# Q6. What happens if you map an aesthetic to something other than a variable name, like aes(colour = displ < 5)? Note, you’ll also need to specify x and y.             
# A.
             
# Exercise 3.5.1 =======================================================================================================================================================            

             
             
             
             
             
             
             
             
             
             
             
             
             
             
             
             
             
             
             
             
