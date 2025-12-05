# Portfolio-Project
This project is a complete end-to-end marketing analytics case study built using SQL for data transformation and Tableau for dashboarding. It demonstrates how to translate raw multi-channel retail data into meaningful insights about customer value, campaign performance, product behavior, and revenue drivers.

The analysis covers customer segmentation, LTV modeling, campaign attribution, channel quartiles, and product co-purchase patterns—all critical skills for an entry-level Marketing Analyst, Business Analyst, or Marketing Data Analyst role.

🛠️ Technical Implementation
Tools & Technologies
  - Tableau Desktop: Dashboard creation and visualization
  - SQL + Power Query: Data extraction, transformation, and aggregation

📊 Project Overview
Using a multi-channel retail dataset (Catalog, Store, Web), the dashboard explores how customers behave across touchpoints, how different demographic groups respond to marketing campaigns, and how product categories interact to influence spend and customer lifetime value (LTV).
The final deliverable includes:
- A combined Tableau dashboard
- SQL transformations
- Demographic segmentation
- Cohort-style quartile and migration analysis
- Product cross-sell insights

Campaign performance deep-dive
🔑 Key Insights

1️⃣ Customer Demographics Show Strong Purchasing Power in Specific Segments
  - High-income and highly educated customers contribute the strongest LTV.
  - Certain countries consistently outperform others with significantly higher mean LTV, indicating concentrated revenue pools.
  - Age distribution skews toward mature customers (mid-30s to late 40s), who also show higher repeat purchasing behavior.
  - Marital status has a noticeable pattern: married customers tend to have higher LTV and higher campaign responsiveness.
📌 Implication:
  - Marketing spend should be focused on high-income, educated cohorts and geographies with proven LTV density.

2️⃣ Top 50 Customers (High-Value Segment) Are Extremely Distinct
1. Income & Education Correlation:
Customers earning $75K-$100K show the highest engagement:
  - 3.571 avg campaigns accepted
  - $84.65 avg purchase value
  - $1,722 average LTV

2. PhD holders demonstrate superior metrics:
Clear positive correlation between education level and marketing responsiveness
  - 3.222 avg campaigns accepted
  - $84.17 avg purchase value
  - $1,529.8 average LTV

3. Family Structure Impact:
Customers with 0 kids significantly outperform:
  - 2.933 avg campaigns accepted
  - $78.78 avg purchase value
  - $1,514.5 average LTV
LTV drops 45% from 0 kids to 2 kids households ($1,514.5 → $798.7)

4. Country Performance (Top 50):
  - Australia leads in campaign acceptance (3.667 avg) and LTV ($1,458)
  - Saudi Arabia shows strong purchase value ($76.57 avg)
  - India and Mexico represent emerging opportunities with lower current spend
📌 Implication:
  - Creating targeted loyalty programs and premium offerings for this cohort would yield outsized returns.
  
3️⃣ Campaign Effectiveness Varies Sharply Across Segments
1. Key Insights:
  - Campaign 5 has the highest revenue per customer ($1,604.69) despite lower reach
  - Campaign 1 achieves the best balance of reach (144) and high spend ($1,403.26)
  - Campaign 3 has poor monetization despite 6.03% acceptance rate
  Optimal target age appears to be 57-61 years across successful campaigns

2. Campaign Acceptance Patterns
Geographic Performance:
  - Saudi Arabia: 37.68% acceptance for Campaign 5 (strongest regional performance)
  - Spain: 33.15% acceptance for Campaign 5
  - Australia: 39.66% acceptance for Campaign 5, strong across all campaigns
  - Canada: More balanced performance, 30.4% for Campaign 5

3. Purchase Behavior by Campaign Engagement:
  - Customers accepting 6-7 campaigns show median 20 purchases across channels
  - Strong correlation between campaign acceptance and total purchase frequency
  - Customers accepting 5+ campaigns spend 83.23 avg purchase value vs. 30.33 for 0 campaigns
  - Diminishing returns appear after 5 campaign acceptances

Campaign acceptance rates reveal:
  - Large variance across countries and age groups, highlighting the need for segmentation-based targeting.
  - A few campaigns show high acceptance but low purchases, suggesting ineffective follow-through or poor conversion design.
  - Others show lower reach but extremely strong conversion, indicating under-investment in strong-performing campaigns.
📌 Implication:
  - Shift budget away from high-reach/low-conversion campaigns toward campaigns where acceptance reliably leads to purchases.
  
4️⃣ Engagement With Campaigns Directly Predicts Higher Spend
A key behavioral pattern emerges:
  - As customers accept more campaigns, both their median purchases and average purchase value rise.
  - There is a clear positive trend between campaign engagement and LTV.
  - This pattern holds across channels and demographic groups.
📌 Implication:
  - Marketing campaigns are not merely acquisition tools—they meaningfully shape LTV.
  - Increasing personalized campaign frequency for mid-/high-value customers can lift revenue.

5️⃣ Channel Quartile Analysis Reveals Distinct Spending Profiles
Channel Performance by Quartile
1. Top 25% Customers (High-Value):
  - Catalog: $1,360.4 avg spend (highest performing channel)
  - Store: $1,152.3 avg spend
  - Web: $985.9 avg spend

2. Gross Revenue by Channel & Quartile:
  - Catalog: $561,853 (top 25%) generates the most gross value
  - Store: More consistent across quartiles ($444K-$493K)
  - Web: Highest variability, strong in Q3 ($243,838)

3. Strategic Implications:
  - Catalog investment should focus on top 25% customers (highest ROI)
  - Web channel shows 87% drop from top to bottom quartile (highest inequality)
  - Store channel is most stable across customer segmentsCatalog shows 38% premium over web channel for top customersQuartile analysis by Store, Web, and Catalog shows:

Top quartile customers contribute the majority of revenue, as expected.
However, the magnitude differs greatly by channel:
  - One channel shows extremely high concentration (top 25% dominate most revenue).
  - Another is more balanced, with Q2 and Q3 users playing a larger role.
  - % change between quartiles exposes where the biggest jumps in LTV occur.
📌 Implication:
  - Marketing should be tailored per channel:
  - Channels with steep quartile jumps = opportunity to move customers upward with targeted nudges.
  - Channels with smoother quartiles = ideal for broad acquisition efforts.

6️⃣ Product Co-Purchase Matrix Reveals Strong Cross-Sell Opportunities
Key Patterns:
  - Wines and Meat are dominant revenue drivers across all channels
  - Catalog heavily favors premium products (Wines, Meat, Gold)
  - Web shows relative strength in Sweets (31.5% of sweets purchases vs. 26.4% avg)
  - Store channel underperforms across all categories except balanced distribution

1. Customer Engagement Metrics
Recency Analysis:
  - Median days since last purchase: 49-50 days across all products
  - Highly consistent engagement regardless of product category
  - Suggests regular purchasing cycles and strong customer retention

2. Customer Distribution by LTV:
  - Relatively even distribution across LTV bins (1,200-1,250 customers per segment)
  - No single product dominates any LTV tier
  - Indicates diverse product interest across value segments

3. Year-over-Year Performance
Average Spend Growth:
  - Strong YoY growth in premium categories
  - Products showing spend increases indicate successful upselling
  - Seasonal patterns visible in certain product categories

4. Revenue Trends:
Total revenue concentration in established products
Opportunity for growth in underperforming categories

The 6×6 co-purchase matrix shows:
  - Clear pairings between certain product categories.
  - Some categories act as “gateway” products—buying them strongly predicts purchases in multiple other categories.
  - Other categories generate high purchase counts but weak cross-sell influence.
📌 Implication:
  - Bundle products based on high-frequency co-purchase pairs.
  - Use gateway categories for targeted cross-sell journeys.

Median days since last purchase identifies which products are falling out of customer habits.
    YoY revenue and average spend charts highlight categories with:
      - consistent growth
      - potential saturation
      - concerning decline
📌 Implication:
  - Products with high recency and declining YoY revenue should be re-marketed, repositioned, or replaced.

📌 Summary of Impact
This project simulates the everyday work of a Marketing Analyst. It answers real business questions:
  - Who are our most valuable customers?
  - What drives campaign success?
  - How do different channels contribute to revenue?
  - Which products should be bundled or promoted?
  - Where should budget be increased or reduced?
  - How can customers be moved to higher LTV quartiles?

Across the dashboards, the insights form a cohesive narrative around customer value, channel performance, product behavior, and marketing ROI.

