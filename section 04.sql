----Task 20:  Count how many products exist in each category. Show category name and product count.
SELECT
    c.category_name,
    COUNT(*) AS product_count
FROM production.products AS p
INNER JOIN production.categories AS c
    ON c.category_id = p.category_id
GROUP BY c.category_name;


---Task 21:  Find the average list price of products per brand.
SELECT
  b.brand_name,
  AVG(p.list_price) AS average_list_price
  FROM production.products AS p
  INNER JOIN production.brands AS b
  ON b.brand_id = p.brand_id
GROUP BY b.brand_name;

---Task 22:  For each store, count the total number of orders.
SELECT
st.store_name,
COUNT(*) AS order_count
FROM sales.stores AS st
INNER JOIN sales.orders AS s
ON st.store_id = s.store_id
GROUP BY st.store_name;


---Task 23:  Find the total revenue per order. Revenue = quantity × list_price × (1 - discount).

SELECT
    oi.order_id,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS Revenue
FROM sales.orders AS o
INNER JOIN sales.order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY oi.order_id;





---Task 24:  Find each customer's total number of orders. Sort by order count descending.
SELECT
s.customer_id,
COUNT(*) AS order_count
FROM sales.customers AS s
INNER JOIN sales.orders AS o
ON o.customer_id = s.customer_id
GROUP BY s.customer_id
ORDER BY order_count DESC;



---Task 25:  Find the brand that has the highest average product price.
SELECT TOP 1
b.brand_name,
  AVG(p.list_price) AS average_list_price
FROM production.products AS p
INNER JOIN production.brands AS b
ON b.brand_id = p.brand_id
GROUP BY b.brand_name
ORDER BY average_list_price DESC;


---Task 26:  List categories that have more than 50 products.
---Hint: Use the HAVING clause to filter grouped results
SELECT
category_name
FROM production.categories AS c
INNER JOIN production.products AS P
ON c.category_id = p.category_id
GROUP BY c.category_name
HAVING COUNT(p.product_id)>50;






----Task 27:  For each store, find the total revenue generated across all orders
SELECT
st.store_name,
   SUM(oi.quantity * oi.list_price * (1-oi.discount)) AS total_revenue
FROM sales.stores AS st
   INNER JOIN sales.orders AS o
   ON st.store_id = o.store_id
   INNER JOIN sales.order_items AS oi
   ON o.order_id=oi.order_id
   GROUP BY st.store_name;


----Task 28:  Find how many orders each staff member handled,
----and show only those who handled more than 50 orders.
SELECT
staff_id,
   COUNT(*)AS order_count
FROM sales.orders AS o
GROUP BY staff_id
HAVING COUNT(order_id)>50;



