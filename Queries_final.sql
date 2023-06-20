-- Creating a new account, procedure used as an example --

DELIMITER //

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_into_customer`(
    IN `firstName` VARCHAR(50),
    IN `middleName` VARCHAR(50),
    IN `lastName` VARCHAR(50),
    IN `email` VARCHAR(100),
    IN `accpassword` VARCHAR(50),
    IN `street` VARCHAR(50),
    IN `city` VARCHAR(50),
    IN `zipCode` INT,
    IN `bankacc` VARCHAR(50)
)
BEGIN
    INSERT INTO Customers (first_name, mid_name, last_name, customer_email, acc_password, street, city, pin, bank_acc)
        
    VALUES (firstName, middleName, lastName, email, accpassword, street, city, zipCode, bankacc);
END //

DELIMITER ;


CALL insert_into_customer('Rohit', 'Raj', 'Singh', 'rohitraj@gmail.com', 'rohit123', '12,Ashok nagar', 'dhanbad', 828201, '845215178285');


-- Browse for a particular category --

select * from products where category = 'Automobile';


-- Recommend similar products --

Select * from products
Where category = (select category
	From products where
	product_id in (select product_id from cart where order_id = 12));
    

-- Track order --

select shipping_status from shipping where order_id = 12;

-- Update shipping address --

update shipping set delivery_address = '321 Main St, Bangalore, Karnataka' where order_id =12;

-- See details of a product before purchasing it --

select prod_description from products where product_name = 'Tata Safari';

-- Suggest products that are currently on sale --

select * from products where on_sale = true;

-- Insert into cart --

INSERT INTO cart (quantity, product_id, order_id) VALUES (2,4,55);

-- Place order using coupon code --

UPDATE payments
SET amt_paid = (select orders.total_price * (1 - coupons.discount_perc)
FROM orders
JOIN coupons ON orders.customer_id = coupons.customer_id
WHERE payments.order_id = orders.order_id
AND coupons.expiry_date > payments.payment_date);

-- Cancel order --

UPDATE orders 
SET order_status="canceled" where order_id=12;

-- Leave a review --

INSERT INTO Reviews (customer_id, comments, rating, review_date, product_id)
VALUES (5, 'This product is amazing! I highly recommend it.', 5, '2023-04-07', 3);

-- See order history

Select * from orders where customer_id = 3;

-- Process refund --

UPDATE orders o
SET o.order_status = 'refund initiated'
WHERE o.order_id = 23
AND (SELECT p.is_paid FROM payments p WHERE p.order_id = o.order_id) = true;

-- Same query using procedure --

DELIMITER //

CREATE DEFINER=`root`@`localhost` PROCEDURE `process_refund`(
IN `orderid` int)
BEGIN
	UPDATE orders o
	SET o.order_status = 'refund initiated'
	WHERE o.order_id = orderid
	AND ((SELECT p.is_paid FROM payments p WHERE p.order_id = o.order_id) = true);
END//

DELIMITER ;
CALL process_refund(23);



-- Suggesting a product that is frequently purchased with the one I just added to cart --

select product_name from products
where product_id in (
select product_id from cart where order_id in(
select order_id from cart where product_id in(
select product_id from cart where order_id = 12)));


-- Update payment information --

Update customers
Set bank_acc= "123432832887"
Where customer_id=3;

-- Trending products --

with trending as (SELECT product_id, COUNT(*) AS frequency
FROM cart
GROUP BY product_id
ORDER BY frequency DESC
LIMIT 5)
select product_name from products join trending using(product_id);


-- Changing the quantity of a product in cart --

Update cart
set quantity=5
where product_id=3 and order_id=55 and 
(select order_status from orders where order_id=55)="in cart";