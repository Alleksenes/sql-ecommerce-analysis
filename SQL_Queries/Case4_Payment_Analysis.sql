-- Case 4, Q1: Cities with Highest Average Credit Card Installments (Min 20 CC Orders)
WITH CityPaymentStats AS (
    SELECT
        c.customer_city,
        AVG(CASE WHEN p.payment_type = 'credit_card' THEN p.payment_installments ELSE NULL END) AS avg_cc_installments,
        COUNT(DISTINCT CASE WHEN p.payment_type = 'credit_card' THEN o.order_id ELSE NULL END) AS cc_order_count,
        COUNT(DISTINCT o.order_id) AS total_order_count
    FROM payments AS p
    INNER JOIN orders AS o ON p.order_id = o.order_id
    INNER JOIN customers AS c ON o.customer_id = c.customer_id
    GROUP BY c.customer_city
    HAVING COUNT(DISTINCT CASE WHEN p.payment_type = 'credit_card' THEN o.order_id ELSE NULL END) >= 20
),
RankedCitiesByInstallments AS (
    SELECT
        customer_city,
        avg_cc_installments,
        cc_order_count,
        total_order_count,
        RANK() OVER (ORDER BY avg_cc_installments DESC) AS installment_rank
    FROM CityPaymentStats
    WHERE avg_cc_installments IS NOT NULL
)
SELECT
    rc.customer_city,
    ROUND(rc.avg_cc_installments, 2) AS avg_cc_installments,
    rc.cc_order_count,
    rc.total_order_count
FROM RankedCitiesByInstallments rc
WHERE rc.installment_rank <= 10
ORDER BY rc.installment_rank;


-- Case 4, Q2: Payment Type Usage and Value (Delivered Orders)
SELECT
    p.payment_type,
    COUNT(p.order_id) AS payment_instances,
    SUM(p.payment_value)::DECIMAL(12,2) AS total_payment_value,
    AVG(p.payment_value)::DECIMAL(10,2) AS avg_payment_value_per_instance
FROM payments AS p
INNER JOIN orders AS o ON p.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY p.payment_type
ORDER BY payment_instances DESC;


-- Case 4, Q3: Installment Usage (Credit Card) by Product Category
WITH OrderCategoryPayment AS (
    SELECT DISTINCT
        oi.order_id,
        pr.product_category_name,
        p.payment_installments
    FROM order_items AS oi
    INNER JOIN products AS pr ON oi.product_id = pr.product_id
    INNER JOIN payments AS p ON oi.order_id = p.order_id
    WHERE p.payment_type = 'credit_card'
      AND pr.product_category_name IS NOT NULL
)
SELECT
    product_category_name,
    COUNT(CASE WHEN payment_installments > 1 THEN order_id END) AS cc_installment_orders,
		ROUND(
        (COUNT(CASE WHEN payment_installments > 1 THEN order_id END)::DECIMAL * 100)
        / COUNT(order_id), 1
    ) AS pct_cc_orders_with_installments,
    COUNT(CASE WHEN payment_installments = 1 THEN order_id END) AS cc_single_pay_orders,
    COUNT(order_id) AS total_cc_orders
FROM OrderCategoryPayment
GROUP BY product_category_name
HAVING COUNT(order_id) > 10 
ORDER BY cc_installment_orders DESC




