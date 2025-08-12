Use master
GO

--CREATE DATABASE PurbachalWasteManagement;
--GO

CREATE DATABASE [PurbachalWasteManagement]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'PurbachalWasteManagement', FILENAME = N'C:\Ostad_DB\PurbachalWasteManagement.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'PurbachalWasteManagement_log', FILENAME = N'C:\Ostad_DB\PurbachalWasteManagement_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO

USE PurbachalWasteManagement;
GO

-- =========================================================================================================================
-- ================================================= TABLE CREATION ========================================================
-- =========================================================================================================================
--------------------
-- 1. Tenants Table:
--------------------
CREATE TABLE Tenants (
    TenantId		INT					PRIMARY KEY IDENTITY(1,1),
    TenantName		NVARCHAR(255)		NOT NULL		UNIQUE,
    Street			NVARCHAR(255),
    City			NVARCHAR(255),
    PostalCode		NVARCHAR(20),
    Phone			NVARCHAR(50),
    Email			NVARCHAR(255)
);

----------------------------------------------------
-- 2. Sites Table: A tenant can have multiple sites.
----------------------------------------------------
CREATE TABLE Sites (
    SiteId			INT					PRIMARY KEY IDENTITY(1,1),
    TenantId		INT					NOT NULL,
    SiteName		NVARCHAR(255)		NOT NULL,
    SitePrefix		NVARCHAR(10)		NOT NULL		UNIQUE,
    Street			NVARCHAR(255),
    City			NVARCHAR(255),
    PostalCode		NVARCHAR(20),
    Phone			NVARCHAR(50),
    Email			NVARCHAR(255),
    CONSTRAINT FK_Sites_Tenants FOREIGN KEY (TenantId) REFERENCES Tenants(TenantId)
);

----------------------------------------------------------------
-- 3. Weighbridges Table: A site can have multiple weighbridges.
----------------------------------------------------------------
CREATE TABLE Weighbridges (
    WeighbridgeId			INT					PRIMARY KEY IDENTITY(1,1),
    SiteId					INT					NOT NULL,
    WeighbridgeName			NVARCHAR(255)		NOT NULL,
    WeighbridgePrefix		NVARCHAR(10)		NOT NULL UNIQUE,
    [Location]				NVARCHAR(255),
    TotalDeck				INT					NOT NULL DEFAULT 1,			-- Number of decks on the weighbridge (e.g., 1, 2, 3, 4)
    CONSTRAINT FK_Weighbridges_Sites FOREIGN KEY (SiteId) REFERENCES Sites(SiteId)
);

---------------------
-- 4. Vehicles Table:
---------------------
CREATE TABLE Vehicles (
    VehicleId				INT					PRIMARY KEY IDENTITY(1,1),
    TenantId				INT					NOT NULL,	
    RegistrationNumber		NVARCHAR(50)		NOT NULL	UNIQUE,
    FleetNo					NVARCHAR(50),
    Tare					DECIMAL(10, 2),
    SteerAxleMaxLoad		DECIMAL(10, 2),
    SecondAxleMaxLoad		DECIMAL(10, 2),
    ThirdAxleMaxLoad		DECIMAL(10, 2),
    CONSTRAINT FK_Vehicles_Tenants FOREIGN KEY (TenantId) REFERENCES Tenants(TenantId)
);

--------------------
-- 5. Drivers Table:
--------------------
CREATE TABLE Drivers (
    DriverId		INT				PRIMARY KEY IDENTITY(1,1),
    TenantId		INT				NOT NULL,
    DriverName		NVARCHAR(255)	NOT NULL,
    Street			NVARCHAR(255),
    City			NVARCHAR(255),
    [State]			NVARCHAR(255),
    PostalCode		NVARCHAR(20),
    Phone			NVARCHAR(50),
    Email			NVARCHAR(255),
    CONSTRAINT FK_Drivers_Tenants FOREIGN KEY (TenantId) REFERENCES Tenants(TenantId)
);

----------------------
-- 6. Customers Table:
----------------------
CREATE TABLE Customers (
    CustomerId		INT				PRIMARY KEY IDENTITY(1,1),
    TenantId		INT				NOT NULL,
    CustomerName	NVARCHAR(255)	NOT NULL,
    Street			NVARCHAR(255),
    City			NVARCHAR(255),
    [State]			NVARCHAR(255),
    PostalCode		NVARCHAR(20),
    Phone			NVARCHAR(50),
    Email			NVARCHAR(255),
    CONSTRAINT FK_Customers_Tenants FOREIGN KEY (TenantId) REFERENCES Tenants(TenantId)
);

---------------------
-- 7. Products Table:
---------------------
CREATE TABLE Products (
    ProductId				INT					PRIMARY KEY IDENTITY(1,1),
    TenantId				INT					NOT NULL,
    ProductCode				NVARCHAR(50)		NOT NULL,
    ProductName				NVARCHAR(255)		NOT NULL,
    ProductDescription		NVARCHAR(MAX),
    CONSTRAINT FK_Products_Tenants FOREIGN KEY (TenantId) REFERENCES Tenants(TenantId),
    CONSTRAINT UQ_Products_TenantId_ProductCode UNIQUE (TenantId, ProductCode)
);

-----------------
-- 8. Jobs Table:
-----------------
CREATE TABLE Jobs (
    JobId					INT					PRIMARY KEY IDENTITY(1,1),
    TenantId				INT					NOT NULL,
    JobNo					NVARCHAR(50)		NOT NULL		UNIQUE,
    SourceSiteId			INT					NOT NULL,
    DestinationSiteId		INT					NOT NULL,
    ProductId				INT					NOT NULL,
    DriverId				INT					NOT NULL,
    CustomerId				INT					NOT NULL,
    JobCreationDateTime		DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Jobs_Tenants FOREIGN KEY (TenantId) REFERENCES Tenants(TenantId),
    CONSTRAINT FK_Jobs_SourceSite FOREIGN KEY (SourceSiteId) REFERENCES Sites(SiteId),
    CONSTRAINT FK_Jobs_DestinationSite FOREIGN KEY (DestinationSiteId) REFERENCES Sites(SiteId),
    CONSTRAINT FK_Jobs_Product FOREIGN KEY (ProductId) REFERENCES Products(ProductId),
    CONSTRAINT FK_Jobs_Driver FOREIGN KEY (DriverId) REFERENCES Drivers(DriverId),
    CONSTRAINT FK_Jobs_Customer FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId)
);
GO

--------------------------------------------
-- 9. Transactions Table: Table for Billing.
--------------------------------------------
CREATE TABLE Transactions (
    TransactionId			INT				PRIMARY KEY IDENTITY(1,1),
    JobId					INT				NULL,
    WeighbridgeId			INT				NOT NULL,
    VehicleId				INT				NOT NULL,
    DriverId				INT				NOT NULL,
    RegistrationNumber		NVARCHAR(50)	NOT NULL,
    
    -- Docket Number Components (for offline generation and uniqueness)
    SitePrefix				NVARCHAR(10)	NOT NULL,
    WeighbridgePrefix		NVARCHAR(10)	NOT NULL,
    AutoIncrementNumber		INT				NOT NULL,
    DocketNumber AS (SitePrefix + '-' + WeighbridgePrefix + '-' + RIGHT('00000000' + CAST(AutoIncrementNumber AS NVARCHAR(8)), 8)) PERSISTED UNIQUE,
    
    Deck1Weight				DECIMAL(10,2),
    Deck2Weight				DECIMAL(10,2),
    Deck3Weight				DECIMAL(10,2),
    Deck4Weight				DECIMAL(10,2),
    GrossWeight				DECIMAL(10,2)				NOT NULL,
    TareWeight				DECIMAL(10,2),
    NetWeight				DECIMAL(10,2),
    
    [Product]				NVARCHAR(255),
    [Source]				NVARCHAR(255),
    Destination				NVARCHAR(255),
    
    TransactionDateTime		DATETIME DEFAULT GETDATE(),
    IsOverloaded			BIT			NOT NULL DEFAULT 0,
    IsDocketIssued			BIT			NOT NULL DEFAULT 0,
    
    -- Fields for offline sync
    RecordedAt				DATETIME DEFAULT GETDATE(), -- Timestamp when the transaction was recorded (local time)
    SyncedToCloud			BIT			NOT NULL DEFAULT 0, -- Flag to indicate if synced to cloud
    
    CONSTRAINT FK_Transactions_Job FOREIGN KEY (JobId) REFERENCES Jobs(JobId),
    CONSTRAINT FK_Transactions_Weighbridge FOREIGN KEY (WeighbridgeId) REFERENCES Weighbridges(WeighbridgeId),
    CONSTRAINT FK_Transactions_Vehicle FOREIGN KEY (VehicleId) REFERENCES Vehicles(VehicleId),
    CONSTRAINT FK_Transactions_Driver FOREIGN KEY (DriverId) REFERENCES Drivers(DriverId)
);
GO

-------------------
-- 10. Roles Table:
-------------------
CREATE TABLE Roles (
    RoleId			INT IDENTITY(1,1)		PRIMARY KEY,
    RoleName		NVARCHAR(50)			NOT NULL UNIQUE
);
GO

-------------------
-- 11. Users Table:
-------------------
CREATE TABLE Users (
    UserId						INT IDENTITY(1,1) PRIMARY KEY,
    TenantId					INT								NULL,
    Email						NVARCHAR(255)					NOT NULL	UNIQUE,
    PasswordHash				NVARCHAR(255)					NOT NULL,
    Salt						NVARCHAR(255)					NOT NULL,
    LastPasswordChangeDate		DATETIME DEFAULT GETDATE(),
    IsActive					BIT								NOT NULL DEFAULT 1,
    CONSTRAINT FK_Users_Tenants FOREIGN KEY (TenantId) REFERENCES Tenants(TenantId)
);
GO

-----------------------
-- 12. UserRoles Table:
-----------------------
CREATE TABLE UserRoles (
    UserId			INT			NOT NULL,
    RoleId			INT			NOT NULL,
    PRIMARY KEY (UserId, RoleId),
    CONSTRAINT FK_UserRoles_Users FOREIGN KEY (UserId) REFERENCES Users(UserId),
    CONSTRAINT FK_UserRoles_Roles FOREIGN KEY (RoleId) REFERENCES Roles(RoleId)
);
GO

-- =========================================================================================================================
-- =============================================== STORED PROCEDURE ========================================================
-- =========================================================================================================================
-------------------------------
-- 1. Tenants Stored Procedure:
-------------------------------
CREATE PROCEDURE sp_InsertTenant
    @TenantName NVARCHAR(255), @Street NVARCHAR(255), @City NVARCHAR(255), @PostalCode NVARCHAR(20), @Phone NVARCHAR(50), @Email NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Tenants (TenantName, Street, City, PostalCode, Phone, Email)
    VALUES (@TenantName, @Street, @City, @PostalCode, @Phone, @Email);
END;
GO

CREATE PROCEDURE sp_UpdateTenant
    @TenantId INT, @TenantName NVARCHAR(255) = NULL, @Street NVARCHAR(255) = NULL, @City NVARCHAR(255) = NULL, @PostalCode NVARCHAR(20) = NULL, @Phone NVARCHAR(50) = NULL, @Email NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Tenants
    SET
        TenantName = ISNULL(@TenantName, TenantName),
        Street = ISNULL(@Street, Street),
        City = ISNULL(@City, City),
        PostalCode = ISNULL(@PostalCode, PostalCode),
        Phone = ISNULL(@Phone, Phone),
        Email = ISNULL(@Email, Email)
    WHERE TenantId = @TenantId;
END;
GO

CREATE PROCEDURE sp_DeleteTenant
    @TenantId INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
            -- Delete dependent records first
            DELETE FROM UserRoles WHERE UserId IN (SELECT UserId FROM Users WHERE TenantId = @TenantId);
            DELETE FROM Transactions WHERE JobId IN (SELECT JobId FROM Jobs WHERE TenantId = @TenantId);
            DELETE FROM Jobs WHERE TenantId = @TenantId;
            DELETE FROM Users WHERE TenantId = @TenantId;
            DELETE FROM Products WHERE TenantId = @TenantId;
            DELETE FROM Customers WHERE TenantId = @TenantId;
            DELETE FROM Drivers WHERE TenantId = @TenantId;
            DELETE FROM Vehicles WHERE TenantId = @TenantId;
            DELETE FROM Weighbridges WHERE SiteId IN (SELECT SiteId FROM Sites WHERE TenantId = @TenantId);
            DELETE FROM Sites WHERE TenantId = @TenantId;
            -- Finally, delete the parent record
            DELETE FROM Tenants WHERE TenantId = @TenantId;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO

-----------------------------
-- 2. Sites Stored Procedure:
-----------------------------
CREATE PROCEDURE sp_InsertSite
    @TenantId INT, @SiteName NVARCHAR(255), @SitePrefix NVARCHAR(10), @Street NVARCHAR(255), @City NVARCHAR(255), @PostalCode NVARCHAR(20), @Phone NVARCHAR(50), @Email NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Sites (TenantId, SiteName, SitePrefix, Street, City, PostalCode, Phone, Email)
    VALUES (@TenantId, @SiteName, @SitePrefix, @Street, @City, @PostalCode, @Phone, @Email);
END;
GO

CREATE PROCEDURE sp_UpdateSite
    @SiteId INT, @SiteName NVARCHAR(255) = NULL, @SitePrefix NVARCHAR(10) = NULL, @Street NVARCHAR(255) = NULL, @City NVARCHAR(255) = NULL, @PostalCode NVARCHAR(20) = NULL, @Phone NVARCHAR(50) = NULL, @Email NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Sites
    SET SiteName = ISNULL(@SiteName, SiteName), SitePrefix = ISNULL(@SitePrefix, SitePrefix), Street = ISNULL(@Street, Street), City = ISNULL(@City, City), PostalCode = ISNULL(@PostalCode, PostalCode), Phone = ISNULL(@Phone, Phone), Email = ISNULL(@Email, Email)
    WHERE SiteId = @SiteId;
END;
GO

CREATE PROCEDURE sp_DeleteSite
    @SiteId INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
            -- Delete dependent records and update foreign keys
            DELETE FROM Weighbridges WHERE SiteId = @SiteId;
            UPDATE Jobs SET SourceSiteId = NULL WHERE SourceSiteId = @SiteId;
            UPDATE Jobs SET DestinationSiteId = NULL WHERE DestinationSiteId = @SiteId;
            -- Finally, delete the parent record
            DELETE FROM Sites WHERE SiteId = @SiteId;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO

-- ----------------------------------
-- 03. Weighbridges Stored Procedure:
-- ----------------------------------
CREATE PROCEDURE sp_InsertWeighbridge
    @SiteId INT, @WeighbridgeName NVARCHAR(255), @WeighbridgePrefix NVARCHAR(10), @Location NVARCHAR(255), @TotalDeck INT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Weighbridges (SiteId, WeighbridgeName, WeighbridgePrefix, Location, TotalDeck)
    VALUES (@SiteId, @WeighbridgeName, @WeighbridgePrefix, @Location, @TotalDeck);
END;
GO

CREATE PROCEDURE sp_UpdateWeighbridge
    @WeighbridgeId INT, @WeighbridgeName NVARCHAR(255) = NULL, @WeighbridgePrefix NVARCHAR(10) = NULL, @Location NVARCHAR(255) = NULL, @TotalDeck INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Weighbridges
    SET WeighbridgeName = ISNULL(@WeighbridgeName, WeighbridgeName), WeighbridgePrefix = ISNULL(@WeighbridgePrefix, WeighbridgePrefix), Location = ISNULL(@Location, Location), TotalDeck = ISNULL(@TotalDeck, TotalDeck)
    WHERE WeighbridgeId = @WeighbridgeId;
END;
GO

CREATE PROCEDURE sp_DeleteWeighbridge
    @WeighbridgeId INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM Weighbridges WHERE WeighbridgeId = @WeighbridgeId;
END;
GO

-- -----------------------------
-- 4. Vehicles Stored Procedure:
-- -----------------------------
CREATE PROCEDURE sp_InsertVehicle
    @TenantId INT, @RegistrationNumber NVARCHAR(50), @FleetNo NVARCHAR(50), @Tare DECIMAL(18, 2), @SteerAxleMaxLoad DECIMAL(18, 2), @SecondAxleMaxLoad DECIMAL(18, 2), @ThirdAxleMaxLoad DECIMAL(18, 2)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Vehicles (TenantId, RegistrationNumber, FleetNo, Tare, SteerAxleMaxLoad, SecondAxleMaxLoad, ThirdAxleMaxLoad)
    VALUES (@TenantId, @RegistrationNumber, @FleetNo, @Tare, @SteerAxleMaxLoad, @SecondAxleMaxLoad, @ThirdAxleMaxLoad);
END;
GO

CREATE PROCEDURE sp_UpdateVehicle
    @VehicleId INT, @RegistrationNumber NVARCHAR(50) = NULL, @FleetNo NVARCHAR(50) = NULL, @Tare DECIMAL(18, 2) = NULL, @SteerAxleMaxLoad DECIMAL(18, 2) = NULL, @SecondAxleMaxLoad DECIMAL(18, 2) = NULL, @ThirdAxleMaxLoad DECIMAL(18, 2) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Vehicles
    SET
        RegistrationNumber = ISNULL(@RegistrationNumber, RegistrationNumber),
        FleetNo = ISNULL(@FleetNo, FleetNo),
        Tare = ISNULL(@Tare, Tare),
        SteerAxleMaxLoad = ISNULL(@SteerAxleMaxLoad, SteerAxleMaxLoad),
        SecondAxleMaxLoad = ISNULL(@SecondAxleMaxLoad, SecondAxleMaxLoad),
        ThirdAxleMaxLoad = ISNULL(@ThirdAxleMaxLoad, ThirdAxleMaxLoad)
    WHERE VehicleId = @VehicleId;
END;
GO

CREATE PROCEDURE sp_DeleteVehicle
    @VehicleId INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM Vehicles WHERE VehicleId = @VehicleId;
END;
GO

-- ----------------------------
-- 5. Drivers Stored Procedure:
-- ----------------------------
CREATE PROCEDURE sp_InsertDriver
    @TenantId INT, @DriverName NVARCHAR(255), @Street NVARCHAR(255), @City NVARCHAR(255), @State NVARCHAR(255), @PostalCode NVARCHAR(20), @Phone NVARCHAR(50), @Email NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Drivers (TenantId, DriverName, Street, City, State, PostalCode, Phone, Email)
    VALUES (@TenantId, @DriverName, @Street, @City, @State, @PostalCode, @Phone, @Email);
END;
GO

CREATE PROCEDURE sp_UpdateDriver
    @DriverId INT, @DriverName NVARCHAR(255) = NULL, @Street NVARCHAR(255) = NULL, @City NVARCHAR(255) = NULL, @State NVARCHAR(255) = NULL, @PostalCode NVARCHAR(20) = NULL, @Phone NVARCHAR(50) = NULL, @Email NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Drivers
    SET
        DriverName = ISNULL(@DriverName, DriverName),
        Street = ISNULL(@Street, Street),
        City = ISNULL(@City, City),
        State = ISNULL(@State, State),
        PostalCode = ISNULL(@PostalCode, PostalCode),
        Phone = ISNULL(@Phone, Phone),
        Email = ISNULL(@Email, Email)
    WHERE DriverId = @DriverId;
END;
GO

CREATE PROCEDURE sp_DeleteDriver
    @DriverId INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
            UPDATE Jobs SET DriverId = NULL WHERE DriverId = @DriverId;
            DELETE FROM Drivers WHERE DriverId = @DriverId;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO

-- ------------------------------
-- 6. Customers Stored Procedure:
-- ------------------------------
CREATE PROCEDURE sp_InsertCustomer
    @TenantId INT, @CustomerName NVARCHAR(255), @Street NVARCHAR(255), @City NVARCHAR(255), @State NVARCHAR(255), @PostalCode NVARCHAR(20), @Phone NVARCHAR(50), @Email NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Customers (TenantId, CustomerName, Street, City, State, PostalCode, Phone, Email)
    VALUES (@TenantId, @CustomerName, @Street, @City, @State, @PostalCode, @Phone, @Email);
END;
GO

CREATE PROCEDURE sp_UpdateCustomer
    @CustomerId INT, @CustomerName NVARCHAR(255) = NULL, @Street NVARCHAR(255) = NULL, @City NVARCHAR(255) = NULL, @State NVARCHAR(255) = NULL, @PostalCode NVARCHAR(20) = NULL, @Phone NVARCHAR(50) = NULL, @Email NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Customers
    SET
        CustomerName = ISNULL(@CustomerName, CustomerName),
        Street = ISNULL(@Street, Street),
        City = ISNULL(@City, City),
        State = ISNULL(@State, State),
        PostalCode = ISNULL(@PostalCode, PostalCode),
        Phone = ISNULL(@Phone, Phone),
        Email = ISNULL(@Email, Email)
    WHERE CustomerId = @CustomerId;
END;
GO

CREATE PROCEDURE sp_DeleteCustomer
    @CustomerId INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
            UPDATE Jobs SET CustomerId = NULL WHERE CustomerId = @CustomerId;
            DELETE FROM Customers WHERE CustomerId = @CustomerId;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO

-- -----------------------------
-- 7. Products Stored Procedure:
-- -----------------------------
CREATE PROCEDURE sp_InsertProduct
    @TenantId INT, @ProductCode NVARCHAR(50), @ProductName NVARCHAR(255), @ProductDescription NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Products (TenantId, ProductCode, ProductName, ProductDescription)
    VALUES (@TenantId, @ProductCode, @ProductName, @ProductDescription);
END;
GO

CREATE PROCEDURE sp_UpdateProduct
    @ProductId INT, @ProductCode NVARCHAR(50) = NULL, @ProductName NVARCHAR(255) = NULL, @ProductDescription NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Products
    SET ProductCode = ISNULL(@ProductCode, ProductCode), ProductName = ISNULL(@ProductName, ProductName), ProductDescription = ISNULL(@ProductDescription, ProductDescription)
    WHERE ProductId = @ProductId;
END;
GO

CREATE PROCEDURE sp_DeleteProduct
    @ProductId INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
            UPDATE Jobs SET ProductId = NULL WHERE ProductId = @ProductId;
            DELETE FROM Products WHERE ProductId = @ProductId;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO

-- -------------------------
-- 8. Jobs Stored Procedure:
-- -------------------------
CREATE PROCEDURE sp_InsertJob
    @TenantId INT, @JobNo NVARCHAR(50), @SourceSiteId INT, @DestinationSiteId INT, @ProductId INT, @DriverId INT, @CustomerId INT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Jobs (TenantId, JobNo, SourceSiteId, DestinationSiteId, ProductId, DriverId, CustomerId)
    VALUES (@TenantId, @JobNo, @SourceSiteId, @DestinationSiteId, @ProductId, @DriverId, @CustomerId);
END;
GO

CREATE PROCEDURE sp_UpdateJob
    @JobId INT, @JobNo NVARCHAR(50) = NULL, @SourceSiteId INT = NULL, @DestinationSiteId INT = NULL, @ProductId INT = NULL, @DriverId INT = NULL, @CustomerId INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Jobs
    SET
        JobNo = ISNULL(@JobNo, JobNo),
        SourceSiteId = ISNULL(@SourceSiteId, SourceSiteId),
        DestinationSiteId = ISNULL(@DestinationSiteId, DestinationSiteId),
        ProductId = ISNULL(@ProductId, ProductId),
        DriverId = ISNULL(@DriverId, DriverId),
        CustomerId = ISNULL(@CustomerId, CustomerId)
    WHERE JobId = @JobId;
END;
GO

CREATE PROCEDURE sp_DeleteJob
    @JobId INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
            DELETE FROM Transactions WHERE JobId = @JobId;
            DELETE FROM Jobs WHERE JobId = @JobId;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO

-- ---------------------------------
-- 9. Transactions Stored Procedure:
-- ---------------------------------
CREATE PROCEDURE sp_InsertTransaction
    @JobId INT = NULL, @WeighbridgeId INT, @VehicleId INT, @DriverId INT, @RegistrationNumber NVARCHAR(50),
    @SitePrefix NVARCHAR(10), @WeighbridgePrefix NVARCHAR(10), @AutoIncrementNumber INT,
    @Deck1Weight DECIMAL(10,2) = NULL, @Deck2Weight DECIMAL(10,2) = NULL, @Deck3Weight DECIMAL(10,2) = NULL, @Deck4Weight DECIMAL(10,2) = NULL,
    @GrossWeight DECIMAL(10,2), @TareWeight DECIMAL(10,2) = NULL, @NetWeight DECIMAL(10,2) = NULL,
    @Product NVARCHAR(255), @Source NVARCHAR(255), @Destination NVARCHAR(255),
    @IsOverloaded BIT = 0, @IsDocketIssued BIT = 0, @SyncedToCloud BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Transactions (JobId, WeighbridgeId, VehicleId, DriverId, RegistrationNumber, SitePrefix, WeighbridgePrefix, AutoIncrementNumber, Deck1Weight, Deck2Weight, Deck3Weight, Deck4Weight, GrossWeight, TareWeight, NetWeight, [Product], [Source], Destination, IsOverloaded, IsDocketIssued, SyncedToCloud)
    VALUES (@JobId, @WeighbridgeId, @VehicleId, @DriverId, @RegistrationNumber, @SitePrefix, @WeighbridgePrefix, @AutoIncrementNumber, @Deck1Weight, @Deck2Weight, @Deck3Weight, @Deck4Weight, @GrossWeight, @TareWeight, @NetWeight, @Product, @Source, @Destination, @IsOverloaded, @IsDocketIssued, @SyncedToCloud);
END;
GO

CREATE PROCEDURE sp_UpdateTransaction
    @TransactionId INT,
    @GrossWeight DECIMAL(10,2) = NULL, @TareWeight DECIMAL(10,2) = NULL, @NetWeight DECIMAL(10,2) = NULL,
    @Deck1Weight DECIMAL(10,2) = NULL, @Deck2Weight DECIMAL(10,2) = NULL, @Deck3Weight DECIMAL(10,2) = NULL, @Deck4Weight DECIMAL(10,2) = NULL,
    @IsOverloaded BIT = NULL, @IsDocketIssued BIT = NULL, @SyncedToCloud BIT = NULL,
    @JobId INT = NULL, @WeighbridgeId INT = NULL, @VehicleId INT = NULL, @DriverId INT = NULL,
    @RegistrationNumber NVARCHAR(50) = NULL, @SitePrefix NVARCHAR(10) = NULL, @WeighbridgePrefix NVARCHAR(10) = NULL, @AutoIncrementNumber INT = NULL,
    @Product NVARCHAR(255) = NULL, @Source NVARCHAR(255) = NULL, @Destination NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Transactions
    SET
        JobId = ISNULL(@JobId, JobId),
        WeighbridgeId = ISNULL(@WeighbridgeId, WeighbridgeId),
        VehicleId = ISNULL(@VehicleId, VehicleId),
        DriverId = ISNULL(@DriverId, DriverId),
        RegistrationNumber = ISNULL(@RegistrationNumber, RegistrationNumber),
        SitePrefix = ISNULL(@SitePrefix, SitePrefix),
        WeighbridgePrefix = ISNULL(@WeighbridgePrefix, WeighbridgePrefix),
        AutoIncrementNumber = ISNULL(@AutoIncrementNumber, AutoIncrementNumber),
        Deck1Weight = ISNULL(@Deck1Weight, Deck1Weight),
        Deck2Weight = ISNULL(@Deck2Weight, Deck2Weight),
        Deck3Weight = ISNULL(@Deck3Weight, Deck3Weight),
        Deck4Weight = ISNULL(@Deck4Weight, Deck4Weight),
        GrossWeight = ISNULL(@GrossWeight, GrossWeight),
        TareWeight = ISNULL(@TareWeight, TareWeight),
        NetWeight = ISNULL(@NetWeight, NetWeight),
        [Product] = ISNULL(@Product, [Product]),
        [Source] = ISNULL(@Source, [Source]),
        Destination = ISNULL(@Destination, Destination),
        IsOverloaded = ISNULL(@IsOverloaded, IsOverloaded),
        IsDocketIssued = ISNULL(@IsDocketIssued, IsDocketIssued),
        SyncedToCloud = ISNULL(@SyncedToCloud, SyncedToCloud)
    WHERE TransactionId = @TransactionId;
END;
GO

CREATE PROCEDURE sp_DeleteTransaction
    @TransactionId INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM Transactions WHERE TransactionId = @TransactionId;
END;
GO

-- ---------------------------
-- 10. Roles Stored Procedure:
-- ---------------------------
CREATE PROCEDURE sp_InsertRole
    @RoleName NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Roles (RoleName)
    VALUES (@RoleName);
END;
GO

CREATE PROCEDURE sp_UpdateRole
    @RoleId INT, @RoleName NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Roles
    SET RoleName = @RoleName
    WHERE RoleId = @RoleId;
END;
GO

CREATE PROCEDURE sp_DeleteRole
    @RoleId INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
            DELETE FROM UserRoles WHERE RoleId = @RoleId;
            DELETE FROM Roles WHERE RoleId = @RoleId;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO

-- ---------------------------
-- 11. Users Stored Procedure:
-- ---------------------------
CREATE PROCEDURE sp_InsertUser
    @TenantId INT, @Email NVARCHAR(255), @PasswordHash NVARCHAR(255), @Salt NVARCHAR(255), @IsActive BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Users (TenantId, Email, PasswordHash, Salt, IsActive)
    VALUES (@TenantId, @Email, @PasswordHash, @Salt, @IsActive);
END;
GO

CREATE PROCEDURE sp_UpdateUser
    @UserId INT, @Email NVARCHAR(255) = NULL, @PasswordHash NVARCHAR(255) = NULL, @Salt NVARCHAR(255) = NULL, @IsActive BIT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Users
    SET
        Email = ISNULL(@Email, Email),
        PasswordHash = ISNULL(@PasswordHash, PasswordHash),
        Salt = ISNULL(@Salt, Salt),
        IsActive = ISNULL(@IsActive, IsActive)
    WHERE UserId = @UserId;
END;
GO

CREATE PROCEDURE sp_DeleteUser
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
            DELETE FROM UserRoles WHERE UserId = @UserId;
            DELETE FROM Users WHERE UserId = @UserId;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO

-- -------------------------------
-- 12. UserRoles Stored Procedure:
-- -------------------------------
CREATE PROCEDURE sp_AddUserRole
    @UserId INT, @RoleId INT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO UserRoles (UserId, RoleId)
    VALUES (@UserId, @RoleId);
END;
GO

CREATE PROCEDURE sp_RemoveUserRole
    @UserId INT, @RoleId INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM UserRoles WHERE UserId = @UserId AND RoleId = @RoleId;
END;
GO
