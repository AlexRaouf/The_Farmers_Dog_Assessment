{\rtf1\ansi\ansicpg1252\cocoartf1561\cocoasubrtf200
{\fonttbl\f0\fnil\fcharset0 Menlo-Regular;}
{\colortbl;\red255\green255\blue255;\red204\green0\blue78;\red255\green255\blue254;\red0\green0\blue0;
\red39\green78\blue204;\red21\green129\blue62;\red42\green55\blue62;\red107\green0\blue1;\red238\green57\blue24;
}
{\*\expandedcolortbl;;\cssrgb\c84706\c10588\c37647;\cssrgb\c100000\c100000\c99608;\cssrgb\c0\c0\c0;
\cssrgb\c20000\c40392\c83922;\cssrgb\c5098\c56471\c30980;\cssrgb\c21569\c27843\c30980;\cssrgb\c50196\c0\c0;\cssrgb\c95686\c31765\c11765;
}
\margl1440\margr1440\vieww13240\viewh8700\viewkind0
\deftab720
\pard\pardeftab720\sl360\partightenfactor0

\f0\fs24 \cf2 \cb3 \expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 -- creating a temp table for the sales table that adjusts the sale_at from UTC to EST\cf4 \cb1 \strokec4 \
\pard\pardeftab720\sl360\partightenfactor0
\cf5 \cb3 \strokec5 CREATE\cf4 \strokec4  \cf5 \strokec5 TABLE\cf4 \strokec4  \cf6 \strokec6 `tfdalexanderraouf.assessment_02.TempSales`\cf4 \cb1 \strokec4 \
\cf5 \cb3 \strokec5 OPTIONS\cf7 \strokec7 (\cf4 \cb1 \strokec4 \
\pard\pardeftab720\sl360\partightenfactor0
\cf4 \cb3   \cf8 \strokec8 expiration_timestamp\cf4 \strokec4 =\cf5 \strokec5 TIMESTAMP_ADD\cf7 \strokec7 (\cf5 \strokec5 CURRENT_TIMESTAMP\cf7 \strokec7 ()\cf4 \strokec4 , \cf5 \strokec5 INTERVAL\cf4 \strokec4  \cf9 \strokec9 2\cf4 \strokec4  DAY\cf7 \strokec7 )\cf4 \cb1 \strokec4 \
\pard\pardeftab720\sl360\partightenfactor0
\cf7 \cb3 \strokec7 )\cf4 \strokec4  \cf5 \strokec5 AS\cf4 \cb1 \strokec4 \
\pard\pardeftab720\sl360\partightenfactor0
\cf5 \cb3 \strokec5 SELECT\cf4 \strokec4  \cb1 \
\
\pard\pardeftab720\sl360\partightenfactor0
\cf4 \cb3     DATETIME\cf7 \strokec7 (\cf4 \strokec4 sale_at, \cf6 \strokec6 "America/New_York"\cf7 \strokec7 )\cf4 \strokec4  \cf5 \strokec5 as\cf4 \strokec4  sale_at, \cb1 \
\cb3     customer_id, \cb1 \
\cb3     sale_value\cb1 \
\pard\pardeftab720\sl360\partightenfactor0
\cf5 \cb3 \strokec5 FROM\cf4 \strokec4  \cf6 \strokec6 `tfdalexanderraouf.assessment_02.sales`\cf4 \strokec4 ;\cb1 \
\
\
\pard\pardeftab720\sl360\partightenfactor0
\cf2 \cb3 \strokec2 -- Creating a temporary table 'FilteredSales' that filters out any sales that did not happen between the specified time frame (2018-10-08 to 2020-05-18)\cf4 \cb1 \strokec4 \
\pard\pardeftab720\sl360\partightenfactor0
\cf5 \cb3 \strokec5 CREATE\cf4 \strokec4  \cf5 \strokec5 TABLE\cf4 \strokec4  \cf6 \strokec6 `tfdalexanderraouf.assessment_02.FilteredSales`\cf4 \cb1 \strokec4 \
\cf5 \cb3 \strokec5 OPTIONS\cf7 \strokec7 (\cf4 \cb1 \strokec4 \
\pard\pardeftab720\sl360\partightenfactor0
\cf4 \cb3   \cf8 \strokec8 expiration_timestamp\cf4 \strokec4 =\cf5 \strokec5 TIMESTAMP_ADD\cf7 \strokec7 (\cf5 \strokec5 CURRENT_TIMESTAMP\cf7 \strokec7 ()\cf4 \strokec4 , \cf5 \strokec5 INTERVAL\cf4 \strokec4  \cf9 \strokec9 3\cf4 \strokec4  DAY\cf7 \strokec7 )\cf4 \cb1 \strokec4 \
\pard\pardeftab720\sl360\partightenfactor0
\cf7 \cb3 \strokec7 )\cf4 \strokec4  \cf5 \strokec5 AS\cf4 \cb1 \strokec4 \
\pard\pardeftab720\sl360\partightenfactor0
\cf5 \cb3 \strokec5 SELECT\cf4 \strokec4  \cb1 \
\pard\pardeftab720\sl360\partightenfactor0
\cf4 \cb3     sale_at, \cb1 \
\cb3     customer_id, \cb1 \
\cb3     sale_value\cb1 \
\pard\pardeftab720\sl360\partightenfactor0
\cf5 \cb3 \strokec5 FROM\cf4 \strokec4  \cf6 \strokec6 `tfdalexanderraouf.assessment_02.TempSales`\cf4 \cb1 \strokec4 \
\cf5 \cb3 \strokec5 WHERE\cf4 \strokec4  \cf5 \strokec5 CAST\cf7 \strokec7 (\cf4 \strokec4 sale_at \cf5 \strokec5 as\cf4 \strokec4  \cf5 \strokec5 Date\cf7 \strokec7 )\cf4 \strokec4  \cf5 \strokec5 BETWEEN\cf4 \strokec4  \cf6 \strokec6 '2018-10-08'\cf4 \strokec4  \cf5 \strokec5 AND\cf4 \strokec4  \cf6 \strokec6 '2020-05-18'\cf4 \strokec4 ;\cb1 \
\
\
\pard\pardeftab720\sl360\partightenfactor0
\cf2 \cb3 \strokec2 -- Creating a temporary table that includes a column that has the date of the next sale purchase by the same customer\cf4 \cb1 \strokec4 \
\cf2 \cb3 \strokec2 -- This will allow us to join the sales and refunds table without having duplicate joins on the wrong dates\cf4 \cb1 \strokec4 \
\pard\pardeftab720\sl360\partightenfactor0
\cf5 \cb3 \strokec5 CREATE\cf4 \strokec4  \cf5 \strokec5 TABLE\cf4 \strokec4  \cf6 \strokec6 `tfdalexanderraouf.assessment_02.FilteredSalesWithLeadDate`\cf4 \cb1 \strokec4 \
\cf5 \cb3 \strokec5 OPTIONS\cf7 \strokec7 (\cf4 \cb1 \strokec4 \
\pard\pardeftab720\sl360\partightenfactor0
\cf4 \cb3   \cf8 \strokec8 expiration_timestamp\cf4 \strokec4 =\cf5 \strokec5 TIMESTAMP_ADD\cf7 \strokec7 (\cf5 \strokec5 CURRENT_TIMESTAMP\cf7 \strokec7 ()\cf4 \strokec4 , \cf5 \strokec5 INTERVAL\cf4 \strokec4  \cf9 \strokec9 3\cf4 \strokec4  DAY\cf7 \strokec7 )\cf4 \cb1 \strokec4 \
\pard\pardeftab720\sl360\partightenfactor0
\cf7 \cb3 \strokec7 )\cf4 \strokec4  \cf5 \strokec5 AS\cf4 \cb1 \strokec4 \
\pard\pardeftab720\sl360\partightenfactor0
\cf5 \cb3 \strokec5 SELECT\cf4 \strokec4  \cb1 \
\pard\pardeftab720\sl360\partightenfactor0
\cf4 \cb3     sale_at, \cb1 \
\cb3     customer_id, \cb1 \
\cb3     sale_value,\cb1 \
\cb3     \cf5 \strokec5 LEAD\cf7 \strokec7 (\cf4 \strokec4 sale_at, \cf9 \strokec9 1\cf7 \strokec7 )\cf4 \strokec4  \cf5 \strokec5 OVER\cf4 \strokec4  \cf7 \strokec7 (\cf5 \strokec5 PARTITION\cf4 \strokec4  \cf5 \strokec5 BY\cf4 \strokec4  customer_id \cf5 \strokec5 ORDER\cf4 \strokec4  \cf5 \strokec5 BY\cf4 \strokec4  sale_at \cf7 \strokec7 )\cf4 \strokec4  \cf5 \strokec5 as\cf4 \strokec4  next_sale_date, \cb1 \
\pard\pardeftab720\sl360\partightenfactor0
\cf5 \cb3 \strokec5 FROM\cf4 \strokec4  \cf6 \strokec6 `tfdalexanderraouf.assessment_02.FilteredSales`\cf4 \strokec4 ;\cb1 \
\
\
\pard\pardeftab720\sl360\partightenfactor0
\cf2 \cb3 \strokec2 -- creating a temp table that adjusts the refund_at from UTC to EST for the refunds table\cf4 \cb1 \strokec4 \
\pard\pardeftab720\sl360\partightenfactor0
\cf5 \cb3 \strokec5 CREATE\cf4 \strokec4  \cf5 \strokec5 TABLE\cf4 \strokec4  \cf6 \strokec6 `tfdalexanderraouf.assessment_02.TempRefunds`\cf4 \cb1 \strokec4 \
\cf5 \cb3 \strokec5 OPTIONS\cf7 \strokec7 (\cf4 \cb1 \strokec4 \
\pard\pardeftab720\sl360\partightenfactor0
\cf4 \cb3   \cf8 \strokec8 expiration_timestamp\cf4 \strokec4 =\cf5 \strokec5 TIMESTAMP_ADD\cf7 \strokec7 (\cf5 \strokec5 CURRENT_TIMESTAMP\cf7 \strokec7 ()\cf4 \strokec4 , \cf5 \strokec5 INTERVAL\cf4 \strokec4  \cf9 \strokec9 2\cf4 \strokec4  DAY\cf7 \strokec7 )\cf4 \cb1 \strokec4 \
\pard\pardeftab720\sl360\partightenfactor0
\cf7 \cb3 \strokec7 )\cf4 \strokec4  \cf5 \strokec5 AS\cf4 \cb1 \strokec4 \
\pard\pardeftab720\sl360\partightenfactor0
\cf5 \cb3 \strokec5 SELECT\cf4 \strokec4  \cb1 \
\pard\pardeftab720\sl360\partightenfactor0
\cf4 \cb3     DATETIME\cf7 \strokec7 (\cf4 \strokec4 refund_at, \cf6 \strokec6 "America/New_York"\cf7 \strokec7 )\cf4 \strokec4  \cf5 \strokec5 as\cf4 \strokec4  refund_at, \cb1 \
\cb3     customer_id, \cb1 \
\cb3     refund_amount\cb1 \
\pard\pardeftab720\sl360\partightenfactor0
\cf5 \cb3 \strokec5 FROM\cf4 \strokec4  \cf6 \strokec6 `tfdalexanderraouf.assessment_02.refunds`\cf4 \strokec4 ;\cb1 \
\
\cf5 \cb3 \strokec5 \
\pard\pardeftab720\sl360\partightenfactor0
\cf4 \cb1 \strokec4 \
\
\cf2 \cb3 \strokec2 -- Creating a temp table all_sales_and_refunds that contains a LEFT JOIN table of the FilteredSalesWithLeadDate and TempRefunds\cf4 \cb1 \strokec4 \
\cf5 \cb3 \strokec5 CREATE\cf4 \strokec4  \cf5 \strokec5 TABLE\cf4 \strokec4  \cf6 \strokec6 `tfdalexanderraouf.assessment_02.all_sales_and_refunds`\cf4 \cb1 \strokec4 \
\cb3     \cf5 \strokec5 OPTIONS\cf7 \strokec7 (\cf4 \cb1 \strokec4 \
\cb3   \cf8 \strokec8 expiration_timestamp\cf4 \strokec4 =\cf5 \strokec5 TIMESTAMP_ADD\cf7 \strokec7 (\cf5 \strokec5 CURRENT_TIMESTAMP\cf7 \strokec7 ()\cf4 \strokec4 , \cf5 \strokec5 INTERVAL\cf4 \strokec4  \cf9 \strokec9 3\cf4 \strokec4  DAY\cf7 \strokec7 )\cf4 \cb1 \strokec4 \
\cf7 \cb3 \strokec7 )\cf4 \strokec4    \cf5 \strokec5 AS\cf4 \strokec4  \cf7 \strokec7 (\cf4 \cb1 \strokec4 \
\cb3         \cf5 \strokec5 SELECT\cf4 \strokec4  \cb1 \
\cb3         	fs.\cf7 \strokec7 *\cf4 \strokec4 ,\cb1 \
\cb3         	tr.\cf7 \strokec7 *\cf4 \strokec4  \cf5 \strokec5 EXCEPT\cf7 \strokec7 (\cf4 \strokec4 customer_id\cf7 \strokec7 )\cf4 \cb1 \strokec4 \
\cb3         \cf5 \strokec5 FROM\cf4 \strokec4   \cf6 \strokec6 `tfdalexanderraouf.assessment_02.FilteredSalesWithLeadDate`\cf4 \strokec4  fs\cb1 \
\cb3         \cf5 \strokec5 LEFT\cf4 \strokec4  \cf5 \strokec5 JOIN\cf4 \strokec4  \cf6 \strokec6 `tfdalexanderraouf.assessment_02.TempRefunds`\cf4 \strokec4  tr\cb1 \
\cb3             \cf5 \strokec5 ON\cf4 \strokec4  fs.\cf8 \strokec8 customer_id\cf4 \strokec4  = tr.customer_id\cb1 \
\cb3             \cf5 \strokec5 AND\cf4 \strokec4  tr.refund_at \cf5 \strokec5 BETWEEN\cf4 \strokec4  fs.sale_at \cf5 \strokec5 AND\cf4 \strokec4  fs.next_sale_date\cb1 \
\cb3             \cf5 \strokec5 AND\cf4 \strokec4  fs.sale_value \cf7 \strokec7 >=\cf4 \strokec4  tr.refund_amount\cb1 \
\cb3           \cf7 \strokec7 )\cf4 \strokec4 ;   \cb1 \
\pard\pardeftab720\sl360\partightenfactor0
\cf4 \
\
\pard\pardeftab720\sl360\partightenfactor0
\cf2 \cb3 \strokec2 -- Checking for any duplicate sales on the same day by the same customer that might have occurred by accident\cf4 \cb1 \strokec4 \
\cf5 \cb3 \strokec5 SELECT\cf4 \strokec4  \cb1 \
\cb3     customer_id, sale_at, \cf5 \strokec5 COUNT\cf7 \strokec7 (*)\cf4 \strokec4  \cf5 \strokec5 as\cf4 \strokec4  counts\cb1 \
\cf5 \cb3 \strokec5 FROM\cf4 \strokec4  \cf6 \strokec6 `tfdalexanderraouf.assessment_02.all_sales_and_refunds`\cf4 \cb1 \strokec4 \
\cf5 \cb3 \strokec5 GROUP\cf4 \strokec4  \cf5 \strokec5 BY\cf4 \strokec4  customer_id, sale_at\cb1 \
\cf5 \cb3 \strokec5 HAVING\cf4 \strokec4  counts\cf7 \strokec7 >\cf9 \strokec9 1\cf4 \strokec4 ;\cb1 \
\pard\pardeftab720\sl360\partightenfactor0
\cf4 \
\
\pard\pardeftab720\sl360\partightenfactor0
\cf2 \cb3 \strokec2 -- Checking for missing dates\cf4 \cb1 \strokec4 \
\cf2 \cb3 \strokec2 -- Discovering how many days are between our first date and last date\cf4 \cb1 \strokec4 \
\cf5 \cb3 \strokec5 SELECT\cf4 \strokec4  \cb1 \
\cb3     \cf5 \strokec5 DATE_DIFF\cf7 \strokec7 (\cf5 \strokec5 MAX\cf7 \strokec7 (\cf5 \strokec5 CAST\cf7 \strokec7 (\cf4 \strokec4 sale_at \cf5 \strokec5 as\cf4 \strokec4  \cf5 \strokec5 DATE\cf7 \strokec7 ))\cf4 \strokec4 , \cf5 \strokec5 MIN\cf7 \strokec7 (\cf5 \strokec5 CAST\cf7 \strokec7 (\cf4 \strokec4 sale_at \cf5 \strokec5 as\cf4 \strokec4  \cf5 \strokec5 DATE\cf7 \strokec7 ))\cf4 \strokec4 , DAY\cf7 \strokec7 )\cf4 \strokec4  \cf7 \strokec7 +\cf4 \strokec4  \cf9 \strokec9 1\cf4 \cb1 \strokec4 \
\cf5 \cb3 \strokec5 FROM\cf4 \strokec4  \cf6 \strokec6 `tfdalexanderraouf.assessment_02.all_sales_and_refunds`\cf4 \strokec4 ;\cb1 \
\pard\pardeftab720\sl360\partightenfactor0
\cf4 \
\pard\pardeftab720\sl360\partightenfactor0
\cf2 \cb3 \strokec2 -- There are 588 days between our first day and last day in our dataset, plus an additional 1 for the first day which isn't initially counted\cf4 \cb1 \strokec4 \
\cf2 \cb3 \strokec2 -- In order to check if there are any missing dates in general, I will count the distinct dates in our dataset\cf4 \cb1 \strokec4 \
\cf5 \cb3 \strokec5 SELECT\cf4 \strokec4  \cb1 \
\cb3     \cf5 \strokec5 COUNT\cf7 \strokec7 (\cf5 \strokec5 DISTINCT\cf4 \strokec4  \cf5 \strokec5 CAST\cf7 \strokec7 (\cf4 \strokec4 sale_at \cf5 \strokec5 as\cf4 \strokec4  \cf5 \strokec5 DATE\cf7 \strokec7 ))\cf4 \cb1 \strokec4 \
\cf5 \cb3 \strokec5 FROM\cf4 \strokec4  \cf6 \strokec6 `tfdalexanderraouf.assessment_02.all_sales_and_refunds`\cf4 \strokec4 ;\cb1 \
\cf2 \cb3 \strokec2 -- The result is 589, so we know there aren't any dates missing between the first date and last date\cf4 \cb1 \strokec4 \
\pard\pardeftab720\sl360\partightenfactor0
\cf4 \
\
\pard\pardeftab720\sl360\partightenfactor0
\cf2 \cb3 \strokec2 -- Looking at the monthly data, and monthly trends\cf4 \cb1 \strokec4 \
\cf2 \cb3 \strokec2 -- Dividing the data into 28 day windows to report our refund information by 'month' since we classify a month as 28 days\cf4 \cb1 \strokec4 \
\cf2 \cb3 \strokec2 -- Since there are 589 days, there should be about 21-22 months (589 / 28) in total\cf4 \cb1 \strokec4 \
\cf5 \cb3 \strokec5 WITH\cf4 \strokec4  ranked_sales_dates \cf5 \strokec5 AS\cf4 \strokec4  \cf7 \strokec7 (\cf4 \cb1 \strokec4 \
\cb3     \cf5 \strokec5 SELECT\cf4 \strokec4  \cb1 \
\cb3         \cf5 \strokec5 DENSE_RANK\cf7 \strokec7 ()\cf4 \strokec4  \cf5 \strokec5 OVER\cf7 \strokec7 (\cf5 \strokec5 ORDER\cf4 \strokec4  \cf5 \strokec5 BY\cf4 \strokec4  \cf5 \strokec5 CAST\cf7 \strokec7 (\cf4 \strokec4 sale_at \cf5 \strokec5 as\cf4 \strokec4  \cf5 \strokec5 DATE\cf7 \strokec7 ))\cf4 \strokec4  \cf5 \strokec5 as\cf4 \strokec4  date_rank,\cb1 \
\cb3         \cf5 \strokec5 CAST\cf7 \strokec7 (\cf4 \strokec4 sale_at \cf5 \strokec5 as\cf4 \strokec4  \cf5 \strokec5 DATE\cf7 \strokec7 )\cf4 \strokec4  \cf5 \strokec5 as\cf4 \strokec4  sale_at,\cb1 \
\cb3         customer_id,\cb1 \
\cb3         sale_value,\cb1 \
\cb3         refund_amount\cb1 \
\cb3     \cf5 \strokec5 FROM\cf4 \strokec4  \cf6 \strokec6 `tfdalexanderraouf.assessment_02.all_sales_and_refunds`\cf4 \cb1 \strokec4 \
\cb3     \cf5 \strokec5 ORDER\cf4 \strokec4  \cf5 \strokec5 BY\cf4 \strokec4  \cf9 \strokec9 2\cf4 \cb1 \strokec4 \
\cf7 \cb3 \strokec7 )\cf4 \cb1 \strokec4 \
\
\cf5 \cb3 \strokec5 SELECT\cf4 \strokec4  \cb1 \
\cb3     \cf5 \strokec5 CAST\cf7 \strokec7 (\cf5 \strokec5 FLOOR\cf7 \strokec7 ((\cf4 \strokec4 date_rank\cf7 \strokec7 -\cf9 \strokec9 1\cf7 \strokec7 )\cf4 \strokec4  \cf7 \strokec7 /\cf4 \strokec4  \cf9 \strokec9 28\cf7 \strokec7 )\cf4 \strokec4  \cf5 \strokec5 AS\cf4 \strokec4  INT\cf7 \strokec7 )\cf4 \strokec4  \cf5 \strokec5 as\cf4 \strokec4  monthly_period,\cb1 \
\cb3     \cf5 \strokec5 MIN\cf7 \strokec7 (\cf4 \strokec4 sale_at\cf7 \strokec7 )\cf4 \strokec4  \cf5 \strokec5 as\cf4 \strokec4  month_start_date,\cb1 \
\cb3     \cf5 \strokec5 MAX\cf7 \strokec7 (\cf4 \strokec4 sale_at\cf7 \strokec7 )\cf4 \strokec4  \cf5 \strokec5 as\cf4 \strokec4  month_end_date,\cb1 \
\cb3     \cf5 \strokec5 SUM\cf7 \strokec7 (\cf4 \strokec4 sale_value\cf7 \strokec7 )\cf4 \strokec4  \cf5 \strokec5 as\cf4 \strokec4  total_monthly_sale,\cb1 \
\cb3     \cf5 \strokec5 SUM\cf7 \strokec7 (\cf4 \strokec4 refund_amount\cf7 \strokec7 )\cf4 \strokec4  \cf5 \strokec5 as\cf4 \strokec4  total_refund_amount,\cb1 \
\cb3     \cf5 \strokec5 ROUND\cf7 \strokec7 (\cf5 \strokec5 SUM\cf7 \strokec7 (\cf4 \strokec4 refund_amount\cf7 \strokec7 )\cf4 \strokec4  \cf7 \strokec7 /\cf4 \strokec4  \cf5 \strokec5 SUM\cf7 \strokec7 (\cf4 \strokec4 sale_value\cf7 \strokec7 )\cf4 \strokec4 , \cf9 \strokec9 2\cf7 \strokec7 )\cf4 \strokec4  \cf5 \strokec5 as\cf4 \strokec4  refund_ratio\cb1 \
\cf5 \cb3 \strokec5 FROM\cf4 \strokec4  ranked_sales_dates\cb1 \
\cf5 \cb3 \strokec5 GROUP\cf4 \strokec4  \cf5 \strokec5 BY\cf4 \strokec4  \cf9 \strokec9 1\cf4 \cb1 \strokec4 \
\cf5 \cb3 \strokec5 ORDER\cf4 \strokec4  \cf5 \strokec5 BY\cf4 \strokec4  \cf9 \strokec9 1\cf4 \strokec4 ;\cb1 \
\pard\pardeftab720\sl360\partightenfactor0
\cf4 \
\
\pard\pardeftab720\sl360\partightenfactor0
\cf2 \cb3 \strokec2 -- Looking at the weekly data, and weekly trends\cf4 \cb1 \strokec4 \
\cf2 \cb3 \strokec2 -- Dividing the data into 7 day windows to report our refund information by 'week' since we classify a week as 7 days\cf4 \cb1 \strokec4 \
\cf2 \cb3 \strokec2 -- Since there are 589 days, there should be about 84-85 months (589 / 7) in total\cf4 \cb1 \strokec4 \
\cf5 \cb3 \strokec5 WITH\cf4 \strokec4  ranked_sales_dates \cf5 \strokec5 AS\cf4 \strokec4  \cf7 \strokec7 (\cf4 \cb1 \strokec4 \
\cb3     \cf5 \strokec5 SELECT\cf4 \strokec4  \cb1 \
\cb3         \cf5 \strokec5 DENSE_RANK\cf7 \strokec7 ()\cf4 \strokec4  \cf5 \strokec5 OVER\cf7 \strokec7 (\cf5 \strokec5 ORDER\cf4 \strokec4  \cf5 \strokec5 BY\cf4 \strokec4  \cf5 \strokec5 CAST\cf7 \strokec7 (\cf4 \strokec4 sale_at \cf5 \strokec5 as\cf4 \strokec4  \cf5 \strokec5 DATE\cf7 \strokec7 ))\cf4 \strokec4  \cf5 \strokec5 as\cf4 \strokec4  date_rank,\cb1 \
\cb3         \cf5 \strokec5 CAST\cf7 \strokec7 (\cf4 \strokec4 sale_at \cf5 \strokec5 as\cf4 \strokec4  \cf5 \strokec5 DATE\cf7 \strokec7 )\cf4 \strokec4  \cf5 \strokec5 as\cf4 \strokec4  sale_at,\cb1 \
\cb3         customer_id,\cb1 \
\cb3         sale_value,\cb1 \
\cb3         refund_amount\cb1 \
\cb3     \cf5 \strokec5 FROM\cf4 \strokec4  \cf6 \strokec6 `tfdalexanderraouf.assessment_02.all_sales_and_refunds`\cf4 \cb1 \strokec4 \
\cb3     \cf5 \strokec5 ORDER\cf4 \strokec4  \cf5 \strokec5 BY\cf4 \strokec4  \cf9 \strokec9 2\cf4 \cb1 \strokec4 \
\cf7 \cb3 \strokec7 )\cf4 \cb1 \strokec4 \
\
\cf5 \cb3 \strokec5 SELECT\cf4 \strokec4  \cb1 \
\cb3     \cf5 \strokec5 CAST\cf7 \strokec7 (\cf5 \strokec5 FLOOR\cf7 \strokec7 ((\cf4 \strokec4 date_rank\cf7 \strokec7 -\cf9 \strokec9 1\cf7 \strokec7 )\cf4 \strokec4  \cf7 \strokec7 /\cf4 \strokec4  \cf9 \strokec9 7\cf7 \strokec7 )\cf4 \strokec4  \cf5 \strokec5 AS\cf4 \strokec4  INT\cf7 \strokec7 )\cf4 \strokec4  \cf5 \strokec5 as\cf4 \strokec4  weekly_period,\cb1 \
\cb3     \cf5 \strokec5 MIN\cf7 \strokec7 (\cf4 \strokec4 sale_at\cf7 \strokec7 )\cf4 \strokec4  \cf5 \strokec5 as\cf4 \strokec4  week_start_date,\cb1 \
\cb3     \cf5 \strokec5 MAX\cf7 \strokec7 (\cf4 \strokec4 sale_at\cf7 \strokec7 )\cf4 \strokec4  \cf5 \strokec5 as\cf4 \strokec4  week_end_date,\cb1 \
\cb3     \cf5 \strokec5 SUM\cf7 \strokec7 (\cf4 \strokec4 sale_value\cf7 \strokec7 )\cf4 \strokec4  \cf5 \strokec5 as\cf4 \strokec4  total_weekly_sale,\cb1 \
\cb3     \cf5 \strokec5 SUM\cf7 \strokec7 (\cf4 \strokec4 refund_amount\cf7 \strokec7 )\cf4 \strokec4  \cf5 \strokec5 as\cf4 \strokec4  total_refund_amount,\cb1 \
\cb3     \cf5 \strokec5 ROUND\cf7 \strokec7 (\cf5 \strokec5 SUM\cf7 \strokec7 (\cf4 \strokec4 refund_amount\cf7 \strokec7 )\cf4 \strokec4  \cf7 \strokec7 /\cf4 \strokec4  \cf5 \strokec5 SUM\cf7 \strokec7 (\cf4 \strokec4 sale_value\cf7 \strokec7 )\cf4 \strokec4 , \cf9 \strokec9 2\cf7 \strokec7 )\cf4 \strokec4  \cf5 \strokec5 as\cf4 \strokec4  refund_ratio\cb1 \
\cf5 \cb3 \strokec5 FROM\cf4 \strokec4  ranked_sales_dates\cb1 \
\cf5 \cb3 \strokec5 GROUP\cf4 \strokec4  \cf5 \strokec5 BY\cf4 \strokec4  \cf9 \strokec9 1\cf4 \cb1 \strokec4 \
\cf5 \cb3 \strokec5 ORDER\cf4 \strokec4  \cf5 \strokec5 BY\cf4 \strokec4  \cf9 \strokec9 1\cf4 \strokec4 ;\cb1 \
\pard\pardeftab720\sl360\partightenfactor0
\cf4 \
\
\pard\pardeftab720\sl360\partightenfactor0
\cf2 \cb3 \strokec2 -- Looking at the average days a customer takes to make a refund\cf4 \cb1 \strokec4 \
\cf5 \cb3 \strokec5 SELECT\cf4 \strokec4  \cb1 \
\cb3     \cf5 \strokec5 AVG\cf7 \strokec7 (\cf5 \strokec5 DATE_DIFF\cf7 \strokec7 (\cf5 \strokec5 CAST\cf7 \strokec7 (\cf4 \strokec4 refund_at \cf5 \strokec5 as\cf4 \strokec4  \cf5 \strokec5 DATE\cf7 \strokec7 )\cf4 \strokec4 , \cf5 \strokec5 CAST\cf7 \strokec7 (\cf4 \strokec4 sale_at \cf5 \strokec5 as\cf4 \strokec4  \cf5 \strokec5 DATE\cf7 \strokec7 )\cf4 \strokec4 , DAY\cf7 \strokec7 ))\cf4 \strokec4  \cf5 \strokec5 as\cf4 \strokec4  avg_days_until_refund,\cb1 \
\cb3     STDDEV\cf7 \strokec7 (\cf5 \strokec5 DATE_DIFF\cf7 \strokec7 (\cf5 \strokec5 CAST\cf7 \strokec7 (\cf4 \strokec4 refund_at \cf5 \strokec5 as\cf4 \strokec4  \cf5 \strokec5 DATE\cf7 \strokec7 )\cf4 \strokec4 , \cf5 \strokec5 CAST\cf7 \strokec7 (\cf4 \strokec4 sale_at \cf5 \strokec5 as\cf4 \strokec4  \cf5 \strokec5 DATE\cf7 \strokec7 )\cf4 \strokec4 , DAY\cf7 \strokec7 ))\cf4 \strokec4  \cf5 \strokec5 as\cf4 \strokec4  std_days_until_refund\cb1 \
\cf5 \cb3 \strokec5 FROM\cf4 \strokec4  \cf6 \strokec6 `tfdalexanderraouf.assessment_02.all_sales_and_refunds`\cf4 \cb1 \strokec4 \
\cf5 \cb3 \strokec5 WHERE\cf4 \strokec4  refund_at \cf5 \strokec5 IS\cf4 \strokec4  \cf5 \strokec5 NOT\cf4 \strokec4  \cf5 \strokec5 NULL\cf4 \strokec4 ;\cb1 \
\
\cf2 \cb3 \strokec2 -- Looking at the average weeks a customer takes to make a refund\cf4 \cb1 \strokec4 \
\cf5 \cb3 \strokec5 SELECT\cf4 \strokec4  \cb1 \
\cb3     \cf5 \strokec5 ROUND\cf7 \strokec7 (\cf5 \strokec5 AVG\cf7 \strokec7 (\cf5 \strokec5 DATE_DIFF\cf7 \strokec7 (\cf5 \strokec5 CAST\cf7 \strokec7 (\cf4 \strokec4 refund_at \cf5 \strokec5 as\cf4 \strokec4  \cf5 \strokec5 DATE\cf7 \strokec7 )\cf4 \strokec4 , \cf5 \strokec5 CAST\cf7 \strokec7 (\cf4 \strokec4 sale_at \cf5 \strokec5 as\cf4 \strokec4  \cf5 \strokec5 DATE\cf7 \strokec7 )\cf4 \strokec4 , DAY\cf7 \strokec7 )\cf4 \strokec4  \cf7 \strokec7 /\cf4 \strokec4  \cf9 \strokec9 7\cf7 \strokec7 ))\cf4 \strokec4  \cf5 \strokec5 as\cf4 \strokec4  avg_weeks_until_refund,\cb1 \
\cb3     \cf5 \strokec5 ROUND\cf7 \strokec7 (\cf4 \strokec4 STDDEV\cf7 \strokec7 (\cf5 \strokec5 DATE_DIFF\cf7 \strokec7 (\cf5 \strokec5 CAST\cf7 \strokec7 (\cf4 \strokec4 refund_at \cf5 \strokec5 as\cf4 \strokec4  \cf5 \strokec5 DATE\cf7 \strokec7 )\cf4 \strokec4 , \cf5 \strokec5 CAST\cf7 \strokec7 (\cf4 \strokec4 sale_at \cf5 \strokec5 as\cf4 \strokec4  \cf5 \strokec5 DATE\cf7 \strokec7 )\cf4 \strokec4 , DAY\cf7 \strokec7 )\cf4 \strokec4  \cf7 \strokec7 /\cf4 \strokec4  \cf9 \strokec9 7\cf7 \strokec7 ))\cf4 \strokec4  \cf5 \strokec5 as\cf4 \strokec4  std_weeks_until_refund\cb1 \
\cf5 \cb3 \strokec5 FROM\cf4 \strokec4  \cf6 \strokec6 `tfdalexanderraouf.assessment_02.all_sales_and_refunds`\cf4 \cb1 \strokec4 \
\cf5 \cb3 \strokec5 WHERE\cf4 \strokec4  refund_at \cf5 \strokec5 IS\cf4 \strokec4  \cf5 \strokec5 NOT\cf4 \strokec4  \cf5 \strokec5 NULL\cf4 \strokec4 ;\cb1 \
\
\cf2 \cb3 \strokec2 -- Looking at the average months a customer takes to make a refund\cf4 \cb1 \strokec4 \
\cf5 \cb3 \strokec5 SELECT\cf4 \strokec4  \cb1 \
\cb3     \cf5 \strokec5 ROUND\cf7 \strokec7 (\cf5 \strokec5 AVG\cf7 \strokec7 (\cf5 \strokec5 DATE_DIFF\cf7 \strokec7 (\cf5 \strokec5 CAST\cf7 \strokec7 (\cf4 \strokec4 refund_at \cf5 \strokec5 as\cf4 \strokec4  \cf5 \strokec5 DATE\cf7 \strokec7 )\cf4 \strokec4 , \cf5 \strokec5 CAST\cf7 \strokec7 (\cf4 \strokec4 sale_at \cf5 \strokec5 as\cf4 \strokec4  \cf5 \strokec5 DATE\cf7 \strokec7 )\cf4 \strokec4 , DAY\cf7 \strokec7 )\cf4 \strokec4  \cf7 \strokec7 /\cf4 \strokec4  \cf9 \strokec9 28\cf7 \strokec7 ))\cf4 \strokec4  \cf5 \strokec5 as\cf4 \strokec4  avg_months_until_refund,\cb1 \
\cb3     \cf5 \strokec5 ROUND\cf7 \strokec7 (\cf4 \strokec4 STDDEV\cf7 \strokec7 (\cf5 \strokec5 DATE_DIFF\cf7 \strokec7 (\cf5 \strokec5 CAST\cf7 \strokec7 (\cf4 \strokec4 refund_at \cf5 \strokec5 as\cf4 \strokec4  \cf5 \strokec5 DATE\cf7 \strokec7 )\cf4 \strokec4 , \cf5 \strokec5 CAST\cf7 \strokec7 (\cf4 \strokec4 sale_at \cf5 \strokec5 as\cf4 \strokec4  \cf5 \strokec5 DATE\cf7 \strokec7 )\cf4 \strokec4 , DAY\cf7 \strokec7 )\cf4 \strokec4  \cf7 \strokec7 /\cf4 \strokec4  \cf9 \strokec9 28\cf7 \strokec7 ))\cf4 \strokec4  \cf5 \strokec5 as\cf4 \strokec4  std_months_until_refund\cb1 \
\cf5 \cb3 \strokec5 FROM\cf4 \strokec4  \cf6 \strokec6 `tfdalexanderraouf.assessment_02.all_sales_and_refunds`\cf4 \cb1 \strokec4 \
\cf5 \cb3 \strokec5 WHERE\cf4 \strokec4  refund_at \cf5 \strokec5 IS\cf4 \strokec4  \cf5 \strokec5 NOT\cf4 \strokec4  \cf5 \strokec5 NULL\cf4 \strokec4 ;\cb1 \
\pard\pardeftab720\sl360\partightenfactor0
\cf4 \
\
\pard\pardeftab720\sl360\partightenfactor0
\cf2 \cb3 \strokec2 -- BONUS QUESTION\cf4 \cb1 \strokec4 \
\cf5 \cb3 \strokec5 SELECT\cf4 \strokec4  \cf7 \strokec7 *\cf4 \strokec4  \cf5 \strokec5 FROM\cf4 \strokec4  \cf6 \strokec6 `tfdalexanderraouf.assessment_02.all_sales_and_refunds`\cf4 \cb1 \strokec4 \
\cf5 \cb3 \strokec5 WHERE\cf4 \strokec4  \cf5 \strokec5 CAST\cf7 \strokec7 (\cf4 \strokec4 sale_at \cf5 \strokec5 as\cf4 \strokec4  \cf5 \strokec5 DATE\cf7 \strokec7 )\cf4 \strokec4  = \cf6 \strokec6 '2020-01-01'\cf4 \cb1 \strokec4 \
\cf5 \cb3 \strokec5 ORDER\cf4 \strokec4  \cf5 \strokec5 BY\cf4 \strokec4  sale_at\cb1 \
\cf5 \cb3 \strokec5 LIMIT\cf4 \strokec4  \cf9 \strokec9 1\cf4 \strokec4 ;\cb1 \
\pard\pardeftab720\sl360\partightenfactor0
\cf4 \
}