SELECT TOP (1000) [cid]
      ,[country]
  FROM [DataWarehouse].[bronze].[erp_loc_a101]


-- cleaning columns

 select distinct country from bronze.erp_loc_a101


-- fixing columns

SELECT 
    REPLACE (cid, '-', '') AS cid,
    CASE    WHEN TRIM(country) IN ('USA', 'United States', 'US') THEN 'United States'
            WHEN TRIM(country) IN ('DE', 'Germany') THEN 'Germany'
            WHEN TRIM(country) = '' OR country IS NULL THEN 'N/A'
            ELSE TRIM(country)
    END AS country
FROM [DataWarehouse].[bronze].[erp_loc_a101]

-- Inserting data

INSERT INTO silver.erp_loc_a101(cid, country)
SELECT 
    REPLACE (cid, '-', '') AS cid,
    CASE    WHEN TRIM(country) IN ('USA', 'United States', 'US') THEN 'United States'
            WHEN TRIM(country) IN ('DE', 'Germany') THEN 'Germany'
            WHEN TRIM(country) = '' OR country IS NULL THEN 'N/A'
            ELSE TRIM(country)
    END AS country
FROM [DataWarehouse].[bronze].[erp_loc_a101]