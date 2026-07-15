CREATE VIEW dbo.vw_VendorConcentration AS
SELECT 
    vendor_id,
    canonical_vendor_name,
    COUNT(*) AS transaction_count,
    SUM(total_dollars_obligated) AS total_spend,
    CAST(SUM(total_dollars_obligated) * 100.0 / 
        (SELECT SUM(total_dollars_obligated) FROM dbo.Contracts_Clean) 
        AS DECIMAL(10,2)) AS pct_of_total_spend
FROM dbo.Contracts_Clean
GROUP BY vendor_id, canonical_vendor_name;
GO

SELECT TOP 15 *
FROM dbo.vw_VendorConcentration
ORDER BY total_spend DESC;

CREATE VIEW dbo.vw_CategorySpend AS
SELECT 
    product_or_service_code_description AS category,
    COUNT(*) AS transaction_count,
    SUM(total_dollars_obligated) AS total_spend,
    CAST(SUM(total_dollars_obligated) * 100.0 / 
        (SELECT SUM(total_dollars_obligated) FROM dbo.Contracts_Clean) 
        AS DECIMAL(10,2)) AS pct_of_total_spend
FROM dbo.Contracts_Clean
GROUP BY product_or_service_code_description;
GO

SELECT TOP 15 *
FROM dbo.vw_CategorySpend
ORDER BY total_spend DESC;

CREATE VIEW dbo.vw_CompetitionSpend AS
SELECT 
    extent_competed,
    COUNT(*) AS transaction_count,
    SUM(total_dollars_obligated) AS total_spend,
    CAST(SUM(total_dollars_obligated) * 100.0 / 
        (SELECT SUM(total_dollars_obligated) FROM dbo.Contracts_Clean) 
        AS DECIMAL(10,2)) AS pct_of_total_spend,
    CAST(COUNT(*) * 100.0 / 
        (SELECT COUNT(*) FROM dbo.Contracts_Clean) 
        AS DECIMAL(10,2)) AS pct_of_total_transactions
FROM dbo.Contracts_Clean
GROUP BY extent_competed;
GO

SELECT *
FROM dbo.vw_CompetitionSpend
ORDER BY total_spend DESC;

CREATE OR ALTER VIEW dbo.vw_MonthlySpendTrend AS
SELECT 
    YEAR(action_date) AS spend_year,
    MONTH(action_date) AS spend_month,
    FORMAT(action_date, 'yyyy-MM') AS year_month,
    COUNT(*) AS transaction_count,
    SUM(total_dollars_obligated) AS total_spend
FROM dbo.Contracts_Clean
GROUP BY YEAR(action_date), MONTH(action_date), FORMAT(action_date, 'yyyy-MM');
GO

SELECT *
FROM dbo.vw_MonthlySpendTrend
ORDER BY spend_year, spend_month;

CREATE OR ALTER VIEW dbo.vw_MaverickSpendFlag AS
SELECT 
    c.contract_transaction_unique_key,
    c.vendor_id,
    c.canonical_vendor_name,
    c.product_or_service_code_description AS category,
    c.action_date,
    c.total_dollars_obligated,
    c.extent_competed,
    vc.pct_of_total_spend AS vendor_spend_share,
    CASE 
        WHEN c.extent_competed IN ('NOT COMPETED', 'NOT COMPETED UNDER SAP', 'NOT AVAILABLE FOR COMPETITION') 
             AND vc.pct_of_total_spend < 1.0
        THEN 'HIGH_RISK'
        WHEN c.extent_competed IN ('NOT COMPETED', 'NOT COMPETED UNDER SAP', 'NOT AVAILABLE FOR COMPETITION')
        THEN 'MEDIUM_RISK'
        ELSE 'LOW_RISK'
    END AS maverick_risk_flag
FROM dbo.Contracts_Clean c
JOIN dbo.vw_VendorConcentration vc
    ON c.vendor_id = vc.vendor_id;
GO

SELECT maverick_risk_flag, COUNT(*) AS txn_count, SUM(total_dollars_obligated) AS total_spend
FROM dbo.vw_MaverickSpendFlag
GROUP BY maverick_risk_flag
ORDER BY total_spend DESC;