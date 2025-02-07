# -*- coding: utf-8 -*-
"""
Created on Thu Mar 9 10:24:42 2023

@author: McCormickT
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import statsmodels.api as sm
from sklearn.preprocessing import StandardScaler
from matplotlib.backends.backend_pdf import PdfPages

# Load the Dataset and select the columns
df = pd.read_csv("logRegressionData_Python.csv")

x_cols = ['Google Search', 'Bing Search', 'Facebook', 'The Trade Desk', 'Quantcast', 'Teads', 'YouTube', 'Discovery']
y_col = 'Inquiries'

# Apply a natural log transformation to the x columns and standardize the data
scaler = StandardScaler()

for col in x_cols:
    if df[col].dtype == "object":  # check if the column contains numeric data
        df[col] = df[col].replace(',', '', regex=True)
    
    df[col] = pd.to_numeric(df[col], errors="coerce").fillna(0)  # replace non-numeric data with default 0
    df[col] = scaler.fit_transform(df[[col]])

# Apply a log transformation to y
df[y_col] = pd.to_numeric(df[y_col], errors="coerce").fillna(0)
y = np.log(df[y_col] + 1)  # Log values

# Create a constant term to account for the intercept
x = sm.add_constant(df[x_cols])

# Fit the logarithmic regression model
model = sm.OLS(y, x)
result = model.fit()

# Print the regression results
print(result.summary())

# Plot the Regression Line
fig, ax = plt.subplots()
ax.scatter(y, result.fittedvalues)
ax.set_xlabel("Actual")
ax.set_ylabel("Predicted")
ax.set_title("Log Regression: Actual vs Predicted")
plt.show()

# Export the results to a pdf
with PdfPages("regression_results.pdf") as pdf:
    # Save the Regression results
    pdf.savefig()  # Save the summary table as a PDF file in the same directory
    
    # Save the fig plot to the PDF file
    fig.savefig(pdf, format="pdf")
    
    # Close the figure and PDF objects
    plt.close(fig)
    pdf.close()
