USE ecommerce_dw;

-- 1. Star Schema Join
SELECT
    d.year,
    d.month_name,
    p.product_name,
    f.quantity,
    f.sales_amount
FROM fact_sales f
JOIN dim_date d ON f.date_key = d.date_key
JOIN dim_product p ON f.product_key = p.product_key;

-- 2. RANK
SELECT
    p.product_name,
    SUM(f.sales_amount) AS total_sales,
    RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS sales_rank
FROM fact_sales f
JOIN dim_product p ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY sales_rank;

-- 3. DENSE_RANK
SELECT
    p.category,
    p.product_name,
    SUM(f.sales_amount) AS total_sales,
    DENSE_RANK() OVER (
        PARTITION BY p.category
        ORDER BY SUM(f.sales_amount) DESC
    ) AS category_rank
FROM fact_sales f
JOIN dim_product p ON f.product_key = p.product_key
GROUP BY p.category, p.product_name;

-- 4. LAG
SELECT
    d.year,
    d.month,
    d.month_name,
    SUM(f.sales_amount) AS monthly_sales,
    LAG(SUM(f.sales_amount)) OVER (
        ORDER BY d.year, d.month
    ) AS previous_month_sales
FROM fact_sales f
JOIN dim_date d ON f.date_key = d.date_key
GROUP BY d.year, d.month, d.month_name;

-- 5. LEAD
SELECT
    d.year,
    d.month,
    d.month_name,
    SUM(f.sales_amount) AS monthly_sales,
    LEAD(SUM(f.sales_amount)) OVER (
        ORDER BY d.year, d.month
    ) AS next_month_sales
FROM fact_sales f
JOIN dim_date d ON f.date_key = d.date_key
GROUP BY d.year, d.month, d.month_name;

-- 6. NTILE
SELECT
    p.product_name,
    SUM(f.sales_amount) AS total_sales,
    NTILE(4) OVER (
        ORDER BY SUM(f.sales_amount) DESC
    ) AS sales_quartile
FROM fact_sales f
JOIN dim_product p ON f.product_key = p.product_key
GROUP BY p.product_name;

-- 7. Window Frame
SELECT
    d.year,
    d.month,
    d.month_name,
    SUM(f.sales_amount) AS monthly_sales,
    SUM(SUM(f.sales_amount)) OVER (
        ORDER BY d.year, d.month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM fact_sales f
JOIN dim_date d ON f.date_key = d.date_key
GROUP BY d.year, d.month, d.month_name;

-- 8. Regular CTE
WITH monthly_sales AS (
    SELECT
        d.year,
        d.month,
        d.month_name,
        SUM(f.sales_amount) AS total_sales
    FROM fact_sales f
    JOIN dim_date d ON f.date_key = d.date_key
    GROUP BY d.year, d.month, d.month_name
)
SELECT *
FROM monthly_sales
ORDER BY year, month;

-- 9. Recursive CTE
WITH RECURSIVE month_list AS (
    SELECT 1 AS month_number
    UNION ALL
    SELECT month_number + 1
    FROM month_list
    WHERE month_number < 12
)
SELECT month_number
FROM month_list;

-- 10. UNION
SELECT customer_name
FROM dim_customer
WHERE city = 'Bangalore'
UNION
SELECT customer_name
FROM dim_customer
WHERE city = 'Mumbai';

-- 11. INTERSECT
SELECT customer_name
FROM dim_customer
WHERE city = 'Bangalore'
INTERSECT
SELECT customer_name
FROM dim_customer
WHERE customer_name LIKE 'S%';

-- 12. EXCEPT
SELECT customer_name
FROM dim_customer
WHERE city = 'Bangalore'
EXCEPT
SELECT customer_name
FROM dim_customer
WHERE customer_name LIKE 'S%';

-- 13. Scalar Subquery
SELECT product_name, price
FROM dim_product
WHERE price > (
    SELECT AVG(price)
    FROM dim_product
);

-- 14. Correlated Subquery
SELECT p.product_name, p.price
FROM dim_product p
WHERE p.price > (
    SELECT AVG(p2.price)
    FROM dim_product p2
    WHERE p2.category = p.category
);

-- 15. EXISTS
SELECT c.customer_name
FROM dim_customer c
WHERE EXISTS (
    SELECT 1
    FROM fact_sales f
    WHERE f.customer_key = c.customer_key
);

-- 16. NOT EXISTS
SELECT c.customer_name
FROM dim_customer c
WHERE NOT EXISTS (
    SELECT 1
    FROM fact_sales f
    WHERE f.customer_key = c.customer_key
);

-- 17. ROLLUP
SELECT
    p.category,
    SUM(f.sales_amount) AS total_sales
FROM fact_sales f
JOIN dim_product p ON f.product_key = p.product_key
GROUP BY p.category WITH ROLLUP;

-- 18. GROUPING SETS Equivalent
SELECT
    p.category,
    SUM(f.sales_amount) AS total_sales
FROM fact_sales f
JOIN dim_product p ON f.product_key = p.product_key
GROUP BY p.category
UNION ALL
SELECT
    NULL,
    SUM(sales_amount)
FROM fact_sales;

-- 19. Standard View
CREATE OR REPLACE VIEW vw_monthly_sales AS
SELECT
    d.year,
    d.month,
    d.month_name,
    SUM(f.sales_amount) AS total_sales
FROM fact_sales f
JOIN dim_date d ON f.date_key = d.date_key
GROUP BY d.year, d.month, d.month_name;

-- 20. View Result
SELECT *
FROM vw_monthly_sales
ORDER BY year, month;

-- 21. Materialized View Simulation
DROP TABLE IF EXISTS mv_monthly_sales;

CREATE TABLE mv_monthly_sales AS
SELECT
    d.year,
    d.month,
    d.month_name,
    SUM(f.sales_amount) AS total_sales
FROM fact_sales f
JOIN dim_date d ON f.date_key = d.date_key
GROUP BY d.year, d.month, d.month_name;

-- 22. Materialized View Result
SELECT *
FROM mv_monthly_sales
ORDER BY year, month;

-- 23. EXPLAIN
EXPLAIN
SELECT
    p.product_name,
    SUM(f.sales_amount) AS total_sales
FROM fact_sales f
JOIN dim_product p ON f.product_key = p.product_key
GROUP BY p.product_name;

-- 24. Final Month-over-Month Growth Report
WITH monthly_sales AS (
    SELECT
        d.year,
        d.month,
        d.month_name,
        SUM(f.sales_amount) AS total_sales
    FROM fact_sales f
    JOIN dim_date d ON f.date_key = d.date_key
    GROUP BY d.year, d.month, d.month_name
),
growth_report AS (
    SELECT
        year,
        month,
        month_name,
        total_sales,
        LAG(total_sales) OVER (
            ORDER BY year, month
        ) AS previous_month_sales
    FROM monthly_sales
)
SELECT
    year,
    month,
    month_name,
    total_sales,
    previous_month_sales,
    ROUND(
        ((total_sales - previous_month_sales) /
        NULLIF(previous_month_sales, 0)) * 100,
        2
    ) AS mom_growth_percentage
FROM growth_report
ORDER BY year, month;