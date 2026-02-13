#Introdcution
This project uses a star schema model with one fact table (fact_sales) and three dimension tables ( dim_customers, dim_dates, dim_products)

## Fact_Sales
This table stores transactional sales records at the transaction level.
| Column Name      | Data Type        | Description                                  |
| ---------------- | ---------------- | -------------------------------------------- |
| `transaction_id` | INT (PK)         | Unique identifier for each sales transaction |
| `date_id`        | INT (FK)         | Foreign key linking to `dim_dates`           |
| `product_id`     | INT (FK)         | Foreign key linking to `dim_products`        |
| `customer_id`    | VARCHAR(50) (FK) | Foreign key linking to `dim_customers`       |
| `quantity`       | INT              | Number of units purchased in the transaction |
| `price_per_unit` | DECIMAL(10,2)    | Unit price of the product category purchased |
| `total_amount`   | DECIMAL(10,2)    | Total revenue generated from the transaction |

## Dim_Customers
This table contains demographic information used for customer segmentation
| Column Name |     Data Type    |                     Description                     |
|:-----------:|:----------------:|:---------------------------------------------------:|
| customer_id | VARCHAR(50) (PK) | Unique identifier for each customer (e.g., CUST015) |
| gender      | VARCHAR(6)       | Customer gender (Male / Female)                     |
| age         | INT              | Customer age                                        |
| age_group   | VARCHAR(30)      | Age segmentation band (e.g., 18–25, 46–60)          |

## Dim_dates
This table provides calendar attributes for time-based analysis.
| Column Name |     Data Type    |                     Description                     |
|:-----------:|:----------------:|:---------------------------------------------------:|
| customer_id | VARCHAR(50) (PK) | Unique identifier for each customer (e.g., CUST015) |
| gender      | VARCHAR(6)       | Customer gender (Male / Female)                     |
| age         | INT              | Customer age                                        |
| age_group   | VARCHAR(30)      | Age segmentation band (e.g., 18–25, 46–60)          |

## Dim_products 
This table stores product category information.

|    Column Name   |  Data Type  |                    Description                    |
|:----------------:|:-----------:|:-------------------------------------------------:|
| product_id       | INT (PK)    | Surrogate key for each product category           |
| product_category | VARCHAR(50) | Product category name (e.g., Electronics, Beauty) |
| age              | INT         | Customer age                                      |
| age_group        | VARCHAR(30) | Age segmentation band (e.g., 18–25, 46–60)        |
