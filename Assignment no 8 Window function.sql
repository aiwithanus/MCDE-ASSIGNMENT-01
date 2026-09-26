--------------------------------------------------------------------------------------------------------------------------
         --->   Assignment no 8 :WINDOW FUNCTION ASSIGNMENT


--7.1 - Assign a sequential row number to each product ordered by list_price descending.
--Then assign a second row number partitioned by category_id, resetting within each category.
SELECT
product_name,
list_price,
category_id,
ROW_NUMBER()OVER(PARTITION BY category_id ORDER BY list_price DESC) AS category_rn,
ROW_NUMBER()OVER(ORDER BY list_price DESC) AS overall_rn
FROM production.products;

--7.2 - Write a query that returns each product with its RANK() and DENSE_RANK()
-- list_price descending within its category. Show a product where the two rankings differ
SELECT
product_name,
list_price,
category_id,
RANK() OVER(PARTITION BY category_id ORDER BY list_price DESC ) AS rank_num,
DENSE_RANK() OVER(PARTITION BY category_id ORDER BY list_price DESC) AS dense_rank
FROM production.products;

--7.3 - Use LAG() to calculate the month-over-month revenue change for each store.
--Show the current month revenue, the previous month revenue, and the difference.
SELECT
    store_id,
    order_year,
    order_month,
    monthly_revenue,

    LAG(monthly_revenue) OVER (
        PARTITION BY store_id
        ORDER BY order_year, order_month
    ) AS previous_month_revenue,

    monthly_revenue -
    LAG(monthly_revenue) OVER (
        PARTITION BY store_id
        ORDER BY order_year, order_month
    ) AS revenue_difference

FROM (
    SELECT
        o.store_id,
        YEAR(o.order_date) AS order_year,
        MONTH(o.order_date) AS order_month,
        SUM(oi.quantity * oi.list_price) AS monthly_revenue
    FROM sales.orders AS o
    JOIN sales.order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        o.store_id,
        YEAR(o.order_date),
        MONTH(o.order_date)
) AS monthly_sales
ORDER BY
    store_id,
    order_year,
    order_month;

--7.4 - Use NTILE(5) to divide all products into five price bands. Return the product name, price, and band number.
SELECT
product_name,
list_price,
NTILE(5) OVER(ORDER BY list_price ) AS price_bands
FROM production.products;

--7.5 - Write a query that shows each order with a running total of revenue ordered by order_date.
--Use ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW.
SELECT
    o.order_id,
    o.order_date,
    SUM(oi.quantity * oi.list_price) AS order_revenue,

    SUM(SUM(oi.quantity * oi.list_price)) OVER (
        ORDER BY o.order_date, o.order_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_revenue

FROM sales.orders AS o
JOIN sales.order_items AS oi
    ON o.order_id = oi.order_id

GROUP BY
    o.order_id,
    o.order_date

ORDER BY
    o.order_date,
    o.order_id;


--7.6 - Think About It: Why does LAST_VALUE() require RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING to return
--the actual last value in the partition, while FIRST_VALUE() works correctly with the default frame? 
--What is the default window frame when ORDER BY is specified, and how does that explain the behavior?
SELECT 
    product_name,
    category_id,
    list_price,

    FIRST_VALUE(list_price) OVER (
        PARTITION BY category_id
        ORDER BY list_price
    ) AS first_price,

    LAST_VALUE(list_price) OVER (
        PARTITION BY category_id
        ORDER BY list_price
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND UNBOUNDED FOLLOWING
    ) AS last_price

FROM production.products;
















