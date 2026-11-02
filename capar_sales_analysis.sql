USE sample_sales;

-- I am analyzing ME - Maine

-- What is total revenue overall for sales in the assigned territory, 
-- plus the start date and end date that tell you what period the data covers?   

SELECT ROUND(SUM(ss.Sale_Amount),2) AS TotalSales, MIN(ss.Transaction_Date) as StartDate, MAX(ss.Transaction_Date) as EndDate
FROM store_sales ss 
JOIN store_locations sl ON ss.Store_ID = sl.StoreId
WHERE sl.State = 'Maine';

SELECT *
FROM management
WHERE State = 'Online Sales';

-- What is the revenue breakdown by year and month for the sales territory?

SELECT sl.State, ROUND(SUM(ss.Sale_Amount),2) AS TotalSale, 
		YEAR(ss.Transaction_Date) AS Year,
        MONTH(ss.Transaction_Date) AS Month
FROM store_sales ss
JOIN store_locations sl ON ss.Store_ID = sl.StoreId
WHERE sl.State = 'Maine'
GROUP BY MONTH(Transaction_Date), YEAR(Transaction_Date);

