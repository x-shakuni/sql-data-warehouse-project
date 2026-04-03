SELECT TOP (1000) [id]
      ,[cat]
      ,[subcat]
      ,[maintenance]
  FROM [DataWarehouse].[bronze].[erp_px_cat_g1v2]


-- check for unwanted spaces
SELECT * FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance)

-- data standatdization & consistency
SELECT DISTINCT cat FROM bronze.erp_px_cat_g1v2
SELECT DISTINCT subcat FROM bronze.erp_px_cat_g1v2
SELECT DISTINCT maintenance FROM bronze.erp_px_cat_g1v2


-- loading data

INSERT INTO silver.erp_px_cat_g1v2(id, cat, subcat, maintenance)
SELECT [id]
      ,[cat]
      ,[subcat]
      ,[maintenance]
  FROM [DataWarehouse].[bronze].[erp_px_cat_g1v2]
