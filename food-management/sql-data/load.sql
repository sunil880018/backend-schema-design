-- ==============================
--      USER MANAGEMENT
-- ==============================
INSERT INTO customer (customer_name, contact_number, email, address) VALUES
('Alice Johnson', '9876543210', 'alice@example.com', '123 Elm Street, New York'),
('Bob Smith', '9876543211', 'bob@example.com', '456 Oak Avenue, Los Angeles'),
('Charlie Brown', '9876543212', 'charlie@example.com', '789 Pine Road, Chicago');

INSERT INTO zomato_employee (employee_name, emp_contact_number, emp_role, avg_rating) VALUES
('David Williams', '9876543220', 'Delivery', 4.5),
('Emily Davis', '9876543221', 'Admin', 0.0),
('Frank Miller', '9876543222', 'Support', 4.0);

-- ==============================
--    RESTAURANT MANAGEMENT
-- ==============================
INSERT INTO restaurant (restaurant_name, location, rating, contact_number) VALUES
('Tasty Bites', 'New York', 4.2, '9876543230'),
('Spicy Delights', 'Los Angeles', 4.7, '9876543231'),
('Yummy Treats', 'Chicago', 4.5, '9876543232');

INSERT INTO categories (category_name) VALUES
('Fast Food'),
('Chinese'),
('Italian');

INSERT INTO foods (food_name, category_id, price_per_unit, description) VALUES
('Burger', 1, 5.99, 'Delicious beef burger with cheese'),
('Fried Rice', 2, 7.99, 'Classic Chinese fried rice'),
('Pasta', 3, 8.99, 'Creamy Italian pasta with garlic sauce');

INSERT INTO restaurant_menu (restaurant_id, food_id, availability) VALUES
(1, 1, TRUE),
(2, 2, TRUE),
(3, 3, TRUE);

-- ==============================
--       ORDER MANAGEMENT
-- ==============================
INSERT INTO order_detail (customer_id, restaurant_id, employee_id, order_status) VALUES
(1, 1, 1, 'Pending'),
(2, 2, 1, 'Preparing'),
(3, 3, 2, 'Out for Delivery');

INSERT INTO order_items (order_id, food_id, quantity) VALUES
(1, 1, 2),
(2, 2, 1),
(3, 3, 3);

-- ==============================
--        PAYMENT SYSTEM
-- ==============================
INSERT INTO payment_table (order_id, payment_type, payment_status, amount) VALUES
(1, 'Credit Card', 'Completed', 11.98),
(2, 'UPI', 'Completed', 7.99),
(3, 'Cash', 'Pending', 26.97);

-- ==============================
--      DELIVERY MANAGEMENT
-- ==============================
INSERT INTO delivery (order_id, employee_id, delivery_status, estimated_time) VALUES
(1, 1, 'Assigned', '2025-02-01 12:30:00'),
(2, 1, 'Out for Delivery', '2025-02-01 13:00:00'),
(3, 2, 'Delivered', '2025-02-01 14:00:00');

-- ==============================
--     REVIEWS & RATINGS
-- ==============================
INSERT INTO reviews (customer_id, restaurant_id, rating, review_text) VALUES
(1, 1, 4.5, 'Great food and fast service!'),
(2, 2, 5.0, 'Amazing flavors, will order again!'),
(3, 3, 4.2, 'Tasty, but delivery took a while.');

-- ==============================
--     OFFERS & DISCOUNTS
-- ==============================
INSERT INTO offers (restaurant_id, discount_percentage, valid_from, valid_until) VALUES
(1, 10.00, '2025-02-01 00:00:00', '2025-02-10 23:59:59'),
(2, 15.00, '2025-02-05 00:00:00', '2025-02-15 23:59:59'),
(3, 20.00, '2025-02-10 00:00:00', '2025-02-20 23:59:59');
