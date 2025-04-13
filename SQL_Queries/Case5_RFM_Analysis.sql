-- Final RFM Segmentation Logic - NTILE(5) with Balanced Tiering
WITH ReferenceDate AS (
    SELECT MAX(InvoiceDate) + INTERVAL '1 day' AS ref_date FROM rfm
),
rfm_calc AS (
    SELECT
        customer_id,
        EXTRACT(DAY FROM (SELECT ref_date FROM ReferenceDate) - MAX(InvoiceDate)) AS Recency,
        COUNT(DISTINCT InvoiceDate) AS Frequency,
        SUM(quantity * unitprice) AS Monetary
    FROM rfm
    WHERE customer_id IS NOT NULL
      AND quantity > 0 AND unitprice > 0
    GROUP BY customer_id
),
rfm_scores_raw AS (
    SELECT
        rc.*,
        NTILE(5) OVER (ORDER BY Recency ASC) AS R_Ntile,
        NTILE(5) OVER (ORDER BY Frequency DESC) AS F_Ntile,
        NTILE(5) OVER (ORDER BY Monetary DESC) AS M_Ntile
    FROM rfm_calc rc
    WHERE Monetary > 0
),
rfm_scores_final AS (
    SELECT
        rsr.*,
        (6 - R_Ntile) AS R_Score, -- Score 1-5 (5=Best)
        (6 - F_Ntile) AS F_Score, -- Score 1-5 (5=Best)
        (6 - M_Ntile) AS M_Score, -- Score 1-5 (5=Best)
        -- Calculate sum of scores for broader categorization
        ( (6 - R_Ntile) + (6 - F_Ntile) + (6 - M_Ntile) ) AS RFM_Sum
    FROM rfm_scores_raw rsr
)
SELECT
    rsf.customer_id,
    rsf.Recency,
    rsf.Frequency,
    rsf.Monetary::DECIMAL(12, 2),
    rsf.R_Score,
    rsf.F_Score,
    rsf.M_Score,
    rsf.RFM_Sum, -- Included for reference/debugging if needed
    CAST(rsf.R_Score AS VARCHAR) || ',' || CAST(rsf.F_Score AS VARCHAR) || ',' || CAST(rsf.M_Score AS VARCHAR) AS RFM_Score_Combined,
    CASE
        -- Tier 1: Elite - Requires perfect scores
        WHEN rsf.R_Score = 5 AND rsf.F_Score = 5 AND rsf.M_Score = 5 THEN '1_Champions_VIPs' -- (Sum=15)

        -- Tier 2: Excellent - At least two 5s, remaining score >= 4
        WHEN rsf.RFM_Sum >= 14 AND rsf.R_Score >= 4 AND rsf.F_Score >= 4 AND rsf.M_Score >= 4 THEN '2_Loyal_Champions' -- Catches (5,5,4), (5,4,5), (4,5,5). More exclusive than just sum>=14.

        -- Tier 3: Good - Loyal Core (Using Sum & Minimums)
        -- High overall sum OR strong individual scores, excluding T1/T2
        WHEN rsf.RFM_Sum >= 12 OR (rsf.R_Score >= 3 AND rsf.F_Score >= 3 AND rsf.M_Score >= 3) THEN '3_Loyal_Core' -- Sum >= 12 OR all scores >= 3

        -- Tier 4: New Customers Focus (Check after top tiers)
        WHEN rsf.R_Score >= 4 AND rsf.M_Score >= 4 THEN '4_New_High_Potential' -- Recent & High Spend
        WHEN rsf.R_Score >= 4 THEN '5_Newcomers' -- Other Recent

        -- Tier 5: High Value, Low Engagement / Lapsed (Check after Newcomers)
        WHEN rsf.M_Score >= 4 THEN '6_Big_Spenders_Lapsed_Infrequent' -- High Spend, but not recent/frequent enough for higher tiers

        -- Tier 6: At Risk - Were valuable, but lapsed significantly (Check using individual scores)
        WHEN rsf.R_Score <= 2 AND rsf.F_Score >= 3 AND rsf.M_Score >= 3 THEN '7_At_Risk_High_Value'

        -- Tier 7: Needs Attention / Slipping (Moderate sum, active recently)
        WHEN rsf.RFM_Sum >= 9 AND rsf.R_Score >= 3 THEN '8_Needs_Attention_Active' -- Sum 9-11 approx & Recent

        -- Tier 8: Low Value / Inactive (Using sum and individual scores)
        WHEN rsf.RFM_Sum <= 7 OR (rsf.R_Score <= 2 AND rsf.F_Score <= 2 AND rsf.M_Score <= 2) THEN '9_Hibernating_Low_Value' -- Low sum OR all scores low

        -- Catch-all for any remaining combinations
        ELSE '10_Low_Potential_Other'

    END AS Customer_Segment
FROM rfm_scores_final rsf
ORDER BY Customer_Segment, rsf.RFM_Sum DESC, rsf.Monetary DESC;