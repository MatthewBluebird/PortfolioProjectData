

-- Creating Data

GO
CREATE TABLE Orders
(
order_id INT PRIMARY KEY,
customer_id INT,
order_date DATE,
total_amount DECIMAL(10, 2),
payment_status VARCHAR(50),
product_id INT,
);
GO
CREATE TABLE Order_Items
(
order_item_id INT PRIMARY KEY,
order_id INT,
product_id INT,
quantity INT,
unit_price DECIMAL(10, 2),
FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);
GO
CREATE TABLE Products
(
product_id INT PRIMARY KEY,
product_name VARCHAR(100),
category VARCHAR(50),
price DECIMAL(10,2)
);
GO
INSERT INTO Orders VALUES
    (1, 101, '2023-01-05', 75.00, 'Paid', 106),
    (2, 102, '2023-02-10', 300.00, 'Paid', 103),
    (3, 103, '2023-03-15', 200.00, 'Pending', 102),
    (4, 104, '2023-04-20', 150.00, 'Paid', 105),
    (5, 105, '2023-05-25', 75.00, 'Paid', 106),
	(6, 106, '2024-02-29', 500.00, 'Paid', 101),
	(7, 103, '2024-01-17', 100.00, 'Paid', 104),
	(8, 103, '2024-01-01', 300.00, 'Paid', 103);
GO
INSERT INTO Order_Items VALUES
    (1, 1, 101, 2, 500.00),
    (2, 1, 102, 1, 200.00),
    (3, 2, 103, 1, 300.00),
    (4, 3, 104, 1, 100.00),
    (5, 4, 105, 3, 150.00),
    (6, 5, 106, 2, 75.00),
	(7, 6, 103, 2, 300.00),
	(8, 7, 103, 4, 300.00);
GO
INSERT INTO Products VALUES
    (101, 'Laptop', 'Electronics', 500.00),
    (102, 'Tablet', 'Electronics', 200.00),
    (103, 'Smartphone', 'Electronics', 300.00),
    (104, 'Headphones', 'Accessories', 100.00),
    (105, 'Smartwatch', 'Wearable Tech', 150.00),
    (106, 'External Hard Drive', 'Computer Accessories', 75.00);

SELECT ORD.order_id, ORD.customer_id, ORD.total_amount, ORD.payment_status, ITM.quantity, ITM.unit_price, PRO.product_name, PRO.category, PRO.price
FROM Orders ORD
JOIN Order_Items ITM
	ON ORD.order_id = ITM.order_item_id
JOIN Products PRO
	ON ORD.customer_id = PRO.product_id


--What is the total number of orders placed in the past year?

SELECT COUNT(order_id) AS NumOfOrdersPastYear
FROM Orders 
WHERE order_date < '2023-10-29'

--How many unique customers placed orders in the past year?

WITH UniqueCustomer AS
(
SELECT customer_id, ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY customer_id) AS CustometDublication -- if more than 1 then dublication
FROM Orders
)

SELECT COUNT(customer_id) AS UniqueCustomers
FROM UniqueCustomer
WHERE CustometDublication = 1

--What is the total revenue generated from orders placed in the past year?

SELECT SUM(total_amount) AS TotalRevenue
FROM Orders 
WHERE order_date < '2023-10-29'

--What are the top 5 best-selling products (by quantity) in the past year?


SELECT ITM.quantity, PRO.product_name, SUM(ITM.quantity) OVER (PARTITION BY PRO.product_name ORDER BY PRO.product_name, ITM.order_item_id) AS RollingQuantitySummed -- 1,1+2=3,3+4=7 Smartphone etc..
FROM Order_Items ITM
JOIN Products PRO
	ON ITM.product_id = PRO.product_id


SELECT TOP(5) SUM(quantity) AS SumedQuantity, product_name
FROM Order_Items ITM
JOIN Products PRO
	ON ITM.product_id = PRO.product_id
GROUP BY product_name
ORDER BY SumedQuantity DESC



--Which product category generated the highest revenue in the past year?

SELECT TOP(1) PRO.category, SUM(ORD.total_amount) AS HighestRevenue
FROM Products PRO
JOIN Orders ORD
	ON PRO.product_id = ORD.product_id
GROUP BY PRO.category
ORDER BY SUM(ORD.total_amount) DESC




