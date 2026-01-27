-- ============================================
-- Lab 2.1 : Sailors, Boats and Reservations
-- Database : MySQL 8.0+
-- ============================================

DROP TABLE IF EXISTS reserves;
DROP TABLE IF EXISTS boats;
DROP TABLE IF EXISTS sailors;

-- ======================
-- SAILORS TABLE
-- ======================
CREATE TABLE sailors (
    sid INT PRIMARY KEY,
    s_name VARCHAR(50),
    rating INT,
    age INT
);

-- ======================
-- BOATS TABLE
-- ======================
CREATE TABLE boats (
    bid INT PRIMARY KEY,
    boat_name VARCHAR(50),
    colour VARCHAR(20)
);

-- ======================
-- RESERVES TABLE
-- ======================
CREATE TABLE reserves (
    sid INT,
    bid INT,
    day DATE,
    PRIMARY KEY (sid, bid, day),
    FOREIGN KEY (sid) REFERENCES sailors(sid),
    FOREIGN KEY (bid) REFERENCES boats(bid)
);

-- ======================
-- INSERT DATA INTO SAILORS
-- ======================
INSERT INTO sailors VALUES
(101, 'Arjun', 7, 28),
(102, 'Ravi', 8, 35),
(103, 'Karan', 6, 32),
(104, 'Vikram', 9, 41),
(105, 'Neeraj', 5, 26),
(106, 'Amit', 7, 30),
(107, 'Suresh', 8, 38),
(108, 'Mahesh', 6, 29),
(109, 'Rahul', 9, 45),
(110, 'Sunil', 4, 24),
(121, 'Deepak', 8, 34),
(911, 'Prakash', 7, 40),
(912, 'Ramesh', 6, 27),
(913, 'Anil', 5, 31),
(914, 'Manoj', 9, 36);

-- ======================
-- INSERT DATA INTO BOATS
-- ======================
INSERT INTO boats VALUES
(201, 'Sea Hawk', 'red'),
(202, 'Ocean Queen', 'blue'),
(203, 'Wave Rider', 'green'),
(204, 'Storm Breaker', 'red'),
(205, 'Blue Pearl', 'blue'),
(206, 'Coral King', 'yellow');

-- ======================
-- INSERT DATA INTO RESERVES
-- ======================
-- Past reservations
INSERT INTO reserves VALUES
(101, 201, '2017-11-25'),   -- For SID 121 query reference
(121, 202, '2017-11-25'),
(102, 203, '2018-01-23'),
(103, 201, '2018-01-23'),
(104, 204, '2018-01-23'),
(105, 205, '2018-01-10'),
(106, 206, '2018-01-15');

-- Consecutive duty assignments
INSERT INTO reserves VALUES
(107, 201, '2024-12-10'),
(107, 202, '2024-12-11');

-- Previous month reservations
INSERT INTO reserves VALUES
(108, 203, DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH)),
(109, 204, DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH));

-- Current month reservations
INSERT INTO reserves VALUES
(101, 201, LAST_DAY(CURRENT_DATE())),
(102, 202, LAST_DAY(CURRENT_DATE())),
(103, 203, LAST_DAY(CURRENT_DATE()));

-- First day of next month (red boat)
INSERT INTO reserves VALUES
(104, 201, DATE_ADD(LAST_DAY(CURRENT_DATE()), INTERVAL 1 DAY)),
(105, 204, DATE_ADD(LAST_DAY(CURRENT_DATE()), INTERVAL 1 DAY));

-- Multiple sailors on same boat same day (overlap)
INSERT INTO reserves VALUES
(106, 205, '2025-02-15'),
(107, 205, '2025-02-15');

-- Future reservations for forecasting
INSERT INTO reserves VALUES
(911, 202, DATE_ADD(CURRENT_DATE(), INTERVAL 2 MONTH)),
(911, 203, DATE_ADD(CURRENT_DATE(), INTERVAL 4 MONTH)),
(912, 204, DATE_ADD(CURRENT_DATE(), INTERVAL 7 DAY)),
(913, 205, DATE_ADD(CURRENT_DATE(), INTERVAL 15 DAY)),
(914, 206, DATE_ADD(CURRENT_DATE(), INTERVAL 45 DAY));

-- High-frequency reservations
INSERT INTO reserves VALUES
(109, 201, '2024-06-10'),
(109, 202, '2024-07-12'),
(109, 203, '2024-08-14'),
(109, 204, '2024-09-16'),
(109, 205, '2024-10-18'),
(109, 206, '2024-11-20');

-- Sparse reservations (gap > 30 days)
INSERT INTO reserves VALUES
(110, 201, '2024-01-01'),
(110, 202, '2024-03-15');