 # Basic Business Performance

1. What is the total revenue generated across all transactions?
```sql
SELECT SUM(total_amount) as total_revenue
FROM  fact_sales;
```
**Result Set:**

total_revenue |
--|
456000.00 |

2. What is the total quantity of products sold?
```sql
SELECT SUM(quantity) as total_quantity_sold
FROM  fact_sales;
```
**Result Set:**

total_quantity_sold |
--|
2514 |

3. What is the average order value (AOV)?
```sql
SELECT avg(total_amount) as avg_order_value
FROM fact_sales;
```
**Result Set:**

avg_order_value |
--|
456 |

4. Which product category generates the highest revenue?
```sql
SELECT TOP 1
p.product_category, SUM(total_amount) as total_revenue
FROM fact_sales s INNER JOIN dim_products p on s.product_id = p.product_id
GROUP BY p.product_category
ORDER BY total_revenue DESC
```
**Result Set:**

product_category | total_revenue |
--| --|
Electronics | 156905.00 |

5. Which product category has the highest average price per unit?

```sql
SELECT TOP 1
p.product_category, ROUND(AVG(s.price_per_unit),2) as avg_price_per_unit
FROM fact_sales s JOIN dim_products p
ON s.product_id = p.product_id
GROUP by p.product_category
ORDER by avg_price_per_unit DESC
```
**Result Set:**

product_category | avg_price_per_unit |
--| --|
Beauty | 184.060000 |


 # Time-Based Analysis
1. What is the total revenue per month?
```sql
SELECT d.month, d.month_name, d.year,  SUM(s.total_amount) as total_revenue
FROM fact_sales s 
JOIN dim_dates d ON d.date_id = s.date_id
GROUP BY d.month_name, d.month, d.year
ORDER BY  d.year, d.month DESC
```
**Result Set:**

month | month_name | year | total_revenue |
--| --| --| --|
1  | January   | 2023 | 35450.00 |
2  | February  | 2023 | 44060.00 |
3  | March     | 2023 | 28990.00 |
4  | April     | 2023 | 33870.00 |
5  | May       | 2023 | 53150.00 |
6  | June      | 2023 | 36715.00 |
7  | July      | 2023 | 35465.00 |
8  | August    | 2023 | 36960.00 |
9  | September | 2023 | 23620.00 |
10 | October   | 2023 | 46580.00 |
11 | November  | 2023 | 34920.00 |
12 | December  | 2023 | 44690.00 |
1  | January   | 2024 | 1530.00  |

2. Which month had the highest sales revenue?
```sql
SELECT TOP 1 
 d.month_name, d.year,  SUM(s.total_amount) as total_revenue
FROM fact_sales s 
JOIN dim_dates d ON d.date_id = s.date_id
GROUP BY d.month_name, d.year
ORDER BY total_revenue DESC
```
**Result Set:**

month_name | year | total_revenue |
--| --| --|
May | 2023 | 53150.00 |

3. What is the month-over-month revenue growth percentage?
```sql
WITH monthly_revenue AS(
	SELECT d.year, d.month, d.month_name, SUM(s.total_amount) as revenue
	FROM fact_sales s JOIN dim_dates d
	ON s.date_id = d.date_id
	GROUP BY d.year, d.month, d.month_name
),

mom AS(
		SELECT year,
			   month, 
			   month_name, 
			   revenue,
			   LAG(revenue) OVER (ORDER BY year, month) as previous_revenue
		FROM monthly_revenue
		)

SELECT year,
	   month, 
	   month_name, 
	   revenue, 
	   previous_revenue, 
		CASE 
			WHEN previous_revenue is NULL or previous_revenue = 0 THEN NULL
			ELSE ROUND((revenue - previous_revenue) * 100 / previous_revenue, 2)
		END as mom_growth_percentage
FROM mom


```
**Result Set:**

year | month | month_name | revenue | previous_revenue | mom_growth_percentage
--| --| -- |-- | -- | -- |
2023 | 1  | January   | 35450.00 | NULL     | NULL       |
2023 | 2  | February  | 44060.00 | 35450.00 | 24.290000  |
2023 | 3  | March     | 28990.00 | 44060.00 | -34.200000 |
2023 | 4  | April     | 33870.00 | 28990.00 | 16.830000  |
2023 | 5  | May       | 53150.00 | 33870.00 | 56.920000  |
2023 | 6  | June      | 36715.00 | 53150.00 | -30.920000 |
2023 | 7  | July      | 35465.00 | 36715.00 | -3.400000  |
2023 | 8  | August    | 36960.00 | 35465.00 | 4.220000   |
2023 | 9  | September | 23620.00 | 36960.00 | -36.090000 |
2023 | 10 | October   | 46580.00 | 23620.00 | 97.210000  |
2023 | 11 | November  | 34920.00 | 46580.00 | -25.030000 |
2023 | 12 | December  | 44690.00 | 34920.00 | 27.980000  |
2024 | 1  | January   | 1530.00  | 44690.00 | -96.580000 |

4. What is the quarterly sales trend?
```sql
SELECT d.year, d.quarter, SUM(s.total_amount) as total_revenue
FROM fact_sales s
JOIN dim_dates d ON s.date_id = d.date_id
GROUP BY d.year, d.quarter
ORDER BY d.year, d.quarter


```
**Result Set:**
year | quarter | total_revenue |
--| --| -- |
2023 | 1 | 108500.00 |
2023 | 2 | 123735.00 |
2023 | 3 | 96045.00  |
2023 | 4 | 126190.00 |
2024 | 1 | 1530.00   |

5. Are there any seasonal patterns in sales?
```sql
SELECT d.year, d.quarter, SUM(s.total_amount) as total_revenue
FROM fact_sales s
JOIN dim_dates d ON s.date_id = d.date_id
GROUP BY d.year, d.quarter
ORDER BY d.year, d.quarter


```
**Result Set:**
year | quarter | total_revenue |
--| --| -- |
2023 | 1 | 108500.00 |
2023 | 2 | 123735.00 |
2023 | 3 | 96045.00  |
2023 | 4 | 126190.00 |
2024 | 1 | 1530.00   |

### Seasonal Patterns

- Sales display moderate seasonality, with sales peaking at the end of the year at Q4 and plumetting at midway through the year at Q2. This displays an increase in demand of customers towards the end of the year, likey due to the holiday expenditure. Nevertheless, there does not seem to be a regular seasonal trend between months or quarters which means that seasonal changes do not significantly influence sales.
# Customer Analytics

1. How many unique customers have made purchases?
```sql
SELECT DISTINCT COUNT(customer_id) as num_of_unique_customers FROM dim_customers;
```
**Result Set:**
num_of_unique_customers |
 -- |
1000 |

2. What is the top 5 average revenue per customer?
```sql
SELECT top 5 customer_id, ROUND(AVG(total_amount),2) as average_revenue
FROM fact_sales
GROUP BY customer_id
ORDER BY average_revenue DESC
```
**Result Set:**
customer_id | average_revenue |
 -- |  -- |
CUST015 | 2000.000000 |
CUST065 | 2000.000000 |
CUST072 | 2000.000000 |
CUST074 | 2000.000000 |
CUST089 | 2000.000000 |

3. Which age group generates the most revenue?
```sql
SELECT top 1 c.age_group, SUM(s.total_amount) as total_revenue 
FROM fact_sales s
JOIN dim_customers c 
ON c.customer_id = s.customer_id
GROUP BY age_group, s.total_amount
ORDER BY total_revenue DESC

```
**Result Set:**
age_group| total_revenue |
-- |  -- |
46-60 | 25500.00 |
# Product Performance

1. Which product categories have the highest order quantities?
```sql
SELECT TOP 1 p.product_category, SUM(s.quantity) as quantity
FROM fact_sales s 
JOIN dim_products p 
ON p.product_id = s.product_id
GROUP BY p.product_category
ORDER BY quantity DESC
```

**Result Set:**
product_category | quantity |
-- |  -- |
Clothing | 894

2. What is the average transaction value per product category?
```sql
SELECT p.product_category, ROUND(AVG(s.total_amount),2) as avg_transaction_value
FROM fact_sales s 
JOIN dim_products p
ON p.product_id = s.product_id
GROUP BY product_category
```
**Result Set:**
product_category | avg_transaction_value |
-- |  -- |
Beauty      | 467.48 |
Clothing    | 443.25 |
Electronics | 458.79 |

3. Which product categories sell most frequently but at lower revenue?
```sql
SELECT p.product_category, COUNT(s.transaction_id) as frequency, SUM(s.total_amount) as revenue
FROM fact_sales s 
JOIN dim_products p 
On p.product_id = s.product_id
GROUP BY product_category

```
**Result Set:**
product_category | frequency | revenue |
-- |  -- | --|
Beauty      | 307 | 143515.00 |
Clothing    | 351 | 155580.00 |
Electronics | 342 | 156905.00 |

4. Rank product categories by revenue contribution.
```sql
WITH category_revenue AS (
    SELECT
        p.product_category,
        SUM(s.total_amount) AS revenue
    FROM dbo.fact_sales s
    JOIN dbo.dim_products p
        ON p.product_id = s.product_id
    GROUP BY p.product_category
)
SELECT
    product_category,
    revenue,
    RANK() OVER (ORDER BY revenue DESC) AS product_category_rank
FROM category_revenue
ORDER BY product_category_rank;

```
**Result Set:**
product_category | revenue | product_category_rank |
-- |  -- | --|
Electronics | 156905.00 | 1
Clothing | 155580.00 | 2
Beauty | 143515.00 | 3

# Advanced SQL / Window Function Focus

1.Rank top 5 customers by lifetime value.
```sql
WITH category_revenue AS (
    SELECT
        p.product_category,
        SUM(s.total_amount) AS revenue
    FROM dbo.fact_sales s
    JOIN dbo.dim_products p
        ON p.product_id = s.product_id
    GROUP BY p.product_category
)
SELECT
    product_category,
    revenue,
    RANK() OVER (ORDER BY revenue DESC) AS product_category_rank
FROM category_revenue
ORDER BY product_category_rank;

```
**Result Set:**
product_category | revenue | product_category_rank |
-- |  -- | --|
Electronics | 156905.00 | 1
Clothing | 155580.00 | 2
Beauty | 143515.00 | 3

2. Compute cumulative revenue over time.
```sql
WITH monthly_revenue AS(
SELECT  d.month_name, d.month,d.year, SUM(s.total_amount) as revenue
FROM fact_sales s 
JOIN dim_dates d 
ON d.date_id = s.date_id
GROUP BY d.year, d.month_name, d.month
)

SELECT month_name, month, year, revenue,
SUM(revenue) OVER (ORDER BY year, month
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_revenue



FROM monthly_revenue
ORDER BY year, month;
                           
```                                                                          
**Result Set:**
month_name | month| year | revenue | cumulative_revenue
-- |  -- | --| --| --|
January   | 1  | 2023 | 35450.00 | 35450.00  |
February  | 2  | 2023 | 44060.00 | 79510.00  |
March     | 3  | 2023 | 28990.00 | 108500.00 |
April     | 4  | 2023 | 33870.00 | 142370.00 |
May       | 5  | 2023 | 53150.00 | 195520.00 |
June      | 6  | 2023 | 36715.00 | 232235.00 |
July      | 7  | 2023 | 35465.00 | 267700.00 |
August    | 8  | 2023 | 36960.00 | 304660.00 |
September | 9  | 2023 | 23620.00 | 328280.00 |
October   | 10 | 2023 | 46580.00 | 374860.00 |
November  | 11 | 2023 | 34920.00 | 409780.00 |
December  | 12 | 2023 | 44690.00 | 454470.00 |
January   | 1  | 2024 | 1530.00  | 456000.00 |

3. Compute running monthly revenue totals.
```sql
WITH monthly_revenue AS(
SELECT  d.month_name, d.month,d.year, SUM(s.total_amount) as revenue
FROM fact_sales s 
JOIN dim_dates d 
ON d.date_id = s.date_id
GROUP BY d.year, d.month_name, d.month
)

SELECT month_name, month, year, revenue,
SUM(revenue) OVER (ORDER BY year, month
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS rolling_3_month_revenue



FROM monthly_revenue
ORDER BY year, month;
                           
```
**Result Set:**
month_name | month| year | revenue | cumulative_revenue
-- |  -- | --| --| --|
January   | 1  | 2023 | 35450.00 | 35450.00  |
February  | 2  | 2023 | 44060.00 | 79510.00  |
March     | 3  | 2023 | 28990.00 | 108500.00 |
April     | 4  | 2023 | 33870.00 | 106920.00 |
May       | 5  | 2023 | 53150.00 | 116010.00 |
June      | 6  | 2023 | 36715.00 | 123735.00 |
July      | 7  | 2023 | 35465.00 | 125330.00 |
August    | 8  | 2023 | 36960.00 | 109140.00 |
September | 9  | 2023 | 23620.00 | 96045.00  |
October   | 10 | 2023 | 46580.00 | 107160.00 |
November  | 11 | 2023 | 34920.00 | 105120.00 |
December  | 12 | 2023 | 44690.00 | 126190.00 |
January   | 1  | 2024 | 1530.00  | 81140.00  |

4. Identify top-selling product category per month.
```sql
WITH product_monthly_revenue AS(
SELECT d.month, d.month_name, d.year, p.product_category, SUM(s.quantity) as monthly_quantity_sold
FROM fact_sales s 
JOIN dim_products p 
ON p.product_id = s.product_id
JOIN dim_dates d
ON d.date_id = s.date_id
GROUP BY d.year, d.month, d.month_name,  p.product_category
),

ranked_category AS(
SELECT month, month_name, year, product_category, monthly_quantity_sold,
DENSE_RANK() OVER (PARTITION BY year, month ORDER BY monthly_quantity_sold DESC) AS category_rank
FROM product_monthly_revenue
)

SELECT month, month_name, year, product_category, monthly_quantity_sold, category_rank
FROM ranked_category
WHERE category_rank =1
ORDER BY year, month, category_rank, product_category
                           
```
**Result Set:**
 month | month_name | year |product_category | monthly_quantity_sold | category_rank
-- |  -- | -- | -- | -- | -- |
1  | January   | 2023 | Clothing    | 72  | 1 |
2  | February  | 2023 | Clothing    | 75  | 1 |
3  | March     | 2023 | Clothing    | 111 | 1 |
4  | April     | 2023 | Clothing    | 93  | 1 |
5  | May       | 2023 | Clothing    | 97  | 1 |
5  | May       | 2023 | Electronics | 97  | 1 |
6  | June      | 2023 | Clothing    | 67  | 1 |
7  | July      | 2023 | Beauty      | 70  | 1 |
8  | August    | 2023 | Electronics | 87  | 1 |
9  | September | 2023 | Clothing    | 60  | 1 |
9  | September | 2023 | Electronics | 60  | 1 |
10 | October   | 2023 | Electronics | 95  | 1 |
11 | November  | 2023 | Electronics | 73  | 1 |
12 | December  | 2023 | Electronics | 92  | 1 |
1  | January   | 2024 | Beauty      | 3   | 1 |

# Business Insight Questions

1. What percentage of total revenue comes from the top 20% of customers?
```sql

ranked AS (
    SELECT
        customer_id,
        revenue,
        ROW_NUMBER() OVER (ORDER BY revenue DESC) AS rn,
        COUNT(*) OVER () AS total_customers
    FROM customer_revenue
),
top20 AS (
    SELECT
        *,
        CEILING(total_customers * 0.2) AS top_n
    FROM ranked
),
totals AS (
    SELECT
        (SELECT SUM(revenue) FROM customer_revenue) AS total_revenue,
        (SELECT SUM(revenue) FROM top20 WHERE rn <= top_n) AS top_20pct_revenue,
        (SELECT MAX(total_customers) FROM ranked) AS total_customers,
        (SELECT MAX(top_n) FROM top20) AS top_20pct_customers
)
SELECT
    total_customers,
    top_20pct_customers,
    top_20pct_revenue,
    total_revenue,
    ROUND(top_20pct_revenue * 100.0 / NULLIF(total_revenue, 0), 2) AS top_20pct_revenue_pct
FROM totals;

                           
```
**Result Set:**
total_customers |top20pct_customers | top_20pct_revenue |total_revenue | top_20pct_revenue_pct |
-- |  -- | --| --| --| 
1000 | 200 | 284800.00 | 456000.00 | 62.460000 |


2. Which product category should be prioritized for marketing?
```sql
SELECT
    p.product_category,
    SUM(f.total_amount) AS total_revenue,
    COUNT(f.transaction_id) AS transaction_count,
    SUM(f.quantity) AS units_sold,
    ROUND(AVG(f.total_amount), 2) AS avg_order_value,
    ROUND(AVG(f.price_per_unit), 2) AS avg_unit_price
FROM dbo.fact_sales f
JOIN dbo.dim_products p
    ON f.product_id = p.product_id
GROUP BY p.product_category
ORDER BY total_revenue DESC;
```
**Result Set:**
product_category |total_revenue | transaction_count |units_sold | avg_order_value | avg_unit_price
-- |  -- | --| --| --| --|
Electronics | 156905.00 | 342 | 849 | 458.790000 | 181.900000 |
Clothing    | 155580.00 | 351 | 894 | 443.250000 | 174.290000 |
Beauty      | 143515.00 | 307 | 771 | 467.480000 | 184.060000 |


3. If the business wants to increase AOV, which category should be targeted?

```sql
SELECT
    p.product_category,
    ROUND(AVG(f.total_amount), 2) AS avg_order_value,
    COUNT(f.transaction_id) AS transaction_count,
    SUM(f.total_amount) AS total_revenue

FROM dbo.fact_sales f
JOIN dbo.dim_products p
ON f.product_id = p.product_id
GROUP BY p.product_category
ORDER BY avg_order_value DESC
```
**Result Set:**
product_category | avg_order_value | transaction_count | total_avenue
--| --| --| -- | 
