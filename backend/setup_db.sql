CREATE DATABASE APP;
GO

USE APP;
GO

CREATE TABLE Products (
  productId INT PRIMARY KEY IDENTITY(1,1),
  productName NVARCHAR(100) NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  stock INT NOT NULL
);
GO

INSERT INTO Products (productName, price, stock) VALUES
('Fish', 20, 50),
('Banana', 15, 40),
('Ramen', 3, 30);
GO
