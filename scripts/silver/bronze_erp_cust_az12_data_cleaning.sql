SELECT  [cid]
      ,[bdate]
      ,[gender]
 FROM [DataWarehouse].[bronze].[erp_cust_az12]

-- Checking for duplicates and blank spaces
SELECT 
    cid,
    COUNT(*)
FROM bronze.erp_cust_az12
GROUP BY cid
HAVING COUNT(*) > 1


SELECT 
    cid
FROM bronze.erp_cust_az12
WHERE cid != TRIM(cid)

SELECT 
    bdate
FROM bronze.erp_cust_az12
WHERE bdate != TRIM(bdate)

SELECT DISTINCT gender
FROM bronze.erp_cust_az12


-- Table formatting

INSERT INTO silver.erp_cust_az12(cid, bdate, gender)

SELECT  
        CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
               ELSE cid
        END AS cid,

        CASE WHEN bdate > GETDATE() THEN NULL
            ELSE bdate
        END AS bdate,

        CASE    WHEN gender = 'M' OR gender = 'Male'
                THEN 'Male'
                WHEN gender = 'F' OR gender = 'Female'
                THEN 'Female'
                ELSE 'N/A'
        END AS gender
 FROM [DataWarehouse].[bronze].[erp_cust_az12]
