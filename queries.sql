-- ============================================================
-- Retail Sales and Profitability Analysis (Super Store)
-- Author  : Satish Sherikar
-- Tool    : SQL
-- Table   : store (9,994 records)
-- Queries : 25 (basic aggregation -> window functions -> pivot)
-- ============================================================


-- ------------------------------------------------------------
-- SECTION A: Basic exploration
-- ------------------------------------------------------------

-- 1. How many rows are in the table?
select count(*) from store;

-- 2. Find total sales, total profit and total quantity
select round(sum(sales)) as Total_sales,
round(sum(profit)) as Total_profit,
round(sum(quantity)) as Total_quantity
from store;

-- 3. List all distinct ship modes
select distinct ship_mode from store;

-- 4. Total sales by region
select region,round(sum(sales)) as Total_sales from store
group by region order by Total_sales desc;

-- 5. Total profit by category.
select category,round(sum(profit))as Total_profit from store
group by category order by Total_profit;

-- 6. Average discount for each sub-category.
select sub_category ,round(avg(discount),3) avg_discount from store 
group by sub_category order by avg_discount;

-- 7. Top 10 cities by sales.
select city, round(sum(sales),2) as Total_sales from store
 group by city order by Total_sales desc limit 10;
 
-- 8. How many loss-making records are there (Profit < 0)?
select count(*) as loss_records from store
where profit<0;

-- 9. How many distinct states and cities exist?
select count(distinct state) states,count(distinct city) cities from store;

-- 10. Number of records in each segment.
select segment ,count(*) as  record from store
group by segment;


-- ------------------------------------------------------------
-- SECTION B: Profitability and ranking
-- ------------------------------------------------------------

-- 11. Profit margin % by category.
select category,round(sum(profit)/sum(sales)*100,2) profit_margin from store
group by category;

-- 12. Top 5 most profitable sub-categories.
select sub_category,round(sum(profit),2) as Total_profit from store
group by sub_category order by Total_profit desc limit 5;

-- 13. Bottom 5 sub-categories by profit.
select sub_category,round(sum(profit),2) as Total_profit from store
group by sub_category order by Total_profit limit 5;

-- 14. Sales by ship mode and segment
select  ship_mode,segment ,round(sum(sales),2) as Total_sales from  store
group by ship_mode,segment;

-- 15. States whose total sales are above the average state sales.
select state,round(sum(sales),2) as Total_sales from store 
group by state
having sum(sales)>(select avg(s) from (select sum(sales) s from store group by state) t);


-- ------------------------------------------------------------
-- SECTION C: Discount impact and loss analysis
-- ------------------------------------------------------------

-- 16. Effect of discount on profit (discount bands).
SELECT CASE WHEN Discount = 0 THEN 'No discount'
            WHEN Discount <= 0.2 THEN 'Low (0-20%)'
            WHEN Discount <= 0.4 THEN 'Medium (20-40%)'
            ELSE 'High (>40%)' END AS discount_band,
       COUNT(*) records, ROUND(AVG(Profit),2) avg_profit, ROUND(SUM(Profit),2) total_profit
FROM store GROUP BY discount_band;

-- 17. Total loss by region (only negative profits)
select region, round(sum(profit),2) as Total_loss from store 
where profit<0
group by region;

-- 18. Cities with overall negative profit.
select city, state,round(sum(profit),2) as Total_profit 
from store 
group by city,state
having sum(profit)<0 order by Total_profit;

-- 19. Sub-categories with average discount above 20% and negative total profit.
select sub_category,round(avg(discount),2) as avg_disc,
round(sum(profit),2) as Total_profit
from store
group by sub_category
having avg(discount)>0.2 and sum(profit)<0;

-- 20. Percentage share of each category in total sales
select category,round(sum(sales),2)  as salesby_ctgy,
round(sum(sales)*100/(select sum(sales) from store),2) as sales_percentage
from store
group by category
order by sales_percentage;


-- ------------------------------------------------------------
-- SECTION D: Window functions and pivot
-- ------------------------------------------------------------

-- 21. Rank sub-categories by profit within each category
select category,sub_category,round(sum(profit),2) as total_profit,
rank() over ( partition by category order by sum(profit)  desc) as rnk
from store
group by category,sub_category;

-- 22. Top 3 states by sales in each region.
select * from (
select region,state,round(sum(sales),2) as Total_sales,
row_number() over(partition by region order by sum(sales) desc) rnk
from store 
group by region,state)t
where rnk<=3;

-- 23. Running (cumulative) sales by state, highest first.
select state,round(sum(sales),2) as Total_sales ,
round(sum(sum(sales)) over(order by sum(sales) desc),2) running_total
from store group by state;

-- 24. Each region's contribution to total profit (%)
select region,round(sum(profit),2) as Total_profit,
round(sum(profit)*100/sum(sum(profit)) over() ,2)as profit_percentage
from store 
group by region;

-- 25. Pivot: sales of each category across segments.
SELECT Category,
  ROUND(SUM(CASE WHEN Segment='Consumer' THEN Sales END),2) Consumer,
  ROUND(SUM(CASE WHEN Segment='Corporate' THEN Sales END),2) Corporate,
  ROUND(SUM(CASE WHEN Segment='Home Office' THEN Sales END),2) Home_Office
FROM store GROUP BY Category;