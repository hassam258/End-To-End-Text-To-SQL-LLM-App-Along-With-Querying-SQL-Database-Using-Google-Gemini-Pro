-- Create database
-- CREATE DATABASE IF NOT EXISTS FinancialDB;
USE FinancialDB;

-- Create Customer table
CREATE TABLE IF NOT EXISTS customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone_number VARCHAR(15),
    address VARCHAR(255)
);

-- Create Account table
CREATE TABLE IF NOT EXISTS accounts (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    account_number VARCHAR(20),
    account_type VARCHAR(20),
    balance DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Create Card table
CREATE TABLE IF NOT EXISTS cards (
    card_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    card_number VARCHAR(20),
    card_type VARCHAR(20),
    expiration_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Create Transaction table
CREATE TABLE IF NOT EXISTS transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT,
    card_id INT,
    amount DECIMAL(10, 2),
    transaction_date DATETIME,
    merchant VARCHAR(100),
    transaction_type VARCHAR(50),
    FOREIGN KEY (account_id) REFERENCES accounts(account_id),
    FOREIGN KEY (card_id) REFERENCES cards(card_id)
);
-- Insert random data into customers table
INSERT INTO customers (first_name, last_name, email, phone_number, address)
VALUES
    ('John', 'Doe', CONCAT('john.doe', FLOOR(RAND() * 1000), '@example.com'), CONCAT('555-', LPAD(FLOOR(RAND() * 10000000), 7, '0')), CONCAT(FLOOR(RAND() * 1000), ' Main St')),
    ('Jane', 'Smith', CONCAT('jane.smith', FLOOR(RAND() * 1000), '@example.com'), CONCAT('555-', LPAD(FLOOR(RAND() * 10000000), 7, '0')), CONCAT(FLOOR(RAND() * 1000), ' Elm St')),
    ('Alice', 'Brown', CONCAT('alice.brown', FLOOR(RAND() * 1000), '@example.com'), CONCAT('555-', LPAD(FLOOR(RAND() * 10000000), 7, '0')), CONCAT(FLOOR(RAND() * 1000), ' Oak St')),
    ('Bob', 'Davis', CONCAT('bob.davis', FLOOR(RAND() * 1000), '@example.com'), CONCAT('555-', LPAD(FLOOR(RAND() * 10000000), 7, '0')), CONCAT(FLOOR(RAND() * 1000), ' Pine St'));

-- Insert random data into accounts table
INSERT INTO accounts (customer_id, account_number, account_type, balance)
VALUES
    (1, CONCAT('ACCT', LPAD(FLOOR(RAND() * 1000000), 6, '0')), 'Checking', ROUND(RAND() * 10000, 2)),
    (2, CONCAT('ACCT', LPAD(FLOOR(RAND() * 1000000), 6, '0')), 'Savings', ROUND(RAND() * 10000, 2)),
    (3, CONCAT('ACCT', LPAD(FLOOR(RAND() * 1000000), 6, '0')), 'Checking', ROUND(RAND() * 10000, 2)),
    (4, CONCAT('ACCT', LPAD(FLOOR(RAND() * 1000000), 6, '0')), 'Savings', ROUND(RAND() * 10000, 2));

-- Insert random data into cards table
INSERT INTO cards (customer_id, card_number, card_type, expiration_date)
VALUES
    (1, CONCAT(LPAD(FLOOR(RAND() * 1000000000000000), 16, '0')), 'Visa', DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND() * 5) YEAR)),
    (2, CONCAT(LPAD(FLOOR(RAND() * 1000000000000000), 16, '0')), 'MasterCard', DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND() * 5) YEAR)),
    (3, CONCAT(LPAD(FLOOR(RAND() * 1000000000000000), 16, '0')), 'Amex', DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND() * 5) YEAR)),
    (4, CONCAT(LPAD(FLOOR(RAND() * 1000000000000000), 16, '0')), 'Discover', DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND() * 5) YEAR));

-- Insert random data into transactions table
INSERT INTO transactions (account_id, card_id, amount, transaction_date, merchant, transaction_type)
VALUES
    (1, 1, ROUND(RAND() * 500, 2), NOW() - INTERVAL FLOOR(RAND() * 1000) HOUR, CONCAT('Merchant', FLOOR(RAND() * 1000)), 'Purchase'),
    (2, 2, ROUND(RAND() * 500, 2), NOW() - INTERVAL FLOOR(RAND() * 1000) HOUR, CONCAT('Merchant', FLOOR(RAND() * 1000)), 'IBFT'),
    (3, 3, ROUND(RAND() * 500, 2), NOW() - INTERVAL FLOOR(RAND() * 1000) HOUR, CONCAT('Merchant', FLOOR(RAND() * 1000)), 'IBFTIn'),
    (4, 4, ROUND(RAND() * 500, 2), NOW() - INTERVAL FLOOR(RAND() * 1000) HOUR, CONCAT('Merchant', FLOOR(RAND() * 1000)), 'BillPayment');

select *  from transactions;
select * from cards;
select * from customers;

SELECT card_type, SUM(amount) FROM cards left join  Transactions 
on cards.card_id=Transactions.card_id 
group by card_type;

SELECT SUM(amount) FROM cards left join  Transactions on cards.card_id=Transactions.card_id  where card_type='MasterCard';