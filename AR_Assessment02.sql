-- creating a temp table for the sales table that adjusts the sale_at from UTC to EST
CREATE TABLE `tfdalexanderraouf.assessment_02.TempSales`
OPTIONS(
  expiration_timestamp=TIMESTAMP_ADD(CURRENT_TIMESTAMP(), INTERVAL 2 DAY)
) AS
SELECT 

    DATETIME(sale_at, "America/New_York") as sale_at, 
    customer_id, 
    sale_value
FROM `tfdalexanderraouf.assessment_02.sales`;


-- Creating a temporary table 'FilteredSales' that filters out any sales that did not happen between the specified time frame (2018-10-08 to 2020-05-18)
CREATE TABLE `tfdalexanderraouf.assessment_02.FilteredSales`
OPTIONS(
  expiration_timestamp=TIMESTAMP_ADD(CURRENT_TIMESTAMP(), INTERVAL 3 DAY)
) AS
SELECT 
    sale_at, 
    customer_id, 
    sale_value
FROM `tfdalexanderraouf.assessment_02.TempSales`
WHERE CAST(sale_at as Date) BETWEEN '2018-10-08' AND '2020-05-18';


-- Creating a temporary table that includes a column that has the date of the next sale purchase by the same customer
-- This will allow us to join the sales and refunds table without having duplicate joins on the wrong dates
CREATE TABLE `tfdalexanderraouf.assessment_02.FilteredSalesWithLeadDate`
OPTIONS(
  expiration_timestamp=TIMESTAMP_ADD(CURRENT_TIMESTAMP(), INTERVAL 3 DAY)
) AS
SELECT 
    sale_at, 
    customer_id, 
    sale_value,
    LEAD(sale_at, 1) OVER (PARTITION BY customer_id ORDER BY sale_at ) as next_sale_date, 
FROM `tfdalexanderraouf.assessment_02.FilteredSales`;


-- creating a temp table that adjusts the refund_at from UTC to EST for the refunds table
CREATE TABLE `tfdalexanderraouf.assessment_02.TempRefunds`
OPTIONS(
  expiration_timestamp=TIMESTAMP_ADD(CURRENT_TIMESTAMP(), INTERVAL 2 DAY)
) AS
SELECT 
    DATETIME(refund_at, "America/New_York") as refund_at, 
    customer_id, 
    refund_amount
FROM `tfdalexanderraouf.assessment_02.refunds`;




-- Creating a temp table all_sales_and_refunds that contains a LEFT JOIN table of the FilteredSalesWithLeadDate and TempRefunds
CREATE TABLE `tfdalexanderraouf.assessment_02.all_sales_and_refunds`
    OPTIONS(
  expiration_timestamp=TIMESTAMP_ADD(CURRENT_TIMESTAMP(), INTERVAL 3 DAY)
)   AS (
        SELECT 
        	fs.*,
        	tr.* EXCEPT(customer_id)
        FROM  `tfdalexanderraouf.assessment_02.FilteredSalesWithLeadDate` fs
        LEFT JOIN `tfdalexanderraouf.assessment_02.TempRefunds` tr
            ON fs.customer_id = tr.customer_id
            AND tr.refund_at BETWEEN fs.sale_at AND fs.next_sale_date
            AND fs.sale_value >= tr.refund_amount
          );   


-- Checking for any duplicate sales on the same day by the same customer that might have occurred by accident
SELECT 
    customer_id, sale_at, COUNT(*) as counts
FROM `tfdalexanderraouf.assessment_02.all_sales_and_refunds`
GROUP BY customer_id, sale_at
HAVING counts>1;


-- Checking for missing dates
-- Discovering how many days are between our first date and last date
SELECT 
    DATE_DIFF(MAX(CAST(sale_at as DATE)), MIN(CAST(sale_at as DATE)), DAY) + 1
FROM `tfdalexanderraouf.assessment_02.all_sales_and_refunds`;

-- There are 588 days between our first day and last day in our dataset, plus an additional 1 for the first day which isn't initially counted
-- In order to check if there are any missing dates in general, I will count the distinct dates in our dataset
SELECT 
    COUNT(DISTINCT CAST(sale_at as DATE))
FROM `tfdalexanderraouf.assessment_02.all_sales_and_refunds`;
-- The result is 589, so we know there aren't any dates missing between the first date and last date


-- Looking at the monthly data, and monthly trends
-- Dividing the data into 28 day windows to report our refund information by 'month' since we classify a month as 28 days
-- Since there are 589 days, there should be about 21-22 months (589 / 28) in total
WITH ranked_sales_dates AS (
    SELECT 
        DENSE_RANK() OVER(ORDER BY CAST(sale_at as DATE)) as date_rank,
        CAST(sale_at as DATE) as sale_at,
        customer_id,
        sale_value,
        refund_amount
    FROM `tfdalexanderraouf.assessment_02.all_sales_and_refunds`
    ORDER BY 2
)

SELECT 
    CAST(FLOOR((date_rank-1) / 28) AS INT) as monthly_period,
    MIN(sale_at) as month_start_date,
    MAX(sale_at) as month_end_date,
    SUM(sale_value) as total_monthly_sale,
    SUM(refund_amount) as total_refund_amount,
    ROUND(SUM(refund_amount) / SUM(sale_value), 2) as refund_ratio
FROM ranked_sales_dates
GROUP BY 1
ORDER BY 1;


-- Looking at the weekly data, and weekly trends
-- Dividing the data into 7 day windows to report our refund information by 'week' since we classify a week as 7 days
-- Since there are 589 days, there should be about 84-85 months (589 / 7) in total
WITH ranked_sales_dates AS (
    SELECT 
        DENSE_RANK() OVER(ORDER BY CAST(sale_at as DATE)) as date_rank,
        CAST(sale_at as DATE) as sale_at,
        customer_id,
        sale_value,
        refund_amount
    FROM `tfdalexanderraouf.assessment_02.all_sales_and_refunds`
    ORDER BY 2
)

SELECT 
    CAST(FLOOR((date_rank-1) / 7) AS INT) as weekly_period,
    MIN(sale_at) as week_start_date,
    MAX(sale_at) as week_end_date,
    SUM(sale_value) as total_weekly_sale,
    SUM(refund_amount) as total_refund_amount,
    ROUND(SUM(refund_amount) / SUM(sale_value), 2) as refund_ratio
FROM ranked_sales_dates
GROUP BY 1
ORDER BY 1;


-- Looking at the average days a customer takes to make a refund
SELECT 
    AVG(DATE_DIFF(CAST(refund_at as DATE), CAST(sale_at as DATE), DAY)) as avg_days_until_refund,
    STDDEV(DATE_DIFF(CAST(refund_at as DATE), CAST(sale_at as DATE), DAY)) as std_days_until_refund
FROM `tfdalexanderraouf.assessment_02.all_sales_and_refunds`
WHERE refund_at IS NOT NULL;

-- Looking at the average weeks a customer takes to make a refund
SELECT 
    ROUND(AVG(DATE_DIFF(CAST(refund_at as DATE), CAST(sale_at as DATE), DAY) / 7)) as avg_weeks_until_refund,
    ROUND(STDDEV(DATE_DIFF(CAST(refund_at as DATE), CAST(sale_at as DATE), DAY) / 7)) as std_weeks_until_refund
FROM `tfdalexanderraouf.assessment_02.all_sales_and_refunds`
WHERE refund_at IS NOT NULL;

-- Looking at the average months a customer takes to make a refund
SELECT 
    ROUND(AVG(DATE_DIFF(CAST(refund_at as DATE), CAST(sale_at as DATE), DAY) / 28)) as avg_months_until_refund,
    ROUND(STDDEV(DATE_DIFF(CAST(refund_at as DATE), CAST(sale_at as DATE), DAY) / 28)) as std_months_until_refund
FROM `tfdalexanderraouf.assessment_02.all_sales_and_refunds`
WHERE refund_at IS NOT NULL;


-- BONUS QUESTION
SELECT * FROM `tfdalexanderraouf.assessment_02.all_sales_and_refunds`
WHERE CAST(sale_at as DATE) = '2020-01-01'
ORDER BY sale_at
LIMIT 1;

