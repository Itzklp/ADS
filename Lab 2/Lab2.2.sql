/* ============================================================
   DATABASE SETUP
   ============================================================ */

DROP DATABASE IF EXISTS food_production_db;
CREATE DATABASE food_production_db;
USE food_production_db;

/* ============================================================
   TABLE DEFINITIONS (DDL)
   ============================================================ */

-- Vendors
CREATE TABLE vendors (
    vendorid CHAR(5) PRIMARY KEY,
    companyname VARCHAR(50) NOT NULL,
    city VARCHAR(40)
);

-- Ingredients
CREATE TABLE ingredients (
    ingredientid CHAR(5) PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    unitprice DECIMAL(5,2) NOT NULL,
    vendorid CHAR(5),
    FOREIGN KEY (vendorid) REFERENCES vendors(vendorid)
);

-- Items (Meals)
CREATE TABLE items (
    itemid CHAR(5) PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    price DECIMAL(6,2) NOT NULL,
    prevprice DECIMAL(6,2)
);

-- Associative relation: items ↔ ingredients
CREATE TABLE madewith (
    itemid CHAR(5),
    ingredientid CHAR(5),
    quantity INT NOT NULL,
    PRIMARY KEY (itemid, ingredientid),
    FOREIGN KEY (itemid) REFERENCES items(itemid),
    FOREIGN KEY (ingredientid) REFERENCES ingredients(ingredientid)
);

-- Audit table for price changes
CREATE TABLE item_price_audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    itemid CHAR(5),
    old_price DECIMAL(6,2),
    new_price DECIMAL(6,2),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

/* ============================================================
   DATA POPULATION
   ============================================================ */

-- Vendors
INSERT INTO vendors VALUES
('V001', 'Veggies_R_Us', 'Ahmedabad'),
('V002', 'Dairy_N_Delight', 'Anand'),
('V003', 'GrainHouse', 'Pune'),
('V004', 'SpiceWorld', 'Jodhpur'),
('V005', 'OilMart', 'Mumbai');

-- Ingredients (unitprice <= 0.90 for trigger testing)
INSERT INTO ingredients VALUES
('I001', 'Tomato', 0.40, 'V001'),
('I002', 'Potato', 0.30, 'V001'),
('I003', 'Onion', 0.35, 'V001'),
('I004', 'Cheese', 0.85, 'V002'),
('I005', 'Milk', 0.60, 'V002'),
('I006', 'Wheat Flour', 0.45, 'V003'),
('I007', 'Rice', 0.50, 'V003'),
('I008', 'Chilli Powder', 0.25, 'V004'),
('I009', 'Turmeric', 0.20, 'V004'),
('I010', 'Cooking Oil', 0.70, 'V005');

-- Items (Meals) – prices intentionally varied
INSERT INTO items VALUES
('M001', 'Veg Sandwich', 40.00, NULL),
('M002', 'Cheese Pizza', 90.00, NULL),
('M003', 'Veg Biryani', 110.00, NULL),
('M004', 'Paneer Wrap', 75.00, NULL),
('M005', 'Rice Bowl', 55.00, NULL),
('M006', 'Masala Dosa', 65.00, NULL),
('M007', 'Butter Toast', 30.00, NULL);

-- MadeWith (ingredient composition)
INSERT INTO madewith VALUES
-- Veg Sandwich
('M001', 'I001', 2),
('M001', 'I002', 1),
('M001', 'I004', 1),

-- Cheese Pizza
('M002', 'I004', 3),
('M002', 'I006', 2),
('M002', 'I010', 1),

-- Veg Biryani
('M003', 'I007', 3),
('M003', 'I001', 2),
('M003', 'I003', 2),
('M003', 'I008', 1),

-- Paneer Wrap
('M004', 'I004', 2),
('M004', 'I006', 1),
('M004', 'I009', 1),

-- Rice Bowl
('M005', 'I007', 2),
('M005', 'I001', 1),

-- Masala Dosa
('M006', 'I006', 2),
('M006', 'I002', 1),
('M006', 'I010', 1),

-- Butter Toast
('M007', 'I006', 1),
('M007', 'I005', 1);

/* ============================================================
   DATASET VALIDATION QUERIES (OPTIONAL)
   ============================================================ */

-- Average meal price (for trigger testing)
SELECT AVG(price) AS avg_meal_price FROM items;

-- Ingredient cost per meal (for UDFs & triggers)
SELECT m.itemid, i.name, SUM(m.quantity * ing.unitprice) AS ingredient_cost
FROM madewith m
JOIN ingredients ing ON m.ingredientid = ing.ingredientid
JOIN items i ON m.itemid = i.itemid
GROUP BY m.itemid, i.name;