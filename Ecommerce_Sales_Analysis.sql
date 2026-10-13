USE ecommerce_project;

DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id VARCHAR(10) PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    age INT,
    gender VARCHAR(20)
);
USE ecommerce_project;

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    cost DECIMAL(10,2)
);
USE ecommerce_project;

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id VARCHAR(10),
    order_date DATE,
    order_status VARCHAR(30)
);

USE ecommerce_project;

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT
);

USE ecommerce_project;

CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    payment_date DATE,
    payment_method VARCHAR(30),
    payment_status VARCHAR(30),
    amount DECIMAL(10,2)
);
USE ecommerce_project;

SELECT COUNT(*) AS customers_count FROM customers;

SELECT COUNT(*) AS products_count FROM products;

SELECT COUNT(*) AS orders_count FROM orders;

SELECT COUNT(*) AS order_items_count FROM order_items;

SELECT COUNT(*) AS payments_count FROM payments;

USE ecommerce_project;

SELECT
    o.order_id,
    c.customer_id,
    c.customer_name,
    c.city,
    o.order_date,
    o.order_status
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
LIMIT 20;
SELECT customer_id, customer_name
FROM customers
LIMIT 5;
SELECT order_id, customer_id
FROM orders
LIMIT 5;

SELECT DISTINCT customer_id
FROM orders
LIMIT 10;
SELECT customer_id, customer_name
FROM customers
WHERE customer_id IN ('C001', 'C038', 'C075');

SELECT
    o.order_id,
    c.customer_id,
    c.customer_name,
    c.city,
    o.order_date,
    o.order_status
FROM orders o
JOIN customers c
    ON CONCAT('C', LPAD(o.customer_id, 3, '0')) = c.customer_id
LIMIT 20;

SELECT COUNT(*) AS delivered_orders
FROM orders
WHERE order_status = 'Delivered';

SELECT
    SUM(oi.quantity * p.price) AS total_revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered';

SELECT
    p.category,
    SUM(oi.quantity * p.price) AS total_revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY p.category
ORDER BY total_revenue DESC;

SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 5;

SELECT
    payment_method,
    SUM(amount) AS total_revenue
FROM payments
WHERE payment_status = 'paid'
GROUP BY payment_method
ORDER BY total_revenue DESC;

SELECT
    c.customer_id,
    c.customer_name,
    SUM(oi.quantity * p.price) AS total_spending
FROM customers c
JOIN orders o
    ON c.customer_id = CONCAT('C', LPAD(o.customer_id, 3, '0'))
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
WHERE o.order_status = 'Delivered'
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spending DESC
LIMIT 10;

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

SELECT
    c.state,
    SUM(oi.quantity * p.price) AS total_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = CONCAT('C', LPAD(o.customer_id, 3, '0'))
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
WHERE o.order_status = 'Delivered'
GROUP BY c.state
ORDER BY total_revenue DESC;

SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.quantity * p.price) AS total_revenue,
    SUM(oi.quantity * p.cost) AS total_cost,
    SUM(oi.quantity * (p.price - p.cost)) AS total_profit
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY
    p.product_id,
    p.product_name
ORDER BY total_profit DESC
LIMIT 10;

SELECT
    (SELECT COUNT(*) FROM customers) AS total_customers,
    (SELECT COUNT(*) FROM orders) AS total_orders,
    (SELECT COUNT(*)
     FROM orders
     WHERE order_status = 'Delivered') AS delivered_orders,
    (SELECT SUM(oi.quantity * p.price)
     FROM order_items oi
     JOIN products p ON oi.product_id = p.product_id
     JOIN orders o ON oi.order_id = o.order_id
     WHERE o.order_status = 'Delivered') AS total_revenue,
    (SELECT SUM(oi.quantity * (p.price - p.cost))
     FROM order_items oi
     JOIN products p ON oi.product_id = p.product_id
     JOIN orders o ON oi.order_id = o.order_id
     WHERE o.order_status = 'Delivered') AS total_profit;
     
     USE ecommerce_project;

-- 1. Total Customers
SELECT COUNT(*) AS total_customers
FROM customers;

-- 2. Total Orders
SELECT COUNT(*) AS total_orders
FROM orders;

-- 3. Delivered Orders
SELECT COUNT(*) AS delivered_orders
FROM orders
WHERE order_status = 'Delivered';

-- 4. Category-wise Revenue
SELECT p.category,
       SUM(oi.quantity * p.price) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY p.category
ORDER BY total_revenue DESC;

-- 5. Product-wise Profit
SELECT p.product_name,
       SUM(oi.quantity * (p.price - p.cost)) AS total_profit
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY p.product_id, p.product_name
ORDER BY total_profit DESC;