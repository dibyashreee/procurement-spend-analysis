USE ProcurementSpendAnalysis;
GO

SELECT COUNT(*) AS TotalRows FROM dbo.Contracts_Clean;

SELECT COUNT(*) AS rows_missing_vendor_id
FROM dbo.Contracts_Clean
WHERE vendor_id IS NULL;

SELECT COUNT(DISTINCT vendor_id) AS distinct_vendors
FROM dbo.Contracts_Clean;