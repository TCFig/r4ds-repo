library(tidyverse) #version 1.3.2


# Exercise 3.2.4 - Creating a ggplot =======================================================================================================================================================

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
       
             
# Exercise 3.3.1 - Aesthetic mappings =======================================================================================================================================================

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
# A. The different levels overlap
             
# Q5. What does the stroke aesthetic do? What shapes does it work with? (Hint: use ?geom_point)
# A. 
ggplot(mpg, aes(displ, cty)) +
  geom_point(stroke = 2)
# For geom_point, stroke changes the dimensions of the points on the graph            

# Q6. What happens if you map an aesthetic to something other than a variable name, like aes(colour = displ < 5)? Note, you’ll also need to specify x and y.             
# A. 
ggplot(mpg, aes(displ, cty)) +
  geom_point(aes(color = displ < 5 ))
# It will color the points based on if the displ is higher (False) or lower (True) than 5.

             
# Exercise 3.5.1 - Facets =======================================================================================================================================================            

# Q1. What happens if you facet on a continuous variable?
# A. When the variable is continuous it creates plots for subjects with the exact same value However, you can specify intervals to bypass this.

# Q2. What do the empty cells in plot with facet_grid(drv ~ cyl) mean? How do they relate to this plot?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = drv, y = cyl))    
# A. A blank plot means that there are no subjects with those variables
             
# Q3. What plots does the following code make? What does . do?

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)
# A. The "." is to put the grid of plots in either rows (. ~ drv) or columns (drv ~ .)    
        
# Q4. Take the first faceted plot in this section:

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)
# What are the advantages to using faceting instead of the colour aesthetic? What are the disadvantages? How might the balance change if you had a larger dataset?
# A. Facet separates "class" into different plots making the information less accumulated in a specific place. However facet can sometimes make it harder to see differences between groups. With a larger dataset, it would be best to use facet to facilitate reading, however grouping by color could be also useful to see if they're could be any clusters forming. 
             
# Q5. Read ?facet_wrap. What does nrow do? What does ncol do? What other options control the layout of the individual panels? Why doesn’t facet_grid() have nrow and ncol arguments?
# A. nrow -> number of rows to divide the data; ncol -> number of columns to divide the data. Contrarly, >facet_grid automatically decides the number of col and rows based on the number of categories in a varibale 
             
# Q6. When using facet_grid() you should usually put the variable with more unique levels in the columns. Why?             
# A. Because variables with lower number of categories should always be inputed in columns. The opposite with rows. This makes it easier to read the plot.

             
# Exercise 3.6.1 - Geometric Objects =======================================================================================================================================================            
            
# Q1. What geom would you use to draw a line chart? A boxplot? A histogram? An area chart?
# A. Line chart -> geom_smooth, geom_line, geom_path; Boxplot -> geom_boxplot; Histogram -> geom_histogram; Area chart -> geom_area
             
# Q2. Run this code in your head and predict what the output will look like. Then, run the code in R and check your predictions.
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth(se = FALSE)
# A. Can't respond
             
# Q3. What does show.legend = FALSE do? What happens if you remove it? Why do you think I used it earlier in the chapter?
# A. show.legend = FALSE, hides the legend of the plot. When you remove this, it goes back to defalut (show.legend = TRUE), showing the legend. 
             
# Q4. What does the se argument to geom_smooth() do?
# A. geom_smooths aids the eye in seeing patterns in the presence of overplotting. se is responsible for the displya of the confidence interval around the line.

# Q5. Will these two graphs look different? Why/why not?
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()

ggplot() + 
  geom_point(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_smooth(data = mpg, mapping = aes(x = displ, y = hwy))
#A. They won't look different, they code for the same thing. The first one just maps goblally for both geoms.
             
# Q6. Recreate the R code necessary to generate the following graphs.
# A.
#plot_1
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
    geom_point(size = 3) +
    geom_smooth(se=FALSE)
#plot_2
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
    geom_point(size = 3) +
    geom_smooth(mapping = aes(group = drv), se=FALSE)
#plot_3
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) +
    geom_point(size = 3) +
    geom_smooth(se=FALSE)
#plot_4
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
    geom_point(mapping = aes(color = drv), size = 3) +
    geom_smooth(se=FALSE)
#plot_5
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
    geom_point(mapping = aes(color = drv), size = 3) +
    geom_smooth(mapping = aes(linetype = drv), se=FALSE)
#plot_6
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
    geom_point(color = "white", size = 5) +
    geom_point(mapping = aes(color = drv), size = 3)
             
             
# Exercise 3.7.1 - Statistical transformations =======================================================================================================================================================            
                         
# Q1. What is the default geom associated with stat_summary()? How could you rewrite the previous plot to use that geom function instead of the stat function?
#A. stat_summary() is associated with geom_pointrange()
ggplot(data = diamonds) + 
  geom_pointrange(mapping = aes(x = cut, y = depth), 
	  stat = "summary",
	  fun.min = min,
	  fun.max = max, 
	  fun = median)

# Q2. What does geom_col() do? How is it different to geom_bar()?
# A. geom_col() and geom_bar() are both bar charts. However, geom_bar() counts the number of cases for each category, where as geom_col() sums the values of a continuous variable that is specified.
             
# Q3. Most geoms and stats come in pairs that are almost always used in concert. Read through the documentation and make a list of all the pairs. What do they have in common?
# A. to see pairs of geoms and stats --> https://ggplot2.tidyverse.org/reference/
             
# Q4. What variables does stat_smooth() compute? What parameters control its behaviour?
# A. stat_smooth() computed variables: y or x, predicted value; ymin or xmin, lower pointwise confidence interval around the mean; ymax or xmax upper pointwise confidence interval around the mean; se, standard error
# Most important parameters to control behavior of stat_smooth(): method, controls smoothing method to be performed; se, determines if standard erros should be plotted; level - confidence interval.
             
# Q5. In our proportion bar chart, we need to set group = 1. Why? In other words what is the problem with these two graphs?
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = after_stat(prop)))
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = color, y = after_stat(prop)))        
# A. By setting group = 1 we create a dummy variable, that corresponds to the proportion of the categories in the dataset. Without it, R would perform an ideal cut (100%)
            
             
# Exercise 3.8.1 - Position adjustments =======================================================================================================================================================               

# Q1. What is the problem with this plot? How could you improve it?
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_point()
# A. Many points of the plot overlap (because cty is rounded) and the plot only shows a fraction of the data. We can use the parameter position = jitter to add random noise making the plot more revealing at larger scales

# Q2. What parameters to geom_jitter() control the amount of jittering?
# A. The parameters height and weight in geom_jitter() control the amount of jitter vertically and horizontally, respectively.
             
# Q3. Compare and contrast geom_jitter() with geom_count().
# A. geom_jitter() adds random noise for each point; geom_count() counts number of points counts number of points clustered in a specific area (dimension of point is related with the counts) and does a scatterplot

# Q4. What’s the default position adjustment for geom_boxplot()? Create a visualisation of the mpg dataset that demonstrates it.
# A. geom_boxplot() default position is dodge2
ggplot(mpg, aes(class, hwy)) +
  geom_boxplot(position = "dodge2")

             
# Exercise 3.9.1 - Coordinate systems =======================================================================================================================================================               

# Q1. Turn a stacked bar chart into a pie chart using coord_polar().
graph + coord_polar(theta = "x") # theta, variable to map angle to
             
# Q2. What does labs() do? Read the documentation.
# A. labs() enables the modification of axis labels, legends, plot labels... (everything related with labelling the plot)

# Q3. What’s the difference between coord_quickmap() and coord_map()?
# A. coord_quickmap() is an aproximation of coord_map(), which requires a lot more computational power.
             
# Q4. What does the plot below tell you about the relationship between city and highway mpg? Why is coord_fixed() important? What does geom_abline() do?
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() + 
  geom_abline() +
  coord_fixed()
# A. The plot shows a positive correlation between hwy and cty. coor_fixed() absically lets us change the plot ratios (default is ratio = 1, which means the x an y axis have the same scale). This parameter is important because it lets us see the true slope of the line. geom_abline(), draws a line with interception in 0 and slope = 1

# 3.10 - The layered grammar of graphics ======================================================================================================================================================= 

ggplot(data = <DATA>) + 
  <GEOM_FUNCTION>(
     mapping = aes(<MAPPINGS>),
     stat = <STAT>, 
     position = <POSITION>
  ) +
  <COORDINATE_FUNCTION> +
  <FACET_FUNCTION>
             
# These 7 parameters compose the grammar of graphics
