Use master
GO

USE PurbachalWasteManagement;
GO

-- -------------------------------------------------
-- Insert default roles
-- -------------------------------------------------
INSERT INTO Roles (RoleName) VALUES
('Super Admin'),
('Site Admin'),
('Manager'),
('Operator');
GO

-- -------------------------------------------------
-- Tenants (10 records)
-- -------------------------------------------------
EXEC sp_InsertTenant 'Global Logistics Inc.', '123 Main St', 'Springfield', '12345', '555-1234', 'contact@globallogistics.com';
EXEC sp_InsertTenant 'Regional Haulage Co.', '456 Oak Ave', 'Shelbyville', '54321', '555-5678', 'info@regionalhaulage.com';
EXEC sp_InsertTenant 'City Carriers Ltd.', '789 Pine Ln', 'Capital City', '67890', '555-9012', 'support@citycarriers.com';
EXEC sp_InsertTenant 'Local Transport Solutions', '101 Elm Blvd', 'Metropolis', '10112', '555-3456', 'sales@localtransport.net';
EXEC sp_InsertTenant 'Agri-Bulk Haulers', '202 Farm Rd', 'Smallville', '34567', '555-7890', 'admin@agribulk.com';
EXEC sp_InsertTenant 'Mountain Movers', '303 Summit Trail', 'Hillsdale', '89012', '555-2345', 'info@mountainmovers.org';
EXEC sp_InsertTenant 'Desert Freight Lines', '404 Sand Dune', 'Oasis', '12300', '555-6789', 'contact@desertfreight.com';
EXEC sp_InsertTenant 'Portside Shipping', '505 Dock St', 'Seaport', '45678', '555-1122', 'shipping@portside.com';
EXEC sp_InsertTenant 'Northern Routes', '606 Snow St', 'Northwood', '98765', '555-3344', 'management@northernroutes.com';
EXEC sp_InsertTenant 'Southern Cross Transport', '707 Sunshine Blvd', 'Sunnyvale', '56789', '555-5566', 'accounts@southerncross.net';
GO

-- -------------------------------------------------
-- Users (10 records)
-- -------------------------------------------------
DECLARE @tenantId_1 INT = (SELECT TOP 1 TenantId FROM Tenants WHERE TenantName = 'Global Logistics Inc.');
DECLARE @tenantId_2 INT = (SELECT TOP 1 TenantId FROM Tenants WHERE TenantName = 'Regional Haulage Co.');
EXEC sp_InsertUser @tenantId_1, 'superadmin1@globallogistics.com', 'hashedpassword1', 'salt1', 1;
EXEC sp_InsertUser @tenantId_1, 'siteadmin1@globallogistics.com', 'hashedpassword2', 'salt2', 1;
EXEC sp_InsertUser @tenantId_1, 'operator1@globallogistics.com', 'hashedpassword3', 'salt3', 1;
EXEC sp_InsertUser @tenantId_1, 'manager1@globallogistics.com', 'hashedpassword4', 'salt4', 1;
EXEC sp_InsertUser @tenantId_2, 'superadmin1@regionalhaulage.com', 'hashedpassword5', 'salt5', 1;
EXEC sp_InsertUser @tenantId_2, 'manager1@regionalhaulage.com', 'hashedpassword6', 'salt6', 1;
EXEC sp_InsertUser @tenantId_2, 'operator1@regionalhaulage.com', 'hashedpassword7', 'salt7', 1;
EXEC sp_InsertUser @tenantId_1, 'siteadmin2@globallogistics.com', 'hashedpassword8', 'salt8', 1;
EXEC sp_InsertUser @tenantId_1, 'manager2@globallogistics.com', 'hashedpassword9', 'salt9', 1;
EXEC sp_InsertUser @tenantId_2, 'operator2@regionalhaulage.com', 'hashedpassword10', 'salt10', 1;
GO

-- -------------------------------------------------
-- UserRoles (10 records)
-- -------------------------------------------------
DECLARE @userId_1 INT = (SELECT TOP 1 UserId FROM Users WHERE Email = 'superadmin1@globallogistics.com');
DECLARE @roleId_1 INT = (SELECT TOP 1 RoleId FROM Roles WHERE RoleName = 'Super Admin');
EXEC sp_AddUserRole @userId_1, @roleId_1;
DECLARE @userId_2 INT = (SELECT TOP 1 UserId FROM Users WHERE Email = 'siteadmin1@globallogistics.com');
DECLARE @roleId_2 INT = (SELECT TOP 1 RoleId FROM Roles WHERE RoleName = 'Site Admin');
EXEC sp_AddUserRole @userId_2, @roleId_2;
DECLARE @userId_3 INT = (SELECT TOP 1 UserId FROM Users WHERE Email = 'operator1@globallogistics.com');
DECLARE @roleId_3 INT = (SELECT TOP 1 RoleId FROM Roles WHERE RoleName = 'Operator');
EXEC sp_AddUserRole @userId_3, @roleId_3;
DECLARE @userId_4 INT = (SELECT TOP 1 UserId FROM Users WHERE Email = 'manager1@globallogistics.com');
DECLARE @roleId_4 INT = (SELECT TOP 1 RoleId FROM Roles WHERE RoleName = 'Manager');
EXEC sp_AddUserRole @userId_4, @roleId_4;
DECLARE @userId_5 INT = (SELECT TOP 1 UserId FROM Users WHERE Email = 'superadmin1@regionalhaulage.com');
DECLARE @roleId_5 INT = (SELECT TOP 1 RoleId FROM Roles WHERE RoleName = 'Super Admin');
EXEC sp_AddUserRole @userId_5, @roleId_5;
DECLARE @userId_6 INT = (SELECT TOP 1 UserId FROM Users WHERE Email = 'manager1@regionalhaulage.com');
DECLARE @roleId_6 INT = (SELECT TOP 1 RoleId FROM Roles WHERE RoleName = 'Manager');
EXEC sp_AddUserRole @userId_6, @roleId_6;
DECLARE @userId_7 INT = (SELECT TOP 1 UserId FROM Users WHERE Email = 'operator1@regionalhaulage.com');
DECLARE @roleId_7 INT = (SELECT TOP 1 RoleId FROM Roles WHERE RoleName = 'Operator');
EXEC sp_AddUserRole @userId_7, @roleId_7;
DECLARE @userId_8 INT = (SELECT TOP 1 UserId FROM Users WHERE Email = 'siteadmin2@globallogistics.com');
DECLARE @roleId_8 INT = (SELECT TOP 1 RoleId FROM Roles WHERE RoleName = 'Site Admin');
EXEC sp_AddUserRole @userId_8, @roleId_8;
DECLARE @userId_9 INT = (SELECT TOP 1 UserId FROM Users WHERE Email = 'manager2@globallogistics.com');
DECLARE @roleId_9 INT = (SELECT TOP 1 RoleId FROM Roles WHERE RoleName = 'Manager');
EXEC sp_AddUserRole @userId_9, @roleId_9;
DECLARE @userId_10 INT = (SELECT TOP 1 UserId FROM Users WHERE Email = 'operator2@regionalhaulage.com');
DECLARE @roleId_10 INT = (SELECT TOP 1 RoleId FROM Roles WHERE RoleName = 'Operator');
EXEC sp_AddUserRole @userId_10, @roleId_10;
GO

-- -------------------------------------------------
-- Sites (10 records)
-- -------------------------------------------------
DECLARE @tenantId_1 INT = (SELECT TOP 1 TenantId FROM Tenants WHERE TenantName = 'Global Logistics Inc.');
DECLARE @tenantId_2 INT = (SELECT TOP 1 TenantId FROM Tenants WHERE TenantName = 'Regional Haulage Co.');
EXEC sp_InsertSite @tenantId_1, 'HQ Depot', 'GLHQ', '123 Depot St', 'Springfield', '12345', '555-1235', 'depot@globallogistics.com';
EXEC sp_InsertSite @tenantId_1, 'Northern Warehouse', 'GLNW', '456 Warehouse Rd', 'Northbrook', '54321', '555-1236', 'north@globallogistics.com';
EXEC sp_InsertSite @tenantId_2, 'Central Hub', 'RHCH', '789 Central Ave', 'Middleton', '67890', '555-5679', 'central@regionalhaulage.com';
EXEC sp_InsertSite @tenantId_2, 'Southern Terminal', 'RHST', '101 Terminal Blvd', 'Southport', '10112', '555-5680', 'south@regionalhaulage.com';
EXEC sp_InsertSite @tenantId_1, 'East Coast Port', 'GLEC', '202 Port Rd', 'Oceanview', '34567', '555-1237', 'ecport@globallogistics.com';
EXEC sp_InsertSite @tenantId_1, 'West Coast Port', 'GLWC', '303 Harbor Dr', 'Baytown', '89012', '555-1238', 'wcport@globallogistics.com';
EXEC sp_InsertSite @tenantId_2, 'Midwest Hub', 'RHMW', '404 Prairie Ln', 'Prairieville', '12300', '555-5681', 'midwest@regionalhaulage.com';
EXEC sp_InsertSite @tenantId_1, 'Logistics Park A', 'GLPA', '505 Industrial Way', 'Industry City', '45678', '555-1239', 'parka@globallogistics.com';
EXEC sp_InsertSite @tenantId_1, 'Distribution Center B', 'GLDB', '606 Commerce Rd', 'Tradeville', '98765', '555-1240', 'distro@globallogistics.com';
EXEC sp_InsertSite @tenantId_2, 'Transload Facility', 'RHTF', '707 Rail St', 'Junction', '56789', '555-5682', 'transload@regionalhaulage.com';
GO

-- -------------------------------------------------
-- Weighbridges (10 records)
-- -------------------------------------------------
DECLARE @siteId_1 INT = (SELECT TOP 1 SiteId FROM Sites WHERE SiteName = 'HQ Depot');
DECLARE @siteId_2 INT = (SELECT TOP 1 SiteId FROM Sites WHERE SiteName = 'Northern Warehouse');
DECLARE @siteId_3 INT = (SELECT TOP 1 SiteId FROM Sites WHERE SiteName = 'Central Hub');
DECLARE @siteId_4 INT = (SELECT TOP 1 SiteId FROM Sites WHERE SiteName = 'Southern Terminal');
EXEC sp_InsertWeighbridge @siteId_1, 'Weighbridge 1', 'WB1', 'North Gate', 4;
EXEC sp_InsertWeighbridge @siteId_1, 'Weighbridge 2', 'WB2', 'South Gate', 4;
EXEC sp_InsertWeighbridge @siteId_2, 'Weighbridge 3', 'WB3', 'Main Entry', 3;
EXEC sp_InsertWeighbridge @siteId_2, 'Weighbridge 4', 'WB4', 'Exit Gate', 3;
EXEC sp_InsertWeighbridge @siteId_3, 'Weighbridge 5', 'WB5', 'Dock 1', 4;
EXEC sp_InsertWeighbridge @siteId_3, 'Weighbridge 6', 'WB6', 'Dock 2', 4;
EXEC sp_InsertWeighbridge @siteId_4, 'Weighbridge 7', 'WB7', 'Truck Bay 1', 3;
EXEC sp_InsertWeighbridge @siteId_4, 'Weighbridge 8', 'WB8', 'Truck Bay 2', 3;
EXEC sp_InsertWeighbridge @siteId_1, 'Weighbridge 9', 'WB9', 'Internal Lane', 2;
EXEC sp_InsertWeighbridge @siteId_2, 'Weighbridge 10', 'WB10', 'Maintenance Pad', 2;
GO

-- -------------------------------------------------
-- Vehicles (10 records)
-- -------------------------------------------------
DECLARE @tenantId_1 INT = (SELECT TOP 1 TenantId FROM Tenants WHERE TenantName = 'Global Logistics Inc.');
DECLARE @tenantId_2 INT = (SELECT TOP 1 TenantId FROM Tenants WHERE TenantName = 'Regional Haulage Co.');
EXEC sp_InsertVehicle @tenantId_1, 'ABC-123', 'GL-001', 5000, 7000, 10000, 10000;
EXEC sp_InsertVehicle @tenantId_1, 'DEF-456', 'GL-002', 5200, 7000, 10000, 10000;
EXEC sp_InsertVehicle @tenantId_1, 'GHI-789', 'GL-003', 4800, 6500, 9500, 9500;
EXEC sp_InsertVehicle @tenantId_1, 'JKL-012', 'GL-004', 5100, 7000, 10000, 10000;
EXEC sp_InsertVehicle @tenantId_2, 'MNO-345', 'RH-101', 5300, 7200, 10200, 10200;
EXEC sp_InsertVehicle @tenantId_2, 'PQR-678', 'RH-102', 5500, 7500, 10500, 10500;
EXEC sp_InsertVehicle @tenantId_2, 'STU-901', 'RH-103', 4900, 6800, 9800, 9800;
EXEC sp_InsertVehicle @tenantId_2, 'VWX-234', 'RH-104', 5050, 7000, 10000, 10000;
EXEC sp_InsertVehicle @tenantId_1, 'YZA-567', 'GL-005', 5400, 7300, 10300, 10300;
EXEC sp_InsertVehicle @tenantId_1, 'BCD-890', 'GL-006', 5600, 7400, 10400, 10400;
GO

-- -------------------------------------------------
-- Drivers (10 records)
-- -------------------------------------------------
DECLARE @tenantId_1 INT = (SELECT TOP 1 TenantId FROM Tenants WHERE TenantName = 'Global Logistics Inc.');
DECLARE @tenantId_2 INT = (SELECT TOP 1 TenantId FROM Tenants WHERE TenantName = 'Regional Haulage Co.');
EXEC sp_InsertDriver @tenantId_1, 'John Smith', '111 Oak St', 'Springfield', 'IL', '12345', '555-9999', 'john.smith@globallogistics.com';
EXEC sp_InsertDriver @tenantId_1, 'Jane Doe', '222 Maple St', 'Springfield', 'IL', '12345', '555-8888', 'jane.doe@globallogistics.com';
EXEC sp_InsertDriver @tenantId_1, 'Peter Jones', '333 Pine St', 'Northbrook', 'IL', '54321', '555-7777', 'peter.jones@globallogistics.com';
EXEC sp_InsertDriver @tenantId_1, 'Mary Williams', '444 Cedar Rd', 'Northbrook', 'IL', '54321', '555-6666', 'mary.w@globallogistics.com';
EXEC sp_InsertDriver @tenantId_2, 'Robert Brown', '555 Birch Ln', 'Middleton', 'OH', '67890', '555-5555', 'robert.b@regionalhaulage.com';
EXEC sp_InsertDriver @tenantId_2, 'Susan Davis', '666 Elm Dr', 'Middleton', 'OH', '67890', '555-4444', 'susan.d@regionalhaulage.com';
EXEC sp_InsertDriver @tenantId_2, 'Michael Miller', '777 Poplar Ct', 'Southport', 'OH', '10112', '555-3333', 'michael.m@regionalhaulage.com';
EXEC sp_InsertDriver @tenantId_2, 'Jessica Wilson', '888 Willow Ave', 'Southport', 'OH', '10112', '555-2222', 'jessica.w@regionalhaulage.com';
EXEC sp_InsertDriver @tenantId_1, 'David Garcia', '999 Redwood Pl', 'Springfield', 'IL', '12345', '555-1111', 'david.g@globallogistics.com';
EXEC sp_InsertDriver @tenantId_1, 'Sarah Hernandez', '1010 Spruce Ct', 'Northbrook', 'IL', '54321', '555-0000', 'sarah.h@globallogistics.com';
GO

-- -------------------------------------------------
-- Customers (10 records)
-- -------------------------------------------------
DECLARE @tenantId_1 INT = (SELECT TOP 1 TenantId FROM Tenants WHERE TenantName = 'Global Logistics Inc.');
DECLARE @tenantId_2 INT = (SELECT TOP 1 TenantId FROM Tenants WHERE TenantName = 'Regional Haulage Co.');
EXEC sp_InsertCustomer @tenantId_1, 'ABC Manufacturing', '100 Industrial Park', 'Springfield', 'IL', '12345', '555-1000', 'orders@abcmfg.com';
EXEC sp_InsertCustomer @tenantId_1, 'XYZ Corp', '200 Business Dr', 'Northbrook', 'IL', '54321', '555-2000', 'logistics@xyzcorp.com';
EXEC sp_InsertCustomer @tenantId_2, 'Midwest Distributors', '300 Commerce Way', 'Middleton', 'OH', '67890', '555-3000', 'shipping@midwestdist.com';
EXEC sp_InsertCustomer @tenantId_2, 'Southern Aggregates', '400 Quarry Rd', 'Southport', 'OH', '10112', '555-4000', 'sales@southernagg.com';
EXEC sp_InsertCustomer @tenantId_1, 'Construction Supply Co', '500 Builders Blvd', 'Oceanview', 'IL', '34567', '555-5000', 'cs@constructionsupply.com';
EXEC sp_InsertCustomer @tenantId_1, 'Bulk Materials Inc', '600 Bulk St', 'Baytown', 'IL', '89012', '555-6000', 'bulk@bulkmaterials.com';
EXEC sp_InsertCustomer @tenantId_2, 'Prairie Farming', '700 Farm Rd', 'Prairieville', 'OH', '12300', '555-7000', 'farm@prairiefarming.com';
EXEC sp_InsertCustomer @tenantId_1, 'Steel & Iron', '800 Steel Ave', 'Industry City', 'IL', '45678', '555-8000', 'info@steeliron.com';
EXEC sp_InsertCustomer @tenantId_1, 'General Goods Co', '900 Main St', 'Tradeville', 'IL', '98765', '555-9000', 'contact@generalgoods.com';
EXEC sp_InsertCustomer @tenantId_2, 'Railside Traders', '1000 Rail Rd', 'Junction', 'OH', '56789', '555-0100', 'trades@railsidetraders.com';
GO

-- -------------------------------------------------
-- Products (10 records)
-- -------------------------------------------------
DECLARE @tenantId_1 INT = (SELECT TOP 1 TenantId FROM Tenants WHERE TenantName = 'Global Logistics Inc.');
DECLARE @tenantId_2 INT = (SELECT TOP 1 TenantId FROM Tenants WHERE TenantName = 'Regional Haulage Co.');
EXEC sp_InsertProduct @tenantId_1, 'GRAIN01', 'Wheat', 'Hard red winter wheat';
EXEC sp_InsertProduct @tenantId_1, 'GRAIN02', 'Corn', 'Yellow corn feed grade';
EXEC sp_InsertProduct @tenantId_2, 'SAND01', 'River Sand', 'Washed and screened river sand';
EXEC sp_InsertProduct @tenantId_2, 'GRAVEL01', 'Crushed Stone', '20mm crushed stone aggregate';
EXEC sp_InsertProduct @tenantId_1, 'CEMENT01', 'Bulk Cement', 'Portland cement for construction';
EXEC sp_InsertProduct @tenantId_1, 'STEEL01', 'Steel Beams', 'Assorted steel beams for construction';
EXEC sp_InsertProduct @tenantId_2, 'FERT01', 'Fertilizer', 'Bulk agricultural fertilizer';
EXEC sp_InsertProduct @tenantId_1, 'LOGS01', 'Timber Logs', 'Pine logs for timber milling';
EXEC sp_InsertProduct @tenantId_1, 'COAL01', 'Thermal Coal', 'Thermal coal for power generation';
EXEC sp_InsertProduct @tenantId_2, 'SALT01', 'Road Salt', 'De-icing salt for winter roads';
GO

-- -------------------------------------------------
-- Jobs (10 records)
-- -------------------------------------------------
DECLARE @tenantId_1 INT = (SELECT TOP 1 TenantId FROM Tenants WHERE TenantName = 'Global Logistics Inc.');
DECLARE @tenantId_2 INT = (SELECT TOP 1 TenantId FROM Tenants WHERE TenantName = 'Regional Haulage Co.');
DECLARE @siteId_1 INT = (SELECT TOP 1 SiteId FROM Sites WHERE SiteName = 'HQ Depot' AND TenantId = @tenantId_1);
DECLARE @siteId_2 INT = (SELECT TOP 1 SiteId FROM Sites WHERE SiteName = 'Northern Warehouse' AND TenantId = @tenantId_1);
DECLARE @siteId_3 INT = (SELECT TOP 1 SiteId FROM Sites WHERE SiteName = 'Central Hub' AND TenantId = @tenantId_2);
DECLARE @siteId_4 INT = (SELECT TOP 1 SiteId FROM Sites WHERE SiteName = 'Southern Terminal' AND TenantId = @tenantId_2);
DECLARE @prodId_1 INT = (SELECT TOP 1 ProductId FROM Products WHERE ProductName = 'Wheat');
DECLARE @prodId_2 INT = (SELECT TOP 1 ProductId FROM Products WHERE ProductName = 'River Sand');
DECLARE @driverId_1 INT = (SELECT TOP 1 DriverId FROM Drivers WHERE DriverName = 'John Smith');
DECLARE @driverId_2 INT = (SELECT TOP 1 DriverId FROM Drivers WHERE DriverName = 'Robert Brown');
DECLARE @custId_1 INT = (SELECT TOP 1 CustomerId FROM Customers WHERE CustomerName = 'ABC Manufacturing');
DECLARE @custId_2 INT = (SELECT TOP 1 CustomerId FROM Customers WHERE CustomerName = 'Midwest Distributors');
EXEC sp_InsertJob @tenantId_1, 'JOB-GL-001', @siteId_1, @siteId_2, @prodId_1, @driverId_1, @custId_1;
EXEC sp_InsertJob @tenantId_1, 'JOB-GL-002', @siteId_2, @siteId_1, @prodId_1, @driverId_1, @custId_1;
EXEC sp_InsertJob @tenantId_2, 'JOB-RH-001', @siteId_3, @siteId_4, @prodId_2, @driverId_2, @custId_2;
EXEC sp_InsertJob @tenantId_2, 'JOB-RH-002', @siteId_4, @siteId_3, @prodId_2, @driverId_2, @custId_2;
EXEC sp_InsertJob @tenantId_1, 'JOB-GL-003', @siteId_1, @siteId_2, @prodId_1, @driverId_1, @custId_1;
EXEC sp_InsertJob @tenantId_1, 'JOB-GL-004', @siteId_2, @siteId_1, @prodId_1, @driverId_1, @custId_1;
EXEC sp_InsertJob @tenantId_2, 'JOB-RH-003', @siteId_3, @siteId_4, @prodId_2, @driverId_2, @custId_2;
EXEC sp_InsertJob @tenantId_2, 'JOB-RH-004', @siteId_4, @siteId_3, @prodId_2, @driverId_2, @custId_2;
EXEC sp_InsertJob @tenantId_1, 'JOB-GL-005', @siteId_1, @siteId_2, @prodId_1, @driverId_1, @custId_1;
EXEC sp_InsertJob @tenantId_1, 'JOB-GL-006', @siteId_2, @siteId_1, @prodId_1, @driverId_1, @custId_1;
GO

-- -------------------------------------------------
-- Transactions (10 records)
-- -------------------------------------------------
DECLARE @jobId_1 INT = (SELECT TOP 1 JobId FROM Jobs WHERE JobNo = 'JOB-GL-001');
DECLARE @wbId_1 INT = (SELECT TOP 1 WeighbridgeId FROM Weighbridges WHERE WeighbridgePrefix = 'WB1');
DECLARE @vehicleId_1 INT = (SELECT TOP 1 VehicleId FROM Vehicles WHERE RegistrationNumber = 'ABC-123');
DECLARE @driverId_1 INT = (SELECT TOP 1 DriverId FROM Drivers WHERE DriverName = 'John Smith');
DECLARE @sitePrefix_1 NVARCHAR(10) = (SELECT TOP 1 SitePrefix FROM Sites WHERE SiteName = 'HQ Depot');
DECLARE @wbPrefix_1 NVARCHAR(10) = (SELECT TOP 1 WeighbridgePrefix FROM Weighbridges WHERE WeighbridgeId = @wbId_1);

-- Transaction 1
EXEC sp_InsertTransaction @JobId = @jobId_1, @WeighbridgeId = @wbId_1, @VehicleId = @vehicleId_1, @DriverId = @driverId_1, @RegistrationNumber = 'ABC-123',
    @SitePrefix = @sitePrefix_1, @WeighbridgePrefix = @wbPrefix_1, @AutoIncrementNumber = 1001,
    @Deck1Weight = 6000, @Deck2Weight = 12000, @Deck3Weight = 12500, @Deck4Weight = 11000,
    @GrossWeight = 41500, @TareWeight = 5000, @NetWeight = 36500,
    @Product = 'Wheat', @Source = 'HQ Depot', @Destination = 'Northern Warehouse',
    @IsOverloaded = 0, @IsDocketIssued = 1, @SyncedToCloud = 1;

-- Transaction 2 (Tare weigh)
EXEC sp_InsertTransaction @JobId = NULL, @WeighbridgeId = @wbId_1, @VehicleId = @vehicleId_1, @DriverId = @driverId_1, @RegistrationNumber = 'ABC-123',
    @SitePrefix = @sitePrefix_1, @WeighbridgePrefix = @wbPrefix_1, @AutoIncrementNumber = 1002,
    @GrossWeight = 5000, @TareWeight = 5000, @NetWeight = 0,
    @Product = 'N/A', @Source = 'HQ Depot', @Destination = 'N/A',
    @IsOverloaded = 0, @IsDocketIssued = 0, @SyncedToCloud = 1;

-- Transaction 3
DECLARE @jobId_2 INT = (SELECT TOP 1 JobId FROM Jobs WHERE JobNo = 'JOB-RH-001');
DECLARE @wbId_2 INT = (SELECT TOP 1 WeighbridgeId FROM Weighbridges WHERE WeighbridgePrefix = 'WB5');
DECLARE @vehicleId_2 INT = (SELECT TOP 1 VehicleId FROM Vehicles WHERE RegistrationNumber = 'MNO-345');
DECLARE @driverId_2 INT = (SELECT TOP 1 DriverId FROM Drivers WHERE DriverName = 'Robert Brown');
DECLARE @sitePrefix_2 NVARCHAR(10) = (SELECT TOP 1 SitePrefix FROM Sites WHERE SiteName = 'Central Hub');
DECLARE @wbPrefix_2 NVARCHAR(10) = (SELECT TOP 1 WeighbridgePrefix FROM Weighbridges WHERE WeighbridgeId = @wbId_2);
EXEC sp_InsertTransaction @JobId = @jobId_2, @WeighbridgeId = @wbId_2, @VehicleId = @vehicleId_2, @DriverId = @driverId_2, @RegistrationNumber = 'MNO-345',
    @SitePrefix = @sitePrefix_2, @WeighbridgePrefix = @wbPrefix_2, @AutoIncrementNumber = 2001,
    @Deck1Weight = 7000, @Deck2Weight = 11000, @Deck3Weight = 11500, @Deck4Weight = 10000,
    @GrossWeight = 39500, @TareWeight = 5300, @NetWeight = 34200,
    @Product = 'River Sand', @Source = 'Central Hub', @Destination = 'Southern Terminal',
    @IsOverloaded = 0, @IsDocketIssued = 1, @SyncedToCloud = 1;

-- Transaction 4 (Overloaded transaction)
EXEC sp_InsertTransaction @JobId = @jobId_2, @WeighbridgeId = @wbId_2, @VehicleId = @vehicleId_2, @DriverId = @driverId_2, @RegistrationNumber = 'MNO-345',
    @SitePrefix = @sitePrefix_2, @WeighbridgePrefix = @wbPrefix_2, @AutoIncrementNumber = 2002,
    @Deck1Weight = 7500, @Deck2Weight = 11500, @Deck3Weight = 12000, @Deck4Weight = 11000,
    @GrossWeight = 42000, @TareWeight = 5300, @NetWeight = 36700,
    @Product = 'River Sand', @Source = 'Central Hub', @Destination = 'Southern Terminal',
    @IsOverloaded = 1, @IsDocketIssued = 0, @SyncedToCloud = 0;

-- Remaining 6 transactions
DECLARE @jobId_3 INT = (SELECT TOP 1 JobId FROM Jobs WHERE JobNo = 'JOB-GL-003');
DECLARE @wbId_3 INT = (SELECT TOP 1 WeighbridgeId FROM Weighbridges WHERE WeighbridgePrefix = 'WB3');
DECLARE @vehicleId_3 INT = (SELECT TOP 1 VehicleId FROM Vehicles WHERE RegistrationNumber = 'GHI-789');
DECLARE @driverId_3 INT = (SELECT TOP 1 DriverId FROM Drivers WHERE DriverName = 'Peter Jones');
DECLARE @sitePrefix_3 NVARCHAR(10) = (SELECT TOP 1 SitePrefix FROM Sites WHERE SiteName = 'Northern Warehouse');
DECLARE @wbPrefix_3 NVARCHAR(10) = (SELECT TOP 1 WeighbridgePrefix FROM Weighbridges WHERE WeighbridgeId = @wbId_3);
EXEC sp_InsertTransaction @JobId = @jobId_3, @WeighbridgeId = @wbId_3, @VehicleId = @vehicleId_3, @DriverId = @driverId_3, @RegistrationNumber = 'GHI-789',
    @SitePrefix = @sitePrefix_3, @WeighbridgePrefix = @wbPrefix_3, @AutoIncrementNumber = 3001,
    @Deck1Weight = 6500, @Deck2Weight = 9500, @Deck3Weight = 9000, @Deck4Weight = NULL,
    @GrossWeight = 25000, @TareWeight = 4800, @NetWeight = 20200,
    @Product = 'Corn', @Source = 'Northern Warehouse', @Destination = 'HQ Depot',
    @IsOverloaded = 0, @IsDocketIssued = 1, @SyncedToCloud = 1;

DECLARE @jobId_4 INT = (SELECT TOP 1 JobId FROM Jobs WHERE JobNo = 'JOB-GL-004');
DECLARE @wbId_4 INT = (SELECT TOP 1 WeighbridgeId FROM Weighbridges WHERE WeighbridgePrefix = 'WB4');
DECLARE @vehicleId_4 INT = (SELECT TOP 1 VehicleId FROM Vehicles WHERE RegistrationNumber = 'JKL-012');
DECLARE @driverId_4 INT = (SELECT TOP 1 DriverId FROM Drivers WHERE DriverName = 'Mary Williams');
DECLARE @sitePrefix_4 NVARCHAR(10) = (SELECT TOP 1 SitePrefix FROM Sites WHERE SiteName = 'Northern Warehouse');
DECLARE @wbPrefix_4 NVARCHAR(10) = (SELECT TOP 1 WeighbridgePrefix FROM Weighbridges WHERE WeighbridgeId = @wbId_4);
EXEC sp_InsertTransaction @JobId = @jobId_4, @WeighbridgeId = @wbId_4, @VehicleId = @vehicleId_4, @DriverId = @driverId_4, @RegistrationNumber = 'JKL-012',
    @SitePrefix = @sitePrefix_4, @WeighbridgePrefix = @wbPrefix_4, @AutoIncrementNumber = 3002,
    @Deck1Weight = 7000, @Deck2Weight = 10000, @Deck3Weight = 9500, @Deck4Weight = NULL,
    @GrossWeight = 26500, @TareWeight = 5100, @NetWeight = 21400,
    @Product = 'Wheat', @Source = 'Northern Warehouse', @Destination = 'HQ Depot',
    @IsOverloaded = 0, @IsDocketIssued = 1, @SyncedToCloud = 1;

DECLARE @jobId_5 INT = (SELECT TOP 1 JobId FROM Jobs WHERE JobNo = 'JOB-RH-003');
DECLARE @wbId_5 INT = (SELECT TOP 1 WeighbridgeId FROM Weighbridges WHERE WeighbridgePrefix = 'WB7');
DECLARE @vehicleId_5 INT = (SELECT TOP 1 VehicleId FROM Vehicles WHERE RegistrationNumber = 'STU-901');
DECLARE @driverId_5 INT = (SELECT TOP 1 DriverId FROM Drivers WHERE DriverName = 'Michael Miller');
DECLARE @sitePrefix_5 NVARCHAR(10) = (SELECT TOP 1 SitePrefix FROM Sites WHERE SiteName = 'Southern Terminal');
DECLARE @wbPrefix_5 NVARCHAR(10) = (SELECT TOP 1 WeighbridgePrefix FROM Weighbridges WHERE WeighbridgeId = @wbId_5);
EXEC sp_InsertTransaction @JobId = @jobId_5, @WeighbridgeId = @wbId_5, @VehicleId = @vehicleId_5, @DriverId = @driverId_5, @RegistrationNumber = 'STU-901',
    @SitePrefix = @sitePrefix_5, @WeighbridgePrefix = @wbPrefix_5, @AutoIncrementNumber = 4001,
    @Deck1Weight = 6800, @Deck2Weight = 9800, @Deck3Weight = 9500, @Deck4Weight = NULL,
    @GrossWeight = 26100, @TareWeight = 4900, @NetWeight = 21200,
    @Product = 'Crushed Stone', @Source = 'Southern Terminal', @Destination = 'Central Hub',
    @IsOverloaded = 0, @IsDocketIssued = 1, @SyncedToCloud = 1;

DECLARE @jobId_6 INT = (SELECT TOP 1 JobId FROM Jobs WHERE JobNo = 'JOB-RH-004');
DECLARE @wbId_6 INT = (SELECT TOP 1 WeighbridgeId FROM Weighbridges WHERE WeighbridgePrefix = 'WB8');
DECLARE @vehicleId_6 INT = (SELECT TOP 1 VehicleId FROM Vehicles WHERE RegistrationNumber = 'VWX-234');
DECLARE @driverId_6 INT = (SELECT TOP 1 DriverId FROM Drivers WHERE DriverName = 'Jessica Wilson');
DECLARE @sitePrefix_6 NVARCHAR(10) = (SELECT TOP 1 SitePrefix FROM Sites WHERE SiteName = 'Southern Terminal');
DECLARE @wbPrefix_6 NVARCHAR(10) = (SELECT TOP 1 WeighbridgePrefix FROM Weighbridges WHERE WeighbridgeId = @wbId_6);
EXEC sp_InsertTransaction @JobId = @jobId_6, @WeighbridgeId = @wbId_6, @VehicleId = @vehicleId_6, @DriverId = @driverId_6, @RegistrationNumber = 'VWX-234',
    @SitePrefix = @sitePrefix_6, @WeighbridgePrefix = @wbPrefix_6, @AutoIncrementNumber = 4002,
    @Deck1Weight = 7000, @Deck2Weight = 10000, @Deck3Weight = 10500, @Deck4Weight = NULL,
    @GrossWeight = 27500, @TareWeight = 5050, @NetWeight = 22450,
    @Product = 'Crushed Stone', @Source = 'Southern Terminal', @Destination = 'Central Hub',
    @IsOverloaded = 0, @IsDocketIssued = 1, @SyncedToCloud = 1;

DECLARE @jobId_7 INT = (SELECT TOP 1 JobId FROM Jobs WHERE JobNo = 'JOB-GL-005');
DECLARE @wbId_7 INT = (SELECT TOP 1 WeighbridgeId FROM Weighbridges WHERE WeighbridgePrefix = 'WB1');
DECLARE @vehicleId_7 INT = (SELECT TOP 1 VehicleId FROM Vehicles WHERE RegistrationNumber = 'YZA-567');
DECLARE @driverId_7 INT = (SELECT TOP 1 DriverId FROM Drivers WHERE DriverName = 'David Garcia');
DECLARE @sitePrefix_7 NVARCHAR(10) = (SELECT TOP 1 SitePrefix FROM Sites WHERE SiteName = 'HQ Depot');
DECLARE @wbPrefix_7 NVARCHAR(10) = (SELECT TOP 1 WeighbridgePrefix FROM Weighbridges WHERE WeighbridgeId = @wbId_7);
EXEC sp_InsertTransaction @JobId = @jobId_7, @WeighbridgeId = @wbId_7, @VehicleId = @vehicleId_7, @DriverId = @driverId_7, @RegistrationNumber = 'YZA-567',
    @SitePrefix = @sitePrefix_7, @WeighbridgePrefix = @wbPrefix_7, @AutoIncrementNumber = 1003,
    @Deck1Weight = 7300, @Deck2Weight = 10300, @Deck3Weight = 10500, @Deck4Weight = 10000,
    @GrossWeight = 38100, @TareWeight = 5400, @NetWeight = 32700,
    @Product = 'Bulk Cement', @Source = 'HQ Depot', @Destination = 'Northern Warehouse',
    @IsOverloaded = 0, @IsDocketIssued = 1, @SyncedToCloud = 1;

DECLARE @jobId_8 INT = (SELECT TOP 1 JobId FROM Jobs WHERE JobNo = 'JOB-GL-006');
DECLARE @wbId_8 INT = (SELECT TOP 1 WeighbridgeId FROM Weighbridges WHERE WeighbridgePrefix = 'WB2');
DECLARE @vehicleId_8 INT = (SELECT TOP 1 VehicleId FROM Vehicles WHERE RegistrationNumber = 'BCD-890');
DECLARE @driverId_8 INT = (SELECT TOP 1 DriverId FROM Drivers WHERE DriverName = 'Sarah Hernandez');
DECLARE @sitePrefix_8 NVARCHAR(10) = (SELECT TOP 1 SitePrefix FROM Sites WHERE SiteName = 'HQ Depot');
DECLARE @wbPrefix_8 NVARCHAR(10) = (SELECT TOP 1 WeighbridgePrefix FROM Weighbridges WHERE WeighbridgeId = @wbId_8);
EXEC sp_InsertTransaction @JobId = @jobId_8, @WeighbridgeId = @wbId_8, @VehicleId = @vehicleId_8, @DriverId = @driverId_8, @RegistrationNumber = 'BCD-890',
    @SitePrefix = @sitePrefix_8, @WeighbridgePrefix = @wbPrefix_8, @AutoIncrementNumber = 1004,
    @Deck1Weight = 7400, @Deck2Weight = 10400, @Deck3Weight = 11000, @Deck4Weight = 10500,
    @GrossWeight = 39300, @TareWeight = 5600, @NetWeight = 33700,
    @Product = 'Steel Beams', @Source = 'HQ Depot', @Destination = 'Northern Warehouse',
    @IsOverloaded = 0, @IsDocketIssued = 1, @SyncedToCloud = 1;
GO

-- ============================ Some Update Operation =====================================

-- Update a tenant's email address
DECLARE @tenantIdToUpdate INT = (SELECT TOP 1 TenantId FROM Tenants WHERE TenantName = 'Global Logistics Inc.');
EXEC sp_UpdateTenant @TenantIdToUpdate, @Email = 'new-contact@globallogistics.com';
GO

-- Update a vehicle's tare weight
DECLARE @vehicleIdToUpdate INT = (SELECT TOP 1 VehicleId FROM Vehicles WHERE RegistrationNumber = 'ABC-123');
EXEC sp_UpdateVehicle @vehicleIdToUpdate, @Tare = 5150.00;
GO

-- Update a transaction to mark it as synced to cloud
DECLARE @transactionIdToUpdate INT = (SELECT TOP 1 TransactionId FROM Transactions WHERE DocketNumber LIKE '%-1002');
EXEC sp_UpdateTransaction @transactionIdToUpdate, @SyncedToCloud = 1;
GO

-- ============================ Some Delete Operation =====================================

-- Delete a job
DECLARE @jobIdToDelete INT = (SELECT TOP 1 JobId FROM Jobs WHERE JobNo = 'JOB-RH-004');
EXEC sp_DeleteJob @jobIdToDelete;
GO
