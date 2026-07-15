SELECT 
    vc.vendor_id,
    vc.canonical_vendor_name,
    vc.transaction_count,
    vc.total_spend,
    vc.pct_of_total_spend,
    -- Get each vendor's dominant category for context
    (SELECT TOP 1 product_or_service_code_description 
     FROM dbo.Contracts_Clean c2 
     WHERE c2.vendor_id = vc.vendor_id 
     GROUP BY product_or_service_code_description 
     ORDER BY COUNT(*) DESC) AS primary_category,
    -- Non-competed spend share per vendor (risk indicator)
    ISNULL((SELECT SUM(c3.total_dollars_obligated) 
     FROM dbo.Contracts_Clean c3 
     WHERE c3.vendor_id = vc.vendor_id 
       AND c3.extent_competed IN ('NOT COMPETED','NOT COMPETED UNDER SAP','NOT AVAILABLE FOR COMPETITION')
    ), 0) AS non_competed_spend
FROM dbo.vw_VendorConcentration vc
ORDER BY vc.total_spend DESC;