SELECT
	prd_id,
	prd_key,
	prd_name,
	prd_cost,
	prd_line,
	prd_start_date,
	prd_end_date
FROM [DataWarehouse].[bronze].[crm_prd_info]

-- Check for nulls or duplicates in primary key

SELECT 
	prd_id,
	COUNT(*)
FROM [DataWarehouse].[bronze].[crm_prd_info]
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL

SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

SELECT DISTINCT prd_line
FROM bronze.crm_prd_info

SELECT prd_start_date
FROM bronze.crm_prd_info
WHERE prd_start_date is null

-- Extracting different columns

SELECT
	prd_id,
	prd_key,
	REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
	SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
	prd_name,
	ISNULL(prd_cost,0) AS prd_cost,
	prd_line,
	CASE	WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
			WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
			WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
			WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
			ELSE 'N/A'
	END AS prd_line,
	CAST(prd_start_date AS DATE) AS prd_start_date,
	LEAD(prd_start_date) OVER (PARTITION BY	prd_key	ORDER BY prd_start_date)-1 AS prd_end_date_test,
	prd_end_date
FROM [DataWarehouse].[bronze].[crm_prd_info]


--WHERE SUBSTRING(prd_key, 7, LEN(prd_key)) NOT IN(
--SELECT sls_prd_key FROM bronze.crm_sales_details)

--WHERE REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') NOT IN
--(SELECT DISTINCT id FROM bronze.erp_px_cat_g1v2)

SELECT *
FROM bronze.crm_prd_info
where prd_end_date < prd_start_date


-- Inserting data into table

INSERT INTO silver.crm_prd_info (
	prd_id,
	cat_id,
	prd_key,
	prd_name,
	prd_cost,
	prd_line,
	prd_start_date,
	prd_end_date
)
SELECT
	prd_id,
	REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,	-- Extract category ID
	SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,			-- Extract product key
	prd_name,
	ISNULL(prd_cost,0) AS prd_cost,
	CASE	WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
			WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
			WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
			WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
			ELSE 'N/A'
	END AS prd_line,										-- Map product line codes to descriptive values
	CAST(prd_start_date AS DATE) AS prd_start_date,
	CAST(
		LEAD(prd_start_date) OVER (PARTITION BY	prd_key	ORDER BY prd_start_date)-1 
		AS date 
	) AS prd_end_date										-- Calculate end date as one day before the next start date
FROM [DataWarehouse].[bronze].[crm_prd_info]

 
