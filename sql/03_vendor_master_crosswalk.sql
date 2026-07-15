SELECT COUNT(*) FROM dbo.Vendor_Master;

SELECT COUNT(DISTINCT vendor_id) FROM dbo.Vendor_Master;

ALTER TABLE dbo.Contracts_Clean
ADD vendor_id NVARCHAR(50),
    canonical_vendor_name NVARCHAR(150);
GO

UPDATE c
SET c.vendor_id = v.vendor_id,
    c.canonical_vendor_name = v.canonical_vendor_name
FROM dbo.Contracts_Clean c
JOIN dbo.Vendor_Master v
    ON c.recipient_name = v.recipient_name;
GO

SELECT COUNT(*) AS unmatched_rows
FROM dbo.Contracts_Clean
WHERE vendor_id IS NULL;

SELECT COUNT(DISTINCT vendor_id) AS distinct_vendors FROM dbo.Contracts_Clean;

SELECT canonical_vendor_name, COUNT(*) AS txn_count, SUM(total_dollars_obligated) AS total_spend
FROM dbo.Contracts_Clean
WHERE canonical_vendor_name = 'ABBOTT LABORATORIES INC.'
GROUP BY canonical_vendor_name;

