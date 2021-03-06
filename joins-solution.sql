-- Tasks
------------------------

-- 1. Get all customers and their addresses.
SELECT * FROM 
customers JOIN addresses ON customers.id = addresses.customer_id;

-- 2. Get all orders and their line items (orders, quantity and product).
SELECT * FROM
orders JOIN line_items ON orders.id = line_items.order_id;

-- 3. Which warehouses have cheetos?
SELECT warehouse.warehouse FROM warehouse
JOIN warehouse_product ON warehouse.id = warehouse_product.warehouse_id
JOIN products on warehouse_product.product_id = products.id
WHERE products.description = 'cheetos';

-- ANSWER: delta

-- 4. Which warehouses have diet pepsi?
SELECT warehouse.warehouse FROM warehouse
JOIN warehouse_product ON warehouse.id = warehouse_product.warehouse_id
JOIN products on warehouse_product.product_id = products.id
WHERE products.description = 'diet pepsi';

-- ANSWER: alpha, delta, gamma

-- 5. Get the number of orders for each customer. NOTE: It is OK if those without orders are not included in results.
SELECT customers.id, customers.first_name, customers.last_name FROM customers
JOIN addresses ON customers.id = addresses.customer_id
JOIN orders ON addresses.id = orders.address_id
ORDER BY customers.id

-- 6. How many customers do we have?
SELECT COUNT(id) FROM customers;

-- 7. How many products do we carry?
SELECT COUNT(id) FROM products;

-- 8. What is the total available on-hand quantity of diet pepsi?
SELECT SUM(on_hand) FROM warehouse_product
JOIN products ON warehouse_product.product_id = products.id
WHERE products.description = 'diet pepsi';

-- ANSWER: 92

-- Stretch
------------------------
-- 9. How much was the total cost for each order?
SELECT orders.id, SUM(products.unit_price * line_items.quantity) FROM orders
JOIN line_items ON orders.id = line_items.order_id
JOIN products ON line_items.product_id = products.id
GROUP BY orders.id ORDER BY orders.id;

-- ANSWER (order.id, total cost in $):
-- 1, 70
-- 2, 18.99
-- 3, 7.2
-- 4, 138.43
-- 5, 96.71
-- 6, 85.86
-- 7, 64.91

-- 10. How much has each customer spent in total?
SELECT customers.id, customers.first_name, customers.last_name, SUM(products.unit_price * line_items.quantity) FROM orders
JOIN line_items ON orders.id = line_items.order_id
JOIN products ON line_items.product_id = products.id
JOIN addresses ON orders.address_id = addresses.id
JOIN customers ON addresses.customer_id = customers.id
GROUP BY customers.id ORDER BY customers.id;

-- ANSWER (customers.id, customers.first_name, customers.last_name, total in $):
-- 1, Lisa, Bonet, 161.1
-- 2, Charles, Darwin, 138.43
-- 4, Lucy, Liu, 182.57

-- 11. How much has each customer spent in total? Customers who have spent $0 should still show up in the table. It should say 0, not NULL (research coalesce).
SELECT customers.id, customers.first_name, customers.last_name, SUM(COALESCE((products.unit_price * line_items.quantity), 0)) FROM orders
JOIN line_items ON orders.id = line_items.order_id
JOIN products ON line_items.product_id = products.id
JOIN addresses ON orders.address_id = addresses.id
FULL OUTER JOIN customers ON addresses.customer_id = customers.id
GROUP BY customers.id ORDER BY customers.id;

-- ANSWER (customers.id, customers.first_name, customers.last_name, total in $):
-- 1, Lisa, Bonet, 161.1
-- 2, Charles, Darwin, 138.43
-- 3, George, Foreman, 0
-- 4, Lucy, Liu, 182.57