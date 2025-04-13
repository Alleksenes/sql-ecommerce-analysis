-- Case 1, Q1: Monthly Order Count (Approved Orders)
SELECT
    TO_CHAR(order_approved_at, 'YYYY-MM') AS order_month,
    COUNT(order_id) AS order_count
FROM orders
WHERE order_approved_at IS NOT NULL
GROUP BY order_month
ORDER BY order_month;

-- Case 1, Q2: Monthly Order Count by Status
SELECT
    TO_CHAR(order_approved_at, 'YYYY-MM') AS order_month,
    order_status,
    COUNT(order_id) AS order_count
FROM orders
WHERE order_approved_at IS NOT NULL
GROUP BY order_month, order_status
ORDER BY order_month, order_count DESC;

-- Case 1, Q3: Top 3 Product Categories per Month (based on Approved Orders)

WITH MonthlyCategoryCounts AS (
	SELECT
		TO_CHAR(o.order_approved_at, 'YYYY-MM') AS order_month,
		COALESCE(p.product_category_name, 'Unknown') AS product_category_name,
		COUNT (DISTINCT o.order_id) AS distinct_order_count
	FROM orders o
	INNER JOIN order_items AS oi ON o.order_id = oi.order_id
	INNER JOIN products AS p ON oi.product_id = p.product_id
	WHERE o.order_approved_at IS NOT NULL
	AND p.product_category_name IS NOT NULL
	GROUP BY order_month, product_category_name
),
RankedCategories AS (
SELECT
	order_month,
	product_category_name,
	distinct_order_count,
	RANK() OVER (PARTITION BY order_month ORDER BY distinct_order_count DESC) AS category_rank
FROM MonthlyCategoryCounts
)
SELECT
	order_month,
	product_category_name,
	distinct_order_count,
	category_rank
FROM RankedCategories
WHERE category_rank <= 3
ORDER BY order_month, product_category_name;

-- Case 1, Q4a: Order Count by Day of Week (DOW)

SELECT
    CASE EXTRACT(DOW FROM order_approved_at)
        WHEN 1 THEN 'Pazartesi'
        WHEN 2 THEN 'Salı'
        WHEN 3 THEN 'Çarşamba'
        WHEN 4 THEN 'Perşembe'
        WHEN 5 THEN 'Cuma'
        WHEN 6 THEN 'Cumartesi'
        WHEN 0 THEN 'Pazar'
        ELSE 'NULL'
    END AS order_day_name,
    COUNT(order_id) AS order_count
FROM orders
GROUP BY order_day_name
ORDER BY order_count DESC;


-- Case 1, Q4b: Order Count by Day of Month (DOM)
SELECT
    EXTRACT(DAY FROM order_approved_at) AS day_of_month,
    COUNT(order_id) AS order_count
FROM orders
WHERE order_approved_at IS NOT NULL
GROUP BY day_of_month
ORDER BY order_count DESC;



