SELECT COUNT(*) AS TotalRows FROM dbo.Contracts_Clean;

SELECT 
    SUM(CASE WHEN total_dollars_obligated IS NULL THEN 1 ELSE 0 END) AS null_tdo,
    SUM(CASE WHEN federal_action_obligation IS NULL THEN 1 ELSE 0 END) AS null_fao,
    SUM(CASE WHEN naics_description IS NULL THEN 1 ELSE 0 END) AS null_naics
FROM dbo.Contracts_Clean;

SELECT TOP 10 contract_transaction_unique_key, award_id_piid, total_dollars_obligated
FROM dbo.Contracts_Clean
WHERE total_dollars_obligated IS NULL;

ALTER TABLE dbo.Contracts_Clean
ADD recipient_name_normalized NVARCHAR(150);
GO

UPDATE dbo.Contracts_Clean
SET recipient_name_normalized = 
    LTRIM(RTRIM(
        REPLACE(
        REPLACE(
        REPLACE(
        REPLACE(
        REPLACE(
        REPLACE(
            UPPER(recipient_name), 
        '.', ''),
        ',', ''),
        ' INC', ''),
        ' CORP', ''),
        ' LLC', ''),
        ' LTD', '')
    ));
GO

SELECT COUNT(DISTINCT recipient_name) AS raw_unique_names,
       COUNT(DISTINCT recipient_name_normalized) AS normalized_unique_names
FROM dbo.Contracts_Clean;

SELECT recipient_name_normalized, 
COUNT(DISTINCT recipient_name) AS variant_count
FROM dbo.Contracts_Clean
GROUP BY recipient_name_normalized
HAVING COUNT(DISTINCT recipient_name) > 1
ORDER BY variant_count DESC;