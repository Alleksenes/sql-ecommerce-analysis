-- Case 3, Q1: Top 10 Fastest Sellers (Min 20 Orders, Median Delivery Time)

WITH OrderDeliveryCalc AS (
    SELECT
        oi.seller_id,
        oi.order_id,
        (o.order_delivered_customer_date - o.order_purchase_timestamp) AS delivery_interval -- to calculates order put, disregarding seller's approval
    FROM orders AS o
    INNER JOIN order_items AS oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
      AND o.order_purchase_timestamp IS NOT NULL
      AND o.order_delivered_customer_date >= o.order_approved_at
),
SellerDeliveryStats AS (
    SELECT
        seller_id,
        COUNT(DISTINCT order_id) as total_delivered_orders,
        AVG(EXTRACT(DAY FROM delivery_interval)) AS avg_delivery_days,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY EXTRACT(DAY FROM delivery_interval)) AS median_delivery_days
    FROM OrderDeliveryCalc
    GROUP BY seller_id
    HAVING COUNT(DISTINCT order_id) >= 20 -- *** Filter for minimum order volume ***
),
RankedSellers AS (
    SELECT
        seller_id,
        total_delivered_orders,
        avg_delivery_days,
        median_delivery_days,
        RANK() OVER (ORDER BY median_delivery_days ASC, avg_delivery_days ASC) as delivery_rank
    FROM SellerDeliveryStats
),
SellerReviews AS (
    SELECT
        oi.seller_id,
        AVG(r.review_score) AS avg_review_score,
        COUNT(r.review_comment_message) AS total_comments,
        ROUND((COUNT(r.review_comment_message)::DECIMAL * 100) / NULLIF(COUNT(DISTINCT r.order_id), 0), 1) AS comment_percentage
    FROM order_items oi
    LEFT JOIN reviews r ON oi.order_id = r.order_id
    GROUP BY oi.seller_id
)
SELECT
    rs.seller_id,
    ROUND(rs.median_delivery_days::NUMERIC, 1) AS median_delivery_days,
    ROUND(rs.avg_delivery_days::NUMERIC, 1) AS avg_delivery_days,
    rs.total_delivered_orders,
    sr.avg_review_score,
    sr.total_comments,
    sr.comment_percentage
FROM RankedSellers rs
INNER JOIN SellerReviews sr ON rs.seller_id = sr.seller_id
WHERE rs.delivery_rank <= 10
ORDER BY rs.delivery_rank;

-- Case 3, Q2: Sellers by Number of Categories vs. Order Volume
WITH SellerCategoryCounts AS (
    SELECT
        oi.seller_id,
        COUNT(DISTINCT p.product_category_name) AS num_categories
    FROM order_items AS oi
    INNER JOIN products AS p ON oi.product_id = p.product_id
    WHERE p.product_category_name IS NOT NULL
    GROUP BY oi.seller_id
),
RankedSellersByCats AS (
    SELECT
        seller_id,
        num_categories,
        RANK() OVER (ORDER BY num_categories DESC) AS category_rank
    FROM SellerCategoryCounts
    WHERE num_categories > 1
)
SELECT
    rs.seller_id,
    rs.num_categories,
    rs.category_rank,
    COUNT(DISTINCT oi.order_id) AS distinct_order_count
FROM RankedSellersByCats AS rs
INNER JOIN order_items AS oi ON rs.seller_id = oi.seller_id
WHERE rs.category_rank <= 15
GROUP BY rs.seller_id, rs.num_categories, rs.category_rank
ORDER BY rs.category_rank;





