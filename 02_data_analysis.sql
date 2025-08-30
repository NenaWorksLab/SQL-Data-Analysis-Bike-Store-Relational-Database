-- Sales Performance Analysis:
-- 1. Which store has the highest total sales revenue? 
SELECT
    s.store_name,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_income
FROM sales.stores AS s
JOIN sales.orders AS o
    ON s.store_id = o.store_id
JOIN sales.order_items AS oi 
    ON o.order_id = oi.order_id
GROUP BY
    s.store_name
ORDER BY
    total_income DESC;
-- 2. are the monthly sales trends?
SELECT
    YEAR(o.order_date) AS Year,
    MONTH(o.order_date) AS Month,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS monthly_sales_total
FROM sales.orders AS o
JOIN sales.order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY
    YEAR(o.order_date),
    MONTH(o.order_date)
ORDER BY
    YEAR(o.order_date),
    MONTH(o.order_date)
    desc;
-- 3. Which staff member is the top performer?
SELECT
    st.first_name,
    st.last_name,
    COUNT(o.order_id) AS total_orders_processed,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_income
FROM sales.staffs AS st
JOIN sales.orders AS o
	ON st.staff_id = o.staff_id
JOIN sales.order_items AS oi
	ON o.order_id = oi.order_id
GROUP BY 
	st.staff_id,
    st.first_name,
    st.last_name
ORDER BY total_orders_processed DESC;

-- Product & Inventory Analysis:
-- 1. Which products are the most popular, and from which categories and brands?
SELECT 
	p.product_name,
    c.category_name,
    b.brand_name,
    SUM(oi.quantity) AS total_sales
FROM production.products AS p
JOIN production.categories AS c
	ON p.category_id = c.category_id
JOIN production.brands as b 
	ON p.brand_id = b.brand_id
JOIN sales.order_items AS oi
	ON p.product_id = oi.product_id
GROUP BY 
	p.product_name,
    c.category_name,
    b.brand_name
ORDER BY
	total_sales DESC
LIMIT 10;

-- 2. Are there any products with low stock (< 5 unit)?
SELECT 
	p.product_name,
    s.store_name,
	st.quantity AS stok
FROM production.stocks AS st
JOIN production.products AS p 
	ON st.product_id = p.product_id
JOIN sales.stores AS s
	ON s.store_id = st.store_id
WHERE 
	st.quantity < 5
ORDER BY 
	st.quantity ASC;
    
SELECT
    COUNT(*) AS total_p
FROM production.stocks AS st
JOIN production.products AS p
    ON st.product_id = p.product_id
WHERE
    st.quantity < 5;
    
--  Customer Analysis:
-- 1. Who are the top 5 most valuable customers based on spending?
SELECT 
	c.first_name,
    c.last_name,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_sales
FROM sales.customers AS c 
JOIN sales.orders AS o 
	ON c.customer_id = o.customer_id
JOIN sales.order_items AS oi 
	ON o.order_id = oi.order_id
GROUP BY 
	 c.customer_id,
    c.first_name,
    c.last_name
ORDER BY 
	total_sales DESC
LIMIT 5; 
   
-- 2. From which regions do most customers come?
SELECT
	state,
    city,
    COUNT(*) AS total_customer
FROM sales.customers
GROUP BY 
	state,
    city
ORDER BY total_customer DESC;
