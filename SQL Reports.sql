----- GET DETAILED VERSION OF GAMES TABLE -----
CREATE OR ALTER VIEW VideoGames AS
SELECT
	Games.Id,Title,Edition,ReleaseYear,Publisher,
	STUFF((
		SELECT ',' + COALESCE(Platforms.PlatformShort,Platforms.[Platform])
		FROM GamePlatforms
		JOIN Platforms on Platforms.Id = GamePlatforms.PlatformId
		WHERE GamePlatforms.GameId = Games.Id
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS Platforms,
	STUFF((
		SELECT ','+Genres.Genre
		FROM GameGenres
		JOIN Genres on Genres.Id = GameGenres.GenreId
		WHERE GameGenres.GameId = Games.Id
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS Genres,
	STUFF((
		SELECT ','+Regions.Region
		FROM GameRegions
		JOIN Regions on Regions.Id = GameRegions.RegionId
		WHERE GameRegions.GameId = Games.Id
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS Regions,
	Price,Discount,
	FORMAT(Price - (Price * (Discount/100.0)),'N2') AS [Discounted Price]
FROM Games
INNER JOIN Publishers on Games.PublisherId = Publishers.Id

select * from VideoGames

----- GET DETAILED VERSION OF CUSTOMERS TABLE -----
CREATE or ALTER VIEW CustomerData AS
SELECT
	Customers.Id,Customers.Email,Customers.Username,Regions.Region,
	PaymentMethods.PaymentMethod as [Payment Method],Customers.[Address],
	(
		SELECT COUNT(Reviews.Rating)
		FROM Reviews
		WHERE CustomerId=Customers.Id
	) AS [Number of Reviews],
	(
		SELECT COUNT(Transactions.Id)
		FROM Transactions
		WHERE CustomerId=Customers.Id
	) AS [Number of Purchases]
FROM Customers
	INNER JOIN Regions ON Customers.RegionId=Regions.Id
	LEFT JOIN PaymentMethods ON Customers.DefaultPaymentMethodId=PaymentMethods.Id
GROUP BY Customers.Id,Customers.Email,Customers.Username,
Regions.Region,PaymentMethods.PaymentMethod,Customers.[Address]

select * from CustomerData

--- Retrieve top 10 highest-rated video games ---
SELECT TOP 10
	Games.Title,
	COUNT(Reviews.GameId) AS [Number of Ratings],
	AVG(Reviews.Rating) AS [Average Rating]
FROM Games
	JOIN Reviews ON Reviews.GameId = Games.Id
GROUP BY Games.Title
ORDER BY [Average Rating] DESC, [Number of Ratings] DESC

--- Retrieve the most popular gaming platforms ---
SELECT
	Platforms.[Platform], COUNT(GamePlatforms.PlatformId) as [Game Count]
FROM Platforms
	JOIN GamePlatforms ON Platforms.Id = GamePlatforms.PlatformId
GROUP BY Platforms.[Platform]
ORDER BY [Game Count] DESC

--- Retrieve the games released by a particular publisher ---
SELECT
	Games.Title, Games.ReleaseYear
FROM Games
	JOIN Publishers ON Games.PublisherId = Publishers.Id
WHERE Publishers.Publisher = 'Sony Interactive Entertainment'

--- Retrieve most popular publishers ---
SELECT
	Publishers.Publisher,
	COUNT(Reviews.GameId) AS [Number of Ratings],
	AVG(Reviews.Rating) AS [Average Rating]
FROM Publishers
	JOIN Games ON Games.PublisherId = Publishers.Id
	JOIN Reviews ON Reviews.GameId = Games.Id
GROUP BY Publishers.Publisher
ORDER BY [Average Rating] DESC, [Number of Ratings] DESC

--- most selling games ---
SELECT
	Games.Title,
	COUNT(Transactions.GameId) as [Purchase Count]
FROM Games
	JOIN Transactions ON Games.Id = Transactions.GameId
GROUP BY Games.Title
ORDER BY [Purchase Count] DESC

--- revenue ---
SELECT
	COUNT(DISTINCT Transactions.CustomerId) AS [Number of Buyers],
	COUNT(Transactions.Id) AS [Number of Purchases],
	SUM(Transactions.TotalPrice) AS [Total Revenue]
FROM Transactions

--- search by year ---
DECLARE @ReleaseYear INT = 2019;
DECLARE @sql NVARCHAR(MAX);
SET @sql = N'SELECT
Games.Title as [Video Games Released In ' + CAST(@ReleaseYear AS NVARCHAR) + ']
FROM Games
WHERE Games.ReleaseYear = ' + CAST(@ReleaseYear AS NVARCHAR);
EXEC sp_executesql @sql;

--- Every Year Sale Record for each Publisher ---
WITH SalesByPublisher AS (
	SELECT
		Games.ReleaseYear,
		Publishers.[Publisher] AS Publisher,
		COUNT(Transactions.Id) AS [Number of Sales],
		SUM(Transactions.TotalPrice) AS Revenue
	FROM
	Games
		INNER JOIN Publishers ON Games.PublisherId = Publishers.Id
		INNER JOIN Transactions ON Games.Id = Transactions.GameId
	GROUP BY
	Games.ReleaseYear,
	Publishers.[Publisher]
)
SELECT
	SalesByPublisher.Publisher,
	SalesByPublisher.ReleaseYear,
	SalesByPublisher.[Number of Sales],
	SalesByPublisher.Revenue
FROM SalesByPublisher
ORDER BY SalesByPublisher.Publisher, SalesByPublisher.ReleaseYear