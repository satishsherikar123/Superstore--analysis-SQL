# Retail Sales and Profitability Analysis (SQL)

An end-to-end SQL analysis of the Super Store retail dataset (**9,994 records**) to find out where the business makes money, where it loses it, and what is driving the losses.

## Objective

Answer key business questions using only SQL:

- Which regions, categories and sub-categories drive sales and profit?
- How much profit is being lost, and where?
- How do discounts affect profitability?
- Which products and locations should the business review first?

## Dataset

| Item | Detail |
|---|---|
| Source | Super Store sales data |
| Records | 9,994 |
| Table name | `store` |
| Key columns | Region, State, City, Segment, Category, Sub_Category, Ship_Mode, Sales, Quantity, Discount, Profit |

## Tools and SQL Concepts

- **SQL** (MySQL 8+ / PostgreSQL compatible)
- Aggregations: `SUM`, `AVG`, `COUNT`, `ROUND`
- Filtering and grouping: `WHERE`, `GROUP BY`, `HAVING`
- Subqueries and `CASE WHEN` (discount banding)
- Window functions: `RANK()`, `ROW_NUMBER()`, running totals, share of total
- Pivot using conditional aggregation

## What the 25 Queries Cover

| Section | Queries | Focus |
|---|---|---|
| A. Basic exploration | 1 - 10 | Row counts, totals, distinct values, sales by region, top cities, loss-making records |
| B. Profitability and ranking | 11 - 15 | Profit margin by category, top/bottom sub-categories, above-average states |
| C. Discount and loss analysis | 16 - 20 | Discount bands vs profit, regional losses, loss-making cities, category sales share |
| D. Window functions and pivot | 21 - 25 | Rank within category, top 3 states per region, running total, profit contribution, category x segment pivot |

All queries are in [`queries.sql`](queries.sql).

## Key Findings

**Overall:** About **2.30M in sales** and **286.4K in profit** across 9,994 records, but **1,871 records (about 18.7%) are loss-making**.

**1. Heavy discounts destroy profit**

| Discount band | Records | Avg profit | Total profit |
|---|---|---|---|
| No discount | 4,798 | 66.90 | 320,987.60 |
| Low (0-20%) | 3,803 | 26.50 | 100,785.47 |
| Medium (20-40%) | 460 | -77.86 | -35,817.47 |
| High (>40%) | 933 | -106.71 | -99,558.59 |

Profit turns negative once discounts go above 20%. The medium and high bands together lose about 135K.

**2. Furniture has a very thin margin**

| Category | Sales | Sales share | Profit margin |
|---|---|---|---|
| Technology | 836,154.03 | 36.4% | 17.4% |
| Furniture | 741,999.80 | 32.3% | 2.49% |
| Office Supplies | 719,047.03 | 31.3% | 17.04% |

Furniture brings in nearly a third of sales but earns almost no profit.

**3. Two sub-categories are loss-making with high discounts**

| Sub-category | Avg discount | Total profit |
|---|---|---|
| Tables | 26% | -17,725.48 |
| Bookcases | 21% | -3,472.56 |

**4. Losses are concentrated in the Central and East regions**

Total loss from loss-making records by region:

| Region | Total loss |
|---|---|
| Central | -56,314.89 |
| East | -49,590.61 |
| South | -27,504.83 |
| West | -22,720.96 |

## Business Recommendations

- Cap or review discounts above 20%, since they are the main driver of negative profit.
- Review pricing and discount policy for Tables and Bookcases.
- Investigate Central and East regions for the causes of high losses.
- Improve Furniture profitability before pushing more volume in that category.

## Repository Structure

```
retail-sales-sql-analysis/
├── README.md
├── queries.sql        # all 25 SQL queries
└── superstore.csv     # dataset
```

## How to Run

1. Create a database and import the dataset into a table named `store`.
2. Open `queries.sql` in MySQL Workbench, DBeaver or any SQL client.
3. Run the queries one by one (each is numbered and commented).

> Window functions need MySQL 8.0+ or PostgreSQL.

## Author

**Satish Sherikar**
Aspiring Data Analyst | SQL, Python, Power BI, Tableau, Excel
LinkedIn: _add your link here_
