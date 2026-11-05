USE sample_sales;

-- I am analyzing ME - Maine

-- What is total revenue overall for sales in the assigned territory, 
-- plus the start date and end date that tell you what period the data covers?   

SELECT ROUND(SUM(ss.Sale_Amount),2) AS TotalSales,
       MIN(ss.Transaction_Date) AS StartDate,
       MAX(ss.Transaction_Date) AS EndDate
FROM store_sales ss
JOIN store_locations sl ON ss.Store_ID = sl.StoreId
WHERE sl.State = 'Maine';

-- What is the revenue breakdown by year and month for the sales territory?

SELECT YEAR(ss.Transaction_Date)  AS Year,
       MONTH(ss.Transaction_Date) AS Month,
       ROUND(SUM(ss.Sale_Amount), 2) AS Revenue
FROM store_sales ss
JOIN store_locations sl ON ss.Store_ID = sl.StoreId
WHERE sl.State = 'Maine'
GROUP BY YEAR(ss.Transaction_Date), MONTH(ss.Transaction_Date)
ORDER BY Year ASC, Month ASC;

-- Provide a comparison of total revenue for the specific sales territory and the region it belongs to.
-- Northeast states are : Maryland, Massachusetts, Maine, New Jersey

	SELECT sl.State as State, ROUND(SUM(ss.Sale_Amount),2) AS Total,
		ROUND(SUM(ss.Sale_Amount) / SUM(SUM(ss.Sale_Amount)) OVER () * 100, 2) AS Percent
	FROM store_sales ss
	JOIN store_locations sl ON ss.Store_ID = sl.StoreId
	WHERE sl.State IN ('Maryland', 'Massachusetts','Maine','New Jersey')
	GROUP BY State
	ORDER BY Percent DESC;


	-- What is the number of transactions per month and average transaction amount by product
	-- category for the sales territory?

		SELECT YEAR(ss.Transaction_Date) as Year,MONTH(ss.Transaction_Date) as Month, ic.Category as Category,
				COUNT(*) as TotalTransaction,
				ROUND(AVG(ss.Sale_Amount),2) AS Average
		FROM store_sales ss
		JOIN store_locations sl ON ss.Store_ID = sl.StoreId
		JOIN products p ON ss.Prod_Num = p.ProdNum
		JOIN inventory_categories ic ON p.Categoryid = ic.Categoryid
		WHERE sl.state = 'Maine'
		GROUP BY Year,Month, Category
		ORDER BY YEAR ASC, MONTH ASC, Category ASC;


-- Can you provide a ranking of in-store sales performance by each store in the sales territory, or a
-- ranking of online sales performance by state within an online sales territory?

SELECT sl.StoreLocation, SUM(ss.Sale_Amount) AS TotalSales
FROM store_sales ss
JOIN store_locations sl ON ss.Store_ID = sl.StoreId
WHERE sl.State = 'Maine'
GROUP BY sl.StoreLocation
ORDER BY TotalSales DESC;

-- What is your recommendation for where to focus sales attention in the next quarter?

	/*
	Q6: Recommendation for next quarter (Q1 2026)

	Context: Maine is 7.75% of Northeast revenue and ranks lowest of 4 states.
	Finding 1: South Portland is the top store, while Bar Harbor has the lowest sales.
	This is likely because South Portland is part of the Portland area, the
	largest metro area in Maine, while Bar Harbor is a small town on an island
	with a much smaller population.
    
	Finding 2: In past years, January–March sales were the lowest of the year, 
    likely because it is the slow period right after the November–December holiday shopping season.
	Students also buy most of their books at the start of the school year, which
	explains the sales increase we see in August and September.
	
	Finding 3: Technology & Accessories has the highest average transaction amount,
	mainly because it includes high-priced items like laptops and tablets,
	compared to lower-priced categories like stationery.

Recommendation: In Q1 2026, the sales team should focus on a Technology & Accessories promotion 
at the South Portland store at the start of the spring semester in January,
because Q1 is usually the slowest quarter of the year, and Technology & Accessories has the 
highest average transaction amount. This could help 
reduce the usual Q1 sales drop and increase Maine’s share of Northeast revenue.
*/



