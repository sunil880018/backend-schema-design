-- Stores information about the users in the system.

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Stores the different payment methods a user can use (e.g., cards, wallets, UPI).

CREATE TABLE payment_methods (
    method_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    method_type ENUM('CARD', 'WALLET', 'UPI', 'BANK_TRANSFER') NOT NULL,
    method_details JSON NOT NULL, -- To store details like card number, UPI ID, etc.
    is_default BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);


-- Tracks all transactions made by users.

CREATE TABLE transactions (
    transaction_id VARCHAR(36) PRIMARY KEY, -- UUID or a unique transaction ID
    user_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'INR',
    status ENUM('PENDING', 'SUCCESS', 'FAILED', 'REFUNDED') NOT NULL,
    payment_method_id INT,
    remarks VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (payment_method_id) REFERENCES payment_methods(method_id)
);

-- Tracks refund details for transactions.

CREATE TABLE refunds (
    refund_id VARCHAR(36) PRIMARY KEY, -- UUID or unique refund ID
    transaction_id VARCHAR(36) NOT NULL,
    refund_amount DECIMAL(10, 2) NOT NULL,
    reason VARCHAR(255),
    status ENUM('PENDING', 'COMPLETED', 'FAILED') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id) ON DELETE CASCADE
);

-- Stores logs for auditing purposes.

CREATE TABLE audit_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    transaction_id VARCHAR(36),
    action ENUM('CREATE_TRANSACTION', 'UPDATE_TRANSACTION', 'CREATE_REFUND', 'LOGIN', 'LOGOUT') NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id)
);

-- Tracks details of the payment gateway used for a transaction.

CREATE TABLE payment_gateways (
    gateway_id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_id VARCHAR(36) NOT NULL,
    gateway_name VARCHAR(50) NOT NULL,
    gateway_status ENUM('SUCCESS', 'FAILED', 'PENDING') NOT NULL,
    gateway_response JSON, -- Store raw gateway response as JSON
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id)
);


-- If you want to implement a wallet feature for users.

CREATE TABLE wallets (
    wallet_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    balance DECIMAL(10, 2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE wallet_transactions (
    wallet_transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    wallet_id INT NOT NULL,
    transaction_type ENUM('CREDIT', 'DEBIT') NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    transaction_id VARCHAR(36), -- If linked to a main transaction
    remarks VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (wallet_id) REFERENCES wallets(wallet_id),
    FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id)
);