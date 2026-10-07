# Week 5 - Dimensional Model and SQL Analytics

## Objective

Build a dimensional data warehouse model and perform advanced SQL analytics using MySQL.

The project focuses on product ranking, customer analysis, window functions, CTEs, subqueries, set operations, aggregation, views, optimization, and Month-over-Month sales growth.

## Project Description

This project implements a simple Star Schema for an e-commerce data warehouse.

The fact table stores sales transactions, while dimension tables provide information about dates, customers, products, and stores.

## Star Schema

                 dim_customer
                      |
                      |
dim_date ------ fact_sales ------ dim_product
                      |
                      |
                  dim_store

## Database Structure

### Dimension Tables

- dim_date - Date and calendar information
- dim_customer - Customer information
- dim_product - Product and category information
- dim_store - Store and regional information

### Fact Table

- fact_sales - Sales transactions, quantities, and sales amounts

## SQL Concepts Covered

- Dimensional / Star Schema
- Subqueries
- Scalar Subqueries
- Correlated Subqueries
- EXISTS
- NOT EXISTS
- Normalization concepts
- RANK()
- DENSE_RANK()
- LAG()
- LEAD()
- NTILE()
- Window Frames
- Common Table Expressions (CTEs)
- Recursive CTEs
- UNION
- INTERSECT
- EXCEPT
- ROLLUP
- GROUPING SETS concept
- Views
- Materialized View simulation
- EXPLAIN
- Month-over-Month Growth Analysis

## Window Functions

The project uses:

- RANK() for product sales ranking
- DENSE_RANK() for category-based ranking
- LAG() for previous-month sales
- LEAD() for next-month sales
- NTILE() for sales quartiles
- Window frames for running totals

## Month-over-Month Analysis

The final report calculates:

- Monthly sales
- Previous month's sales
- Month-over-Month growth percentage

MoM Growth % =
((Current Month Sales - Previous Month Sales) / Previous Month Sales) × 100

## Views

A standard SQL view named vw_monthly_sales is created to provide monthly sales summaries.

## Materialized View

MySQL does not provide native materialized views.

Therefore, a summary table named mv_monthly_sales is used to simulate a materialized view.

## Optimization

The EXPLAIN statement is used to inspect the execution plan of a sales aggregation query.

## Normalization

The project follows the principles of:

- 1NF - Atomic values and no repeating groups
- 2NF - Removal of partial dependencies
- 3NF - Removal of transitive dependencies

The final dimensional model is intentionally designed for analytical queries and reporting.

## Project Structure

week5
├── database
│   └── schema.sql
├── queries
│   └── week5_queries.sql
└── README.md

## Database Setup

Open MySQL and run the schema.sql file to create the ecommerce_dw database and its tables.

Then select the database:

USE ecommerce_dw;

The SQL queries are available in:

queries/week5_queries.sql

## Main Analysis

The project provides:

- Top product rankings
- Category-wise product rankings
- Monthly sales trends
- Previous and next month comparisons
- Running sales totals
- Sales quartiles
- Customer existence analysis
- Product price analysis
- Monthly sales summary
- Month-over-Month growth

## Technologies Used

- MySQL 8.0
- SQL
- MySQL Command Line
- Visual Studio Code
- Git
- GitHub

## Learning Outcomes

This project demonstrates practical understanding of:

- Data warehouse dimensional modeling
- Advanced SQL
- Window functions
- CTEs
- Subqueries
- Set operations
- Analytical reporting
- SQL optimization
- Business-oriented sales analysis

## Author

Sameer Honnatti

Nitte Meenakshi Institute of Technology

Artificial Intelligence & Data Science