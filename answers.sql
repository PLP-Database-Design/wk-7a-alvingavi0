QUESTION 1: Reaching First Normal Form, or 1NF
We must remove the multi-valued column Products in order to guarantee that the table satisfies 1NF. One product per order should be represented by each row. This can be accomplished by dividing the multi-valued Products column into distinct rows for every single product.

SQL Inquiry for 1NF:
-- Create a new table to store the normalized data
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(255),
    Product VARCHAR(255)
);

-- Insert data into the normalized table by splitting products into separate rows
INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product)
SELECT OrderID, CustomerName, TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n.n), ',', -1)) AS Product
FROM ProductDetail
JOIN (SELECT 1 AS n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8) n
ON CHAR_LENGTH(Products) -CHAR_LENGTH(REPLACE(Products, ',', '')) >= n.n - 1;

QUESTION 2: Reaching the Second Normal Form (DNF)
Partial dependencies must be eliminated in order to reach 2NF. When a non-key column depends on only a portion of the primary key, this is known as a partial dependency. In this instance, CustomerName solely depends on OrderID, which is a partial dependency, even if the table has a composite primary key of OrderID and Product.

In order to convert this table to 2NF, we must:

Since CustomerName depends only on OrderID, it should be separated from the OrderDetails record into a new table.

Make an OrderDetails table that just contains the OrderID and Product.

SQL queries related to 2NF:
-- Create a new table for Customers that maps OrderID to CustomerName
CREATE TABLE Customer (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(255)
);

-- Insert data into the Customer table
INSERT INTO Customer (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Create a new table for OrderDetails that only contains OrderID, Product, and Quantity
CREATE TABLE OrderDetails_2NF (
    OrderID INT,
    Product VARCHAR(255),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Customer(OrderID)
);

-- Insert data into the new OrderDetails table
INSERT INTO OrderDetails_2NF (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;
