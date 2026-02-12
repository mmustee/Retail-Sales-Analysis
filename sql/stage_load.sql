BULK INSERT dbo.stg_retail_sales
FROM 'C:\Users\mohan\Downloads\archive (2)\retail_sales_dataset.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);

