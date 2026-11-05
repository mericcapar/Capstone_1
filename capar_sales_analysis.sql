USE sample_sales;

-- I am analyzing ME - Maine
-- Assumption: This analysis includes in-store sales only.
-- Online sales belong to the separate Online Sales territory and its managers.

-- What is total revenue overall for sales in the assigned territory, 


-- plus the start date and end date that tell you what period the data covers?   

SELECT ROUND(SUM(ss.Sale_Amount),2) AS TotalSales,
       MIN(ss.Transaction_Date) AS StartDate,
       MAX(ss.Transaction_Date) AS EndDate
FROM store_sales ss
JOIN store_locations sl ON ss.Store_ID = sl.StoreId
WHERE sl.State = 'Maine';

-- Result: Maine total in-store sales were $1877249.75 from 2022-01-01 to 2025-12-31.

-- What is the revenue breakdown by year and month for the sales territory?

SELECT YEAR(ss.Transaction_Date)  AS Year,
       MONTH(ss.Transaction_Date) AS Month,
       ROUND(SUM(ss.Sale_Amount), 2) AS Revenue
FROM store_sales ss
JOIN store_locations sl ON ss.Store_ID = sl.StoreId
WHERE sl.State = 'Maine'
GROUP BY YEAR(ss.Transaction_Date), MONTH(ss.Transaction_Date)
ORDER BY Year ASC, Month ASC;

-- Result: 48 months of data. Lowest month: 1/2022 - $15700.31. Highest month: 10/2025 - $93456.68.

-- Provide a comparison of total revenue for the specific sales territory and the region it belong to.

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

SELECT sl.StoreLocation, ROUND(SUM(ss.Sale_Amount),2) AS TotalSales
FROM store_sales ss
JOIN store_locations sl ON ss.Store_ID = sl.StoreId
WHERE sl.State = 'Maine'
GROUP BY sl.StoreLocation
ORDER BY TotalSales DESC;

/*
Q6: Recommendation for next quarter (Q1 2026)

Context: Maine is 7.75% of Northeast revenue and ranks lowest of 4 states.

Finding 1: South Portland is the top store, while Bar Harbor has the lowest sales.
This is likely because South Portland is part of the Portland area, the largest
metro area in Maine, while Bar Harbor is a small town on an island with a much
smaller population.

Finding 2: In every year from 2022 to 2025, sales in the second half of the year
(July–December) were higher than in the first half (January–June). Q3 was the
strongest quarter in 3 of 4 years, likely because it matches the back-to-school
season in August and September, when students buy books, supplies and technology.
Q1 was the lowest quarter overall, likely because it is the slow period right
after the holiday shopping season. Sales also grew strongly over time, with big
jumps in 2023 (+62%) and 2025 (+54%).
(See capar_territory_chart.xlsx for the quarterly and half-year tables.)

Finding 3: Technology & Accessories has the highest average transaction amount,
mainly because it includes high-priced items like laptops and tablets, compared
to lower-priced categories like stationery.

Recommendation: In Q1 2026, the sales team should use the slower first half of
the year to prepare for the stronger second half, especially the back-to-school
season in Q3. This means planning marketing campaigns and advertising early, and
making sure South Portland has enough Technology & Accessories stock, because
these are the periods and products where customers already spend the most.
Being visible during these peak months could bring the biggest increase in revenue.
*/



