USE sample_sales;

-- I am analyzing ME - Maine

-- What is total revenue overall for sales in the assigned territory, 
-- plus the start date and end date that tell you what period the data covers?   

SELECT ROUND(SUM(TotalSales),2) AS TotalSales,
		MIN(Sale_Date) AS StartDate,
        MAX(Sale_Date) AS EndDate
FROM 
(SELECT ss.Sale_Amount AS TotalSales, ss.Transaction_Date AS Sale_Date
FROM store_sales ss 
JOIN store_locations sl ON ss.Store_ID = sl.StoreId
WHERE sl.State = 'Maine'
UNION ALL
SELECT SalesTotal AS TotalSales, Date AS Sale_Date
FROM online_sales
WHERE ShiptoState = 'Maine') AS Combined;


-- What is the revenue breakdown by year and month for the sales territory?

SELECT YEAR(Dates) AS Year, 
        MONTH(Dates) AS Month,
		ROUND(SUM(Amount),2) AS Revenue
FROM 
(SELECT ss.Sale_Amount AS Amount, 
		ss.Transaction_Date as Dates
FROM store_sales ss
JOIN store_locations sl ON ss.Store_ID = sl.StoreId
WHERE sl.State = 'Maine'
UNION ALL 
SELECT SalesTotal as Amount, Date as Dates
FROM online_sales
WHERE ShiptoState = 'Maine') AS Combined
GROUP BY MONTH(Dates), YEAR(Dates)
ORDER BY Year ASC, Month ASC;

-- Provide a comparison of total revenue for the specific sales territory and the region it belongs to.
-- Northeast states are : Maryland, Massachusetts, Maine, New Jersey

SELECT State as State, 
	ROUND(SUM(Amount),2) as `Total Revenue of Northeast`
FROM 
(SELECT sl.State as State, ss.Sale_Amount as Amount
FROM store_sales ss
JOIN store_locations sl ON ss.Store_ID = sl.StoreId
WHERE sl.State IN ('Maryland', 'Massachusetts','Maine','New Jersey')
UNION ALL
SELECT ShiptoState as State, SalesTotal as Amount
FROM online_sales
WHERE ShiptoState IN ('Maryland', 'Massachusetts','Maine','New Jersey')) AS Combined
GROUP BY State
ORDER BY State DESC;

-- Maine: 2,741,089.55 
-- Total :32,846,960.65
-- Percentage of Maine: %8.35

-- What is the number of transactions per month and average transaction amount by product
-- category for the sales territory?

-- Number of transactions per month
SELECT COUNT(*) As `Total Transaction`,
		MONTH(TransactionDate) AS Month,
		YEAR(TransactionDate) AS Year
FROM
(SELECT ss.Sale_Amount AS Amount, ss.Transaction_Date as TransactionDate
FROM store_sales ss
JOIN store_locations sl ON ss.Store_ID = sl.StoreId
WHERE sl.State = 'Maine'
UNION ALL
SELECT SalesTotal as Amount, Date as TransactionDate
FROM online_sales
WHERE ShiptoState = 'Maine') AS Combined
GROUP BY YEAR(TransactionDate), MONTH(TransactionDate)
ORDER BY Year, Month;


-- Average transaction amount by category

-- Can you provide a ranking of in-store sales performance by each store in the sales territory, or a
-- ranking of online sales performance by state within an online sales territory?

SELECT sl.StoreLocation, SUM(ss.Sale_Amount) AS TotalSales
FROM store_sales ss
JOIN store_locations sl ON ss.Store_ID = sl.StoreId
WHERE sl.State = 'Maine'
GROUP BY sl.StoreLocation
ORDER BY TotalSales DESC;

-- What is your recommendation for where to focus sales attention in the next quarter?






