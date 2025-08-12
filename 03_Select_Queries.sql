Use master
GO

USE PurbachalWasteManagement;
GO

-- =========================================================================================================================
-- ================================================== DATABASE QUERIES =====================================================
-- =========================================================================================================================

-----------------------------------------------------------------------
-- This query identifies transactions where the vehicle was overloaded.
-----------------------------------------------------------------------
SELECT
    t.DocketNumber,
    t.GrossWeight,
    t.NetWeight,
    v.RegistrationNumber,
    d.DriverName,
    wb.WeighbridgeName,
    s.SiteName AS WeighbridgeSite,
    tn.TenantName
FROM Transactions AS t
INNER JOIN Vehicles AS v ON t.VehicleId = v.VehicleId
INNER JOIN Drivers AS d ON t.DriverId = d.DriverId
INNER JOIN Weighbridges AS wb ON t.WeighbridgeId = wb.WeighbridgeId
INNER JOIN Sites AS s ON wb.SiteId = s.SiteId
INNER JOIN Tenants AS tn ON s.TenantId = tn.TenantId
WHERE
    t.IsOverloaded = 1
ORDER BY
    t.TransactionDateTime DESC;
GO

---------------------------------------------
-- This query provides a summary of each job.
---------------------------------------------
SELECT
    j.JobNo,
    c.CustomerName,
    p.ProductName,
    d.DriverName,
    src.SiteName AS SourceSite,
    dest.SiteName AS DestinationSite,
    SUM(t.NetWeight) AS TotalNetWeight
FROM Jobs AS j
INNER JOIN Customers AS c ON j.CustomerId = c.CustomerId
INNER JOIN Products AS p ON j.ProductId = p.ProductId
INNER JOIN Drivers AS d ON j.DriverId = d.DriverId
INNER JOIN Sites AS src ON j.SourceSiteId = src.SiteId
INNER JOIN Sites AS dest ON j.DestinationSiteId = dest.SiteId
LEFT JOIN Transactions AS t ON j.JobId = t.JobId
GROUP BY
    j.JobNo,
    c.CustomerName,
    p.ProductName,
    d.DriverName,
    src.SiteName,
    dest.SiteName
ORDER BY
    j.JobNo;
GO

--------------------------------------------------------------
-- This query aggregates data to show each tenant information.
--------------------------------------------------------------
SELECT
    t.TenantName,
    t.Email,
    (SELECT COUNT(*) FROM Sites AS s WHERE s.TenantId = t.TenantId) AS NumberOfSites,
    (SELECT COUNT(*) FROM Vehicles AS v WHERE v.TenantId = t.TenantId) AS NumberOfVehicles,
    (SELECT COUNT(*) FROM Jobs AS j WHERE j.TenantId = t.TenantId) AS NumberOfJobs,
    (SELECT COUNT(*) FROM Users AS u WHERE u.TenantId = t.TenantId AND u.IsActive = 1) AS ActiveUsers,
    COUNT(t_trans.TransactionId) AS TotalTransactions
FROM Tenants AS t
LEFT JOIN Sites AS s ON t.TenantId = s.TenantId
LEFT JOIN Weighbridges AS wb ON s.SiteId = wb.SiteId
LEFT JOIN Transactions AS t_trans ON wb.WeighbridgeId = t_trans.WeighbridgeId
GROUP BY
	t.TenantId,
    t.TenantName,
    t.Email
ORDER BY
    t.TenantName;
GO

-----------------------------------------------------------------------------------------------------------------
-- This query calculates the total number of transactions and the total net weight processed by each weighbridge.
-----------------------------------------------------------------------------------------------------------------
SELECT
    tn.TenantName,
    s.SiteName,
    wb.WeighbridgeName,
    COUNT(t.TransactionId) AS TotalTransactions,
    SUM(t.NetWeight) AS TotalNetWeightProcessed
FROM Weighbridges AS wb
LEFT JOIN Transactions AS t ON wb.WeighbridgeId = t.WeighbridgeId
INNER JOIN Sites AS s ON wb.SiteId = s.SiteId
INNER JOIN Tenants AS tn ON s.TenantId = tn.TenantId
GROUP BY
    tn.TenantName,
    s.SiteName,
    wb.WeighbridgeName
ORDER BY
    tn.TenantName,
    s.SiteName,
    wb.WeighbridgeName;
GO

------------------------------------------------------------------------------
-- This query identifies the drivers transactions and their associated tenant.
------------------------------------------------------------------------------
SELECT
    d.DriverName,
    tn.TenantName,
    COUNT(t.TransactionId) AS TransactionCount
FROM Drivers AS d
LEFT JOIN Transactions AS t ON d.DriverId = t.DriverId
INNER JOIN Tenants AS tn ON d.TenantId = tn.TenantId
GROUP BY
    d.DriverName,
    tn.TenantName
ORDER BY
    TransactionCount DESC;
GO
