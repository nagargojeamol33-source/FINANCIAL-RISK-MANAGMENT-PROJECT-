# 1. Handling Duplicates:
  Remove identical transaction entries
WITH DuplicateCTE AS (
    SELECT *, ROW_NUMBER() OVER (
        PARTITION BY TransactionID, Date, Amount, Customer_Name 
        ORDER BY TransactionID) AS row_num
    FROM Raw_Finance_Data
)
DELETE FROM DuplicateCTE WHERE row_num > 1;

#2. Standardizing Text:
  Remove extra spaces from Customer Names
UPDATE Raw_Finance_Data
SET Customer_Name = TRIM(Customer_Name);

#3. Fixing Casing Inconsistency:
  Convert all Currency codes to Uppercase (USD, INR)
UPDATE Raw_Finance_Data
SET Currency = UPPER(Currency);
# 4. Handling NULL Values:
  Fill missing Categories with 'Uncategorized'
UPDATE Raw_Finance_Data
SET Category = COALESCE(Category, 'Uncategorized');

#5. Data Type Formatting:
  Ensure the Date column is in proper DATE format
ALTER TABLE Raw_Finance_Data 
ALTER COLUMN Date SET DATA TYPE DATE;

# 6. Filtering Outliers/Invalid Data: Remove transactions with negative or zero amounts
DELETE FROM Raw_Finance_Data
WHERE Amount <= 0;

#7. Categorical Standardization:
  Fix "SALES" vs "Sales" vs "Sls"
UPDATE Raw_Finance_Data
SET Category = 'Sales'
WHERE Category IN ('SALES', 'Sls', 'Sale');

#8. Creating Derived Columns: 
  Add a 'Fiscal_Year' column for better reporting
ALTER TABLE Raw_Finance_Data ADD COLUMN Fiscal_Year INT;
UPDATE Raw_Finance_Data
SET Fiscal_Year = CASE 
    WHEN MONTH(Date) >= 4 THEN YEAR(Date) 
    ELSE YEAR(Date) - 1 
END;
