---Task 29: Find all products whose list price is above the overall average list price.
SELECT
    p.product_name,
    p.list_price
FROM production.products AS p
WHERE p.list_price > (
    SELECT AVG(list_price)
    FROM production.products
);


---Task 30: Find customers who have never placed an order.
SELECT
    c.first_name,
    c.last_name
FROM sales.customers AS c
WHERE c.customer_id NOT IN (
    SELECT o.customer_id
    FROM sales.orders AS o
);


---Task 31: List the most expensive product in each category.
SELECT
    p.product_name,
    p.list_price,
    c.category_name
FROM production.products AS p
INNER JOIN production.categories AS c
    ON p.category_id = c.category_id
WHERE p.list_price = (
    SELECT MAX(p2.list_price)
    FROM production.products AS p2
    WHERE p2.category_id = p.category_id
);


---Task 32: Find staff members who work in the store that generated the most revenue.
SELECT
    s.first_name,
    s.last_name,
    s.store_id
FROM sales.staffs AS s
WHERE s.store_id = (
    SELECT TOP 1
        o.store_id
    FROM sales.orders AS o
    INNER JOIN sales.order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY o.store_id
    ORDER BY SUM(
        oi.quantity * oi.list_price * (1 - oi.discount)
    ) DESC
);


---Task 33: Find orders where the total order value exceeds 5000.
SELECT
    oi.order_id,
    SUM(
        oi.quantity * oi.list_price * (1 - oi.discount)
    ) AS total_order_value
FROM sales.order_items AS oi
GROUP BY oi.order_id
HAVING SUM(
    oi.quantity * oi.list_price * (1 - oi.discount)
) > 5000;


---Task 34: List products that have never been ordered by any customer.
SELECT
    p.product_name
FROM production.products AS p
WHERE p.product_id NOT IN (
    SELECT oi.product_id
    FROM sales.order_items AS oi
);


---Task 35: Find the customer who has spent the most money overall.
SELECT TOP 1
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(
        oi.quantity * oi.list_price * (1 - oi.discount)
    ) AS total_spent
FROM sales.customers AS c
INNER JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
INNER JOIN sales.order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_spent DESC;