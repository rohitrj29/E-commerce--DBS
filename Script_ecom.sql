CREATE DATABASE IF NOT EXISTS eecommerce;
use eecommerce;


CREATE TABLE Customers (  										# to store the customer details                    
    customer_id INT NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    mid_name VARCHAR(50),
    last_name VARCHAR(50) NOT NULL,
    customer_email VARCHAR(100) NOT NULL UNIQUE,
    acc_password VARCHAR(50) NOT NULL,
    street VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    bank_acc varchar(50),
    pin INTEGER CHECK(pin >= 100000 and pin <= 999999),		# ensuring a 6 digit pin
    PRIMARY KEY (customer_id)
);

INSERT INTO Customers (first_name, mid_name, last_name, customer_email, acc_password, street, city, pin, bank_acc) 
VALUES ('Aarav', 'Kumar', 'Verma', 'aaravverma@gmail.com', 'p@ssword123', 'Gandhi Road', 'Mumbai', 400001,"5455 5625 1515");

INSERT INTO Customers (first_name, mid_name, last_name, customer_email, acc_password, street, city, pin, bank_acc) 
VALUES ('Aditi', 'Singh', 'Yadav', 'aditisingh@gmail.com', 'my$ecurep@ss', 'Saket Road', 'New Delhi', 110017,"5432 5625 1515");

INSERT INTO Customers (first_name, mid_name, last_name, customer_email, acc_password, street, city, pin, bank_acc) 
VALUES ('Akshay', 'Raj', 'Sharma', 'akshaysharma@gmail.com', 'p@$$word321', 'MG Road', 'Bengaluru', 560001,"5489 5625 1515");

INSERT INTO Customers (first_name, mid_name, last_name, customer_email, acc_password, street, city, pin, bank_acc) 
VALUES ('Anjali', 'Gupta', 'Shukla', 'anjalishukla@gmail.com', 'pa$$word456', 'Rajpath', 'New Delhi', 110001,"5455 5625 1985");

INSERT INTO Customers (first_name, mid_name, last_name, customer_email, acc_password, street, city, pin, bank_acc) 
VALUES ('Ishaan', 'Singh', 'Patel', 'ishaanpatel@gmail.com', 'mynewp@ssword', 'Malabar Hill', 'Mumbai', 400006,"5455 8425 1515");

INSERT INTO Customers (first_name, mid_name, last_name, customer_email, acc_password, street, city, pin, bank_acc) 
VALUES ('Jhanvi', 'Mehta', 'Kapoor', 'jhanvikapoor@gmail.com', 'p@ssw0rd789', 'Film City Road', 'Mumbai', 400065,"5455 5535 1515");

INSERT INTO Customers (first_name, mid_name, last_name, customer_email, acc_password, street, city, pin, bank_acc) 
VALUES ('Kabir', 'Singh', 'Bhalla', 'kabirbhalla@gmail.com', 'newp@ssword!234', 'Ashok Nagar', 'Chennai', 600083,"6355 5625 1515");

INSERT INTO Customers (first_name, mid_name, last_name, customer_email, acc_password, street, city, pin, bank_acc) 
VALUES ('Kavya', 'Reddy', 'Nair', 'kavyanair@gmail.com', 'myp@ssword2023', 'Kochi Bypass', 'Kochi', 682024,"9455 5651 1515");

INSERT INTO Customers (first_name, mid_name, last_name, customer_email, acc_password, street, city, pin, bank_acc) 
VALUES ('Riya', 'Shah', 'Patil', 'riyapatil@gmail.com', 'p@$$word4321', 'Pedder Road', 'Mumbai', 400026,"5455 1651 1515");

INSERT INTO Customers (first_name, mid_name, last_name, customer_email, acc_password, street, city, pin, bank_acc) 
VALUES ('Samarth', 'Kumar', 'Nair', 'samarthnair@gmail.com', 'password1234', 'MG Road', 'Pune', 411001,"9855 5625 1515");


CREATE TABLE Coupons ( 						#each customer having one  coupon at a time, with the discount percentage in decimal, can be used only within the expiration date
    coupon_code VARCHAR(20) NOT NULL,
    discount_perc FLOAT NOT NULL,
    customer_id INT NOT NULL,
    expiry_date DATE NOT NULL,
    PRIMARY KEY (coupon_code),
    CONSTRAINT fk_customer
        FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id)
);

CREATE TABLE Seller (									# each product hosted by a seller for the product
    seller_id INT NOT NULL,
    seller_name VARCHAR(50) NOT NULL,
    seller_email VARCHAR(100) NOT NULL UNIQUE,
    PRIMARY KEY (seller_id)
);

CREATE TABLE Products (									# product details
    product_id INT NOT NULL,
    seller_id INT,
    avg_rating FLOAT ,									# derived from reviews table
    product_name VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    category VARCHAR(50) NOT NULL,						# category of the product
    on_sale BOOLEAN NOT NULL DEFAULT false,				#specifies if the product is on sale, if yes the price is already hosted discounted
    prod_description TEXT,								#description for the product for custoer perusal before purchasing
    PRIMARY KEY (product_id),							
    CONSTRAINT fk_seller
        FOREIGN KEY (seller_id)
        REFERENCES Seller(seller_id)
);

CREATE TABLE Customer_phone (							# each customer may have more than one phone number, this stores that
    customer_id INT NOT NULL,
    phone_no VARCHAR(12) NOT NULL,
    PRIMARY KEY (customer_id, phone_no),
        FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id)
);

CREATE TABLE Reviews (									# reviews given about a product by customers, rating(out of 5)
    review_id INT NOT NULL AUTO_INCREMENT,
    customer_id INT NOT NULL,
    comments TEXT,
    rating INT NOT NULL,
    review_date DATE NOT NULL,
    product_id INT NOT NULL,
    PRIMARY KEY (review_id),
        FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id),
        FOREIGN KEY (product_id) 
        REFERENCES Products(product_id) on update no action  
        ON DELETE CASCADE
);

CREATE TABLE Orders (										# orders table stores the orders by different customers having different statuses for eg., cancelled, in cart, delivered, placed, etc. with 
  customer_id INT references Customers,						# "in cart" serving as the cart for an individual customer
  order_id INT PRIMARY KEY,
  total_price DECIMAL(10, 2),
  order_status VARCHAR(20) NOT NULL,
  order_date DATE NOT NULL
);

CREATE TABLE Cart (										# Cart serves to keep track of the different products that have been ordered till present. (Not the typical cart for a customer, as explained above)
    quantity INT NOT NULL,
    product_id INT NOT NULL,
    order_id INT NOT NULL,
    CONSTRAINT fk_product
        FOREIGN KEY (product_id)
        REFERENCES Products(product_id),
    CONSTRAINT fk_order
        FOREIGN KEY (order_id)
        REFERENCES Orders(order_id)
);



CREATE TABLE Payments (						# Payment details
  payment_id INT PRIMARY KEY,
  order_id INT NOT NULL,
  amt_paid DECIMAL(10,2),					# Involves discount on coupon usage after usage of coupon
  payment_date DATE NOT NULL,			
  pay_mode VARCHAR(50) NOT NULL,			# UPI, COD, etc
  is_paid boolean,							# depicting if the payment is done in advance
  FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

CREATE TABLE Shipping (						# Shipping details useful for tracking order and deliverying to any address wanted by the customer
  shipping_id INT PRIMARY KEY,
  order_id INT NOT NULL,
  delivery_date DATE NOT NULL,
  shipping_date DATE NOT NULL,
  shipping_status VARCHAR(20) NOT NULL,
  delivery_address VARCHAR(200) NOT NULL,
  FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

INSERT INTO Coupons (coupon_code, discount_perc, customer_id, expiry_date)
VALUES
('COUPON01', 0.2, 1, '2023-12-31'),
('COUPON02', 0.25, 2, '2024-01-31'),
('COUPON03', 0.33, 3, '2024-02-28'),
('COUPON04', 0.4 , 4, '2024-03-31'),
('COUPON05', 0.12, 5, '2024-04-30'),
('COUPON06', 0.23, 6, '2024-05-31'),
('COUPON07', 0.35, 7, '2024-06-30'),
('COUPON08', 0.22, 8, '2024-07-31'),
('COUPON09', 0.4,  9, '2024-08-31'),
('COUPON10', 0.1, 10, '2025-09-30');


INSERT INTO orders (order_id, total_price, order_date, order_status, customer_id)
VALUES 
(12, NULL, '2023-01-01', 'cancelled', 1),
(23, NULL, '2023-01-10', 'ongoing', 2),
(08, NULL, '2023-01-20', 'delivered', 3),
(24, NULL, '2023-02-05', 'cancelled', 4),
(34, NULL, '2023-02-14', 'ongoing', 5),
(69, NULL, '2023-02-23', 'delivered', 6),
(42, NULL, '2023-03-10', 'cancelled', 7),
(35, NULL, '2023-03-19', 'ongoing', 8),
(16, NULL, '2023-03-28', 'delivered', 9),
(19, NULL, '2023-04-06', 'cancelled', 10),
(55, NULL, '2023-04-26', 'in cart', 10);

INSERT INTO Seller (seller_id, seller_name, seller_email)
VALUES 
(3, 'Tata', 'tata@gmail.com'),
(25, 'Mahindra', 'mahindra@gmail.com'),
(9, 'Bajaj', 'bajaj@gmail.com'),
(77, 'Reliance', 'reliance@gmail.com'),
(44, 'Godrej', 'godrej@gmail.com'),
(60, 'Hindustan Unilever', 'hindustanunilever@gmail.com'),
(50, 'Infosys', 'infosys@gmail.com'),
(15, 'TCS', 'tcs@gmail.com'),
(91, 'Wipro', 'wipro@gmail.com'),
(31, 'Bharti Airtel', 'airtel@gmail.com');

INSERT INTO Customer_phone (customer_id, phone_no)
VALUES 
(1, '912345678901'),
(1, '922345678902'),
(2, '932345678903'),
(3, '942345678904'),
(3, '952345678905'),
(3, '962345678906'),
(4, '972345678907'),
(5, '982345678908'),
(5, '992345678909'),
(6, '912345678910'),
(7, '922345678911'),
(7, '932345678912'),
(8, '942345678913'),
(9, '952345678914'),
(9, '962345678915'),
(10, '972345678916'),
(10, '982345678917'),
(10, '992345678918');

INSERT INTO Products (product_id, seller_id, avg_rating, product_name, price, category, on_sale, prod_description)
VALUES 
(1, 3, NULL, 'Tata Safari', 1500000, 'Automobile', true, 'A stylish and comfortable SUV.'),
(2, 25, NULL, 'Mahindra XUV500', 1400000, 'Automobile', false, 'A feature-rich SUV with advanced safety features.'),
(3, 9, NULL, 'Bajaj Pulsar 150', 100000, 'Two Wheeler', true, 'A powerful and efficient bike.'),
(4, 77, NULL, 'JioPhone Next', 5000, 'Smartphone', true, 'An affordable smartphone with 4G connectivity.'),
(5, 44, NULL, 'Godrej Aer Click', 249, 'Air Freshener', true, 'A refreshing fragrance with easy-to-use click mechanism.'),
(6, 60, NULL, 'Surf Excel Easy Wash', 225, 'Laundry Detergent', true, 'A detergent specially designed for top load washing machines.'),
(7, 50, NULL, 'Infosys Nia', 500000, 'Artificial Intelligence', false, 'A platform for enterprise-grade AI applications.'),
(8, 15, NULL, 'TCS BaNCS', 1000000, 'Banking Software', false, 'A comprehensive suite of banking solutions.'),
(9, 91, NULL, 'Wipro Lighting', 1500, 'LED Bulbs', true, 'An energy-efficient LED bulb for home lighting.'),
(10, 31, NULL, 'Airtel Xstream', 499, 'OTT Platform', true, 'A subscription-based streaming service with a wide range of content.');

INSERT INTO cart (quantity, product_id, order_id)
VALUES
(5, 1, 12),
(2, 2, 23),
(1, 1, 23),
(8, 3, 8),
(3, 4, 24),
(6, 5, 34),
(2, 2, 34),
(1, 6, 69),
(4, 7, 42),
(1, 8, 35),
(6, 1, 35),
(3, 5, 35),
(7, 9, 16),
(10, 10, 19),
(2, 8, 19),
(2,3,55);

UPDATE orders														# calculating total price for each order
SET total_price = 
    (SELECT SUM(cart.quantity * products.price)
    FROM cart
    INNER JOIN products ON cart.product_id = products.product_id
    WHERE cart.order_id = orders.order_id);
    
INSERT INTO payments (payment_id, payment_date, amt_paid, pay_mode, is_paid, order_id)
VALUES
(1, '2023-01-02', NULL, 'COD', false, 12),
(2, '2023-01-11', NULL, 'UPI', true, 23),
(3, '2023-01-21', NULL, 'netbanking', true, 8),
(4, '2023-02-06', NULL, 'COD', false, 24),
(5, '2023-02-15', NULL, 'UPI', true, 34),
(6, '2023-02-24', NULL, 'netbanking', true, 69),
(7, '2023-03-11', NULL, 'COD', false, 42),
(8, '2023-03-20', NULL, 'UPI', true, 35),
(9, '2023-03-29', NULL, 'netbanking', true, 16),
(10, '2023-04-07', NULL, 'COD', false, 19);

UPDATE payments															# calculating discount price on use of coupons
SET amt_paid = (select orders.total_price * (1 - coupons.discount_perc)
FROM orders
JOIN coupons ON orders.customer_id = coupons.customer_id
WHERE payments.order_id = orders.order_id
AND coupons.expiry_date > payments.payment_date);

INSERT INTO shipping (delivery_address, shipping_status, shipping_date, shipping_id, delivery_date, order_id)
VALUES 
('123 Main St, Bangalore, Karnataka', 'order placed', '2023-01-01', 1, '2023-01-05', 12),
('456 Park Rd, Mumbai, Maharashtra', 'dispatched', '2023-01-10', 2, '2023-01-15', 23),
('789 Elm St, Delhi, Delhi', 'out for delivery', '2023-01-20', 3, '2023-01-25', 08),
('321 Maple Ave, Hyderabad, Telangana', 'cancelled', '2023-02-05', 4, '2023-02-15', 24),
('654 Oak St, Chennai, Tamil Nadu', 'ongoing', '2023-02-14', 5, '2023-02-19', 34),
('987 Pine St, Kolkata, West Bengal', 'delivered', '2023-02-23', 6, '2023-02-28', 69),
('246 Cedar Rd, Pune, Maharashtra', 'cancelled', '2023-03-10', 7, '2023-03-15', 42),
('369 Birch Ln, Jaipur, Rajasthan', 'ongoing', '2023-03-19', 8, '2023-03-24', 35),
('159 Walnut St, Ahmedabad, Gujarat', 'delivered', '2023-03-28', 9, '2023-04-02', 16),
('753 Cherry Ave, Surat, Gujarat', 'cancelled', '2023-04-06', 10, '2023-04-12', 19);

INSERT INTO Reviews (customer_id, comments, rating, review_date, product_id)
VALUES 
    (1, 'Great car!', 4, '2022-03-15', 1),
    (2, 'Love this SUV!', 4, '2022-03-17', 1),
    (3, 'Smooth ride and good mileage', 4, '2022-03-20', 3),
    (4, 'Affordable and feature-packed', 3, '2022-03-21', 4),
    (5, 'Refreshing fragrance', 4, '2022-03-22', 5),
    (6, 'Cleans clothes well', 4, '2022-03-25', 6),
    (7, 'Powerful AI platform', 4, '2022-03-26', 7),
    (8, 'Comprehensive banking solutions', 4, '2022-03-28', 8),
    (9,'Good bulb for home lighting', 3, '2022-03-30', 9),
    (10,'Great streaming service', 4, '2022-03-31', 10),
    (1, 'Comfortable and spacious', 4, '2022-04-01', 2),
    (2, 'Feature-rich and safe', 4, '2022-04-02', 2),
    (3, 'Powerful bike with good looks', 4, '2022-04-05', 3),
    (4, 'Decent phone for the price', 3, '2022-04-06', 4),
    (5, 'Long-lasting fragrance', 4, '2022-04-07', 5),
    (6, 'Effective detergent for top load washing machines', 4, '2022-04-10', 6),
    (7, 'Easy-to-use AI platform', 4, '2022-04-11', 7),
    (8, 'Powerful banking software', 4, '2022-04-12', 8),
    (9, 'Bright and energy-efficient bulb', 4, '2022-04-15', 9),
    (10, 'Good collection of movies and shows', 4, '2022-04-16', 10);

UPDATE Products								# calculating average rating for a product
SET avg_rating = (
    SELECT AVG(rating)
    FROM Reviews
    WHERE Reviews.product_id = Products.product_id
    GROUP BY product_id
);
