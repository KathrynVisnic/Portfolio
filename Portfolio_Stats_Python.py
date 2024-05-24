import pandas as pd
from IPython.display import display, HTML

#  data from mtcars.csv data set.
cars_df_orig = pd.read_csv("https://s3-us-west-2.amazonaws.com/data-analytics.zybooks.com/mtcars.csv")

#random 30 observations

cars_df = cars_df_orig.sample(n=30, replace=False)

# print only the first five observations in the data set.
print("\nCars data frame (showing only the first five observations)")
display(HTML(cars_df.head().to_html()))

import matplotlib.pyplot as plt

# scatterplot
plt.plot(cars_df["wt"], cars_df["mpg"], 'o', color='red')
plt.title('MPG against Weight')
plt.xlabel('Weight (1000s lbs)')
plt.ylabel('MPG')

# show the plot.
plt.show()

# correlation matrix for mpg and wt.
mpg_wt_corr = cars_df[['mpg','wt']].corr()
print(mpg_wt_corr)

from statsmodels.formula.api import ols

# simple linear regression model with mpg as the response variable and weight as the predictor variable
model = ols('mpg ~ wt', data=cars_df).fit()

#print the model summary
print(model.summary())