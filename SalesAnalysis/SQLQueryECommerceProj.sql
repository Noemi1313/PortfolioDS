--E-Commerce database queries
--Noemi Carolina Guerra Montiel
--October 2023

--Using correct database
USE ECommerce;

--CHECK DATA
--Checking that all the tables have been correctly uploaded 
SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

--Count the number of rows on each table
SELECT t1.Rows_Cus,t2.Rows_Ord, t3.Rows_Prod, t4.Rows_Sal
FROM
(SELECT COUNT(1) AS Rows_Cus FROM Customers) AS t1, 
(SELECT COUNT(1) AS Rows_Ord FROM Orders) AS t2,
(SELECT COUNT(1) AS Rows_Prod FROM Products) AS t3,
(SELECT COUNT(1) AS Rows_Sal FROM Sales) AS t4;

--Count the number of columns on each table
SELECT t1.Cols_Cus,t2.Cols_Ord, Cols_Prod, Cols_Sal
FROM
(SELECT COUNT(*) AS Cols_Cus FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Customers') as t1, 
(SELECT COUNT(*) AS Cols_Ord FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Orders') as t2, 
(SELECT COUNT(*) AS Cols_Prod FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Products') as t3, 
(SELECT COUNT(*) AS Cols_Sal FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Sales') as t4; 

--Change columns names
--EXEC sp_rename 'Sales.quantity', 'sales_quantity', 'COLUMN' -- Rename col
--EXEC sp_rename 'Sales.total_price', 'sales_total_price', 'COLUMN' -- Rename col
--EXEC sp_rename 'Products.price', 'product_price', 'COLUMN' -- Rename col
--EXEC sp_rename 'Products.quantity', 'stock', 'COLUMN' -- Rename col

--DATA ANALYSIS
--Total sales revenue of year 2021 (until October)
SELECT SUM(S.sales_total_price) AS total_sales_revenue
FROM Sales S;

--Total revenue and number of sales made
SELECT MONTH(O.order_date) AS month_of_sale, SUM(S.sales_total_price) AS total_sales, COUNT(S.sales_quantity) AS num_sales
FROM Sales S
JOIN Orders O ON S.order_id = O.order_id
GROUP BY MONTH(O.order_date)
ORDER BY month_of_sale;

--Average sales revenue per month
SELECT MONTH(O.order_date) AS month_of_sale, AVG(S.sales_total_price) AS avg_sales
FROM Sales S
JOIN Orders O ON S.order_id = O.order_id
GROUP BY MONTH(O.order_date)
ORDER BY month_of_sale;

--Top 3 months with most revenue
SELECT TOP 3 MONTH(O.order_date) AS month_of_sale, SUM(S.sales_total_price) AS total_sales, COUNT(S.sales_quantity) AS num_sales
FROM Sales S
JOIN Orders O ON S.order_id = O.order_id
GROUP BY MONTH(O.order_date)
ORDER BY total_sales DESC;

--Which products were sold the most in the last month?
SELECT TOP 10 P.product_type, P.product_name, SUM(S.sales_total_price) AS total_sales_revenue
FROM Sales S
JOIN Products P ON S.product_id = P.product_ID
JOIN Orders O ON S.order_id = O.order_id
WHERE MONTH(O.order_date) = 10
GROUP BY P.product_type, P.product_name
ORDER BY total_sales_revenue DESC;

--Top 5 customers with more sales made
SELECT TOP 5 C.customer_name, SUM(S.sales_total_price) AS total_sales
FROM Sales S
JOIN Orders O ON S.order_id = O.order_id
JOIN Customers C ON O.customer_id = C.customer_id
GROUP BY C.customer_name
ORDER BY total_sales DESC;

--Demographics: top sales by gender
SELECT C.gender, COUNT(C.gender) AS gender_count, SUM(S.sales_total_price) AS total_sales
FROM Sales S
JOIN Orders O ON S.order_id = O.order_id
JOIN Customers C ON O.customer_id = C.customer_id
GROUP BY C.gender
ORDER BY total_sales DESC;

----Demographics: top sales by state
SELECT C.state, COUNT(C.state) AS state_count, SUM(S.sales_total_price) AS total_sales
FROM Sales S
JOIN Orders O ON S.order_id = O.order_id
JOIN Customers C ON O.customer_id = C.customer_id
GROUP BY C.state
ORDER BY total_sales DESC;
