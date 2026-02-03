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
-- |  -- |
Beauty      | 307 | 143515.00 |
Clothing    | 351 | 155580.00 |
Electronics | 342 | 156905.00 |

4. Rank product categories by revenue contribution.

# Advanced SQL / Window Function Focus

1.Rank customers by lifetime value.

2. Compute cumulative revenue over time.

3. Compute running monthly revenue totals.

4. Identify top 5 customers per month.

5. Identify top-selling product category per month.

# Business Insight Questions

1. What percentage of total revenue comes from the top 20% of customers?

2. Identify customers who have not purchased in the last 3 months.

3. Which product category should be prioritized for marketing?

4. Which age group has the highest repeat purchase rate?

5. If the business wants to increase AOV, which category should be targeted?
