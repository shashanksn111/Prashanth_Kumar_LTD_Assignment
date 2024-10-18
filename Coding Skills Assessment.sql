--create the tables 
CREATE TABLE Customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Books (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE OrderDetails (
    order_id INT NOT NULL,
    book_id INT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (order_id, book_id),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);


SELECT c.customer_id, c.name, SUM(od.quantity) AS total_books
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN OrderDetails od ON o.order_id = od.order_id
WHERE o.order_date >= CURRENT_DATE - INTERVAL '1 year'
GROUP BY c.customer_id, c.name
ORDER BY total_books DESC
LIMIT 5;

INSERT INTO Books (book_id, title, author, price) VALUES
(1, 'Harry Potter and the Philosopher''s Stone', 'J.K. Rowling', 20.00),
(2, 'A Song of Ice and Fire', 'George R.R. Martin', 25.00),
(3, 'The Shining', 'Stephen King', 15.00),
(4, 'Murder on the Orient Express', 'Agatha Christie', 12.00),
(5, 'The Da Vinci Code', 'Dan Brown', 18.00);


INSERT INTO Customers (name, email) VALUES
('Alice Smith', 'alice@example.com'),
('Bob Johnson', 'bob@example.com'),
('Charlie Brown', 'charlie@example.com');


INSERT INTO Orders (order_id, customer_id, order_date) VALUES
(1, 1, CURRENT_DATE - INTERVAL '6 MONTH'),   -- Order within the last year
(2, 2, CURRENT_DATE - INTERVAL '1 YEAR'),     -- Order exactly one year ago
(3, 1, CURRENT_DATE - INTERVAL '1 YEAR' - INTERVAL '1 DAY'); -- Order older than one year

INSERT INTO Books (book_id, title, author, price) VALUES
(1, 'Harry Potter and the Philosopher''s Stone', 'J.K. Rowling', 20.00),
(2, 'A Song of Ice and Fire', 'George R.R. Martin', 25.00),
(3, 'The Shining', 'Stephen King', 15.00),
(4, 'Murder on the Orient Express', 'Agatha Christie', 12.00),
(5, 'The Da Vinci Code', 'Dan Brown', 18.00);


INSERT INTO Orders (order_id, customer_id, order_date) VALUES
(1, 1, CURRENT_DATE - INTERVAL '6 MONTH'),   -- Order within the last year
(2, 2, CURRENT_DATE - INTERVAL '1 YEAR'),     -- Order exactly one year ago
(3, 1, CURRENT_DATE - INTERVAL '1 YEAR' - INTERVAL '1 DAY'); -- Order older than one year


INSERT INTO OrderDetails (order_id, book_id, quantity) VALUES
(1, 1, 10),  -- 10 copies of 'Harry Potter'
(1, 2, 5),   -- 5 copies of 'A Song of Ice and Fire'
(2, 3, 3),   -- 3 copies of 'The Shining'
(3, 4, 12),  -- 12 copies of 'Murder on the Orient Express'
(3, 5, 8);   -- 8 copies of 'The Da Vinci Code'


SELECT b.author, SUM(od.quantity * b.price) AS total_revenue
FROM Books b
JOIN OrderDetails od ON b.book_id = od.book_id
GROUP BY b.author
ORDER BY total_revenue DESC;

-- Insert additional data to ensure some books have been ordered more than 10 times
INSERT INTO OrderDetails (order_id, book_id, quantity) VALUES
(1, 1, 10),  -- 10 copies of 'Harry Potter' for order 1
(1, 2, 2),   -- 2 copies of 'A Song of Ice and Fire' for order 1
(1, 3, 3),   -- 3 copies of 'The Shining' for order 1
(2, 1, 15),  -- 15 copies of 'Harry Potter' for order 2
(2, 4, 1),   -- 1 copy of 'Murder on the Orient Express' for order 2
(2, 5, 2),   -- 2 copies of 'The Da Vinci Code' for order 2
(3, 1, 5),   -- 5 copies of 'Harry Potter' for order 3
(3, 2, 8),   -- 8 copies of 'A Song of Ice and Fire' for order 3
(3, 4, 2);   -- 2 copies of 'Murder on the Orient Express' for order 3

SELECT * FROM OrderDetails;


UPDATE OrderDetails
SET quantity = quantity + 5  -- Increase the quantity by 5 for the specific order and book
WHERE order_id = 1 AND book_id = 1;  -- For 'Harry Potter' in order 1

INSERT INTO OrderDetails (order_id, book_id, quantity) VALUES
(4, 1, 10),  -- 10 copies of 'Harry Potter' for order 4
(4, 2, 2),   -- 2 copies of 'A Song of Ice and Fire' for order 4
(5, 3, 3),   -- 3 copies of 'The Shining' for order 5
(5, 1, 15),  -- 15 copies of 'Harry Potter' for order 5
(5, 4, 1),   -- 1 copy of 'Murder on the Orient Express' for order 5
(5, 5, 2);   -- 2 copies of 'The Da Vinci Code' for order 5


INSERT INTO "orders" (order_id, customer_id, order_date) VALUES
(1, 1, CURRENT_DATE - INTERVAL '6 MONTH'),  -- Order within the last year
(2, 2, CURRENT_DATE - INTERVAL '1 MONTH'),   -- Order within the last month
(3, 1, CURRENT_DATE - INTERVAL '1 YEAR');     -- Order exactly one year ago

INSERT INTO OrderDetails (order_id, book_id, quantity) VALUES
(4, 1, 10),  -- 10 copies of 'Harry Potter' for order 4
(4, 2, 2),   -- 2 copies of 'A Song of Ice and Fire' for order 4
(5, 3, 3),   -- 3 copies of 'The Shining' for order 5
(5, 1, 15),  -- 15 copies of 'Harry Potter' for order 5
(5, 4, 1),   -- 1 copy of 'Murder on the Orient Express' for order 5
(5, 5, 2);   -- 2 copies of 'The Da Vinci Code' for order 5


-- For the top 5 customers
SELECT c.customer_id, c.name, SUM(od.quantity) AS total_books_purchased
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN orderdetails od ON o.order_id = od.order_id
WHERE o.order_date >= CURRENT_DATE - INTERVAL '1 YEAR'
GROUP BY c.customer_id, c.name
ORDER BY total_books_purchased DESC
LIMIT 5;

-- For total revenue generated from book sales by each author
SELECT b.author, SUM(od.quantity * b.price) AS total_revenue
FROM books b
JOIN orderdetails od ON b.book_id = od.book_id
GROUP BY b.author
ORDER BY total_revenue DESC;

-- For books ordered more than 10 times with total quantity ordered
SELECT b.book_id, b.title, SUM(od.quantity) AS total_quantity_ordered
FROM books b
JOIN orderdetails od ON b.book_id = od.book_id
GROUP BY b.book_id, b.title
HAVING SUM(od.quantity) > 10
ORDER BY total_quantity_ordered DESC;