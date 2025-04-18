# Comprehensive E-commerce Data Analysis using SQL

## Project Overview

This project performs an in-depth analysis of a sample e-commerce dataset (Olist) using PostgreSQL. The goal is to extract actionable business insights related to orders, customers, sellers, payments, and customer segmentation using RFM analysis.

## Dataset

[Olist, via Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

### Database Schema (ERD)

![ERD Diagram](diagram.png)

## Technologies Used

*   **Database:** PostgreSQL
*   **Visualization:** Charts generated using based on SQL query outputs.

## Analysis Structure

1.  **Case 1: Order Analysis:** Examining order trends, statuses, and popular product categories over time.
2.  **Case 2: Customer Analysis:** Identifying key customer geographic locations.
3.  **Case 3: Seller Analysis:** Evaluating seller performance based on delivery speed and product category diversity.
4.  **Case 4: Payment Analysis:** Investigating payment installment usage and popular payment methods.
5.  **Case 5: RFM Analysis:** Segmenting customers based on Recency, Frequency, and Monetary value to identify key groups like VIPs, loyal customers, and those at risk.

## Key Questions & Insights
Case 1: Order Analysis

1.1: Monthly Order Volume 

- Demonstrates significant growth throughout 2017 from a low 2016 base.
- Identifies a major peak in Nov 2017 (7,395 orders), confirming Black Friday's impact.
- Shows sustained high volume in early 2018 (Jan-Mar > 7,000).
- Indicates slight moderation/stabilization in mid-2018 volumes.
- Flags potential data incompleteness for Sep 2016, Dec 2016, Sep 2018.

1.2: Monthly Order Status Distribution 

- delivered status dominates, confirming high overall fulfillment rate.
- Significant unavailable counts (peak 86 in Nov 2017) indicate inventory/listing issues.
- Notable canceled counts (peak 71 in Feb 2018) require root cause analysis.
- Fluctuations in shipped counts reflect transit volume variations.

1.3: Top Product Categories by Month

- cama_mesa_banho shows sustained dominance, especially mid-2017 to early 2018 (peak 799 in Nov 2017).
- beleza_saude is consistently strong, rising to #1 in mid-late 2018.
- informatica_acessorios shows a major spike to #1 in Feb 2018 (808 orders).
- Home goods and personal care categories form the consistent core demand.
- Nov 2017 confirms Black Friday impact on home, leisure, and decor categories.


1.4a: Order Volume by Day of Week (DOW)

- Peak purchasing activity occurs on Tuesday (19,154 orders).
- Strong volume persists from Wednesday to Friday (>14.6k).
- Weekends, especially Sunday (9,014 orders), show significantly lower activity.
- Indicates a clear mid-week focus for customer purchasing.
- 160 orders have missing date information needing attention.

1.4b: Order Volume by Day of Month (DOM) 

- Identifies an anomalous major peak on the 24th (4,315 orders) requiring investigation.
- Shows generally strong purchasing activity in the first week (esp. day 5).
- Reveals relatively stable daily volumes mid-month (days 8-27, excl. 24th).
- Confirms a distinct drop-off in volume on the last days of the month (29-31).


Case 2: Customer Analysis

2.1: Top Customer Cities Analysis

- sao paulo is the overwhelmingly dominant city (15,540 orders).
- rio de janeiro is the clear second major hub (6,882 orders).
- Multiple other major cities (Belo Horizonte, Brasilia, Curitiba, etc.) show substantial volume (>1,200 orders each).
- Confirms geographic concentration but also significant reach into secondary metropolitan areas.

Case 3: Seller Analysis

3.1: Fastest Sellers Analysis

- Identifies top sellers achieving consistent 4-4.5 day median delivery (min 20 orders).
- Shows average delivery times are slightly higher, indicating some variability.
- Reveals strong positive correlation between reliable speed (4-5 day median) and high customer reviews (avg > 4.2) for most top sellers.
- Highlights an exception (99a5...) where speed doesn't overcome other issues leading to low scores and high comment rates.

3.2: Seller Product Category Diversity

- Highest category diversity (27 categories) does not correspond to highest order volume (337 orders).
- Significant volume is achieved by sellers with both high (~23 categories, 1287 orders) and moderate (~13 categories, 338 orders) diversity.
- Confirms lack of direct positive correlation between category breadth and sales volume.
- Suggests both specialist and generalist seller strategies are viable.

Case 4: Payment Analysis

4.1: Average Installments by City

- Identifies specific smaller cities (arapiraca, luis eduardo magalhaes, etc.) with high average CC installments (5.0 - 5.88).
- Confirms significant regional variation in financing preferences, even after filtering for minimum volume.
- Suggests extended financing (~6 months) is particularly important in these specific locations.


4.2: Payment Method Popularity & Value

- credit_card: Dominant in count, total value, and average value per transaction.
- boleto: Critical second method with high volume, massive total value, and high average value.
- voucher: Frequent use but very low total and average value; likely for discounts/partial pay.
- debit_card: Least frequent but used for moderately high-value direct purchases.

4.3: Installment Usage by Product Category

- Confirms extreme variation in installment necessity across product categories.
- Identifies categories with overwhelming reliance (>80%) where installments are essential (PCs, Watches, specific Furniture, etc.).
- Shows very high usage (60-75%) across a broad range of popular categories (Home Goods, Beauty, Toys, Auto).
- Highlights categories with low usage (<50%), likely lower-priced items (Beverages, Flowers, specific Electronics/Appliances).


5. RFM Segmentation Analysis & Recommendations


5.1. VIP Champions (Est. 1-5%)
Analysis:
This elite group represents the pinnacle of customer value, defined by perfect scores (**R=5, F=5, M=5**) translating to an RFM Sum of 15. They purchase most recently, most frequently, and spend the most, as exemplified by customers with monetary values ranging from 7k+ up to the maximum observed (*280,206.02*). Their recency is minimal (*~1-12 days*), and frequency is very high (*~7-210 purchases*). They are the core revenue drivers and likely strong brand advocates. Retaining this segment is the highest priority.
Recommendations:
•	Implement exclusive "*white-glove*" customer service and relationship management.
•	Offer unique rewards, early access, personalized gifts, and experiences unavailable to others.
•	Actively solicit their feedback for strategic decisions and product development.
•	Build personal connections where feasible (~dedicated account manager).
•	Ensure every interaction is frictionless and exceeds expectations.

5.2. Loyal Champions (Est. 5-10%)
Analysis:
Highly valuable and strongly engaged, these customers narrowly miss the absolute top tier, typically having at least two '5' scores and the remaining score being '4' (**RFM Sum usually 14**). Examples show recent purchases (*Recency ~14-33 days*), high frequency (*often 6-50+ purchases*), and significant spending (*~2k - 124k+*). They represent a crucial high-value group requiring consistent nurturing to maintain loyalty and potentially elevate to VIP status.
Recommendations:
•	Grant upper-tier status in loyalty programs with substantial benefits.
•	Provide personalized product recommendations and exclusive bundles.
•	Offer proactive, high-quality customer support.
•	Run targeted campaigns focused on maintaining high engagement and potentially increasing AOV.
•	Acknowledge their loyalty and value through status recognition or exclusive communications.

5.3. Loyal Core Customers (Est. 15-25%)
Analysis:
This substantial segment forms the reliable backbone, characterized by good performance across all metrics (**R>=3, F>=3, M>=3**) or a high overall RFM Sum (>=12), excluding the top two tiers. They purchase consistently (Recency often *~1-70 days*), maintain good frequency (*~2-10+ purchases*), and exhibit solid spending (*~500 - 10k+*). While not individually the highest spenders, their collective volume and regularity are vital for stable revenue.
Recommendations:
•	Engage with standard loyalty program benefits (points, tiered discounts).
•	Utilize segmented email marketing with relevant content and promotions.
•	Encourage repeat purchases through timely reminders or modest incentives.
•	Identify cross-sell/upsell opportunities relevant to their purchase history.
•	Ensure a consistently smooth and positive customer experience.

5.4. New High Potential Customers (Est. 2-5%)
Analysis:
These are newly acquired customers (**R>=4**) who immediately demonstrate high spending potential (**M>=4**). Their Frequency is often low (**F=1 or 2**) simply due to being new. Examples show Recency *~1-33 days* and Monetary values often *900+*. Their strong initial investment signals a high likelihood of becoming future valuable customers if properly engaged from the start.
Recommendations:
•	Implement a strong, personalized onboarding sequence highlighting value.
•	Showcase product breadth relevant to their high-value initial purchase(s?).
•	Offer a compelling, targeted incentive for their crucial second purchase.
•	Provide proactive support and gather early feedback on their experience.
•	Introduce loyalty program benefits promptly.

5.5. New Customers (Est. 10-15%)
Analysis:
Comprising all other recently acquired customers (**R>=4**) not classified higher, this segment exhibits varying initial frequency and monetary value (**F=1-5, M=1-3**). Our data shows many examples with F=1 or 2 and Monetary values ranging widely from low (*<50*) to moderate (*~500*). Their future value is undetermined, making their initial experiences and subsequent engagement critical for retention.
Recommendations:
•	Deliver excellent onboarding with educational content.
•	Encourage exploration of the product/service range.
•	Offer a small welcome incentive for a second purchase.
•	Monitor early behavior closely to identify emerging potential or disengagement.
•	Segment further based on initial purchase for more relevant follow-up.

5.6. Big Spenders Lapsed/Infrequent (Est. 5-10%)
Analysis:
These customers are characterized by high Monetary scores (**M>=4**) but lower Recency (R<=3) and potentially lower Frequency (F<=3), having not qualified for higher tiers. They make significant purchases when they do buy but lack consistent engagement. They represent substantial potential revenue if their frequency or recency can be improved. Examples include customers with very old Recency (*~>200 days*) but high M scores.
Recommendations:
•	Analyze past large purchases to understand triggers (promotions, specific items, seasonality).
•	Target with campaigns featuring high-value items or relevant exclusive bundles.
•	Proactively communicate major sales events or new high-ticket arrivals.
•	Focus on impactful communication rather than frequent, low-value marketing.
•	Consider surveys to understand barriers to more frequent purchasing.

5.7. At Risk High Value Customers (Est. 5-10%)
Analysis:
This critical group consists of customers who were previously valuable (**F>=3, M>=3**) but have become inactive (R<=2). They represent significant potential lost revenue and are at high risk of churning permanently. Urgent, targeted reactivation efforts are necessary. Examples show low Recency (*~>70 days*) but strong historical F and M scores.
Recommendations:
•	Launch targeted, aggressive "We Miss You" win-back campaigns with strong, personalized incentives.
•	Conduct surveys specifically asking why they stopped purchasing.
•	Highlight key product/service improvements made since their last purchase.
•	Offer personalized consultations or high-touch support for top individuals within this group.

5.8. Active Customers Needing Attention (Est. 10-20%)
Analysis:
These customers have purchased relatively recently (**R>=3**) but show lower frequency or monetary value than the 'Loyal Core' (typically RFM Sum 9-11). They are currently engaged but haven't reached high value levels. They represent an opportunity for growth and development into more valuable segments. The data shows examples with R=3 or 4 but lower F/M scores (~F=2, M=1 or F=3, M=2).
Recommendations:
•	Increase engagement with relevant content marketing or interactive campaigns.
•	Promote bundling, volume discounts, or loyalty thresholds to increase AOV.
•	Run campaigns focused on increasing purchase frequency.
•	Offer personalized recommendations for complementary products.
•	Clearly communicate the benefits of advancing in the loyalty program.

5.9. Hibernating Low Value Customers (Est. 15-25%)
Analysis:
This large segment includes customers with low scores across the board (R<=2, F<=2, M<=2) or a low RFM Sum (<=7). They haven't purchased recently, didn't buy often, and didn't spend much. The provided data shows many examples with very high Recency (*~>100-300+ days*) and low F/M scores (1s and 2s), including low monetary values like 38.10. They represent the lowest engagement and value tier.
Recommendations:
•	Minimize marketing investment; allocate resources to higher-potential segments.
•	Include in occasional, very low-cost mass communication (~major annual sales).
•	Consider a final, automated low-effort reactivation attempt before ceasing regular contact.
•	Analyze in aggregate if segment size grows, potentially indicating broader issues.

5.10. Other Low Potential (Est. 5-10%)
Analysis:
This is a catch-all for customers not fitting other defined segments, usually indicating mixed low-to-moderate scores that don't align with specific actionable groups (**~R=3, F=1, M=1**). Their overall value and engagement are typically low.
Recommendations:	
•	Apply similar low-investment strategies as the Hibernating Low Value Customers segment.
•	Monitor segment composition – if specific patterns emerge, consider refining segmentation rules.
•	Generally exclude from targeted or high-cost marketing efforts.























