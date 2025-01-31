-- ==============================
--      USER MANAGEMENT
-- ==============================
CREATE TABLE customer (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL,
    contact_number VARCHAR(15) UNIQUE NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    address TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- Indexes for quick lookup
    CONSTRAINT idx_customer_contact UNIQUE (contact_number),
    CONSTRAINT idx_customer_email UNIQUE (email)
);

CREATE INDEX idx_customer_contact ON customer(contact_number);
CREATE INDEX idx_customer_email ON customer(email);

CREATE TABLE zomato_employee (
    employee_id SERIAL PRIMARY KEY,
    employee_name VARCHAR(50) NOT NULL,
    emp_contact_number VARCHAR(15) UNIQUE NOT NULL,
    emp_role VARCHAR(20) CHECK (emp_role IN ('Delivery', 'Admin', 'Support')) NOT NULL,
    avg_rating DECIMAL(2,1) CHECK (avg_rating BETWEEN 0 AND 5) NOT NULL DEFAULT 0.0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- Index for quick employee lookup by contact number
    CONSTRAINT idx_employee_contact UNIQUE (emp_contact_number)
);

CREATE INDEX idx_employee_contact ON zomato_employee(emp_contact_number);

-- ==============================
--    RESTAURANT MANAGEMENT
-- ==============================
CREATE TABLE restaurant (
    restaurant_id SERIAL PRIMARY KEY,
    restaurant_name VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL,
    rating DECIMAL(2,1) CHECK (rating BETWEEN 0 AND 5) NOT NULL DEFAULT 0.0,
    contact_number VARCHAR(15) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- Indexes for searching restaurants quickly by name, location, and rating
    CONSTRAINT idx_restaurant_name UNIQUE (restaurant_name)
);

CREATE INDEX idx_restaurant_location ON restaurant(location);
CREATE INDEX idx_restaurant_name ON restaurant(restaurant_name);
CREATE INDEX idx_restaurant_rating ON restaurant(rating);

CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE foods (
    food_id SERIAL PRIMARY KEY,
    food_name VARCHAR(100) NOT NULL,
    category_id INT NOT NULL,
    price_per_unit DECIMAL(7,2) CHECK (price_per_unit > 0) NOT NULL,
    description TEXT,
    CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE CASCADE,
    -- Index on category_id for faster lookups by category
    CONSTRAINT idx_food_category UNIQUE (category_id)
);

CREATE INDEX idx_food_category ON foods(category_id);

CREATE TABLE restaurant_menu (
    menu_id SERIAL PRIMARY KEY,
    restaurant_id INT NOT NULL,
    food_id INT NOT NULL,
    availability BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT fk_restaurant FOREIGN KEY (restaurant_id) REFERENCES restaurant(restaurant_id) ON DELETE CASCADE,
    CONSTRAINT fk_food FOREIGN KEY (food_id) REFERENCES foods(food_id) ON DELETE CASCADE,
    UNIQUE (restaurant_id, food_id) -- Ensures food is unique per restaurant
);

CREATE INDEX idx_restaurant_menu ON restaurant_menu(restaurant_id, food_id);

-- ==============================
--       ORDER MANAGEMENT
-- ==============================
CREATE TABLE order_detail (
    order_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    employee_id INT NOT NULL,
    order_status VARCHAR(20) CHECK (order_status IN ('Pending', 'Preparing', 'Out for Delivery', 'Delivered', 'Cancelled')) NOT NULL DEFAULT 'Pending',
    order_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    delivered_time TIMESTAMP NULL,
    CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE,
    CONSTRAINT fk_restaurant FOREIGN KEY (restaurant_id) REFERENCES restaurant(restaurant_id) ON DELETE CASCADE,
    CONSTRAINT fk_zomato_employee FOREIGN KEY (employee_id) REFERENCES zomato_employee(employee_id) ON DELETE SET NULL,
    -- Indexes for filtering orders by time and status
    CONSTRAINT idx_order_time INDEX (order_time),
    CONSTRAINT idx_order_status INDEX (order_status)
);

CREATE INDEX idx_order_time ON order_detail(order_time);
CREATE INDEX idx_order_status ON order_detail(order_status);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    food_id INT NOT NULL,
    quantity INT CHECK (quantity > 0) NOT NULL,
    CONSTRAINT fk_order FOREIGN KEY (order_id) REFERENCES order_detail(order_id) ON DELETE CASCADE,
    CONSTRAINT fk_food FOREIGN KEY (food_id) REFERENCES foods(food_id) ON DELETE CASCADE,
    -- Index for faster lookups of order and food
    CONSTRAINT idx_order_food UNIQUE (order_id, food_id)
);

CREATE INDEX idx_order_food ON order_items(order_id, food_id);

-- ==============================
--        PAYMENT SYSTEM
-- ==============================
CREATE TABLE payment_table (
    transaction_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    payment_type VARCHAR(20) CHECK (payment_type IN ('Credit Card', 'Debit Card', 'UPI', 'Cash', 'Wallet')) NOT NULL,
    payment_status VARCHAR(20) CHECK (payment_status IN ('Pending', 'Completed', 'Failed', 'Refunded')) NOT NULL DEFAULT 'Pending',
    payment_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10,2) CHECK (amount > 0) NOT NULL,
    CONSTRAINT fk_order FOREIGN KEY (order_id) REFERENCES order_detail(order_id) ON DELETE CASCADE,
    -- Index for faster lookup of payment status and order ID
    CONSTRAINT idx_payment_order_id INDEX (order_id),
    CONSTRAINT idx_payment_status INDEX (payment_status)
);

CREATE INDEX idx_payment_order_id ON payment_table(order_id);
CREATE INDEX idx_payment_status ON payment_table(payment_status);

-- ==============================
--      DELIVERY MANAGEMENT
-- ==============================
CREATE TABLE delivery (
    delivery_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    employee_id INT NOT NULL,
    delivery_status VARCHAR(20) CHECK (delivery_status IN ('Assigned', 'Out for Delivery', 'Delivered', 'Failed')) NOT NULL DEFAULT 'Assigned',
    estimated_time TIMESTAMP,
    actual_delivery_time TIMESTAMP NULL,
    CONSTRAINT fk_order FOREIGN KEY (order_id) REFERENCES order_detail(order_id) ON DELETE CASCADE,
    CONSTRAINT fk_employee FOREIGN KEY (employee_id) REFERENCES zomato_employee(employee_id) ON DELETE SET NULL,
    -- Index for filtering deliveries by status
    CONSTRAINT idx_delivery_status INDEX (delivery_status)
);

CREATE INDEX idx_delivery_status ON delivery(delivery_status);

-- ==============================
--     REVIEWS & RATINGS
-- ==============================
CREATE TABLE reviews (
    review_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    rating DECIMAL(2,1) CHECK (rating BETWEEN 0 AND 5) NOT NULL,
    review_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE,
    CONSTRAINT fk_restaurant FOREIGN KEY (restaurant_id) REFERENCES restaurant(restaurant_id) ON DELETE CASCADE,
    -- Indexes for searching reviews by customer or restaurant
    CONSTRAINT idx_reviews_customer_id INDEX (customer_id),
    CONSTRAINT idx_reviews_restaurant_id INDEX (restaurant_id)
);

CREATE INDEX idx_reviews_customer_id ON reviews(customer_id);
CREATE INDEX idx_reviews_restaurant_id ON reviews(restaurant_id);

CREATE TABLE restaurant_reviews (
    review_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    rating DECIMAL(2,1) CHECK (rating BETWEEN 0 AND 5) NOT NULL,
    review_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE,
    CONSTRAINT fk_restaurant FOREIGN KEY (restaurant_id) REFERENCES restaurant(restaurant_id) ON DELETE CASCADE,
    -- Index for searching restaurant reviews
    CONSTRAINT idx_restaurant_reviews_customer_id INDEX (customer_id),
    CONSTRAINT idx_restaurant_reviews_restaurant_id INDEX (restaurant_id)
);

CREATE INDEX idx_restaurant_reviews_customer_id ON restaurant_reviews(customer_id);
CREATE INDEX idx_restaurant_reviews_restaurant_id ON restaurant_reviews(restaurant_id);

-- ==============================
--     OFFERS & DISCOUNTS
-- ==============================
CREATE TABLE offers (
    offer_id SERIAL PRIMARY KEY,
    restaurant_id INT NOT NULL,
    discount_percentage DECIMAL(5,2) CHECK (discount_percentage BETWEEN 0 AND 100) NOT NULL,
    valid_from TIMESTAMP NOT NULL,
    valid_until TIMESTAMP NOT NULL,
    CONSTRAINT fk_restaurant FOREIGN KEY (restaurant_id) REFERENCES restaurant(restaurant_id) ON DELETE CASCADE,
    -- Index on restaurant_id for quick lookup of offers
    CONSTRAINT idx_offers_restaurant_id INDEX (restaurant_id)
);

CREATE INDEX idx_offers_restaurant_id ON offers(restaurant_id);
