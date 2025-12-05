# Portfolio-Project
This project is a complete end-to-end marketing analytics case study built using SQL for data transformation and Tableau for dashboarding. It demonstrates how to translate raw multi-channel retail data into meaningful insights about customer value, campaign performance, product behavior, and revenue drivers.

The analysis covers customer segmentation, LTV modeling, campaign attribution, channel quartiles, and product co-purchase patterns—all critical skills for an entry-level Marketing Analyst, Business Analyst, or Marketing Data Analyst role.

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
  High-income and highly educated customers contribute the strongest LTV.
  Certain countries consistently outperform others with significantly higher mean LTV, indicating concentrated revenue pools.
  Age distribution skews toward mature customers (mid-30s to late 40s), who also show higher repeat purchasing behavior.
  Marital status has a noticeable pattern: married customers tend to have higher LTV and higher campaign responsiveness.
📌 Implication:
  Marketing spend should be focused on high-income, educated cohorts and geographies with proven LTV density.

2️⃣ Top 50 Customers (High-Value Segment) Are Extremely Distinct
  Within the top-earning cohort:
  They have significantly more campaign interactions.
  They exhibit higher average purchase value, not just higher frequency.
  A disproportionate share of their value comes from specific product categories, indicating strong category loyalty.
📌 Implication:
  Creating targeted loyalty programs and premium offerings for this cohort would yield outsized returns.
  
3️⃣ Campaign Effectiveness Varies Sharply Across Segments
  Campaign acceptance rates reveal:
  Large variance across countries and age groups, highlighting the need for segmentation-based targeting.
  A few campaigns show high acceptance but low purchases, suggesting ineffective follow-through or poor conversion design.
  Others show lower reach but extremely strong conversion, indicating under-investment in strong-performing campaigns.
📌 Implication:
  Shift budget away from high-reach/low-conversion campaigns toward campaigns where acceptance reliably leads to purchases.
  
4️⃣ Engagement With Campaigns Directly Predicts Higher Spend
  A key behavioral pattern emerges:
  As customers accept more campaigns, both their median purchases and average purchase value rise.
  There is a clear positive trend between campaign engagement and LTV.
  This pattern holds across channels and demographic groups.
📌 Implication:
  Marketing campaigns are not merely acquisition tools—they meaningfully shape LTV.
  Increasing personalized campaign frequency for mid-/high-value customers can lift revenue.

5️⃣ Channel Quartile Analysis Reveals Distinct Spending Profiles
  Quartile analysis by Store, Web, and Catalog shows:
  Top quartile customers contribute the majority of revenue, as expected.
  However, the magnitude differs greatly by channel:
  One channel shows extremely high concentration (top 25% dominate most revenue).
  Another is more balanced, with Q2 and Q3 users playing a larger role.
  % change between quartiles exposes where the biggest jumps in LTV occur.
📌 Implication:
  Marketing should be tailored per channel:
  Channels with steep quartile jumps = opportunity to move customers upward with targeted nudges.
  Channels with smoother quartiles = ideal for broad acquisition efforts.

6️⃣ Product Co-Purchase Matrix Reveals Strong Cross-Sell Opportunities
  The 6×6 co-purchase matrix shows:
  Clear pairings between certain product categories.
  Some categories act as “gateway” products—buying them strongly predicts purchases in multiple other categories.
  Other categories generate high purchase counts but weak cross-sell influence.
📌 Implication:
  Bundle products based on high-frequency co-purchase pairs.
  Use gateway categories for targeted cross-sell journeys.

7️⃣ Product-Level Recency & YoY Performance Provide Operational Insight
  Median days since last purchase identifies which products are falling out of customer habits.
  YoY revenue and average spend charts highlight categories with:
  consistent growth
  potential saturation
  concerning decline
📌 Implication:
  Products with high recency and declining YoY revenue should be re-marketed, repositioned, or replaced.

📌 Summary of Impact
This project simulates the everyday work of a Marketing Analyst. It answers real business questions:
  Who are our most valuable customers?
  What drives campaign success?
  How do different channels contribute to revenue?
  Which products should be bundled or promoted?
  Where should budget be increased or reduced?
  How can customers be moved to higher LTV quartiles?

Across the dashboards, the insights form a cohesive narrative around customer value, channel performance, product behavior, and marketing ROI.

