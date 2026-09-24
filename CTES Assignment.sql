
--6.1 — Rewrite this derived table query as a CTE:
WITH cte_store AS(
SELECT AVG(order_count) AS avg_orders
FROM (
    SELECT store_id, COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY store_id
) AS store_counts)
SELECT * FROM cte_store ;

--6.2 — Write a CTE called cte_high_value_products that returns products with list_price > 2000.
--Then query the CTE to return only Mountain Bikes from that list, joining to production.categories.
WITH cte_high_value_products AS (
SELECT
p.product_name,
p.list_price,
p.category_id
FROM production.products AS p
WHERE list_price> 2000
)
SELECT
h.product_name,
h.list_price,
c.category_name
FROM cte_high_value_products AS h 
INNER JOIN production.categories AS c
ON h.category_id = c.category_id
WHERE c.category_name = 'Mountain Bikes' ;

--6.3 — Write two CTEs in one WITH clause: one that counts orders per customer,
--and one that sums revenue per customer.Join them in the outer query to return 
---customer_id, order_count, and total_revenue side by side.
WITH order_counts AS (
    SELECT
        customer_id,
        COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY customer_id
),

revenue AS (
    SELECT
        o.customer_id,
        SUM(oi.quantity * oi.list_price) AS total_revenue
    FROM sales.orders AS o
    INNER JOIN sales.order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)

SELECT
    oc.customer_id,
    oc.order_count,
    r.total_revenue
FROM order_counts AS oc
INNER JOIN revenue AS r
    ON oc.customer_id = r.customer_id;

--6.4 — Using a recursive CTE,generate a list of numbers from 1 to 10.
--Each row should have the number and its square (n * n).
WITH numbers AS (
    -- Anchor: starting point
    SELECT
        1 AS n,
        1 * 1 AS square

    UNION ALL

    -- Recursive part
    SELECT
        n + 1,
        (n + 1) * (n + 1)
    FROM numbers
    WHERE n < 10
)
SELECT *
FROM numbers
OPTION (MAXRECURSION 10);

------6.5 — Using the recursive CTE org chart from section 9.6.2 as a starting point,
----modify it to also show the manager's first_name alongside each employee.
------- a level column (0 for the top manager, 1 for their direct reports, 2 for the next level down).
WITH org_chart AS (
    -- Top manager
    SELECT
        s.staff_id,
        s.first_name AS employee_name,
        s.manager_id,
        CAST(NULL AS VARCHAR(50)) AS manager_name,
        0 AS level
    FROM sales.staffs AS s
    WHERE s.manager_id IS NULL

    UNION ALL

    -- Employees under each manager
    SELECT
        e.staff_id,
        e.first_name AS employee_name,
        e.manager_id,
        m.first_name AS manager_name,
        o.level + 1
    FROM sales.staffs AS e
    INNER JOIN org_chart AS o
        ON e.manager_id = o.staff_id
    INNER JOIN sales.staffs AS m
        ON e.manager_id = m.staff_id
)
SELECT
    staff_id,
    employee_name,
    manager_name,
    level
FROM org_chart
ORDER BY level, staff_id
OPTION (MAXRECURSION 100);

--6.6 — Think About It: A CTE is defined once but referenced twice in the same outer query.
--A colleague says "CTEs are faster than subqueries because the database computes the result once and reuses it."
--Is this claim accurate? What would you need to do if you genuinely needed the result computed only once and reused?
WITH x AS (
    SELECT *
    FROM sales.orders
)
SELECT *
FROM x
WHERE order_id < 100

UNION ALL

SELECT *
FROM x
WHERE order_id > 1000;


