-- =====================================================
-- PHARMACEUTICAL SALES & PRESCRIPTION ANALYSIS
-- =====================================================

DROP DATABASE IF EXISTS pharma_sales;

CREATE DATABASE pharma_sales;

USE pharma_sales;

-- =====================================================
-- CREATE TABLE
-- =====================================================

Drop table if exists pharma_data;
CREATE TABLE pharma_data (

    Transaction_ID INT PRIMARY KEY,

    Date DATE,

    Year INT,

    Month VARCHAR(20),

    Quarter INT,

    Drug_Name VARCHAR(100),

    Drug_Category VARCHAR(100),

    State VARCHAR(50),

    City VARCHAR(50),

    Sales_Rep VARCHAR(100),

    Customer_Type VARCHAR(50),

    Doctor_Specialty VARCHAR(100),

    Patient_Gender VARCHAR(20),

    Patient_Age INT,

    Prescriptions INT,

    Units_Sold INT,

    Unit_Price DOUBLE,

    Discount_Percentage DOUBLE,

    Revenue DOUBLE,

    Cost DOUBLE,

    Profit DOUBLE,

    Profit_Margin_percentage DOUBLE,

    Revenue_Per_Prescription DOUBLE,

    Cost_Per_Unit DOUBLE,

    Revenue_Per_Unit DOUBLE,

    Age_Group VARCHAR(30),

    Season VARCHAR(20),

    Day VARCHAR(20),

    Month_Number INT,

    Week INT

);

LOAD DATA LOCAL INFILE
'D:/Pharmaceutical sales and Precription Analysis/clean_pharma_data.csv'

INTO TABLE pharma_data

FIELDS TERMINATED BY ','

ENCLOSED BY '"'

LINES TERMINATED BY '\r\n'

IGNORE 1 ROWS

(

Transaction_ID,

@Date,

Year,

Month,

Quarter,

Drug_Name,

Drug_Category,

State,

City,

Sales_Rep,

Customer_Type,

Doctor_Specialty,

Patient_Gender,

Patient_Age,

Prescriptions,

Units_Sold,

Unit_Price,

Discount_Percentage,

Revenue,

Cost,

Profit,

Profit_Margin_Percentage,

Revenue_Per_Prescription,

Cost_Per_Unit,

Revenue_Per_Unit,

Age_Group,

Season,

Day,

Month_Number,

Week

)

SET Date = STR_TO_DATE(@Date,'%d-%m-%Y');

SELECT COUNT(*) FROM pharma_data;

SELECT * FROM pharma_data LIMIT 10;

DESCRIBE pharma_data;

# Business Queries
-- Total Revenue
SELECT SUM(Revenue) AS Total_Revenue
FROM pharma_data;

-- Total_Profit
SELECT SUM(Profit) AS Total_Profit
FROM pharma_data;

-- Total Prescriptions
SELECT SUM(Prescriptions) AS Total_Prescriptions
FROM pharma_data;

-- Total_Units Sold
SELECT SUM(Units_Sold) AS Total_Units
FROM pharma_data;

-- Average Revenue
SELECT AVG(Revenue)
FROM pharma_data;

-- Number of Orders
SELECT COUNT(*)
FROM pharma_data;

-- Average Profit Margin
SELECT AVG(Profit_Margin_Percentage) AS Avg_Profit_Margin
FROM pharma_data;



# Revenue Analysis
-- Revenue by Drug
SELECT
Drug_Name,
SUM(Revenue) AS Revenue
FROM pharma_data
GROUP BY Drug_Name
ORDER BY Revenue DESC;

-- Revenue by Drug Category
SELECT
Drug_Category,
SUM(Revenue) AS Revenue
FROM pharma_data
GROUP BY Drug_Category
ORDER BY Revenue DESC;

-- Revenue by State
SELECT
State,
SUM(Revenue) AS Revenue
FROM pharma_data
GROUP BY State
ORDER BY Revenue DESC;

-- Revenue by City
SELECT
City,
SUM(Revenue) Revenue
FROM pharma_data
GROUP BY City
ORDER BY Revenue DESC;

-- Revenue by Sales Representative
SELECT
Sales_Rep,
SUM(Revenue) Revenue
FROM pharma_data
GROUP BY Sales_Rep
ORDER BY Revenue DESC;

-- Revenue by Customer Type
SELECT
Customer_Type,
SUM(Revenue) Revenue
FROM pharma_data
GROUP BY Customer_Type;

-- Revenue by Doctor Specialty
SELECT
Doctor_Specialty,
SUM(Revenue) Revenue
FROM pharma_data
GROUP BY Doctor_Specialty
ORDER BY Revenue DESC;

-- Revenue by Gender
SELECT
Patient_Gender,
SUM(Revenue) Revenue
FROM pharma_data
GROUP BY Patient_Gender;

--  Revenue by Age Group
SELECT
Age_Group,
SUM(Revenue) Revenue
FROM pharma_data
GROUP BY Age_Group;

-- Revenue by Season
SELECT
Season,
SUM(Revenue) Revenue
FROM pharma_data
GROUP BY Season;

-- Monthly Revenue
SELECT
Month,
SUM(Revenue) Revenue
FROM pharma_data
GROUP BY Month_Number, Month
ORDER BY Month_Number;

-- Quarterly Revenue
SELECT
Quarter,
SUM(Revenue) Revenue
FROM pharma_data
GROUP BY Quarter;

-- Yearly Revenue
SELECT
Year,
SUM(Revenue) Revenue
FROM pharma_data
GROUP BY Year;

-- Weekly Revenue
SELECT
Week,
SUM(Revenue) Revenue
FROM pharma_data
GROUP BY Week
ORDER BY Week;

-- Top 10 Drugs
SELECT
Drug_Name,
SUM(Revenue) Revenue
FROM pharma_data
GROUP BY Drug_Name
ORDER BY Revenue DESC
LIMIT 10;

-- Bottom 10 Drugs
SELECT
Drug_Name,
SUM(Revenue) Revenue
FROM pharma_data
GROUP BY Drug_Name
ORDER BY Revenue
LIMIT 10;

-- Most Sold Drugs
SELECT
Drug_Name,
SUM(Units_Sold) Units
FROM pharma_data
GROUP BY Drug_Name
ORDER BY Units DESC;

-- Average Unit Price
SELECT
Drug_Name,
AVG(Unit_Price) Avg_Price
FROM pharma_data
GROUP BY Drug_Name;

-- Average Unit Price
SELECT
Drug_Name,
AVG(Unit_Price) Avg_Price
FROM pharma_data
GROUP BY Drug_Name;

-- Highest Profit Drug
SELECT
Drug_Name,
SUM(Profit) Profit
FROM pharma_data
GROUP BY Drug_Name
ORDER BY Profit DESC;

-- Average Revenue per Prescription
SELECT
Drug_Name,
AVG(Revenue_Per_Prescription)
FROM pharma_data
GROUP BY Drug_Name;

# Advanced Queries
-- Running Revenue
SELECT
Date,
Revenue,
SUM(Revenue) OVER(ORDER BY Date) Running_Revenue
FROM pharma_data;

-- Drug Revenue Ranking
SELECT
Drug_Name,
SUM(Revenue) Revenue,
RANK() OVER(ORDER BY SUM(Revenue) DESC) Drug_Rank
FROM pharma_data
GROUP BY Drug_Name;

-- Top 3 Drugs in Each Category
SELECT *
FROM
(
SELECT
Drug_Category,
Drug_Name,
SUM(Revenue) Revenue,
ROW_NUMBER() OVER(
PARTITION BY Drug_Category
ORDER BY SUM(Revenue) DESC
) rn
FROM pharma_data
GROUP BY Drug_Category, Drug_Name
) t
WHERE rn<=3;

-- Revenue Above Average
SELECT *
FROM pharma_data
WHERE Revenue >
(
SELECT AVG(Revenue)
FROM pharma_data
);

-- Month-over-Month Revenue
SELECT
Year,
Month_Number,
Month,
SUM(Revenue) Revenue,
LAG(SUM(Revenue)) OVER(
ORDER BY Year, Month_Number
) Previous_Month
FROM pharma_data
GROUP BY Year, Month_Number, Month;

-- Profit Ranking by Sales Representative
SELECT
Sales_Rep,
SUM(Profit) Profit,
DENSE_RANK() OVER(
ORDER BY SUM(Profit) DESC
) Profit_Rank
FROM pharma_data
GROUP BY Sales_Rep;

-- Revenue Contribution %
SELECT
Drug_Name,
SUM(Revenue) Revenue,
ROUND(
SUM(Revenue)*100/
SUM(SUM(Revenue)) OVER(),2
) Contribution_Percentage
FROM pharma_data
GROUP BY Drug_Name
ORDER BY Revenue DESC;

-- Year-over-Year Growth
SELECT
Year,
SUM(Revenue) Revenue,
LAG(SUM(Revenue)) OVER(
ORDER BY Year
) Previous_Year,
ROUND(
(
SUM(Revenue)-LAG(SUM(Revenue)) OVER(ORDER BY Year)
)
/
LAG(SUM(Revenue)) OVER(ORDER BY Year)
*100,2
) Growth_Percentage
FROM pharma_data
GROUP BY Year;

-- Top 5 Cities by Revenue
SELECT
City,
SUM(Revenue) Revenue
FROM pharma_data
GROUP BY City
ORDER BY Revenue DESC
LIMIT 5;

-- Top 5 States by Profit
SELECT
State,
SUM(Profit) Profit
FROM pharma_data
GROUP BY State
ORDER BY Profit DESC
LIMIT 5;

