## Basic Business Performance

1. What is the total revenue generated across all transactions?
```sql
SELECT SUM(total_amount) as total_revenue
FROM  fact_sales;
```
**Result Set:**

total_revenue |
--|
456000.00 |
