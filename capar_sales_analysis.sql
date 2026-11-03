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

-- Can you provide a ranking of in-store sales performance by each store in the sales territory, or a
-- ranking of online sales performance by state within an online sales territory?

SELECT sl.StoreLocation, SUM(ss.Sale_Amount) AS TotalSales
FROM store_sales ss
JOIN store_locations sl ON ss.Store_ID = sl.StoreId
WHERE sl.State = 'Maine'
GROUP BY sl.StoreLocation
ORDER BY TotalSales DESC;






