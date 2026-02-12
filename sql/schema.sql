

CREATE TABLE dbo.dim_customers (
    customer_id VARCHAR(50) NOT NULL PRIMARY KEY,  
    gender      VARCHAR(6)  NULL,
    age         INT         NULL,
    age_group   VARCHAR(30) NULL,
    CONSTRAINT chk_gender CHECK (gender IN ('Male','Female') OR gender IS NULL),
    CONSTRAINT chk_age CHECK (age BETWEEN 0 AND 120 OR age IS NULL)
);


CREATE TABLE dbo.dim_products (
    product_id       INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    product_category VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE dbo.dim_dates (
    date_id     INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    full_date   DATE NOT NULL UNIQUE,
    day         INT  NULL,
    month       INT  NULL,
    year        INT  NULL,
    quarter     INT  NULL,
    month_name  VARCHAR(15) NULL,
    weekday     VARCHAR(15) NULL,
    CONSTRAINT chk_month CHECK (month BETWEEN 1 AND 12 OR month IS NULL),
    CONSTRAINT chk_day CHECK (day BETWEEN 1 AND 31 OR day IS NULL),
    CONSTRAINT chk_quarter CHECK (quarter BETWEEN 1 AND 4 OR quarter IS NULL)
);

CREATE TABLE dbo.fact_sales (
    transaction_id  INT NOT NULL PRIMARY KEY,
    date_id         INT NOT NULL,
    product_id      INT NOT NULL,
    customer_id     VARCHAR(50) NOT NULL,
    quantity        INT NULL,
    price_per_unit  DECIMAL(10,2) NULL,
    total_amount    DECIMAL(10,2) NULL,

    CONSTRAINT fk_fact_customer FOREIGN KEY (customer_id) REFERENCES dbo.dim_customers(customer_id),
    CONSTRAINT fk_fact_product  FOREIGN KEY (product_id)  REFERENCES dbo.dim_products(product_id),
    CONSTRAINT fk_fact_date     FOREIGN KEY (date_id)     REFERENCES dbo.dim_dates(date_id),

    CONSTRAINT chk_quantity CHECK (quantity >= 0 OR quantity IS NULL),
    CONSTRAINT chk_price CHECK (price_per_unit >= 0 OR price_per_unit IS NULL),
    CONSTRAINT chk_total CHECK (total_amount >= 0 OR total_amount IS NULL);

CREATE TABLE dbo.stg_retail_sales (
    transaction_id    VARCHAR(50)  NULL,
    sale_date         VARCHAR(50)  NULL,
    customer_id       VARCHAR(50)  NULL,
    gender            VARCHAR(20)  NULL,
    age               VARCHAR(50)  NULL,
    product_category  VARCHAR(50)  NULL,
    quantity          VARCHAR(50)  NULL,
    price_per_unit    VARCHAR(50)  NULL,
    total_amount      VARCHAR(50)  NULL
);