CREATE DATABASE [VideoGamesDb]
GO
USE [VideoGamesDb]
GO
/****** Object:  Table [dbo].[Publishers]    Script Date: 2/7/2023 8:46:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Publishers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Publisher] [nvarchar](250) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Platforms]    Script Date: 2/7/2023 8:46:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Platforms](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Platform] [nvarchar](100) NOT NULL,
	[PlatformShort] [varchar](4) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Genres]    Script Date: 2/7/2023 8:46:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Genres](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Genre] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Regions]    Script Date: 2/7/2023 8:46:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Regions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Region] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Games]    Script Date: 2/7/2023 8:46:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Games](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](250) NOT NULL,
	[Edition] [nvarchar](50) NULL,
	[ReleaseYear] [int] NOT NULL,
	[PublisherId] [int] NOT NULL,
	[Price] [float] NOT NULL,
	[Discount] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GamePlatforms]    Script Date: 2/7/2023 8:46:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GamePlatforms](
	[GameId] [int] NOT NULL,
	[PlatformId] [int] NOT NULL,
 CONSTRAINT [PK_GamePlatforms] PRIMARY KEY CLUSTERED 
(
	[GameId] ASC,
	[PlatformId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GameGenres]    Script Date: 2/7/2023 8:46:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GameGenres](
	[GameId] [int] NOT NULL,
	[GenreId] [int] NOT NULL,
 CONSTRAINT [PK_GameGenres] PRIMARY KEY CLUSTERED 
(
	[GameId] ASC,
	[GenreId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GameRegions]    Script Date: 2/7/2023 8:46:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GameRegions](
	[GameId] [int] NOT NULL,
	[RegionId] [int] NOT NULL,
 CONSTRAINT [PK_GameRegions] PRIMARY KEY CLUSTERED 
(
	[GameId] ASC,
	[RegionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[VideoGames]    Script Date: 2/7/2023 8:46:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[VideoGames] AS
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
GO
/****** Object:  Table [dbo].[PaymentMethods]    Script Date: 2/7/2023 8:46:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PaymentMethods](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PaymentMethod] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Customers]    Script Date: 2/7/2023 8:46:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Email] [nvarchar](250) NOT NULL,
	[Username] [varchar](32) NOT NULL,
	[Password] [nvarchar](250) NOT NULL,
	[RegionId] [int] NOT NULL,
	[DefaultPaymentMethodId] [int] NULL,
	[Address] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reviews]    Script Date: 2/7/2023 8:46:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reviews](
	[CustomerId] [int] NOT NULL,
	[GameId] [int] NOT NULL,
	[Rating] [int] NOT NULL,
	[Review] [nvarchar](max) NULL,
 CONSTRAINT [PKC_Reviews] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC,
	[GameId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Transactions]    Script Date: 2/7/2023 8:46:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Transactions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[GameId] [int] NOT NULL,
	[Date] [datetime] NULL,
	[PaymentMethodId] [int] NOT NULL,
	[TotalPrice] [float] NOT NULL,
 CONSTRAINT [PKC_Transactions] UNIQUE CLUSTERED 
(
	[CustomerId] ASC,
	[GameId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[CustomerData]    Script Date: 2/7/2023 8:46:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[CustomerData] AS
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
GO
/****** Object:  Table [dbo].[Invoices]    Script Date: 2/7/2023 8:46:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Invoices](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrderId] [int] NOT NULL,
	[Date] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Customers] ON 
GO
INSERT [dbo].[Customers] ([Id], [Email], [Username], [Password], [RegionId], [DefaultPaymentMethodId], [Address]) VALUES (1, N'amaan@mail.com', N'Amaan Al Mir', N'202cb962ac59075b964b07152d234b70', 4, 2, NULL)
GO
INSERT [dbo].[Customers] ([Id], [Email], [Username], [Password], [RegionId], [DefaultPaymentMethodId], [Address]) VALUES (2, N'raman@mail.com', N'Raman Raghav', N'250cf8b51c773f3f8dc8b4be867a9a02', 4, NULL, N'Mumbai, India')
GO
INSERT [dbo].[Customers] ([Id], [Email], [Username], [Password], [RegionId], [DefaultPaymentMethodId], [Address]) VALUES (3, N'johnwick@continental.com', N'Johnathan Wick', N'8ef9ae32e7b1351f139e074c18df9371', 3, NULL, NULL)
GO
INSERT [dbo].[Customers] ([Id], [Email], [Username], [Password], [RegionId], [DefaultPaymentMethodId], [Address]) VALUES (4, N'user123@gmail.com', N'User 123', N'6ad14ba9986e3615423dfca256d04e3f', 1, NULL, NULL)
GO
INSERT [dbo].[Customers] ([Id], [Email], [Username], [Password], [RegionId], [DefaultPaymentMethodId], [Address]) VALUES (5, N'wahid@yahoo.com', N'Wahid Uddin', N'ac6f3d4d696ba928a03f70cbbef83356', 4, NULL, N'Doha, Qatar')
GO
INSERT [dbo].[Customers] ([Id], [Email], [Username], [Password], [RegionId], [DefaultPaymentMethodId], [Address]) VALUES (6, N'shamsh@outlook.com', N'Umm Fateh Ali', N'323081f5b83f4340ab5a219fdb01e8da', 4, NULL, N'Jharkhand, India')
GO
INSERT [dbo].[Customers] ([Id], [Email], [Username], [Password], [RegionId], [DefaultPaymentMethodId], [Address]) VALUES (7, N'sania66@hotmail.com', N'Sabila Ahmed', N'e63aa50cb57c494b8b77d8d342e66624', 3, 1, N'Alberta, Canada')
GO
INSERT [dbo].[Customers] ([Id], [Email], [Username], [Password], [RegionId], [DefaultPaymentMethodId], [Address]) VALUES (8, N'looneytunes@gmail.com', N'Looney Tunes', N'596a96cc7bf9108cd896f33c44aedc8a', 3, NULL, N'Ney York city, New york, United States')
GO
SET IDENTITY_INSERT [dbo].[Customers] OFF
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (1, 1)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (1, 2)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (2, 1)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (2, 2)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (3, 1)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (3, 2)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (3, 16)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (3, 17)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (3, 18)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (4, 1)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (4, 2)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (4, 16)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (4, 17)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (4, 18)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (5, 1)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (5, 4)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (5, 5)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (5, 11)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (6, 3)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (6, 8)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (6, 10)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (7, 3)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (7, 6)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (7, 9)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (8, 2)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (8, 6)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (8, 12)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (9, 7)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (9, 8)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (9, 10)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (9, 11)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (10, 3)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (10, 5)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (10, 9)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (11, 1)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (11, 6)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (11, 9)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (12, 1)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (12, 6)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (12, 9)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (12, 12)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (13, 6)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (13, 7)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (13, 10)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (13, 13)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (14, 7)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (14, 11)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (14, 13)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (15, 7)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (15, 8)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (15, 9)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (15, 10)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (16, 6)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (16, 7)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (16, 11)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (17, 6)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (17, 8)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (17, 9)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (17, 13)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (18, 3)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (18, 8)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (18, 10)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (18, 11)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (19, 2)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (19, 7)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (19, 10)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (20, 1)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (20, 4)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (20, 8)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (20, 12)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (21, 1)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (21, 2)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (21, 7)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (21, 12)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (22, 1)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (22, 10)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (22, 11)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (23, 2)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (23, 3)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (23, 4)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (23, 7)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (24, 3)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (24, 9)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (24, 12)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (25, 3)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (25, 13)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (26, 1)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (26, 8)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (26, 9)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (26, 10)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (27, 3)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (27, 7)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (27, 8)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (27, 9)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (28, 2)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (28, 9)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (28, 11)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (28, 12)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (29, 1)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (29, 5)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (29, 9)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (29, 13)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (30, 1)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (30, 5)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (30, 6)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (30, 13)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (31, 8)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (31, 10)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (31, 11)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (31, 13)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (32, 1)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (32, 3)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (32, 9)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (32, 12)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (33, 6)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (33, 7)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (33, 12)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (34, 6)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (34, 11)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (34, 12)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (35, 8)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (35, 9)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (35, 11)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (35, 13)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (36, 2)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (36, 4)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (36, 10)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (37, 3)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (37, 10)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (37, 12)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (38, 1)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (38, 2)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (38, 10)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (38, 11)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (39, 1)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (39, 5)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (39, 10)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (39, 13)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (40, 2)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (40, 11)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (41, 2)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (41, 3)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (41, 6)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (41, 9)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (42, 4)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (42, 6)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (42, 8)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (42, 13)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (43, 5)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (43, 7)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (43, 10)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (44, 3)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (44, 8)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (44, 9)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (44, 13)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (45, 2)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (45, 5)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (45, 7)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (45, 11)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (46, 1)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (46, 12)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (46, 13)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (47, 3)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (47, 6)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (47, 7)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (47, 8)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (48, 1)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (48, 4)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (48, 5)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (48, 11)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (49, 4)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (49, 5)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (49, 9)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (50, 6)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (50, 9)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (50, 12)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (51, 2)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (51, 4)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (51, 11)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (52, 1)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (52, 2)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (52, 5)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (52, 13)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (53, 4)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (53, 8)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (53, 12)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (54, 6)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (54, 10)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (54, 11)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (54, 13)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (55, 3)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (55, 5)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (55, 7)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (55, 13)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (56, 7)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (56, 8)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (56, 9)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (56, 11)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (57, 4)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (57, 7)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (57, 9)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (57, 10)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (58, 1)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (58, 4)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (58, 10)
GO
INSERT [dbo].[GameGenres] ([GameId], [GenreId]) VALUES (58, 12)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (1, 3)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (1, 5)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (2, 3)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (2, 4)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (3, 2)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (3, 8)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (4, 3)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (4, 5)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (4, 9)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (5, 2)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (5, 3)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (5, 12)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (6, 1)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (6, 5)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (6, 7)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (7, 4)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (7, 10)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (7, 11)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (8, 6)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (8, 12)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (9, 5)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (9, 6)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (9, 11)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (10, 8)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (10, 10)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (10, 13)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (11, 5)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (11, 12)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (12, 3)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (12, 6)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (12, 8)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (13, 9)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (13, 10)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (13, 13)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (14, 3)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (14, 8)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (14, 9)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (15, 5)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (15, 11)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (16, 7)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (16, 11)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (16, 12)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (17, 2)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (17, 4)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (17, 8)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (18, 5)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (18, 9)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (19, 2)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (19, 3)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (19, 10)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (20, 4)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (20, 10)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (20, 13)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (21, 5)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (21, 13)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (22, 7)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (22, 12)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (23, 1)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (23, 7)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (23, 12)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (24, 10)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (24, 11)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (24, 13)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (25, 7)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (25, 9)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (25, 10)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (26, 1)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (26, 2)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (26, 8)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (27, 5)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (27, 6)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (27, 11)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (28, 4)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (28, 5)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (28, 13)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (29, 8)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (29, 9)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (29, 12)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (30, 3)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (30, 7)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (30, 10)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (31, 6)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (31, 7)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (31, 12)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (32, 3)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (32, 6)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (32, 12)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (33, 9)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (33, 10)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (33, 12)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (34, 3)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (34, 7)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (34, 9)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (35, 3)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (35, 6)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (35, 12)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (36, 3)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (36, 10)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (36, 11)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (37, 2)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (37, 12)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (37, 13)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (38, 9)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (38, 13)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (39, 1)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (39, 2)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (39, 11)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (40, 2)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (40, 3)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (41, 6)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (41, 7)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (41, 13)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (42, 1)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (42, 5)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (42, 6)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (43, 2)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (43, 5)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (43, 8)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (44, 7)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (44, 9)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (44, 11)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (45, 1)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (45, 4)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (45, 13)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (46, 3)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (46, 10)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (47, 2)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (47, 3)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (47, 6)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (48, 5)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (48, 10)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (49, 1)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (49, 5)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (49, 12)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (50, 4)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (50, 10)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (50, 11)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (51, 2)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (51, 8)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (51, 9)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (52, 11)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (52, 12)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (52, 13)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (53, 13)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (54, 2)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (54, 4)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (54, 5)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (55, 3)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (55, 8)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (55, 12)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (56, 2)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (56, 8)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (56, 9)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (57, 1)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (57, 4)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (58, 5)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (58, 6)
GO
INSERT [dbo].[GamePlatforms] ([GameId], [PlatformId]) VALUES (58, 9)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (1, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (1, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (1, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (1, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (2, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (2, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (2, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (2, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (3, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (3, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (3, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (3, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (4, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (4, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (4, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (4, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (5, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (5, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (5, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (5, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (6, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (6, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (6, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (6, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (7, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (7, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (7, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (7, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (8, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (8, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (8, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (8, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (9, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (9, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (9, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (9, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (10, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (10, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (10, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (10, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (11, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (11, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (11, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (11, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (12, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (12, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (12, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (12, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (13, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (13, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (13, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (13, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (14, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (14, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (14, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (14, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (15, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (15, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (15, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (15, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (16, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (16, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (16, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (16, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (17, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (17, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (17, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (18, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (18, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (18, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (18, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (19, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (19, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (19, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (19, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (20, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (20, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (20, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (20, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (21, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (21, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (21, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (21, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (22, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (22, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (22, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (22, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (23, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (23, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (23, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (23, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (24, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (24, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (24, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (24, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (25, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (25, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (25, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (25, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (26, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (26, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (26, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (27, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (27, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (27, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (27, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (28, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (28, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (28, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (28, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (29, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (29, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (29, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (29, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (30, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (30, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (30, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (30, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (31, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (31, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (32, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (32, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (32, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (32, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (33, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (33, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (33, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (33, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (34, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (34, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (34, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (34, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (35, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (35, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (35, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (35, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (36, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (36, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (36, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (36, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (37, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (37, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (37, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (38, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (38, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (38, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (39, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (39, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (39, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (39, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (40, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (40, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (40, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (40, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (41, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (41, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (41, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (41, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (42, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (42, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (42, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (43, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (43, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (43, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (43, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (44, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (44, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (44, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (44, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (45, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (45, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (45, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (45, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (46, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (46, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (46, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (46, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (47, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (47, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (47, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (47, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (48, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (48, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (48, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (48, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (49, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (49, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (49, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (49, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (50, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (50, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (50, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (50, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (51, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (51, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (51, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (52, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (52, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (52, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (52, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (53, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (53, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (53, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (54, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (54, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (54, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (54, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (55, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (55, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (55, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (55, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (56, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (56, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (56, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (56, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (57, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (57, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (57, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (57, 4)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (58, 1)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (58, 2)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (58, 3)
GO
INSERT [dbo].[GameRegions] ([GameId], [RegionId]) VALUES (58, 4)
GO
SET IDENTITY_INSERT [dbo].[Games] ON 
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (1, N'God of War', N'Standard', 2018, 4, 59.99, 20)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (2, N'God of War: Ragnarok', N'Standard', 2022, 4, 59.99, 0)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (3, N'Red Dead Redemption', N'Standard', 2010, 1, 59.99, 60)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (4, N'Red Dead Redemption 2', N'Standard', 2018, 1, 59.99, 0)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (5, N'Death Stranding', N'Standard', 2019, 17, 59.99, 0)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (6, N'Metal Gear Solid V: The Phantom Pain', N'Standard', 2015, 12, 59.99, 0)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (7, N'Max Payne 3', N'Standard', 2012, 1, 59.99, 42)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (8, N'Doom', N'Standard', 2016, 16, 59.99, 15)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (9, N'Grand Theft Auto V', N'Standard', 2013, 1, 59.99, 75)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (10, N'Life is Strange', N'Standard', 2015, 11, 19.99, 18)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (11, N'Assassin''s Creed: Odyssey', N'Standard', 2018, 10, 59.99, 0)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (12, N'Horizon Zero Dawn', N'Standard', 2017, 4, 59.99, 0)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (13, N'Far Cry 4', N'Standard', 2014, 10, 59.99, 28)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (14, N'Far Cry 5', N'Standard', 2018, 10, 59.99, 0)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (15, N'Far Cry 6', N'Standard', 2021, 10, 59.99, 0)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (16, N'Hitman: Absolution', N'Standard', 2012, 11, 59.99, 62)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (17, N'Resident Evil VII: Biohazard', N'Standard', 2017, 14, 59.99, 12)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (18, N'Spider-Man', N'Standard', 2018, 4, 59.99, 0)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (19, N'Assassin''s Creed IV: Black Flag', N'Standard', 2013, 10, 59.99, 25)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (20, N'Uncharted 4: A Thief''s End', N'Standard', 2016, 18, 59.99, 0)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (21, N'Days Gone', N'Standard', 2019, 4, 59.99, 0)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (22, N'Detroit: Become Human', N'Standard', 2018, 4, 59.99, 0)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (23, N'Shadow of the Tomb Raider', N'Standard', 2018, 11, 59.99, 12)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (24, N'Forza Horizon 4', N'Standard', 2018, 5, 59.99, 0)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (25, N'The Witcher 3: Wild Hunt', N'Standard', 2015, 18, 59.99, 8)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (26, N'The Last of Us', N'Standard', 2013, 2, 60, 10)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (27, N'The Legend of Zelda: Breath of the Wild', N'Standard', 2017, 3, 80, 15)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (28, N'Final Fantasy VII Remake', N'Standard', 2020, 4, 70, 20)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (29, N'BioShock Infinite', N'Standard', 2013, 5, 40, 25)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (30, N'Super Mario Odyssey', N'Standard', 2017, 6, 50, 30)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (31, N'Super Mario Galaxy 2', N'Standard', 2010, 6, 30, 35)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (32, N'Minecraft', N'Standard', 2011, 7, 20, 40)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (33, N'The Elder Scrolls V: Skyrim', N'Standard', 2011, 8, 60, 45)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (34, N'Super Smash Bros. Ultimate', N'Standard', 2018, 9, 70, 50)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (35, N'Dark Souls III', N'Standard', 2016, 11, 50, 60)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (36, N'Overwatch', N'Standard', 2016, 13, 60, 70)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (37, N'Monster Hunter: World', N'Standard', 2018, 14, 40, 75)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (38, N'Fallout 4', N'Standard', 2015, 15, 50, 80)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (39, N'The Legend of Zelda: Ocarina of Time', N'Standard', 1998, 3, 20, 85)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (40, N'Portal 2', N'Standard', 2011, 16, 50, 90)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (41, N'Mass Effect 2', N'Standard', 2010, 17, 40, 95)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (42, N'Dragon Quest XI: Echoes of an Elusive Age', N'Standard', 2018, 18, 60, 100)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (43, N'FIFA 21', N'Standard', 2020, 18, 60, 10)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (44, N'Call of Duty: Warzone', N'Standard', 2020, 12, 45, 15)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (45, N'Among Us', N'Standard', 2018, 16, 5, 20)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (46, N'Dota 2', N'Standard', 2013, 17, 10, 0)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (47, N'Fortnite Battle Royale', N'Standard', 2017, 13, 35, 30)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (48, N'Apex Legends', N'Standard', 2019, 14, 0, 35)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (49, N'Animal Crossing: New Horizons', N'Standard', 2020, 6, 60, 45)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (50, N'The Last of Us Part II', N'Standard', 2020, 2, 70, 0)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (51, N'Final Fantasy XIV', N'Standard', 2013, 4, 13, 55)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (52, N'Monster Hunter World: Iceborne', N'Standard', 2019, 14, 40, 60)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (53, N'Star Wars Jedi: Fallen Order', N'Standard', 2019, 10, 60, 65)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (54, N'Sekiro: Shadows Die Twice', N'Standard', 2019, 11, 60, 70)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (55, N'Resident Evil 2', N'Standard', 2019, 11, 60, 80)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (56, N'Devil May Cry 5', N'Standard', 2019, 12, 60, 85)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (57, N'A Way Out', N'Standard', 2018, 16, 20, 90)
GO
INSERT [dbo].[Games] ([Id], [Title], [Edition], [ReleaseYear], [PublisherId], [Price], [Discount]) VALUES (58, N'Hitman 2', N'Standard', 2018, 17, 60, 95)
GO
SET IDENTITY_INSERT [dbo].[Games] OFF
GO
SET IDENTITY_INSERT [dbo].[Genres] ON 
GO
INSERT [dbo].[Genres] ([Id], [Genre]) VALUES (1, N'Action')
GO
INSERT [dbo].[Genres] ([Id], [Genre]) VALUES (2, N'Adventure')
GO
INSERT [dbo].[Genres] ([Id], [Genre]) VALUES (12, N'Battle Royale')
GO
INSERT [dbo].[Genres] ([Id], [Genre]) VALUES (9, N'Casual')
GO
INSERT [dbo].[Genres] ([Id], [Genre]) VALUES (4, N'Fighting')
GO
INSERT [dbo].[Genres] ([Id], [Genre]) VALUES (13, N'Horror')
GO
INSERT [dbo].[Genres] ([Id], [Genre]) VALUES (18, N'Multiplayer')
GO
INSERT [dbo].[Genres] ([Id], [Genre]) VALUES (16, N'Open-World')
GO
INSERT [dbo].[Genres] ([Id], [Genre]) VALUES (5, N'Puzzle')
GO
INSERT [dbo].[Genres] ([Id], [Genre]) VALUES (7, N'Racing')
GO
INSERT [dbo].[Genres] ([Id], [Genre]) VALUES (3, N'Role-Playing')
GO
INSERT [dbo].[Genres] ([Id], [Genre]) VALUES (14, N'Sci-Fi')
GO
INSERT [dbo].[Genres] ([Id], [Genre]) VALUES (15, N'Shooting')
GO
INSERT [dbo].[Genres] ([Id], [Genre]) VALUES (8, N'Simulation')
GO
INSERT [dbo].[Genres] ([Id], [Genre]) VALUES (17, N'Singleplayer')
GO
INSERT [dbo].[Genres] ([Id], [Genre]) VALUES (6, N'Sports')
GO
INSERT [dbo].[Genres] ([Id], [Genre]) VALUES (10, N'Strategy')
GO
INSERT [dbo].[Genres] ([Id], [Genre]) VALUES (11, N'Survival')
GO
SET IDENTITY_INSERT [dbo].[Genres] OFF
GO
SET IDENTITY_INSERT [dbo].[Invoices] ON 
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (1, 1, CAST(N'2023-02-03T10:11:26.810' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (2, 3, CAST(N'2023-02-03T10:11:38.950' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (3, 4, CAST(N'2023-02-03T10:19:07.337' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (4, 5, CAST(N'2023-02-03T10:19:22.427' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (5, 6, CAST(N'2023-02-03T10:19:23.163' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (6, 7, CAST(N'2023-02-03T10:19:23.357' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (7, 8, CAST(N'2023-02-03T10:19:23.693' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (8, 9, CAST(N'2023-02-03T10:19:23.853' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (9, 10, CAST(N'2023-02-03T10:19:24.007' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (10, 11, CAST(N'2023-02-03T10:19:32.033' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (11, 12, CAST(N'2023-02-03T10:19:32.573' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (12, 13, CAST(N'2023-02-03T10:19:32.750' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (13, 14, CAST(N'2023-02-03T10:19:32.893' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (14, 15, CAST(N'2023-02-03T10:19:33.183' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (15, 16, CAST(N'2023-02-03T10:19:33.437' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (16, 17, CAST(N'2023-02-03T10:19:33.610' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (17, 18, CAST(N'2023-02-03T10:19:33.793' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (18, 19, CAST(N'2023-02-03T10:19:33.963' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (19, 20, CAST(N'2023-02-03T10:19:34.147' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (20, 21, CAST(N'2023-02-03T10:19:34.350' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (21, 22, CAST(N'2023-02-03T10:19:34.500' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (22, 23, CAST(N'2023-02-03T10:19:34.667' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (23, 24, CAST(N'2023-02-03T10:19:34.833' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (24, 25, CAST(N'2023-02-03T10:19:35.010' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (25, 26, CAST(N'2023-02-03T10:19:35.260' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (26, 27, CAST(N'2023-02-03T10:19:35.470' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (27, 28, CAST(N'2023-02-03T10:19:35.717' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (28, 29, CAST(N'2023-02-03T10:19:35.927' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (29, 30, CAST(N'2023-02-03T10:19:36.167' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (30, 31, CAST(N'2023-02-03T10:19:36.407' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (31, 32, CAST(N'2023-02-03T10:19:36.587' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (32, 33, CAST(N'2023-02-03T10:19:36.790' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (33, 34, CAST(N'2023-02-03T10:19:36.963' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (34, 35, CAST(N'2023-02-03T10:19:37.243' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (35, 36, CAST(N'2023-02-03T10:19:37.420' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (36, 37, CAST(N'2023-02-03T10:19:37.627' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (37, 38, CAST(N'2023-02-03T10:19:37.807' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (38, 39, CAST(N'2023-02-03T10:19:38.113' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (39, 40, CAST(N'2023-02-03T10:19:38.290' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (40, 42, CAST(N'2023-02-03T10:19:38.727' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (41, 43, CAST(N'2023-02-03T10:19:38.910' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (42, 44, CAST(N'2023-02-03T10:19:39.130' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (43, 45, CAST(N'2023-02-03T10:19:39.387' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (44, 46, CAST(N'2023-02-03T10:19:39.560' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (45, 47, CAST(N'2023-02-03T10:19:39.770' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (46, 48, CAST(N'2023-02-03T10:19:40.060' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (47, 49, CAST(N'2023-02-03T10:19:40.240' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (48, 50, CAST(N'2023-02-03T10:19:40.433' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (49, 51, CAST(N'2023-02-03T10:19:40.723' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (50, 53, CAST(N'2023-02-03T10:19:41.160' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (51, 54, CAST(N'2023-02-03T10:19:41.350' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (52, 55, CAST(N'2023-02-03T10:19:41.553' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (53, 56, CAST(N'2023-02-03T10:19:41.673' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (54, 58, CAST(N'2023-02-03T10:19:43.603' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (55, 60, CAST(N'2023-02-03T10:19:44.073' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (56, 61, CAST(N'2023-02-03T10:19:44.270' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (57, 62, CAST(N'2023-02-03T10:19:44.427' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (58, 63, CAST(N'2023-02-03T10:19:44.610' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (59, 65, CAST(N'2023-02-03T10:19:44.970' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (60, 66, CAST(N'2023-02-03T10:19:45.130' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (61, 67, CAST(N'2023-02-03T10:19:45.643' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (62, 68, CAST(N'2023-02-03T10:19:45.813' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (63, 69, CAST(N'2023-02-03T10:19:46.000' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (64, 70, CAST(N'2023-02-03T10:19:46.150' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (65, 71, CAST(N'2023-02-03T10:19:46.357' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (66, 72, CAST(N'2023-02-03T10:19:46.560' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (67, 73, CAST(N'2023-02-03T10:19:46.727' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (68, 74, CAST(N'2023-02-03T10:19:46.917' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (69, 75, CAST(N'2023-02-03T10:19:47.090' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (70, 76, CAST(N'2023-02-03T10:19:47.353' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (71, 77, CAST(N'2023-02-03T10:19:47.553' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (72, 78, CAST(N'2023-02-03T10:19:47.730' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (73, 79, CAST(N'2023-02-03T10:19:47.917' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (74, 80, CAST(N'2023-02-03T10:19:48.087' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (75, 81, CAST(N'2023-02-03T10:19:48.280' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (76, 82, CAST(N'2023-02-03T10:19:48.507' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (77, 83, CAST(N'2023-02-03T10:19:48.673' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (78, 84, CAST(N'2023-02-03T10:19:48.873' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (79, 86, CAST(N'2023-02-03T10:19:49.240' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (80, 87, CAST(N'2023-02-03T10:19:49.463' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (81, 88, CAST(N'2023-02-03T10:19:49.610' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (82, 89, CAST(N'2023-02-03T10:19:49.787' AS DateTime))
GO
INSERT [dbo].[Invoices] ([Id], [OrderId], [Date]) VALUES (83, 90, CAST(N'2023-02-03T13:16:47.173' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Invoices] OFF
GO
SET IDENTITY_INSERT [dbo].[PaymentMethods] ON 
GO
INSERT [dbo].[PaymentMethods] ([Id], [PaymentMethod]) VALUES (3, N'Amazon Pay')
GO
INSERT [dbo].[PaymentMethods] ([Id], [PaymentMethod]) VALUES (4, N'Apple Pay')
GO
INSERT [dbo].[PaymentMethods] ([Id], [PaymentMethod]) VALUES (1, N'Card')
GO
INSERT [dbo].[PaymentMethods] ([Id], [PaymentMethod]) VALUES (5, N'Google Pay')
GO
INSERT [dbo].[PaymentMethods] ([Id], [PaymentMethod]) VALUES (2, N'PayPal')
GO
SET IDENTITY_INSERT [dbo].[PaymentMethods] OFF
GO
SET IDENTITY_INSERT [dbo].[Platforms] ON 
GO
INSERT [dbo].[Platforms] ([Id], [Platform], [PlatformShort]) VALUES (1, N'PlayStation 2', N'PS2')
GO
INSERT [dbo].[Platforms] ([Id], [Platform], [PlatformShort]) VALUES (2, N'PlayStation 3', N'PS3')
GO
INSERT [dbo].[Platforms] ([Id], [Platform], [PlatformShort]) VALUES (3, N'PlayStation 4', N'PS4')
GO
INSERT [dbo].[Platforms] ([Id], [Platform], [PlatformShort]) VALUES (4, N'PlayStation 5', N'PS5')
GO
INSERT [dbo].[Platforms] ([Id], [Platform], [PlatformShort]) VALUES (5, N'Microsoft Windows', N'PC')
GO
INSERT [dbo].[Platforms] ([Id], [Platform], [PlatformShort]) VALUES (6, N'Nintendo Switch', NULL)
GO
INSERT [dbo].[Platforms] ([Id], [Platform], [PlatformShort]) VALUES (7, N'Xbox', NULL)
GO
INSERT [dbo].[Platforms] ([Id], [Platform], [PlatformShort]) VALUES (8, N'Xbox 360', NULL)
GO
INSERT [dbo].[Platforms] ([Id], [Platform], [PlatformShort]) VALUES (9, N'Xbox One', NULL)
GO
INSERT [dbo].[Platforms] ([Id], [Platform], [PlatformShort]) VALUES (10, N'Xbox One S', NULL)
GO
INSERT [dbo].[Platforms] ([Id], [Platform], [PlatformShort]) VALUES (11, N'Xbox One X', NULL)
GO
INSERT [dbo].[Platforms] ([Id], [Platform], [PlatformShort]) VALUES (12, N'Xbox Series S', NULL)
GO
INSERT [dbo].[Platforms] ([Id], [Platform], [PlatformShort]) VALUES (13, N'Xbox Series X', NULL)
GO
SET IDENTITY_INSERT [dbo].[Platforms] OFF
GO
SET IDENTITY_INSERT [dbo].[Publishers] ON 
GO
INSERT [dbo].[Publishers] ([Id], [Publisher]) VALUES (15, N'2K Games')
GO
INSERT [dbo].[Publishers] ([Id], [Publisher]) VALUES (17, N'505 Games')
GO
INSERT [dbo].[Publishers] ([Id], [Publisher]) VALUES (6, N'Activision Blizzard')
GO
INSERT [dbo].[Publishers] ([Id], [Publisher]) VALUES (8, N'Bandai Namco')
GO
INSERT [dbo].[Publishers] ([Id], [Publisher]) VALUES (16, N'Bethesda Softworks')
GO
INSERT [dbo].[Publishers] ([Id], [Publisher]) VALUES (14, N'Capcom')
GO
INSERT [dbo].[Publishers] ([Id], [Publisher]) VALUES (2, N'Electronic Arts')
GO
INSERT [dbo].[Publishers] ([Id], [Publisher]) VALUES (12, N'Konami Games')
GO
INSERT [dbo].[Publishers] ([Id], [Publisher]) VALUES (5, N'Microsoft')
GO
INSERT [dbo].[Publishers] ([Id], [Publisher]) VALUES (18, N'Naughty Dog')
GO
INSERT [dbo].[Publishers] ([Id], [Publisher]) VALUES (7, N'Nintendo')
GO
INSERT [dbo].[Publishers] ([Id], [Publisher]) VALUES (1, N'Rockstar Games')
GO
INSERT [dbo].[Publishers] ([Id], [Publisher]) VALUES (13, N'Sega')
GO
INSERT [dbo].[Publishers] ([Id], [Publisher]) VALUES (4, N'Sony Interactive Entertainment')
GO
INSERT [dbo].[Publishers] ([Id], [Publisher]) VALUES (11, N'Square Enix')
GO
INSERT [dbo].[Publishers] ([Id], [Publisher]) VALUES (9, N'Take-Two Interactive')
GO
INSERT [dbo].[Publishers] ([Id], [Publisher]) VALUES (3, N'Tencent Games')
GO
INSERT [dbo].[Publishers] ([Id], [Publisher]) VALUES (10, N'Ubisoft')
GO
SET IDENTITY_INSERT [dbo].[Publishers] OFF
GO
SET IDENTITY_INSERT [dbo].[Regions] ON 
GO
INSERT [dbo].[Regions] ([Id], [Region]) VALUES (1, N'America')
GO
INSERT [dbo].[Regions] ([Id], [Region]) VALUES (3, N'Asia')
GO
INSERT [dbo].[Regions] ([Id], [Region]) VALUES (2, N'Europe')
GO
INSERT [dbo].[Regions] ([Id], [Region]) VALUES (4, N'Japan')
GO
SET IDENTITY_INSERT [dbo].[Regions] OFF
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (1, 1, 10, N'This Game is amazing!')
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (1, 2, 10, N'I love this game!')
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (1, 16, 1, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (1, 17, 4, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (1, 28, 2, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (1, 30, 4, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (1, 33, 4, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (1, 36, 1, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (1, 43, 3, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (1, 45, 6, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (1, 46, 2, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (1, 50, 4, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (1, 58, 5, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (2, 1, 6, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (2, 6, 1, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (2, 7, 1, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (2, 9, 6, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (2, 15, 10, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (2, 22, 1, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (2, 36, 8, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (2, 42, 5, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (2, 51, 10, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (2, 56, 10, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (3, 7, 9, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (3, 19, 9, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (3, 27, 8, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (3, 29, 9, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (3, 30, 9, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (3, 37, 10, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (3, 38, 1, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (3, 39, 4, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (3, 40, 4, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (3, 42, 8, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (3, 53, 5, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (4, 1, 2, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (4, 2, 3, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (4, 3, 2, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (4, 13, 2, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (4, 14, 4, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (4, 22, 10, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (4, 30, 7, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (4, 34, 7, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (4, 35, 9, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (4, 37, 9, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (4, 44, 10, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (4, 47, 5, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (4, 48, 9, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (4, 50, 3, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (4, 57, 6, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (5, 5, 8, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (5, 6, 9, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (5, 8, 4, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (5, 11, 7, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (5, 14, 6, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (5, 16, 3, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (5, 17, 10, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (5, 23, 8, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (5, 26, 9, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (5, 28, 1, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (5, 30, 9, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (5, 33, 5, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (5, 39, 7, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (5, 44, 5, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (5, 47, 5, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (5, 48, 7, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (5, 53, 7, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (5, 58, 9, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (6, 14, 1, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (6, 24, 4, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (6, 31, 6, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (6, 33, 9, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (6, 37, 2, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (6, 39, 6, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (6, 41, 1, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (6, 43, 3, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (6, 44, 4, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (6, 52, 1, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (6, 56, 7, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (6, 57, 6, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (7, 5, 3, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (7, 7, 7, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (7, 8, 1, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (7, 9, 5, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (7, 10, 8, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (7, 14, 6, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (7, 15, 2, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (7, 20, 4, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (7, 23, 3, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (7, 29, 9, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (7, 31, 8, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (7, 32, 6, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (7, 37, 9, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (7, 38, 8, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (7, 43, 2, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (7, 53, 1, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (7, 54, 2, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (7, 57, 6, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (8, 2, 5, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (8, 6, 6, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (8, 9, 1, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (8, 13, 4, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (8, 21, 5, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (8, 36, 2, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (8, 37, 6, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (8, 49, 6, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (8, 50, 10, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (8, 53, 10, NULL)
GO
INSERT [dbo].[Reviews] ([CustomerId], [GameId], [Rating], [Review]) VALUES (8, 54, 7, NULL)
GO
SET IDENTITY_INSERT [dbo].[Transactions] ON 
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (1, 1, 1, CAST(N'2023-02-03T10:11:26.810' AS DateTime), 1, 47.992000000000004)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (3, 1, 2, CAST(N'2023-02-03T10:11:38.950' AS DateTime), 1, 59.99)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (44, 1, 9, CAST(N'2023-02-03T10:19:39.130' AS DateTime), 3, 14.997500000000002)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (63, 1, 12, CAST(N'2023-02-03T10:19:44.610' AS DateTime), 5, 59.99)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (10, 1, 13, CAST(N'2023-02-03T10:19:24.007' AS DateTime), 4, 43.1928)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (7, 1, 23, CAST(N'2023-02-03T10:19:23.353' AS DateTime), 2, 52.7912)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (78, 1, 24, CAST(N'2023-02-03T10:19:47.730' AS DateTime), 3, 59.99)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (22, 1, 27, CAST(N'2023-02-03T10:19:34.500' AS DateTime), 5, 68)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (16, 1, 28, CAST(N'2023-02-03T10:19:33.437' AS DateTime), 3, 56)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (45, 1, 34, CAST(N'2023-02-03T10:19:39.387' AS DateTime), 1, 35)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (35, 1, 35, CAST(N'2023-02-03T10:19:37.243' AS DateTime), 2, 20)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (32, 1, 45, CAST(N'2023-02-03T10:19:36.587' AS DateTime), 5, 4)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (14, 1, 50, CAST(N'2023-02-03T10:19:32.893' AS DateTime), 3, 70)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (4, 2, 1, CAST(N'2023-02-03T10:19:07.333' AS DateTime), 1, 47.992000000000004)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (72, 2, 6, CAST(N'2023-02-03T10:19:46.560' AS DateTime), 1, 59.99)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (34, 2, 15, CAST(N'2023-02-03T10:19:36.960' AS DateTime), 4, 59.99)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (9, 2, 26, CAST(N'2023-02-03T10:19:23.853' AS DateTime), 3, 54)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (29, 2, 35, CAST(N'2023-02-03T10:19:35.927' AS DateTime), 4, 20)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (58, 2, 36, CAST(N'2023-02-03T10:19:43.603' AS DateTime), 4, 18)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (27, 2, 41, CAST(N'2023-02-03T10:19:35.470' AS DateTime), 4, 2)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (76, 2, 43, CAST(N'2023-02-03T10:19:47.353' AS DateTime), 3, 54)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (67, 2, 47, CAST(N'2023-02-03T10:19:45.643' AS DateTime), 4, 24.5)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (13, 2, 56, CAST(N'2023-02-03T10:19:32.750' AS DateTime), 4, 9)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (77, 3, 5, CAST(N'2023-02-03T10:19:47.553' AS DateTime), 5, 59.99)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (66, 3, 8, CAST(N'2023-02-03T10:19:45.130' AS DateTime), 4, 50.9915)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (88, 3, 19, CAST(N'2023-02-03T10:19:49.610' AS DateTime), 2, 44.9925)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (50, 3, 24, CAST(N'2023-02-03T10:19:40.433' AS DateTime), 5, 59.99)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (74, 3, 39, CAST(N'2023-02-03T10:19:46.917' AS DateTime), 4, 3)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (68, 3, 41, CAST(N'2023-02-03T10:19:45.813' AS DateTime), 2, 2)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (56, 3, 46, CAST(N'2023-02-03T10:19:41.673' AS DateTime), 1, 10)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (17, 4, 2, CAST(N'2023-02-03T10:19:33.610' AS DateTime), 2, 59.99)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (12, 4, 9, CAST(N'2023-02-03T10:19:32.573' AS DateTime), 4, 14.997500000000002)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (81, 4, 19, CAST(N'2023-02-03T10:19:48.277' AS DateTime), 2, 44.9925)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (23, 4, 21, CAST(N'2023-02-03T10:19:34.667' AS DateTime), 3, 59.99)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (33, 4, 25, CAST(N'2023-02-03T10:19:36.790' AS DateTime), 3, 55.1908)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (69, 4, 27, CAST(N'2023-02-03T10:19:46.000' AS DateTime), 3, 68)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (84, 4, 33, CAST(N'2023-02-03T10:19:48.873' AS DateTime), 1, 33)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (75, 4, 37, CAST(N'2023-02-03T10:19:47.090' AS DateTime), 3, 10)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (20, 4, 40, CAST(N'2023-02-03T10:19:34.147' AS DateTime), 3, 5)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (15, 4, 42, CAST(N'2023-02-03T10:19:33.183' AS DateTime), 5, 0)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (55, 4, 50, CAST(N'2023-02-03T10:19:41.553' AS DateTime), 5, 70)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (71, 4, 51, CAST(N'2023-02-03T10:19:46.357' AS DateTime), 1, 5.85)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (82, 4, 54, CAST(N'2023-02-03T10:19:48.507' AS DateTime), 3, 18)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (19, 5, 3, CAST(N'2023-02-03T10:19:33.963' AS DateTime), 5, 23.996000000000002)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (11, 5, 6, CAST(N'2023-02-03T10:19:32.033' AS DateTime), 1, 59.99)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (80, 5, 7, CAST(N'2023-02-03T10:19:48.087' AS DateTime), 3, 34.794200000000004)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (73, 5, 10, CAST(N'2023-02-03T10:19:46.727' AS DateTime), 1, 16.3918)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (31, 5, 11, CAST(N'2023-02-03T10:19:36.407' AS DateTime), 5, 59.99)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (37, 5, 18, CAST(N'2023-02-03T10:19:37.623' AS DateTime), 5, 59.99)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (46, 5, 25, CAST(N'2023-02-03T10:19:39.560' AS DateTime), 4, 55.1908)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (83, 5, 27, CAST(N'2023-02-03T10:19:48.673' AS DateTime), 3, 68)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (60, 5, 34, CAST(N'2023-02-03T10:19:44.073' AS DateTime), 1, 35)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (24, 5, 38, CAST(N'2023-02-03T10:19:34.833' AS DateTime), 5, 10)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (40, 5, 50, CAST(N'2023-02-03T10:19:38.290' AS DateTime), 4, 70)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (18, 5, 54, CAST(N'2023-02-03T10:19:33.793' AS DateTime), 2, 18)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (39, 5, 57, CAST(N'2023-02-03T10:19:38.113' AS DateTime), 2, 2)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (51, 6, 7, CAST(N'2023-02-03T10:19:40.723' AS DateTime), 4, 34.794200000000004)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (5, 6, 11, CAST(N'2023-02-03T10:19:22.423' AS DateTime), 2, 59.99)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (47, 6, 23, CAST(N'2023-02-03T10:19:39.770' AS DateTime), 2, 52.7912)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (79, 6, 41, CAST(N'2023-02-03T10:19:47.917' AS DateTime), 5, 2)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (26, 6, 43, CAST(N'2023-02-03T10:19:35.260' AS DateTime), 5, 54)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (86, 7, 2, CAST(N'2023-02-03T10:19:49.240' AS DateTime), 3, 59.99)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (25, 7, 11, CAST(N'2023-02-03T10:19:35.010' AS DateTime), 1, 59.99)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (49, 7, 16, CAST(N'2023-02-03T10:19:40.240' AS DateTime), 1, 22.7962)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (61, 7, 17, CAST(N'2023-02-03T10:19:44.270' AS DateTime), 5, 52.7912)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (90, 7, 23, CAST(N'2023-02-03T13:16:47.160' AS DateTime), 5, 52.7912)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (36, 7, 24, CAST(N'2023-02-03T10:19:37.420' AS DateTime), 3, 59.99)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (6, 7, 27, CAST(N'2023-02-03T10:19:23.163' AS DateTime), 2, 68)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (28, 7, 28, CAST(N'2023-02-03T10:19:35.717' AS DateTime), 1, 56)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (42, 7, 31, CAST(N'2023-02-03T10:19:38.727' AS DateTime), 4, 19.5)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (53, 7, 35, CAST(N'2023-02-03T10:19:41.160' AS DateTime), 2, 20)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (8, 7, 43, CAST(N'2023-02-03T10:19:23.693' AS DateTime), 2, 54)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (89, 7, 45, CAST(N'2023-02-03T10:19:49.787' AS DateTime), 2, 4)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (30, 7, 46, CAST(N'2023-02-03T10:19:36.167' AS DateTime), 2, 10)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (87, 8, 3, CAST(N'2023-02-03T10:19:49.463' AS DateTime), 2, 23.996000000000002)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (21, 8, 5, CAST(N'2023-02-03T10:19:34.350' AS DateTime), 1, 59.99)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (65, 8, 9, CAST(N'2023-02-03T10:19:44.970' AS DateTime), 1, 14.997500000000002)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (48, 8, 11, CAST(N'2023-02-03T10:19:40.060' AS DateTime), 1, 59.99)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (38, 8, 29, CAST(N'2023-02-03T10:19:37.807' AS DateTime), 5, 30)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (54, 8, 34, CAST(N'2023-02-03T10:19:41.350' AS DateTime), 4, 35)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (62, 8, 46, CAST(N'2023-02-03T10:19:44.427' AS DateTime), 1, 10)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (70, 8, 47, CAST(N'2023-02-03T10:19:46.150' AS DateTime), 1, 24.5)
GO
INSERT [dbo].[Transactions] ([Id], [CustomerId], [GameId], [Date], [PaymentMethodId], [TotalPrice]) VALUES (43, 8, 50, CAST(N'2023-02-03T10:19:38.910' AS DateTime), 1, 70)
GO
SET IDENTITY_INSERT [dbo].[Transactions] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Customer__A9D10534B8EA3BF7]    Script Date: 2/7/2023 8:46:27 AM ******/
ALTER TABLE [dbo].[Customers] ADD UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Genres__F1410CF326582D46]    Script Date: 2/7/2023 8:46:27 AM ******/
ALTER TABLE [dbo].[Genres] ADD UNIQUE NONCLUSTERED 
(
	[Genre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__PaymentM__4D355D498B659F0C]    Script Date: 2/7/2023 8:46:27 AM ******/
ALTER TABLE [dbo].[PaymentMethods] ADD UNIQUE NONCLUSTERED 
(
	[PaymentMethod] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Platform__130CCEA2E87837DB]    Script Date: 2/7/2023 8:46:27 AM ******/
ALTER TABLE [dbo].[Platforms] ADD UNIQUE NONCLUSTERED 
(
	[Platform] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Publishe__C25E15ABFA7EA346]    Script Date: 2/7/2023 8:46:27 AM ******/
ALTER TABLE [dbo].[Publishers] ADD UNIQUE NONCLUSTERED 
(
	[Publisher] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Regions__D3C77407878ABB54]    Script Date: 2/7/2023 8:46:27 AM ******/
ALTER TABLE [dbo].[Regions] ADD UNIQUE NONCLUSTERED 
(
	[Region] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [PK__Transact__3214EC065F0F91EE]    Script Date: 2/7/2023 8:46:27 AM ******/
ALTER TABLE [dbo].[Transactions] ADD PRIMARY KEY NONCLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Games] ADD  DEFAULT ('Standard') FOR [Edition]
GO
ALTER TABLE [dbo].[Games] ADD  DEFAULT ((0)) FOR [Discount]
GO
ALTER TABLE [dbo].[Invoices] ADD  DEFAULT (getdate()) FOR [Date]
GO
ALTER TABLE [dbo].[Transactions] ADD  DEFAULT (getdate()) FOR [Date]
GO
ALTER TABLE [dbo].[Customers]  WITH CHECK ADD FOREIGN KEY([DefaultPaymentMethodId])
REFERENCES [dbo].[PaymentMethods] ([Id])
GO
ALTER TABLE [dbo].[Customers]  WITH CHECK ADD FOREIGN KEY([RegionId])
REFERENCES [dbo].[Regions] ([Id])
GO
ALTER TABLE [dbo].[GameGenres]  WITH CHECK ADD FOREIGN KEY([GameId])
REFERENCES [dbo].[Games] ([Id])
GO
ALTER TABLE [dbo].[GameGenres]  WITH CHECK ADD FOREIGN KEY([GenreId])
REFERENCES [dbo].[Genres] ([Id])
GO
ALTER TABLE [dbo].[GamePlatforms]  WITH CHECK ADD FOREIGN KEY([GameId])
REFERENCES [dbo].[Games] ([Id])
GO
ALTER TABLE [dbo].[GamePlatforms]  WITH CHECK ADD FOREIGN KEY([PlatformId])
REFERENCES [dbo].[Platforms] ([Id])
GO
ALTER TABLE [dbo].[GameRegions]  WITH CHECK ADD FOREIGN KEY([GameId])
REFERENCES [dbo].[Games] ([Id])
GO
ALTER TABLE [dbo].[GameRegions]  WITH CHECK ADD FOREIGN KEY([RegionId])
REFERENCES [dbo].[Regions] ([Id])
GO
ALTER TABLE [dbo].[Games]  WITH CHECK ADD FOREIGN KEY([PublisherId])
REFERENCES [dbo].[Publishers] ([Id])
GO
ALTER TABLE [dbo].[Invoices]  WITH CHECK ADD FOREIGN KEY([OrderId])
REFERENCES [dbo].[Transactions] ([Id])
GO
ALTER TABLE [dbo].[Reviews]  WITH CHECK ADD FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customers] ([Id])
GO
ALTER TABLE [dbo].[Reviews]  WITH CHECK ADD FOREIGN KEY([GameId])
REFERENCES [dbo].[Games] ([Id])
GO
ALTER TABLE [dbo].[Transactions]  WITH CHECK ADD FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customers] ([Id])
GO
ALTER TABLE [dbo].[Transactions]  WITH CHECK ADD FOREIGN KEY([GameId])
REFERENCES [dbo].[Games] ([Id])
GO
ALTER TABLE [dbo].[Transactions]  WITH CHECK ADD FOREIGN KEY([PaymentMethodId])
REFERENCES [dbo].[PaymentMethods] ([Id])
GO
ALTER TABLE [dbo].[Games]  WITH CHECK ADD CHECK  (([Discount]>=(0) AND [Discount]<=(100)))
GO
ALTER TABLE [dbo].[Games]  WITH CHECK ADD CHECK  (([ReleaseYear]>=(1900) AND [ReleaseYear]<=(2100)))
GO
ALTER TABLE [dbo].[Reviews]  WITH CHECK ADD CHECK  (([Rating]>=(1) AND [Rating]<=(10)))
GO
/****** Object:  StoredProcedure [dbo].[PurchaseGame]    Script Date: 2/7/2023 8:46:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[PurchaseGame]
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
GO
