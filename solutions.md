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
