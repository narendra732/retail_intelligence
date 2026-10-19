CREATE DATABASE retail_sales;
USE retail_sales;
DROP TABLE IF EXISTS superstore_raw_import;

CREATE TABLE superstore_raw_import (
    `Row ID` VARCHAR(30),
    `Order ID` VARCHAR(100),
    `Order Date` VARCHAR(40),
    `Ship Date` VARCHAR(40),
    `Ship Mode` VARCHAR(50),
    `Customer ID` VARCHAR(50),
    `Segment` VARCHAR(50),
    `Country` VARCHAR(100),
    `City` VARCHAR(100),
    `State` VARCHAR(100),
    `Region` VARCHAR(50),
    `Product ID` VARCHAR(50),
    `Category` VARCHAR(50),
    `Sub-Category` VARCHAR(50),
    `Product Name` TEXT,
    `Sales` VARCHAR(50),
    `Quantity` VARCHAR(30),
    `Discount` VARCHAR(30),
    `Profit` VARCHAR(50)
);

LOAD DATA LOCAL INFILE
'C:\Users\narendragopi\Downloads\sales2.csv'
INTO TABLE retail_sales.superstore_raw_import
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

SELECT COUNT(*) AS total_rows
FROM retail_sales.superstore_raw_import;

SET GLOBAL local_infile = ON;

SHOW GLOBAL VARIABLES LIKE 'local_infile';


LOAD DATA LOCAL INFILE
'C:/Users/narendragopi/Downloads/sales2.csv'
INTO TABLE retail_sales.superstore_raw_import
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

SELECT * 
FROM retail_sales.superstore_raw_import;

USE retail_sales;

-- First, verify the imported dataset
SELECT COUNT(*) AS total_rows
FROM superstore_raw_import;

-- Category sales and profitability analysis
SELECT
    `Category`,
    ROUND(SUM(CAST(NULLIF(TRIM(`Sales`), '') AS DECIMAL(12,2))), 2)
        AS total_sales,
    ROUND(SUM(CAST(NULLIF(TRIM(`Profit`), '') AS DECIMAL(12,2))), 2)
        AS total_profit,
    ROUND(
        100.0 * SUM(CAST(NULLIF(TRIM(`Profit`), '') AS DECIMAL(12,2)))
        / NULLIF(
            SUM(CAST(NULLIF(TRIM(`Sales`), '') AS DECIMAL(12,2))),
            0
        ),
        2
    ) AS profit_margin_pct
FROM superstore_raw_import
GROUP BY `Category`
ORDER BY total_sales DESC;
USE retail_sales;

SELECT
    `Product Name`,
    `Category`,
    `Sub-Category`,
    ROUND(SUM(CAST(`Sales` AS DECIMAL(12,2))), 2) AS total_sales,
    ROUND(SUM(CAST(`Profit` AS DECIMAL(12,2))), 2) AS total_profit
FROM superstore_raw_import
GROUP BY
    `Product Name`,
    `Category`,
    `Sub-Category`
HAVING SUM(CAST(`Profit` AS DECIMAL(12,2))) < 0
ORDER BY total_profit ASC
LIMIT 10;
#region based sales
USE retail_sales;

SELECT
    `Region`,
    ROUND(SUM(CAST(`Sales` AS DECIMAL(12,2))), 2) AS total_sales,
    ROUND(SUM(CAST(`Profit` AS DECIMAL(12,2))), 2) AS total_profit,
    ROUND(
        100 * SUM(CAST(`Profit` AS DECIMAL(12,2)))
        / NULLIF(SUM(CAST(`Sales` AS DECIMAL(12,2))), 0),
        2
    ) AS profit_margin_pct
FROM superstore_raw_import
GROUP BY `Region`
ORDER BY total_profit DESC;
#which type of customer contributes the most sales and profit?

USE retail_sales;

SELECT
    `Segment`,
    ROUND(SUM(CAST(`Sales` AS DECIMAL(12,2))), 2) AS total_sales,
    ROUND(SUM(CAST(`Profit` AS DECIMAL(12,2))), 2) AS total_profit,
    ROUND(
        100 * SUM(CAST(`Profit` AS DECIMAL(12,2)))
        / NULLIF(SUM(CAST(`Sales` AS DECIMAL(12,2))), 0),
        2
    ) AS profit_margin_pct
FROM superstore_raw_import
GROUP BY `Segment`
ORDER BY total_profit DESC;

SELECT
    `Sub-Category`,
    ROUND(AVG(CAST(`Discount` AS DECIMAL(10,4))) * 100, 2)
        AS avg_discount_pct,
    ROUND(SUM(CAST(`Sales` AS DECIMAL(12,2))), 2)
        AS total_sales,
    ROUND(SUM(CAST(`Profit` AS DECIMAL(12,2))), 2)
        AS total_profit
FROM superstore_raw_import
GROUP BY `Sub-Category`
ORDER BY avg_discount_pct DESC;

USE retail_sales;
USE retail_sales;

#monthly profit
SELECT
    DATE_FORMAT(
        STR_TO_DATE(TRIM(`Order Date`), '%Y-%m-%d'),
        '%Y-%m'
    ) AS order_month,

    ROUND(
        SUM(CAST(`Sales` AS DECIMAL(12,2))),
        2
    ) AS total_sales,

    ROUND(
        SUM(CAST(`Profit` AS DECIMAL(12,2))),
        2
    ) AS total_profit

FROM superstore_raw_import

WHERE STR_TO_DATE(TRIM(`Order Date`), '%Y-%m-%d') IS NOT NULL

GROUP BY order_month
ORDER BY order_month;

#business metrics
USE retail_sales;

SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT `Order ID`) AS total_orders,
    COUNT(DISTINCT `Customer ID`) AS unique_customers,

    ROUND(
        SUM(CAST(`Sales` AS DECIMAL(12,2))), 2
    ) AS total_sales,

    ROUND(
        SUM(CAST(`Profit` AS DECIMAL(12,2))), 2
    ) AS total_profit,

    ROUND(
        100 * SUM(CAST(`Profit` AS DECIMAL(12,2)))
        / NULLIF(SUM(CAST(`Sales` AS DECIMAL(12,2))), 0),
        2
    ) AS profit_margin_pct

FROM superstore_raw_import;
