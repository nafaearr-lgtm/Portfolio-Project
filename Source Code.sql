/* Initial Look
SUMMARIZE SELECT * FROM '/Users/nafay/Downloads/Marketing+Data/marketing_data.csv'
Observations: 
1. Since there are 573 unique acq dates, that means customer cohorts can be made.
2. Null values in income  will be dealt with in the first CTE
3. Every column has the same count of rows-> 2240
4. Data types are consistent 
*/

-- Objective 1: Customer Demographic Profiling
	/* To identify high-engagement and high-value customers by calculating customer lifetime value (LTV), and filtering those with strong campaign response and purchase activity. 
	This helps create profitable, responsive audiences for targeted marketing. */
-- Objective 1 CTEs
	WITH avg_income AS (
	  SELECT AVG(income) AS avg_inc
	  FROM '/Users/nafay/Downloads/Marketing+Data/marketing_data.csv'
	  WHERE income IS NOT NULL
	),
	base AS (
	  SELECT
	    ID, YEAR(CURRENT_DATE) - Year_Birth as Age, Education, Country,
	    COALESCE(income, (SELECT avg_inc FROM avg_income)) AS Salary,
	    Marital_Status AS Status, Kidhome as kids, Teenhome as Teens, Dt_Customer AS Acq_Date, Recency, MntWines, MntFruits, MntMeatProducts, MntFishProducts, MntSweetProducts,
	    MntGoldProds, NumDealsPurchases, NumWebPurchases, NumCatalogPurchases, NumStorePurchases, NumWebVisitsMonth, AcceptedCmp1 as Camp1, AcceptedCmp2 as Camp2, AcceptedCmp3 as Camp3, 
	    AcceptedCmp4 as Camp4, AcceptedCmp5 as Camp5, Response, Complain
	  FROM '/Users/nafay/Downloads/Marketing+Data/marketing_data.csv'
	),
	data AS ( 
	SELECT ID, 
	(Camp1 + Camp2 + Camp3 + Camp4 + Camp5 + Response) as total_camp,
	(NumCatalogPurchases + NumDealsPurchases + NumStorePurchases + NumWebPurchases)  as total_purchases,
	(MntWines + MntFruits + MntMeatProducts + MntSweetProducts + MntGoldProds) as LTV
	FROM base
	);
-- Result 1
/* A cleaned and segmented customer view highlighting top performers (high LTV, multiple campaign responses, and strong purchasing activity). 
 * Includes demographic brackets (age, income), education, marital status, and country, ready for further persona analysis or targeted campaign planning. */
SELECT 
	sub3.ID,
	CASE 
		WHEN AGE >= 30 AND AGE <40 THEN '30-40'
		WHEN AGE >= 40 AND AGE <50 THEN '40-50'
		WHEN AGE >= 50 AND AGE <60 THEN '50-60'
		WHEN AGE >=60 AND AGE <70 THEN '60-70'
	 ELSE 'Above 70'
	END as age_group,
	CASE 
		WHEN SALARY < 40000 THEN 'Less than 40K'
		WHEN SALARY >= 40000 AND SALARY < 50000 THEN '40K-50K'
		WHEN SALARY >= 50000 AND SALARY < 60000 THEN '50-60K'
		WHEN SALARY >= 60000 AND SALARY < 70000 THEN '60-70K'
		WHEN SALARY >= 70000 AND SALARY < 80000 THEN '70-80K'
		ELSE 'Above 80K'
	END as income_bracket,
	sub3.Country,
	sub3.Education,
	sub3.Status
FROM
	(SELECT b.ID, b.Age, b.Education, b.Country, b.Salary, b.Status FROM 
		(SELECT * from 
			(SELECT b.ID, b.NumWebVisitsMonth, d.LTV, d.total_camp, d.total_purchases, rank() OVER (PARTITION BY d.total_camp, d.total_purchases ORDER BY d.LTV DESC) as rank 
			FROM base b JOIN data d ON b.ID = d.ID ) SUB
		WHERE sub."rank" IN (1, 2, 3) 
		AND SUB.total_camp >= 1 
		AND sub.total_purchases  >= 14 
		AND sub.NumWebVisitsMonth >= 6
		ORDER BY SUB.total_camp DESC) sub2
	JOIN base b ON b.id = sub2.ID ) sub3
ORDER BY sub3.ID;

-- Objective 2: Campaign Analysis & User Attribution
	/* To analyze the demographic and behavioral characteristics of customers who accepted at least one marketing campaign. 
	The goal is to profile paid users, assess campaign effectiveness, and identify which campaigns performed best based on acceptance rates, spending, and engagement metrics. */ 
-- Objective 2a, 2b CTEs
WITH avg_income AS ( -- To deal with null values in the income clmn
		SELECT AVG(income) AS avg_inc
		FROM '/Users/nafay/Downloads/Marketing+Data/marketing_data.csv'
		WHERE income IS NOT NULL
		),
	base AS ( -- Removing nulls from income, cleaning column order, formatting names 
	  	SELECT
	    	ID, YEAR(CURRENT_DATE) - Year_Birth as Age, Education, Country,
	   		COALESCE(income, (SELECT avg_inc FROM avg_income)) AS Salary,
	    	Marital_Status AS Status, Kidhome as kids, Teenhome as Teens, Dt_Customer AS Acq_Date, Recency, MntWines, MntFruits, MntMeatProducts, MntFishProducts, MntSweetProducts,
	    	MntGoldProds, NumDealsPurchases, NumWebPurchases, NumCatalogPurchases, NumStorePurchases, NumWebVisitsMonth, AcceptedCmp1 as Camp1, AcceptedCmp2 as Camp2, AcceptedCmp3 as Camp3, 
	    	AcceptedCmp4 as Camp4, AcceptedCmp5 as Camp5, Response, Complain
	  	FROM '/Users/nafay/Downloads/Marketing+Data/marketing_data.csv'
		),
	paid_users_pu AS ( -- Customers who accepted at least one campaign
		SELECT 
			ID,
			COUNT(ID)  
		FROM base 
		WHERE Camp1 = 1 OR Camp2 = 1 OR Camp3 = 1 OR Camp4 = 1 OR Camp5 = 1 OR Response = 1
		GROUP BY ID
		),		
	pu_demos AS (
		SELECT 
			b.ID, b.Age, b.Education, b.Status, b.Country, b.Salary,
			Camp1 + Camp2 + Camp3 + Camp4 + Camp5 + Response as total_campaigns,
			TRIM(BOTH ', ' FROM (
		      CASE WHEN Camp1 = 1 THEN 'Campaign 1, ' ELSE '' END ||
		      CASE WHEN Camp2 = 1 THEN 'Campaign 2, ' ELSE '' END ||
		      CASE WHEN Camp3 = 1 THEN 'Campaign 3, ' ELSE '' END ||
		      CASE WHEN Camp4 = 1 THEN 'Campaign 4, ' ELSE '' END ||
		      CASE WHEN Camp5 = 1 THEN 'Campaign 5, ' ELSE '' END ||
		      CASE WHEN Response = 1 THEN 'Response' ELSE '' END
		    )) AS campaigns
		FROM base b 
		JOIN paid_users_pu p ON b.ID = p.ID
		),
	ID_attr AS (
		SELECT
	  	p.ID,
	  	b.Age as Age, 
	  	b.Recency as days_since_last_prch,
	  	b.MntWines + b.MntFruits + b.MntMeatProducts + b.MntFishProducts + b.MntSweetProducts + b.MntGoldProds AS total_amount_spent,
	  	b.NumDealsPurchases + b.NumWebPurchases + b.NumCatalogPurchases + b.NumStorePurchases AS total_channel_purchases,
	  	b.Complain as has_complained,
	  	p.campaigns
	  	FROM base b JOIN pu_demos p ON b.ID = p.ID
	  	),
	camp_analysis AS (
  		SELECT
		CASE
		  WHEN i.campaigns LIKE '%Campaign 1%' THEN 'Campaign 1'
		  WHEN i.campaigns LIKE '%Campaign 2%' THEN 'Campaign 2'
		  WHEN i.campaigns LIKE '%Campaign 3%' THEN 'Campaign 3'
		  WHEN i.campaigns LIKE '%Campaign 4%' THEN 'Campaign 4'
		  WHEN i.campaigns LIKE '%Campaign 5%' THEN 'Campaign 5'
		  WHEN i.campaigns LIKE '%Response%' THEN 'Response'
		  END AS campaign_name, 
		COUNT(DISTINCT i.ID) as users_reached,
		ROUND((COUNT(DISTINCT i.ID)/2240)*100, 2) AS global_acceptance_rate, 
		ROUND(AVG(i.Age), 1) as average_age,
		ROUND(AVG(i.days_since_last_prch),2) as avg_days_from_last_purch,
		ROUND(AVG(i.total_amount_spent),2) as avg_user_spent,
		ROUND(AVG(i.total_channel_purchases),1) as avg_user_num_purchases,
		ROUND(AVG(i.has_complained),2) as avg_complaints
		FROM pu_demos p JOIN ID_attr i ON p.campaigns = i.campaigns
		GROUP BY campaign_name
		ORDER BY 2 DESC
		);
-- Result 2a: 
 /*The first output (camp_analysis) provides a campaign-level summary showing how each campaign performed based on acceptance rate, spending behavior, recency, and complaints. This dataset helps identify which campaigns 
resonated most with high-value users. */	
	SELECT * FROM camp_analysis ; 
-- Result 2b: 
/* The second output ranks paid users within their countries by the number of campaigns they accepted, displaying their demographics and engagement.  This allows comparison of campaign responsiveness across countries and income/age segments. */
	SELECT 
		DENSE_RANK() OVER (PARTITION BY sub.Country ORDER BY sub.total_campaigns DESC) as ranked,
		sub.*
	FROM (SELECT 
			p.ID, p.Education, p.Status, p.Country,
			CASE 
				WHEN p.Age >= 30 AND p.Age <40 THEN '30-39' WHEN p.Age >= 40 AND p.Age <50 THEN '40-49' WHEN p.Age >= 50 AND p.Age <60 THEN '50-59' WHEN p.Age >=60 AND p.Age <70 THEN '60-69' ELSE 'Above 70'
			END as age_group,
			CASE 
				WHEN p.SALARY < 40000 THEN 'Less than 40K' WHEN p.SALARY >= 40000 AND p.SALARY < 50000 THEN '40K-50K' WHEN p.SALARY >= 50000 AND p.SALARY < 60000 THEN '50-60K' WHEN p.SALARY >= 60000 AND p.SALARY < 70000 THEN '60-70K' WHEN p.SALARY >= 70000 AND p.SALARY < 80000 THEN '70-80K' ELSE 'Above 80K'
			END as income_bracket,
			p.total_campaigns, 
			p.campaigns
			FROM pu_demos p
			ORDER BY p.total_campaigns DESC) sub;

-- Objective 3: Channel Analysis
	/* Identify and classify customers into distinct channel preference segments based on their purchase behavior across web, catalog, and store channels to optimize marketing resource allocation 
	 and personalize cross-channel engagement strategies. */
-- Objective 3 CTEs
WITH 
		avg_income AS (
		SELECT AVG(income) AS avg_inc
		FROM '/Users/nafay/Downloads/Marketing+Data/marketing_data.csv'
		WHERE income IS NOT NULL
		),
		base AS (
		SELECT
			ID,
			YEAR(CURRENT_DATE) - Year_Birth as Age,
			Education,
			Country,
			COALESCE(income, (SELECT avg_inc FROM avg_income)) AS Salary,
			Marital_Status AS Status,
			Kidhome as kids,
			Teenhome as Teens,
			Dt_Customer AS Acq_Date,
			Recency,
			MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds as LTV,
			NumDealsPurchases as discounts_used,
			NumWebPurchases as web_purchases,
			NumCatalogPurchases as catalog_purchases,
			NumStorePurchases as store_purchases,
			NumWebVisitsMonth as site_visits,
			AcceptedCmp1 as Camp1, AcceptedCmp2 as Camp2, AcceptedCmp3 as Camp3, AcceptedCmp4 as Camp4, AcceptedCmp5 as Camp5,
			Response,  Complain
			FROM read_csv_auto('/Users/nafay/Downloads/Marketing+Data/marketing_data.csv')
			), 
		data AS (
		SELECT
			*,
			CASE 
		      WHEN web_purchases > 0 
		      THEN NTILE(4) OVER (
		        PARTITION BY CASE WHEN web_purchases > 0 THEN 1 END 
		        ORDER BY web_purchases
		      )
		    END AS web_quartile,
		    CASE 
		      WHEN store_purchases > 0 
		      THEN NTILE(4) OVER (
		        PARTITION BY CASE WHEN store_purchases > 0 THEN 1 END 
		        ORDER BY store_purchases
		      )
		    END AS store_quartile,
		    CASE 
		      WHEN catalog_purchases > 0 
		      THEN NTILE(4) OVER (
		        PARTITION BY CASE WHEN catalog_purchases > 0 THEN 1 END 
		        ORDER BY catalog_purchases
		      )
		    END AS catalog_quartile
		FROM base
			),
		standings AS (
			SELECT
		    d.ID,
		    CASE web_quartile
		      WHEN 4 THEN 'Top 25% Web'
		      WHEN 3 THEN 'Q3 Web'
		      WHEN 2 THEN 'Q2 Web'
		      WHEN 1 THEN 'Bottom 25% Web'
		    END AS web_standing,
		    CASE store_quartile
		      WHEN 4 THEN 'Top 25% Store'
		      WHEN 3 THEN 'Q3 Store'
		      WHEN 2 THEN 'Q2 Store'
		      WHEN 1 THEN 'Bottom 25% Store'
		    END AS store_standing,
		    CASE catalog_quartile
		      WHEN 4 THEN 'Top 25% Catalog'
		      WHEN 3 THEN 'Q3 Catalog'
		      WHEN 2 THEN 'Q2 Catalog'
		      WHEN 1 THEN 'Bottom 25% Catalog'
		    END AS catalog_standing
	  	FROM data d
			),
		unpivoted AS (
			SELECT id, web_standing as standing FROM standings
				  UNION ALL
		  	SELECT id, store_standing as standing FROM standings
				  UNION ALL
		  	SELECT id, catalog_standing as standing FROM standings
			)
-- Result 3:
/* Segment customers using statistical quartiles (Q1, Median, Q3) for each purchase channel, creating mutually exclusive collectively exhaustive performance tiers. This percentile-based approach ensures segments are data-driven */	
SELECT
		  standing,
		  COUNT(DISTINCT u.id) AS User_Count,
		  ROUND(AVG(d.LTV), 2) AS avg_user_spent,
		  ROUND(AVG(d.site_visits), 2) AS avg_site_visits,
		  ROUND(AVG(d.Age), 1) AS average_age,
		  ROUND(AVG(d.discounts_used), 2) AS avg_num_discount,
		  ROUND(AVG(d.Salary), 2) AS avg_user_salary, 
		FROM unpivoted u
		JOIN data d ON d.id = u.id
		JOIN standings s on s.id = u.id
		where u.standing IS NOT NULL
		GROUP BY standing
	ORDER BY 2 desc;

-- Objective 4: Product Analysis
	/* Identify strongest product (dominant); product with most room-for-growth (supporting), product which need to provide more value to customers (low interest). 
	 * Identify which product categories are frequently purchased together and can be used for cross selling and bundling. 
	 */ 
-- Objective 4 CTEs:
WITH avg_income AS (
		SELECT AVG(income) AS avg_inc
		FROM '/Users/nafay/Downloads/Marketing+Data/marketing_data.csv'
		WHERE income IS NOT NULL
		),
		base AS (
		SELECT
			ID,
			YEAR(CURRENT_DATE) - Year_Birth as Age,
			Education,
			Country,
			COALESCE(income, (SELECT avg_inc FROM avg_income)) AS Salary,
			Marital_Status AS Status,
			Kidhome,
			Teenhome,
    		LEFT(DATE_TRUNC('month', Dt_Customer)::string, 7) AS cohort,
			Recency,
			MntWines as Wines_Spend,
			MntFruits as Fruit_Spend,
			MntMeatProducts as Meat_Spend,
			MntFishProducts as Fish_Spend,
			MntSweetProducts as Sweets_Spend,
			MntGoldProds as Gold_spend,
			MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds as LTV,
			NumDealsPurchases as discounts_used,
			NumWebPurchases,
			NumCatalogPurchases,
			NumStorePurchases,
			NumWebVisitsMonth,
			AcceptedCmp1 as Camp1, AcceptedCmp2 as Camp2, AcceptedCmp3 as Camp3, AcceptedCmp4 as Camp4, AcceptedCmp5 as Camp5,
			Response,  Complain
			FROM read_csv_auto('/Users/nafay/Downloads/Marketing+Data/marketing_data.csv')
			),
		data AS ( 
		SELECT 
			ID,
			(Wines_spend/LTV)*100 as wines_pct,
			(fruit_spend/LTV)*100 as fruit_pct,
			(meat_spend/LTV)*100 as meat_pct,
			(fish_spend/LTV)*100 as fish_pct,
			(sweets_spend/LTV)*100 as sweet_pct,
			(gold_spend/LTV)*100 as gold_pct
		FROM base
			),
		unpivoted AS ( 
		SELECT d.ID, 'Wines' as category, d.wines_pct as pct, b.Wines_Spend as spend FROM data d JOIN base b on b.id = d.id
			UNION  ALL
		SELECT d.ID, 'Fruit' as category, d.fruit_pct as pct, b.Fruit_Spend as spend FROM data d JOIN base b on b.id = d.id
			UNION ALL
		SELECT d.ID, 'Meat' as category, d.meat_pct as pct, b.Meat_Spend as spend FROM data d JOIN base b on b.id = d.id
			UNION ALL
		SELECT d.ID, 'Fish' as category, d.fish_pct as pct, b.Fish_Spend as spend FROM data d JOIN base b on b.id = d.id
			UNION ALL
		SELECT d.ID, 'Sweets' as category, d.sweet_pct as pct, b.Sweets_Spend as spend FROM data d JOIN base b on b.id = d.id
			UNION ALL
		SELECT d.ID, 'Gold' as category, d.gold_pct as pct, b.Gold_spend as spend FROM data d JOIN base b on b.id = d.id  
			)
		select * from unpivoted
		,
		dataset1 AS (
		select 
			id, 
			category as product, 
			CASE WHEN spend > 0 THEN 1 ELSE 0 
			END as exists 
		from unpivoted 
		),
		products as ( 
		select 
			product,
			count(*) as num_customers
		from dataset1
		where exists = 1
		group by 1
		),
		pairs as ( 
		select 
			count(distinct d1.ID) AS num,
			d1.product as product_a,
			d2.product as product_b
		from dataset1 d1 
		join dataset1 d2 
			on d1.id = d2.id 
		where d1.exists = 1 AND d2.exists = 1 AND d1.product < d2.product 
		group by 2,3
		order by 1 desc
		),
		matrix AS ( 
		SELECT 
			product_a as prod1,
			product_b as prod2,
			num as value
		from pairs
		UNION ALL
		SELECT 
			product as prod1,
			product as prod2,
			num_customers as value
		from products
		),
		pct_buckets AS (
		SELECT 
			u.*, 
			CASE
				WHEN pct < 15 THEN 'Low interest Category'
				WHEN pct >= 15 AND pct <=40 THEN 'Supporting Category'
				WHEN pct > 40 THEN 'Dominant Category'
			END as category_profile
		FROM unpivoted u
		);
-- Result 4a:
/* A symmetric matrix which shows the number of customers who purchased each product (on the diagonal), and the off-diagonal shows the number of customers who purchased both products together. This reveals:
 1. Market basket insights
 2. Cross-sell & bundling opportunities thru high co-purchase pairs
*/
SELECT 
	*
FROM matrix
PIVOT ( SUM(value) FOR prod2 IN (Wines, Fruit, Meat, Fish, Sweets, Gold))
ORDER BY 
CASE prod1
    WHEN 'Wines' THEN 1
    WHEN 'Fruit' THEN 2
    WHEN 'Meat' THEN 3
    WHEN 'Fish' THEN 4
    WHEN 'Sweets' THEN 5
    WHEN 'Gold' THEN 6
END;
-- Result 4b: 
/* Calculates the mean percentage of wallet share for each product across all customers.
 * Calculates the total unique customers who purchased the product
 * Interest distribution by calculating the number of customers who view each product as a dominant reason for visiting, a supporting reason, or a low-interest reason.
 */
select 
	p.category,
	AVG(p.pct) mean_pct,
	count(CASE WHEN p.spend  > 0 THEN 1 END) AS num_unique_customers,
	count(CASE WHEN category_profile = 'Low interest Category' then 1 END) as low_interest_count,
	count(CASE WHEN category_profile = 'Supporting Category' then 1 END) as supporting_interest_count,
	count(CASE WHEN category_profile = 'Dominant Category' then 1 END) as dominant_interest_count
from pct_buckets p 
group by p.category
order by 2 desc;
