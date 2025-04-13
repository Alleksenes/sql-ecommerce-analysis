-- Case 2, Q1: Top 10 Cities by Customer's Primary Ordering Location
WITH CustomerOrderCityCounts AS (
    SELECT
        c.customer_id,
        c.customer_city,
        COUNT(o.order_id) AS city_order_count
    FROM customers AS c
    INNER JOIN orders AS o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_city
),
CustomerPrimaryCity AS (
    SELECT
        customer_id,
        customer_city,
        city_order_count,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY city_order_count DESC) AS city_rank
    FROM CustomerOrderCityCounts
)
SELECT
    cp.customer_city,
    SUM(cp.city_order_count) AS total_orders_from_primary_city_customers
FROM CustomerPrimaryCity AS cp
WHERE cp.city_rank = 1
GROUP BY cp.customer_city
ORDER BY total_orders_from_primary_city_customers DESC
LIMIT 10;
