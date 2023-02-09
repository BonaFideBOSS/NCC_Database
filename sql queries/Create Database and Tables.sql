CREATE DATABASE VideoGamesDb
GO
USE VideoGamesDb

CREATE TABLE Publishers(
Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
Publisher NVARCHAR(250) UNIQUE NOT NULL
)

CREATE TABLE Platforms(
Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
[Platform] NVARCHAR(100) UNIQUE NOT NULL,
PlatformShort VARCHAR(4) NULL
)

CREATE TABLE Genres(
Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
Genre VARCHAR(50) UNIQUE NOT NULL,
)

CREATE TABLE Regions(
Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
Region VARCHAR(50) UNIQUE NOT NULL
)

CREATE TABLE PaymentMethods(
Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
PaymentMethod VARCHAR(50) UNIQUE NOT NULL
)

CREATE TABLE Games(
Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
Title NVARCHAR(250) NOT NULL,
Edition NVARCHAR(50) DEFAULT 'Standard' NULL,
ReleaseYear INT NOT NULL,
CHECK (ReleaseYear >= 1900 AND ReleaseYear <= 2100),
PublisherId INT NOT NULL FOREIGN KEY REFERENCES Publishers(Id),
Price FLOAT NOT NULL,
Discount INT DEFAULT 0 NULL,
CHECK (Discount >= 0 AND Discount <= 100)
)

CREATE TABLE GamePlatforms(
GameId INT NOT NULL FOREIGN KEY REFERENCES Games(Id),
PlatformId INT NOT NULL FOREIGN KEY REFERENCES Platforms(Id),
CONSTRAINT PK_GamePlatforms PRIMARY KEY CLUSTERED (GameId ASC,PlatformId ASC)
)

CREATE TABLE GameGenres(
GameId INT NOT NULL FOREIGN KEY REFERENCES Games(Id),
GenreId INT NOT NULL FOREIGN KEY REFERENCES Genres(Id),
CONSTRAINT PK_GameGenres PRIMARY KEY CLUSTERED (GameId ASC,GenreId ASC)
)

CREATE TABLE GameRegions(
GameId INT NOT NULL FOREIGN KEY REFERENCES Games(Id),
RegionId INT NOT NULL FOREIGN KEY REFERENCES Regions(Id),
CONSTRAINT PK_GameRegions PRIMARY KEY CLUSTERED (GameId ASC,RegionId ASC)
)

CREATE TABLE Customers(
Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
Email NVARCHAR(250) UNIQUE NOT NULL,
Username VARCHAR(32) NOT NULL,
[Password] NVARCHAR(250) NOT NULL,
RegionId INT NOT NULL FOREIGN KEY REFERENCES Regions(Id),
DefaultPaymentMethodId INT NULL FOREIGN KEY REFERENCES PaymentMethods(Id),
[Address] NVARCHAR(500) NULL
)

CREATE TABLE Reviews(  
CustomerId INT NOT NULL FOREIGN KEY REFERENCES Customers(Id),
GameId INT NOT NULL FOREIGN KEY REFERENCES Games(Id),
Rating INT NOT NULL,
CHECK (Rating >= 1 AND Rating <= 10),
Review NVARCHAR(max) NULL,
CONSTRAINT PKC_Reviews PRIMARY KEY CLUSTERED (CustomerId ASC,GameId ASC)
)

CREATE TABLE Transactions(
Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
CustomerId INT NOT NULL FOREIGN KEY REFERENCES Customers(Id),
GameId INT NOT NULL FOREIGN KEY REFERENCES Games(Id),
[Date] DATETIME NULL DEFAULT GETDATE(),
PaymentMethodId INT NOT NULL FOREIGN KEY REFERENCES PaymentMethods(Id),
TotalPrice FLOAT NOT NULL,
CONSTRAINT PKC_Transactions UNIQUE CLUSTERED (CustomerId ASC,GameId ASC)
)

drop table Transactions

CREATE TABLE Invoices(
Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
OrderId INT NOT NULL FOREIGN KEY REFERENCES Transactions(Id),
[Date] DATETIME NULL DEFAULT GETDATE()
)

CREATE OR ALTER TRIGGER Game_Regions
	ON Games
	AFTER INSERT
AS
BEGIN
	DECLARE @gameid INT
	SELECT @gameid = Id FROM INSERTED
	INSERT INTO GameRegions VALUES(@gameid,1)
	INSERT INTO GameRegions VALUES(@gameid,2)
	INSERT INTO GameRegions VALUES(@gameid,3)
	INSERT INTO GameRegions VALUES(@gameid,4)
END

CREATE OR ALTER PROCEDURE PurchaseGame
	@customerid INT,
	@gameid INT,
	@paymentmethod INT
AS
BEGIN
	DECLARE @price FLOAT
	DECLARE @discount INT
	SELECT @price = Price FROM Games WHERE Id = @gameid
	SELECT @discount = Discount FROM Games WHERE Id = @gameid
	INSERT INTO Transactions(CustomerId,GameId,PaymentMethodId,TotalPrice)
	VALUES (@customerid,@gameid,@paymentmethod,@price - (@price * (@discount/100.0)))
END

CREATE OR ALTER TRIGGER Transaction_Invoices
	ON Transactions
	AFTER INSERT
AS
BEGIN
	DECLARE @orderid INT
	SELECT @orderid = Id FROM INSERTED
	INSERT INTO Invoices(OrderId) VALUES(@orderid)
END


select * from Publishers
select * from Platforms
select * from Genres
select * from Regions
select * from PaymentMethods
select * from Games
select * from GamePlatforms
select * from GameGenres
select * from GameRegions
select * from Customers
select * from Reviews
select * from Transactions
select * from Invoices