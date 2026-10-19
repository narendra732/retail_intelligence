# Retail Sales & Profitability Analysis

An end-to-end business intelligence project using MySQL and Power BI to evaluate sales performance, profitability, product-level losses, discount patterns, regional results, and customer segments.

The project combines SQL-based analysis with an interactive three-page Power BI report. The dashboard uses a dark charcoal canvas with emerald-green accents to establish a consistent visual system across pages.

## Business Problem

Sales volume alone does not explain business performance. A retailer also needs to understand which products and customer segments generate profit, where losses occur, how performance varies by region, and whether discount patterns are associated with lower profitability.

This project addresses those questions by organizing the Sample Superstore order data into reusable metrics and interactive Power BI visuals.

## Project Objectives

- Establish baseline sales, profit, order, and customer KPIs.
- Compare sales and profitability across product categories, sub-categories, regions, and customer segments.
- Identify the most profitable products and products with negative aggregate profit.
- Examine discount and profit patterns without assuming that correlation proves causation.
- Present results in an executive-friendly dashboard that supports filtering and exploration.

## Tools and Technologies

- **MySQL** — data validation, aggregation, grouping, date parsing, and profitability analysis.
- **Power BI Desktop** — data modelling and interactive report design.
- **DAX** — reusable measures for sales, profit, margin, orders, customers, and discount analysis.
- **Power Query** — assigning appropriate date and numeric data types after importing the source table.
- **Excel / CSV** — source data inspection and preparation.

## Dataset

The analysis uses the Sample Superstore dataset, containing order, customer, product, shipping, sales, discount, and profit information.

| Dataset measure | Validated result |
|---|---:|
| Records | 9,994 |
| Distinct orders | 5,009 |
| Distinct customers | 793 |
| Total sales | $2,297,200.86 |
| Total profit | $286,397.02 |
| Overall profit margin | 12.47% |
| Average order-line discount | 15.62% |

The measures above describe the imported dataset without report filters. Values displayed in Power BI may be abbreviated (for example, 2.30M) based on each visual's display-unit settings.

**Data note:** Check the terms of the dataset's original source before redistributing the raw CSV. If redistribution is not permitted or the source terms are unclear, publish the SQL, Power BI report where appropriate, and dashboard screenshots without committing the raw dataset.

## Power BI Report

The report contains three pages built around a consistent dark charcoal and emerald-green design.

### 1. Executive Overview

Provides a high-level view of business performance, including:

- Total Sales, Total Profit, Profit Margin, and Total Orders KPIs
- Monthly sales and profit trend
- Profit by product category
- Profit by region
- Top products by profit

### 2. Product & Profitability Analysis

Focuses on product-level performance and sources of losses, including:

- Total Sales, Total Profit, Average Discount, and Loss-Making Products KPIs
- Top 10 profitable products
- Top 10 loss-making products
- Profitability by sub-category
- Discount versus profit analysis

### 3. Regional & Customer Analysis

Compares performance by geography and customer segment, including:

- Total Sales, Total Profit, Total Customers, and Profit Margin KPIs
- Sales by region
- Profit by customer segment
- Sales by customer segment
- Top 10 customers by sales

The report is designed to support exploration through visual-level filters and slicers where configured.

## Key Findings

Based on the validated aggregate results and the report visuals:

1. **Technology is the strongest profit contributor by category**, generating approximately $145.5K in profit. Office Supplies contributes approximately $122.5K, while Furniture contributes approximately $18.5K.
2. **The West region leads in sales and profit** in the regional comparison. The Central region generates less profit than the other regions, warranting closer investigation rather than a sales-only assessment.
3. **Profitability differs substantially across products.** The most profitable products and the largest-loss products are not necessarily the same products with the highest sales volume.
4. **The Consumer segment contributes the largest share of total profit** among the three customer segments.
5. **Discounts deserve additional review at product and sub-category level.** The discount-versus-profit visual is exploratory: it can show associations, but it does not establish that discounts caused a loss.

## Recommendations

- Review pricing, cost, and discount practices for products with persistent negative aggregate profit before deciding whether to reprice, reduce discounting, or discontinue them.
- Assess sub-categories on profit as well as sales volume; high revenue does not automatically imply strong profitability.
- Investigate the Central region's lower profit contribution by comparing its product mix, discounting, and order composition with higher-performing regions.
- Use discount analysis as a diagnostic signal and validate proposed changes with further analysis before implementing them.
- Monitor the core KPIs over time and use report filters to investigate the products, regions, and customer segments driving material changes.

These are analytical recommendations for further investigation, not causal conclusions.

## Core DAX Measures

The report uses reusable measures similar to the following examples. The underlying columns must be typed correctly as numeric fields in Power Query.

```dax
Total Sales =
SUM('superstore_raw_import'[Sales])

Total Profit =
SUM('superstore_raw_import'[Profit])

Profit Margin % =
DIVIDE([Total Profit], [Total Sales], 0)

Total Orders =
DISTINCTCOUNT('superstore_raw_import'[Order ID])

Total Customers =
DISTINCTCOUNT('superstore_raw_import'[Customer ID])

Average Order Value =
DIVIDE([Total Sales], [Total Orders], 0)

Average Discount % =
AVERAGE('superstore_raw_import'[Discount])

Loss-Making Products =
COUNTROWS(
    FILTER(
        VALUES('superstore_raw_import'[Product Name]),
        CALCULATE([Total Profit]) < 0
    )
)
```

## SQL Analysis

The SQL workflow includes:

- Row-count and distinct-key validation
- Overall sales, profit, and profit-margin KPIs
- Category and sub-category profitability
- Regional performance
- Customer-segment performance
- Product-level profit and loss ranking
- Discount analysis
- Monthly sales and profit trends

A consolidated script is provided in [`sql/retail_sales_analysis.sql`](sql/retail_sales_analysis.sql). It expects a MySQL database named `retail_sales` and an imported table named `superstore_raw_import` with the column names used in the script.

## Repository Structure

```text
retail-sales-profitability-analysis/
├── README.md
├── retail_sales_analysis.pbix       # Add your Power BI report file
├── sql/
│   └── retail_sales_analysis.sql
└── images/
    ├── dashboard-1-executive-overview.png
    ├── dashboard-2-product-profitability.png
    └── dashboard-3-regional-customer-analysis.png
```

The `.pbix` file and screenshot images are not included with this README automatically. Add your own report file and export or capture the final report pages, then save the screenshots using the filenames shown above so they can be embedded below.

## Dashboard Screenshots

### Executive Overview

![Executive Overview](images/dashboard-1-executive-overview.png)

### Product & Profitability Analysis

![Product & Profitability Analysis](images/dashboard-2-product-profitability.png)

### Regional & Customer Analysis

![Regional & Customer Analysis](images/dashboard-3-regional-customer-analysis.png)

## How to Reproduce the Analysis

1. Obtain the Sample Superstore dataset from its original source and review its redistribution terms.
2. Create a MySQL database named `retail_sales` and import the dataset into a table named `superstore_raw_import`.
3. Confirm that the imported row count and KPI totals match the validation figures in this README. The SQL import table may initially use text fields; cast values for SQL calculations or convert the data types in Power Query before using them in DAX.
4. Open the SQL script in MySQL Workbench and run the required analyses.
5. Open the Power BI report, connect or load the same dataset, set date and numeric data types, and verify the DAX measures.
6. Review the report without filters and confirm that the KPI totals align with the validated results.

## Limitations

- This project analyzes historical sales records; findings should not be treated as a forecast.
- Discount and profit patterns are descriptive and do not, by themselves, establish causation.
- Product, region, and segment recommendations should be validated against cost, pricing, operational, and commercial context before decisions are made.
- The report's totals depend on the dataset version, data preparation, and active report filters.

## Author

**Narendra Gopi**

Data Analytics Portfolio Project — MySQL and Power BI
