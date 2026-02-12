INSERT INTO dbo.dim_customers (customer_id, gender, age, age_group)
SELECT DISTINCT
     LTRIM(RTRIM(customer_id)) AS customer_id,
     LTRIM(RTRIM(gender)) AS gender,
    TRY_CONVERT(INT, NULLIF(LTRIM(RTRIM(age)), '')) AS age,
    CASE
        WHEN TRY_CONVERT(INT, LTRIM(RTRIM(age))) < 18 THEN 'Under 18'
        WHEN TRY_CONVERT(INT, LTRIM(RTRIM(age))) BETWEEN 18 AND 25 THEN '18-25'
        WHEN TRY_CONVERT(INT, LTRIM(RTRIM(age))) BETWEEN 26 AND 35 THEN '26-35'
        WHEN TRY_CONVERT(INT, LTRIM(RTRIM(age))) BETWEEN 36 AND 45 THEN '36-45'
        WHEN TRY_CONVERT(INT, LTRIM(RTRIM(age))) BETWEEN 46 AND 60 THEN '46-60'
        WHEN TRY_CONVERT(INT,  LTRIM(RTRIM(age))) >= 61 THEN '60+'
        ELSE NULL
    END AS age_group
FROM dbo.stg_retail_sales
WHERE LTRIM(RTRIM(customer_id), '') IS NOT NULL;

INSERT INTO dbo.dim_products (product_category)
SELECT DISTINCT
    LTRIM(RTRIM(product_category)) AS product_category
FROM dbo.stg_retail_sales
WHERE NULLIF(LTRIM(RTRIM(product_category)), '') IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM dbo.dim_products p
      WHERE p.product_category = LTRIM(RTRIM(stg_retail_sales.product_category))
  );

WITH parsed_dates AS (
    SELECT DISTINCT
        COALESCE(
            TRY_CONVERT(DATE, NULLIF(LTRIM(RTRIM(sale_date)), ''), 103),
            TRY_CONVERT(DATE, NULLIF(LTRIM(RTRIM(sale_date)), ''), 101),
            TRY_CONVERT(DATE, NULLIF(LTRIM(RTRIM(sale_date)), ''))
        ) AS full_date
    FROM dbo.stg_retail_sales
)
INSERT INTO dbo.dim_dates (full_date, day, month, year, quarter, month_name, weekday)
SELECT
    d.full_date,
    DATEPART(DAY, d.full_date) AS [day],
    DATEPART(MONTH, d.full_date) AS [month],
    DATEPART(YEAR, d.full_date) AS [year],
    DATEPART(QUARTER, d.full_date) AS [quarter],
    DATENAME(MONTH, d.full_date) AS month_name,
    DATENAME(WEEKDAY, d.full_date) AS weekday
FROM parsed_dates d
WHERE d.full_date IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM dbo.dim_dates dd WHERE dd.full_date = d.full_date
  );


WITH cleaned AS (
    SELECT
        TRY_CONVERT(INT, NULLIF(LTRIM(RTRIM(transaction_id)), '')) AS transaction_id,
        COALESCE(
            TRY_CONVERT(DATE, NULLIF(LTRIM(RTRIM(sale_date)), ''), 103),
            TRY_CONVERT(DATE, NULLIF(LTRIM(RTRIM(sale_date)), ''), 101),
            TRY_CONVERT(DATE, NULLIF(LTRIM(RTRIM(sale_date)), ''))
        ) AS full_date,
        NULLIF(LTRIM(RTRIM(product_category)), '') AS product_category,
        NULLIF(LTRIM(RTRIM(customer_id)), '') AS customer_id,
        TRY_CONVERT(INT, NULLIF(LTRIM(RTRIM(quantity)), '')) AS quantity,
        TRY_CONVERT(DECIMAL(10,2), NULLIF(LTRIM(RTRIM(price_per_unit)), '')) AS price_per_unit,
        TRY_CONVERT(DECIMAL(10,2), NULLIF(LTRIM(RTRIM(total_amount)), '')) AS total_amount
    FROM dbo.stg_retail_sales
)
INSERT INTO dbo.fact_sales (
    transaction_id, date_id, product_id, customer_id,
    quantity, price_per_unit, total_amount
)
SELECT
    c.transaction_id,
    dd.date_id,
    p.product_id,
    c.customer_id,
    c.quantity,
    c.price_per_unit,
    c.total_amount
FROM cleaned c
JOIN dbo.dim_dates dd
    ON dd.full_date = c.full_date
JOIN dbo.dim_products p
    ON p.product_category = c.product_category
JOIN dbo.dim_customers cu
    ON cu.customer_id = c.customer_id
WHERE c.transaction_id IS NOT NULL
 AND NOT EXISTS (
      SELECT 1 FROM dbo.fact_sales f WHERE f.transaction_id = c.transaction_id
  );