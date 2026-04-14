import pandas as pd

# Load data 
df = pd.read_csv('cleaned_data.csv')

# 'Amount' column serched outliers incolums
outliers = df[df['Amount'] > df['Amount'].mean() + 3 * df['Amount'].std()]

# Outliers save
outliers.to_csv('suspicious_transactions.csv')
print("Python cleaning done!")
