use  assignment;
drop database  main;

# Hotel management system

create table users(
user_id varchar(150) Primary key,
name varchar(150),
phone_number varchar(150),
mail_id varchar(150),
billing_address varchar(150)
);

create table bookings(
booking_id varchar(150) primary key,
booking_date datetime,
room_no varchar(100),
user_id varchar(150),
Foreign key (user_id) references users(user_id)
);



create table booking_commercials(
id varchar(50) primary key,
booking_id varchar(150),
bill_id varchar(150),
bill_date datetime,
item_id varchar(150),
item_quantity decimal(10,2),
foreign key (booking_id) references bookings(booking_id),
foreign key(item_id) references items(item_id)
);



create table items (
    item_id varchar(50) primary key,
    item_name VARCHAR(100),
    item_rate DECIMAL(10,2)
);

INSERT INTO users VALUES
('21wrcxuy-67erfn','John Doe','9700000001','john.doe@example.com','XX Street, ABC City'),
('32abcyz-89ghij','Jane Smith','9700000002','jane.smith@example.com','YY Street, XYZ City'),
('45pqrs-12lmno','Rahul Kumar','9700000003','rahul@example.com','ZZ Street, Bangalore');

select * from users;

INSERT INTO bookings VALUES
('bk-001','2021-10-05 10:30:00','rm-101','21wrcxuy-67erfn'),
('bk-002','2021-11-12 14:20:00','rm-102','32abcyz-89ghij'),
('bk-003','2021-11-25 09:15:00','rm-103','21wrcxuy-67erfn'),
('bk-004','2021-12-01 18:45:00','rm-104','45pqrs-12lmno');

select * from bookings;

INSERT INTO items VALUES
('itm-001','Tawa Paratha',18.00),
('itm-002','Mix Veg',89.00),
('itm-003','Paneer Butter Masala',150.00),
('itm-004','Rice',60.00);

select * from items;


INSERT INTO booking_commercials VALUES
('id-001','bk-001','bill-001','2021-10-05 12:00:00','itm-001',3),
('id-002','bk-001','bill-001','2021-10-05 12:00:00','itm-002',2),

('id-003','bk-002','bill-002','2021-11-12 15:00:00','itm-003',1),
('id-004','bk-002','bill-002','2021-11-12 15:00:00','itm-004',2),

('id-005','bk-003','bill-003','2021-11-25 10:00:00','itm-001',5),
('id-006','bk-003','bill-003','2021-11-25 10:00:00','itm-003',2),

('id-007','bk-004','bill-004','2021-12-01 19:00:00','itm-002',10),
('id-008','bk-004','bill-004','2021-12-01 19:00:00','itm-004',5);

select * from booking_commercials;


#First Question
SELECT b.user_id, b.room_no
FROM bookings b
JOIN (
    SELECT user_id, MAX(booking_date) AS last_booking
    FROM bookings
    GROUP BY user_id
) lb
ON b.user_id = lb.user_id 
AND b.booking_date = lb.last_booking;

#2nd Question
select bc.booking_id,sum(bc.item_quantity*it.item_rate) as 
total_billing_amount
from booking_commercials 
bc join items it on bc.item_id=it.item_id
where month(bc.bill_date)=11 and year(bc.bill_date)=2021
group by bc.booking_id order by total_billing_amount desc
;

#3rd Question

select bc.bill_id, sum(bc.item_quantity*it.item_rate) as bill_amount from 
booking_commercials bc join items it
on bc.item_id=it.item_id
where month(bc.bill_date)=10 and year(bc.bill_date)=2021
group by bc.bill_id 
having bill_amount>1000;
	
SELECT *
FROM (
    SELECT 
    MONTH(bc.bill_date) AS month,
    bc.item_id,
    SUM(bc.item_quantity) AS total_qty,
    RANK() OVER (PARTITION BY MONTH(bc.bill_date)
    ORDER BY SUM(bc.item_quantity) DESC) AS rnk_desc,
    RANK() OVER (PARTITION BY MONTH(bc.bill_date) 
    ORDER BY SUM(bc.item_quantity) ASC) AS rnk_asc
FROM booking_commercials bc
WHERE YEAR(bc.bill_date) = 2021
GROUP BY MONTH(bc.bill_date), bc.item_id
) t
WHERE rnk_desc = 1 OR rnk_asc = 1;


#5 Question

SELECT user_id, bill_id, bill_amount, month
FROM (
    SELECT b.user_id,
        bc.bill_id,
        MONTH(bc.bill_date) AS month,
        SUM(bc.item_quantity * i.item_rate) AS bill_amount,
        DENSE_RANK() OVER (
            PARTITION BY MONTH(bc.bill_date) 
            ORDER BY SUM(bc.item_quantity * i.item_rate) DESC
        ) AS rnk
    FROM booking_commercials bc
    JOIN bookings b ON bc.booking_id = b.booking_id
    JOIN items i ON bc.item_id = i.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY b.user_id, bc.bill_id, MONTH(bc.bill_date)
) t
WHERE rnk = 2;



# Clinic management system

CREATE TABLE clinics (
    cid VARCHAR(50) PRIMARY KEY,
    clinic_name VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE customer (
    uid VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100),
    mobile VARCHAR(15)
);

CREATE TABLE clinic_sales (
    oid VARCHAR(50) PRIMARY KEY,
    uid VARCHAR(50),
    cid VARCHAR(50),
    amount DECIMAL(10,2),
    datetime DATETIME,
    sales_channel VARCHAR(50),
    FOREIGN KEY (uid) REFERENCES customer(uid),
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

CREATE TABLE expenses (
    eid VARCHAR(50) PRIMARY KEY,
    cid VARCHAR(50),
    description VARCHAR(100),
    amount DECIMAL(10,2),
    datetime DATETIME,
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

INSERT INTO clinics VALUES
('cnc-001','XYZ Clinic','Bangalore','Karnataka','India'),
('cnc-002','ABC Clinic','Hyderabad','Telangana','India'),
('cnc-003','Health Plus','Bangalore','Karnataka','India');

INSERT INTO customer VALUES
('u-001','John Doe','9700000001'),
('u-002','Jane Smith','9700000002'),
('u-003','Rahul Kumar','9700000003');

INSERT INTO clinic_sales VALUES
('ord-001','u-001','cnc-001',25000,'2021-09-10 10:00:00','online'),
('ord-002','u-002','cnc-001',15000,'2021-09-15 12:00:00','offline'),
('ord-003','u-001','cnc-002',30000,'2021-09-20 14:00:00','online'),
('ord-004','u-003','cnc-003',20000,'2021-10-05 11:00:00','referral'),
('ord-005','u-002','cnc-002',18000,'2021-10-10 16:00:00','online');

INSERT INTO expenses VALUES
('exp-001','cnc-001','Medicines',5000,'2021-09-12 09:00:00'),
('exp-002','cnc-002','Equipment',8000,'2021-09-18 10:00:00'),
('exp-003','cnc-003','Maintenance',4000,'2021-10-06 08:00:00'),
('exp-004','cnc-001','Staff Salary',6000,'2021-10-01 09:00:00');

#1st Question

SELECT 
    sales_channel,
    SUM(amount) AS total_revenue
FROM clinic_sales
WHERE YEAR(datetime) = 2021
GROUP BY sales_channel;

#2nd Question

select c.uid,c.name,sum(cs.amount) as total_spent from customer c join clinic_sales cs 
on c.uid=cs.uid where year(cs.datetime)=2021 group by c.uid,c.name order by total_spent limit 10;

#3rd Question

SELECT 
    m.month,
    m.revenue,
    e.expense,
    (m.revenue - IFNULL(e.expense,0)) AS profit,
    CASE 
        WHEN (m.revenue - IFNULL(e.expense,0)) > 0 THEN 'PROFITABLE'
        ELSE 'NOT-PROFITABLE'
    END AS status
FROM (
    SELECT 
        MONTH(datetime) AS month,
        SUM(amount) AS revenue
    FROM clinic_sales
    WHERE YEAR(datetime) = 2021
    GROUP BY MONTH(datetime)
) m
LEFT JOIN (
    SELECT 
        MONTH(datetime) AS month,
        SUM(amount) AS expense
    FROM expenses
    WHERE YEAR(datetime) = 2021
    GROUP BY MONTH(datetime)
) e
ON m.month = e.month;

#4th Question

SELECT city, cid, profit
FROM (
    SELECT 
        cl.city,
        cs.cid,
        SUM(cs.amount) - IFNULL(SUM(e.amount),0) AS profit,
        RANK() OVER (
            PARTITION BY cl.city 
            ORDER BY SUM(cs.amount) - IFNULL(SUM(e.amount),0) DESC
        ) AS rnk
    FROM clinic_sales cs
    JOIN clinics cl ON cs.cid = cl.cid
    LEFT JOIN expenses e 
    ON cs.cid = e.cid 
    AND MONTH(e.datetime) = 9 
    AND YEAR(e.datetime) = 2021
    WHERE MONTH(cs.datetime) = 9 
      AND YEAR(cs.datetime) = 2021
    GROUP BY cl.city, cs.cid
) t
WHERE rnk = 1;

#5th Question 

SELECT state, cid, profit
FROM (
    SELECT 
        cl.state,
        cs.cid,
        SUM(cs.amount) - IFNULL(SUM(e.amount),0) AS profit,
        DENSE_RANK() OVER (
            PARTITION BY cl.state 
            ORDER BY SUM(cs.amount) - IFNULL(SUM(e.amount),0) ASC
        ) AS rnk
    FROM clinic_sales cs
    JOIN clinics cl ON cs.cid = cl.cid
    LEFT JOIN expenses e 
    ON cs.cid = e.cid 
    AND MONTH(e.datetime) = 9 AND YEAR(e.datetime) = 2021
    WHERE MONTH(cs.datetime) = 9 
      AND YEAR(cs.datetime) = 2021
    GROUP BY cl.state, cs.cid
) t
WHERE rnk = 2;