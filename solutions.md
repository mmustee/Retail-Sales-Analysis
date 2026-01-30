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

3. What is the month-over-month revenue growth percentage?

4. What is the quarterly sales trend?

5. Are there any seasonal patterns in sales?

# Customer Analytics

1. How many unique customers have made purchases?

2. What is the average revenue per customer?

3. Which customers have the highest lifetime value?

4. What percentage of customers are repeat buyers?

5. Which age group generates the most revenue?

# Product Performance

1. Which products have the highest sales volume?

2. Which product categories have the highest order quantities?

3. What is the average transaction value per product category?

4. Which product categories sell most frequently but at lower revenue?

5. Rank product categories by revenue contribution.

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
