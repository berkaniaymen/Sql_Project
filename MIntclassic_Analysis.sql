USE `mintclassics`;

-- Show all tables in the database
SHOW TABLES;

-- Describe the structure of a specific table (e.g., customers table)
DESCRIBE mintclassics.customers;

-- Query: Count products in each warehouse and the total inventory per warehouse
SELECT 
    warehouseCode, 
    COUNT(productCode) AS total_products, 
    SUM(quantityInStock) AS total_inventory
FROM 
    products
GROUP BY 
    warehouseCode
ORDER BY 
    total_inventory DESC;
    
-- Query: Compare inventory to sales figures for each product
SELECT 
    p.productCode, 
    p.productName, 
    p.quantityInStock AS inventory_quantity, 
    SUM(od.quantityOrdered) AS total_sales
FROM 
    products p
JOIN 
    orderdetails od ON p.productCode = od.productCode
JOIN 
    orders o ON od.orderNumber = o.orderNumber
WHERE 
    o.status = 'Shipped'  -- Only consider completed orders
GROUP BY 
    p.productCode
ORDER BY 
    inventory_quantity DESC;
    
-- Query: Identify items with no sales (no shipped orders)
SELECT 
    p.productCode, 
    p.productName, 
    p.quantityInStock AS inventory_quantity,
    IFNULL(SUM(od.quantityOrdered), 0) AS total_sales
FROM 
    products p
LEFT JOIN 
    orderdetails od ON p.productCode = od.productCode
LEFT JOIN 
    orders o ON od.orderNumber = o.orderNumber
WHERE 
    o.status = 'Shipped'  -- Only consider completed orders
GROUP BY 
    p.productCode
HAVING 
    total_sales = 0  -- Items with no sales
ORDER BY 
    inventory_quantity DESC;
    
-- Query: Overview of all products in inventory, showing product details and stock levels
SELECT 
    productCode, 
    productName, 
    quantityInStock, 
    warehouseCode, 
    productLine
FROM 
    products
ORDER BY 
    quantityInStock DESC;
    
SELECT 
    p.productCode, 
    p.productName, 
    p.quantityInStock, 
    IFNULL(SUM(od.quantityOrdered), 0) AS total_sales, 
    ROUND(IFNULL(SUM(od.quantityOrdered), 0) / p.quantityInStock, 2) AS turnover_rate
FROM 
    products p
LEFT JOIN 
    orderdetails od ON p.productCode = od.productCode
JOIN 
    orders o ON od.orderNumber = o.orderNumber
WHERE 
    o.status = 'Shipped'
GROUP BY 
    p.productCode
ORDER BY 
    turnover_rate ASC;



-- Based on the results of these queries:

-- 1 Underutilized warehouses: Consolidate inventory from low-utilization warehouses to eliminate them.
-- 2 Excess stock: Consider reducing overstocked products by lowering the quantity in stock or offering promotions to boost sales.
-- 3 Non-moving items: Identify products with no sales or minimal turnover, and consider removing them from the product line to reduce storage costs.
