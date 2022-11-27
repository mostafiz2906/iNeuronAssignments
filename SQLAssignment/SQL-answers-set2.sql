--Q51:

CREATE TABLE world
(
  name VARCHAR(25),
  continent VARCHAR(10),
  area INT,
  population INT,
  gdp BIGINT,
  CONSTRAINT pk_world PRIMARY KEY (name)
);

INSERT INTO world VALUES('Afghanistan', 'Asia', 652230, 25500100, 20343000000);
INSERT INTO world VALUES('Albania', 'Europe', 28748, 2831741, 12960000000);
INSERT INTO world VALUES('Algeria', 'Africa', 2381741, 37100000, 188681000000);
INSERT INTO world VALUES('Andorra', 'Europe', 468, 78115, 3712000000);
INSERT INTO world VALUES('Angola', 'Africa', 1246700, 20609294, 100990000000);

SELECT 
  name,
  population,
  area
FROM 
  world
WHERE
  area >= 3000000
  OR population >= 25000000
;

--drop tables

DROP TABLE world;


--Q52:

CREATE TABLE customer
(
  id INT,
  name VARCHAR(25),
  referee_id BIGINT,
  CONSTRAINT pk_customer PRIMARY KEY (id)
);

INSERT INTO customer VALUES(1, 'Will', null);
INSERT INTO customer VALUES(2, 'Jane', null);
INSERT INTO customer VALUES(3, 'Alex', 2);
INSERT INTO customer VALUES(4, 'Bill', null);
INSERT INTO customer VALUES(5, 'Zack', 1);
INSERT INTO customer VALUES(6, 'Mark', 2);

SELECT 
  name
FROM 
  customer
WHERE
  referee_id <> 2
  OR referee_id IS NULL
;

--drop tables

DROP TABLE customer;


--Q53:

CREATE TABLE customers
(
  id INT,
  name VARCHAR(25),
  CONSTRAINT pk_customers PRIMARY KEY (id)
);

CREATE TABLE orders
(
  id INT,
  customer_id INT,
  CONSTRAINT pk_orders PRIMARY KEY (id),
  CONSTRAINT fk_customer_order FOREIGN KEY(customer_id)
    REFERENCES customers(id)
);

INSERT INTO customers VALUES(1, 'Joe');
INSERT INTO customers VALUES(2, 'Henry');
INSERT INTO customers VALUES(3, 'Sam');
INSERT INTO customers VALUES(4, 'Max');

INSERT INTO orders VALUES(1, 3);
INSERT INTO orders VALUES(2, 1);

SELECT 
  name
FROM 
  customers c
WHERE
  NOT EXISTS(
    SELECT
      *
    FROM
      orders o
    WHERE c.id = o.customer_id
  )
;

--drop tables

DROP TABLE orders;
DROP TABLE customers;


--Q54:

CREATE TABLE employee
(
  employee_id INT,
  team_id INT,
  CONSTRAINT pk_employee PRIMARY KEY (employee_id)
);

INSERT INTO employee VALUES(1, 8);
INSERT INTO employee VALUES(2, 8);
INSERT INTO employee VALUES(3, 8);
INSERT INTO employee VALUES(4, 7);
INSERT INTO employee VALUES(5, 9);
INSERT INTO employee VALUES(6, 9);

SELECT 
  employee_id,
  count(*) OVER(PARTITION BY team_id) AS team_size
FROM 
  employee
;

--drop tables

DROP TABLE employee;


--Q55:

CREATE TABLE person
(
  id INT,
  name VARCHAR(25),
  phone_number VARCHAR(11),
  CONSTRAINT pk_person PRIMARY KEY (id)
);

CREATE TABLE country
(
  name VARCHAR(25),
  country_code VARCHAR(3),
  CONSTRAINT pk_country PRIMARY KEY (country_code)
);

CREATE TABLE calls
(
  caller_id INT,
  callee_id INT,
  duration INT
);

INSERT INTO person VALUES(3, 'Jonathan', '051-1234567');
INSERT INTO person VALUES(12, 'Elvis', '051-7654321');
INSERT INTO person VALUES(1, 'Moncef', '212-1234567');
INSERT INTO person VALUES(2, 'Maroua', '212-6523651');
INSERT INTO person VALUES(7, 'Meir', '972-1234567');
INSERT INTO person VALUES(9, 'Rachel', '972-0011100');

INSERT INTO country VALUES('Peru', '51');
INSERT INTO country VALUES('Israel', '972');
INSERT INTO country VALUES('Morocco', '212');
INSERT INTO country VALUES('Germany', '49');
INSERT INTO country VALUES('Ethiopia', '251');

INSERT INTO calls VALUES(1, 9, 33);
INSERT INTO calls VALUES(2, 9, 4);
INSERT INTO calls VALUES(1, 2, 59);
INSERT INTO calls VALUES(3, 12, 102);
INSERT INTO calls VALUES(3, 12, 330);
INSERT INTO calls VALUES(12, 3, 5);
INSERT INTO calls VALUES(7, 9, 13);
INSERT INTO calls VALUES(7, 1, 3);
INSERT INTO calls VALUES(9, 7, 1);
INSERT INTO calls VALUES(1, 7, 7);

WITH receiver_caller_calls AS(
  SELECT
    caller_id AS caller_receiver_id,
    duration
  FROM
    calls
  UNION ALL
  SELECT
    callee_id AS caller_receiver_id,
    duration
  FROM
    calls
),
call_duration_avg AS(
  SELECT
    DISTINCT cn.name,
    avg(c.duration) OVER() as global_average,
    avg(c.duration) OVER(PARTITION BY cn.name) as country_average
  FROM 
    person p
    JOIN country cn 
      ON  CAST(SUBSTRING_INDEX(p.phone_number, '-', 1) AS UNSIGNED) =  CAST(cn.country_code AS UNSIGNED)
    JOIN receiver_caller_calls c
      ON c.caller_receiver_id = p.id
)
SELECT
  name
FROM
  call_duration_avg
WHERE
  country_average > global_average
;

--drop tables

DROP TABLE person;
DROP TABLE country;
DROP TABLE calls;


--Q56:

CREATE TABLE activity
(
  player_id INT,
  device_id INT,
  event_date DATE,
  games_played INT
);

INSERT INTO activity VALUES(1, 2, '2016-03-01', 5);
INSERT INTO activity VALUES(1, 2, '2016-05-02', 6);
INSERT INTO activity VALUES(2, 3, '2017-06-25', 1);
INSERT INTO activity VALUES(3, 1, '2016-03-02', 0);
INSERT INTO activity VALUES(3, 4, '2018-07-03', 5);

WITH activity_with_device_serial AS(
  SELECT
    player_id,
    device_id,
    DENSE_RANK() OVER(PARTITION BY player_id ORDER BY event_date) as device_serial
  FROM 
    activity
)
SELECT
  player_id,
  device_id
FROM
  activity_with_device_serial
WHERE
  device_serial = 1
;

--drop tables

DROP TABLE activity;


--Q57:

CREATE TABLE orders
(
  order_number INT,
  customer_number INT,
  CONSTRAINT pk_orders PRIMARY KEY (order_number)
);

INSERT INTO orders VALUES(1, 1);
INSERT INTO orders VALUES(2, 2);
INSERT INTO orders VALUES(3, 3);
INSERT INTO orders VALUES(4, 3);

WITH customer_with_no_of_order AS(
  SELECT
    customer_number,
    count(*) AS no_of_order
  FROM 
    orders
  GROUP BY customer_number
)
SELECT
  customer_number
FROM
  customer_with_no_of_order
ORDER BY no_of_order DESC
LIMIT 1;

--Follow Up:

INSERT INTO orders VALUES(5, 2);

WITH customer_with_no_of_order AS(
  SELECT
    customer_number,
    count(*) AS no_of_order
  FROM 
    orders
  GROUP BY customer_number
)
SELECT
  customer_number
FROM
  customer_with_no_of_order
WHERE 
  no_of_order IN (
    SELECT
      max(no_of_order) AS max_no_of_order
    FROM
      customer_with_no_of_order
  )
;

--drop tables

DROP TABLE orders;


--Q58:

CREATE TABLE cinema
(
  seat_id INT AUTO_INCREMENT,
  free BOOLEAN,
  CONSTRAINT pk_cinema PRIMARY KEY (seat_id)
);

INSERT INTO cinema(free) VALUES(TRUE);
INSERT INTO cinema(free) VALUES(FALSE);
INSERT INTO cinema(free) VALUES(TRUE);
INSERT INTO cinema(free) VALUES(TRUE);
INSERT INTO cinema(free) VALUES(TRUE);

WITH seat_id_with_diff_with_next_val AS (
  SELECT
    seat_id,
    seat_id - LEAD(seat_id, 1) OVER(ORDER BY seat_id) AS diff_next_val,
    seat_id - LAG(seat_id, 1) OVER(ORDER BY seat_id) AS diff_prev_val
  FROM
    cinema
  WHERE
    free <> 0
)
SELECT
  seat_id
FROM
  seat_id_with_diff_with_next_val
WHERE 
  diff_next_val = -1
  OR diff_prev_val = 1
;

--drop tables

DROP TABLE cinema;


--Q59:

CREATE TABLE sales_person
(
  sales_id INT,
  name VARCHAR(25),
  salary INT,
  commission_rate INT,
  hire_rate DATE,
  CONSTRAINT pk_sales_person PRIMARY KEY (sales_id)
);

CREATE TABLE company
(
  com_id INT,
  name VARCHAR(25),
  city VARCHAR(25),
  CONSTRAINT pk_company PRIMARY KEY (com_id)
);

CREATE TABLE orders
(
  order_id INT,
  order_date DATE,
  com_id INT,
  sales_id INT,
  amount INT,
  CONSTRAINT pk_orders PRIMARY KEY (order_id),
  CONSTRAINT fk_company FOREIGN KEY (com_id)
    REFERENCES company(com_id),
  CONSTRAINT fk_sales_person FOREIGN KEY (sales_id)
    REFERENCES sales_person(sales_id)
);


INSERT INTO sales_person VALUES(1, 'John', 100000, 6, '2006-04-01');
INSERT INTO sales_person VALUES(2, 'Amy', 12000, 5, '2010-05-01');
INSERT INTO sales_person VALUES(3, 'Mark', 65000, 12, '2008-12-25');
INSERT INTO sales_person VALUES(4, 'Pam', 25000, 25, '2005-01-01');
INSERT INTO sales_person VALUES(5, 'Alex', 5000, 10, '2007-02-03');

INSERT INTO company VALUES(1, 'RED', 'Boston');
INSERT INTO company VALUES(2, 'ORANGE', 'New York');
INSERT INTO company VALUES(3, 'YELLOW', 'Boston');
INSERT INTO company VALUES(4, 'GREEN', 'Austin');


INSERT INTO orders VALUES(1, '2014-01-01', 3, 4, 10000);
INSERT INTO orders VALUES(2, '2014-02-01', 4, 5, 5000);
INSERT INTO orders VALUES(3, '2014-03-01', 1, 1, 50000);
INSERT INTO orders VALUES(4, '2014-04-01', 1, 4, 25000);

SELECT
  name
FROM
  sales_person sp
WHERE
  NOT EXISTS(
    SELECT
      *
    FROM
      orders o
      JOIN company c ON o.com_id = c.com_id
    WHERE
      sp.sales_id = o.sales_id
      AND c.name = 'RED'
  )
;

--drop tables

DROP TABLE orders;
DROP TABLE company;
DROP TABLE sales_person;


--Q60:

CREATE TABLE triangle
(
  x INT,
  y INT,
  z INT,
  CONSTRAINT pk_triangle PRIMARY KEY (x,y,z)
);

INSERT INTO triangle VALUES(13, 15, 30);
INSERT INTO triangle VALUES(10, 20, 15);

SELECT
  *,
  CASE
    WHEN x + y > z AND y + z > x AND z + x > y
      THEN 'Yes'
    ELSE 'No'
  END as triangle
FROM
  triangle
;

--drop tables

DROP TABLE triangle;


--Q61:

CREATE TABLE point
(
  x INT,
  CONSTRAINT pk_point PRIMARY KEY (x)
);

INSERT INTO point VALUES(-1);
INSERT INTO point VALUES(0);
INSERT INTO point VALUES(2);

SELECT
  MIN(ABS(p1.x - p2.x)) AS shortest
FROM 
  point p1
  JOIN point p2 ON p1.x <> p2.x
;

--Follow Up:

WITH ordered_point AS(
  SELECT
    x,
    ROW_NUMBER() OVER(ORDER BY x) AS ordered_no
  FROM
    point 
)
SELECT
  MIN(ABS(p1.x - p2.x)) AS shortest
FROM 
  ordered_point p1
  JOIN ordered_point p2 ON p2.ordered_no > p1.ordered_no
;

--drop tables

DROP TABLE point;


--Q62:

CREATE TABLE actor_director
(
  actor_id INT,
  director_id INT,
  timestamp INT,
  CONSTRAINT pk_actor_director PRIMARY KEY (timestamp)
);

INSERT INTO actor_director VALUES(1, 1, 0);
INSERT INTO actor_director VALUES(1, 1, 1);
INSERT INTO actor_director VALUES(1, 1, 2);
INSERT INTO actor_director VALUES(1, 2, 3);
INSERT INTO actor_director VALUES(1, 2, 4);
INSERT INTO actor_director VALUES(2, 1, 5);
INSERT INTO actor_director VALUES(2, 1, 6);

SELECT
  actor_id,
  director_id
FROM 
  actor_director
GROUP BY
  actor_id,
  director_id
HAVING 
  count(*) >= 3
;

--drop tables

DROP TABLE actor_director;


--Q63:

CREATE TABLE product
(
  product_id INT,
  product_name VARCHAR(25),
  CONSTRAINT pk_product PRIMARY KEY (product_id)
);

CREATE TABLE sales
(
  sale_id INT,
  product_id INT,
  year INT,
  quantity INT,
  price INT,
  CONSTRAINT pk_sales PRIMARY KEY (sale_id, year),
  CONSTRAINT fk_product FOREIGN KEY (product_id)
    REFERENCES product(product_id)
);

INSERT INTO product VALUES(100, 'Nokia');
INSERT INTO product VALUES(200, 'Apple');
INSERT INTO product VALUES(300, 'Samsung');

INSERT INTO sales VALUES(1, 100, 2008, 10, 5000);
INSERT INTO sales VALUES(2, 100, 2009, 12, 5000);
INSERT INTO sales VALUES(7, 200, 2011, 15, 9000);

SELECT
  product_name,
  year,
  price
FROM
  product p
  JOIN sales s ON p.product_id = s.product_id
;

--drop tables

DROP TABLE sales;
DROP TABLE product;


--Q64:

CREATE TABLE employee
(
  employee_id INT,
  name VARCHAR(25),
  experience_years INT,
  CONSTRAINT pk_employee PRIMARY KEY (employee_id)
);

CREATE TABLE project
(
  project_id INT,
  employee_id INT,
  CONSTRAINT pk_project PRIMARY KEY (project_id, employee_id),
  CONSTRAINT fk_employee FOREIGN KEY (employee_id)
    REFERENCES employee(employee_id)
);

INSERT INTO employee VALUES(1, 'Khaled', 3);
INSERT INTO employee VALUES(2, 'Ali', 2);
INSERT INTO employee VALUES(3, 'John', 1);
INSERT INTO employee VALUES(4, 'Doe', 2);

INSERT INTO project VALUES(1, 1);
INSERT INTO project VALUES(1, 2);
INSERT INTO project VALUES(1, 3);
INSERT INTO project VALUES(2, 1);
INSERT INTO project VALUES(2, 4);

SELECT
  p.project_id,
  ROUND(avg(e.experience_years),2) AS average_years
FROM 
  project p
  JOIN employee e ON p.employee_id = e. employee_id
GROUP BY p.project_id
;

--drop tables

DROP TABLE project;
DROP TABLE employee;


--Q65:

CREATE TABLE product
(
  product_id INT,
  product_name VARCHAR(25),
  unit_price INT,
  CONSTRAINT pk_product PRIMARY KEY (product_id)
);

CREATE TABLE sales
(
  seller_id INT,
  product_id INT,
  buyer_id INT,
  sale_date DATE,
  quantity INT,
  price INT,
  CONSTRAINT fk_product FOREIGN KEY (product_id)
    REFERENCES product(product_id)
);

INSERT INTO product VALUES(1, 'S8', 1000);
INSERT INTO product VALUES(2, 'G4', 800);
INSERT INTO product VALUES(3, 'iPhone', 1400);

INSERT INTO sales VALUES(1, 1, 1, '2019-01-21', 2, 2000);
INSERT INTO sales VALUES(1, 2, 2, '2019-02-17', 1, 800);
INSERT INTO sales VALUES(2, 2, 3, '2019-06-02', 1, 800);
INSERT INTO sales VALUES(3, 3, 4, '2019-05-13', 2, 2800);

WITH sales_rank AS(
  SELECT
    seller_id,
    sum(price) AS total_sales,
    DENSE_RANK() OVER(ORDER BY sum(price) DESC) rank_by_sales
  FROM
    sales
  GROUP BY
    seller_id
)
SELECT
  seller_id
FROM
  sales_rank
WHERE
  rank_by_sales = 1
;

--drop tables

DROP TABLE sales;
DROP TABLE product;


--Q66:

CREATE TABLE product
(
  product_id INT,
  product_name VARCHAR(25),
  unit_price INT,
  CONSTRAINT pk_product PRIMARY KEY (product_id)
);

CREATE TABLE sales
(
  seller_id INT,
  product_id INT,
  buyer_id INT,
  sale_date DATE,
  quantity INT,
  price INT,
  CONSTRAINT fk_product FOREIGN KEY (product_id)
    REFERENCES product(product_id)
);

INSERT INTO product VALUES(1, 'S8', 1000);
INSERT INTO product VALUES(2, 'G4', 800);
INSERT INTO product VALUES(3, 'iPhone', 1400);

INSERT INTO sales VALUES(1, 1, 1, '2019-01-21', 2, 2000);
INSERT INTO sales VALUES(1, 2, 2, '2019-02-17', 1, 800);
INSERT INTO sales VALUES(2, 1, 3, '2019-06-02', 1, 800);
INSERT INTO sales VALUES(3, 3, 3, '2019-05-13', 2, 2800);

WITH s8_iphone_sales AS(
  SELECT
    s.buyer_id,
    p.product_name
  FROM
    sales s  
    JOIN product p ON s.product_id = p.product_id
  WHERE
    p.product_name = 'S8'
    OR p.product_name = 'iPhone'
)

SELECT
  s1.buyer_id
FROM
  s8_iphone_sales s1
  LEFT JOIN s8_iphone_sales s2 
    ON (s1.product_name = 'S8'
      OR s1.product_name = 'iPhone')
      AND s2.product_name = 'iPhone' 
      AND s1.buyer_id = s2.buyer_id
WHERE
  s2.buyer_id is null
;

--drop tables

DROP TABLE sales;
DROP TABLE product;


--Q67:

CREATE TABLE customer
(
  customer_id INT,
  name VARCHAR(25),
  visited_on DATE,
  amount INT,
  CONSTRAINT pk_customer PRIMARY KEY (customer_id, visited_on)
);

INSERT INTO customer VALUES(1, 'Jhon', '2019-01-01', 100);
INSERT INTO customer VALUES(2, 'Daniel', '2019-01-02', 110);
INSERT INTO customer VALUES(3, 'Jade', '2019-01-03', 120);
INSERT INTO customer VALUES(4, 'Khaled', '2019-01-04', 130);
INSERT INTO customer VALUES(5, 'Winston', '2019-01-05', 110);
INSERT INTO customer VALUES(6, 'Elvis', '2019-01-06', 140);
INSERT INTO customer VALUES(7, 'Anna', '2019-01-07', 150);
INSERT INTO customer VALUES(8, 'Maria', '2019-01-08', 80);
INSERT INTO customer VALUES(9, 'Jaze', '2019-01-09', 110);
INSERT INTO customer VALUES(1, 'Jhon', '2019-01-10', 130);
INSERT INTO customer VALUES(3, 'Jade', '2019-01-10', 150);

WITH daily_sales AS(
  SELECT 
    visited_on,
    sum(amount) AS daily_sales_total_amount
  FROM
    customer
  GROUP BY visited_on
)
SELECT
  visited_on,
  sum(daily_sales_total_amount) 
    OVER(ORDER BY visited_on RANGE BETWEEN INTERVAL '6' day PRECEDING AND CURRENT ROW) AS amount,
  ROUND(avg(daily_sales_total_amount) 
    OVER(ORDER BY visited_on RANGE BETWEEN INTERVAL '6' day PRECEDING AND CURRENT ROW), 2) AS average_amount
FROM
  daily_sales
LIMIT 6,18446744073709551615
;

--drop tables

DROP TABLE customer;


--Q68:

CREATE TABLE scores
(
  player_name VARCHAR(25),
  gender VARCHAR(1),
  day DATE,
  score_points INT,
  CONSTRAINT pk_scores PRIMARY KEY (gender, day)
);

INSERT INTO scores VALUES('Aron', 'F', '2020-01-01', 17);
INSERT INTO scores VALUES('Alice', 'F', '2020-01-07', 23);
INSERT INTO scores VALUES('Bajrang', 'M', '2020-01-07', 7);
INSERT INTO scores VALUES('Khali' , 'M', '2019-12-25', 11);
INSERT INTO scores VALUES('Slaman', 'M', '2019-12-30', 13);
INSERT INTO scores VALUES('Joe', 'M', '2019-12-31', 3);
INSERT INTO scores VALUES('Jose', 'M', '2019-12-18', 2);
INSERT INTO scores VALUES('Priya', 'F', '2019-12-31', 23);
INSERT INTO scores VALUES('Priyanka', 'F', '2019-12-30', 17);

SELECT
  gender,
  day,
  sum(score_points) OVER(PARTITION BY gender ORDER BY day) AS total
FROM
  scores
;

--drop tables

DROP TABLE scores;


--Q69:

CREATE TABLE logs
(
  log_id INT,
  CONSTRAINT pk_logs PRIMARY KEY (log_id)
);

INSERT INTO logs VALUES(1),(2),(3),(7),(8),(10);

WITH log_id_with_diff_with_next_val AS (
  SELECT
    log_id,
    IFNULL(log_id - LEAD(log_id, 1) OVER(ORDER BY log_id), 0) AS diff_next_val,
    IFNULL(log_id - LAG(log_id, 1) OVER(ORDER BY log_id), 0) AS diff_prev_val
  FROM
    logs
),
start_end_logs AS(
  SELECT
    CASE
      WHEN ABS(diff_next_val) = 1
          OR (ABS(diff_next_val) <> 1
            AND ABS(diff_prev_val) <> 1)
        THEN log_id
    END start_id,
    CASE
      WHEN ABS(LEAD(diff_prev_val) OVER(ORDER BY log_id)) = 1  
        THEN LEAD(log_id) OVER(ORDER BY log_id)
      WHEN (ABS(diff_next_val) <> 1
            AND ABS(diff_prev_val) <> 1)
        THEN log_id
    END end_id

  FROM
    log_id_with_diff_with_next_val
  WHERE
    NOT (
      ABS(IFNULL(diff_next_val, 0)) = 1
      AND ABS(IFNULL(diff_prev_val, 0)) = 1
    )
)
SELECT
  *
FROM
  start_end_logs
WHERE
  start_id IS NOT NULL
;

--drop tables

DROP TABLE logs;


--Q70:

CREATE TABLE students
(
  student_id INT,
  student_name VARCHAR(25),
  CONSTRAINT pk_students PRIMARY KEY (student_id)
);

CREATE TABLE subjects
(
  subject_name VARCHAR(25),
  CONSTRAINT pk_students PRIMARY KEY (subject_name)
);

CREATE TABLE examinations
(
  student_id INT,
  subject_name VARCHAR(25)
);

INSERT INTO students VALUES(1, 'Alice');
INSERT INTO students VALUES(2, 'Bob');
INSERT INTO students VALUES(13, 'John');
INSERT INTO students VALUES(6,'Alex');

INSERT INTO subjects VALUES('Math');
INSERT INTO subjects VALUES('Physics');
INSERT INTO subjects VALUES('Programming');

INSERT INTO examinations VALUES(1,'Math');
INSERT INTO examinations VALUES(1, 'Physics');
INSERT INTO examinations VALUES(1, 'Programming');
INSERT INTO examinations VALUES(2, 'Programming');
INSERT INTO examinations VALUES(1, 'Physics');
INSERT INTO examinations VALUES(1, 'Math');
INSERT INTO examinations VALUES(13, 'Math');
INSERT INTO examinations VALUES(13, 'Programming');
INSERT INTO examinations VALUES(13, 'Physics');
INSERT INTO examinations VALUES(2, 'Math');
INSERT INTO examinations VALUES(1, 'Math');


SELECT
  st.student_id,
  st.student_name,
  sb.subject_name,
  sum(
    CASE
      WHEN ex.subject_name IS NOT NULL
        THEN 1
      ELSE
        0
    END
  ) as attended_exams
FROM students st
  JOIN subjects sb
  LEFT JOIN examinations ex ON ex.subject_name = sb.subject_name
    AND st.student_id = ex.student_id
GROUP BY 
  st.student_id,
  st.student_name,
  sb.subject_name
ORDER BY
  st.student_id,
  st.student_name
;

--drop tables

DROP TABLE students;
DROP TABLE subjects;
DROP TABLE examinations;


--Q71:

CREATE TABLE employees
(
  employee_id INT,
  employee_name VARCHAR(25),
  manager_id INT,
  CONSTRAINT pk_employees PRIMARY KEY(employee_id)
);

INSERT INTO employees VALUES(1, 'Boss', 1);
INSERT INTO employees VALUES(3, 'Alice', 3);
INSERT INTO employees VALUES(2, 'Bob', 1);
INSERT INTO employees VALUES(4, 'Daniel', 2);
INSERT INTO employees VALUES(7, 'Luis', 4);
INSERT INTO employees VALUES(8, 'Jhon', 3);
INSERT INTO employees VALUES(9, 'Angela', 8);
INSERT INTO employees VALUES(77, 'Robert', 1);


WITH RECURSIVE emp_hir AS  
(
  SELECT
    employee_id,
    manager_id,
    employee_name,
    1 as lvl 
  FROM 
    employees 
  WHERE
    employee_name = 'Boss'
  UNION
  SELECT 
    em.employee_id,
    em.manager_id, 
    em.employee_name,
    eh.lvl + 1 as lvl 
  FROM
    emp_hir eh 
    JOIN employees em ON eh.employee_id = em.manager_id
  WHERE
    em.employee_name <> 'Boss'
)
SELECT 
  eh1.employee_id 
FROM 
  emp_hir eh1
WHERE
  eh1.employee_name <> 'Boss'
;

--drop tables

DROP TABLE employees;


--Q72:

CREATE TABLE transactions
(
  id INT,
  country VARCHAR(25),
  state VARCHAR(15),
  amount INT,
  trans_date DATE,
  CONSTRAINT pk_trx PRIMARY KEY(id)
);

INSERT INTO transactions VALUES(121, 'US', 'approved', 1000, '2018-12-18');
INSERT INTO transactions VALUES(122, 'US', 'declined', 2000, '2018-12-19');
INSERT INTO transactions VALUES(123, 'US', 'approved', 2000, '2019-01-01');
INSERT INTO transactions VALUES(124, 'DE', 'approved', 2000, '2019-01-07');

SELECT
  DATE_FORMAT(trans_date, '%Y-%m') AS month,
  country,
  COUNT(*) AS trans_count,
  COUNT(
    CASE
      WHEN state = 'approved'
        THEN id
    END
  ) AS approved_count,
  SUM(amount) AS trans_total_amount,
  SUM(
    CASE
      WHEN state = 'approved'
        THEN amount
    END
  ) AS approved_total_amount
FROM
  transactions
GROUP BY
  DATE_FORMAT(trans_date, '%Y-%m'),
  country
;

--drop tables

DROP TABLE transactions;

--Q73:

CREATE TABLE actions
(
  user_id INT,
  post_id INT,
  action_date DATE,
  action VARCHAR(15),
  extra VARCHAR(25)
);

CREATE TABLE removals
(
  post_id INT,
  remove_date DATE
);

INSERT INTO actions VALUES(1, 1, '2019-07-01','view', null);
INSERT INTO actions VALUES(1, 1, '2019-07-01', 'like', null);
INSERT INTO actions VALUES(1, 1, '2019-07-01', 'share', null);
INSERT INTO actions VALUES(2, 2, '2019-07-04', 'view', null);
INSERT INTO actions VALUES(2, 2, '2019-07-04', 'report', 'spam');
INSERT INTO actions VALUES(3, 4, '2019-07-04', 'view', null);
INSERT INTO actions VALUES(3, 4, '2019-07-04', 'report', 'spam');
INSERT INTO actions VALUES(4, 3, '2019-07-02', 'view', null);
INSERT INTO actions VALUES(4, 3, '2019-07-02', 'report', 'spam');
INSERT INTO actions VALUES(5, 2, '2019-07-03', 'view', null);
INSERT INTO actions VALUES(5, 2, '2019-07-03', 'report', 'racism');
INSERT INTO actions VALUES(5, 5, '2019-07-03', 'view', null);
INSERT INTO actions VALUES(5, 5, '2019-07-03', 'report', 'racism');

INSERT INTO removals VALUES(2, '2019-07-20');
INSERT INTO removals VALUES(3, '2019-07-18');

WITH reported_removed_stat AS(
  SELECT
    a.action_date,
    COUNT(*) AS total_reported,
    COUNT(
      CASE
        WHEN r.post_id IS NOT NULL
          THEN r.post_id
      END
    ) AS total_removed
  FROM
    actions a
    LEFT JOIN removals r ON r.post_id = a.post_id
  WHERE
    a.action = 'report'
    AND a.extra = 'spam'
  GROUP BY
    a.action_date
),
daily_pct AS(
  SELECT
    action_date,
    (total_removed)*100.00/total_reported as daily_ratio
  FROM
    reported_removed_stat
  GROUP BY 
    action_date
)
SELECT
  ROUND(AVG(daily_ratio), 2) AS average_daily_percent
FROM
  daily_pct
;

--drop tables

DROP TABLE actions;
DROP TABLE removals;


--Q74:

CREATE TABLE activity
(
  player_id INT,
  device_id INT,
  event_date DATE,
  games_played INT,
  CONSTRAINT pk_activity PRIMARY KEY(player_id, event_date)
);

INSERT INTO activity VALUES(1, 2, '2016-03-01', 5);
INSERT INTO activity VALUES(1 ,2, '2016-03-02', 6);
INSERT INTO activity VALUES(2, 3, '2017-06-25', 1);
INSERT INTO activity VALUES(3, 1, '2016-03-02', 0);
INSERT INTO activity VALUES(3, 4, '2018-07-03', 5);

WITH logged_in_prev_day AS(
  SELECT
    count(DISTINCT player_id) AS player_count
  FROM
    activity a1
  WHERE
    EXISTS(
      SELECT
        *
      FROM
        activity a2
      WHERE
        a1.player_id = a2.player_id
        AND a1.event_date = DATE_ADD(a2.event_date, INTERVAL 1 DAY)
    )
),
all_player AS(
  SELECT
    count(DISTINCT player_id) AS total_player_count
  FROM
    activity
)
SELECT
  ROUND(
    (SELECT
      player_count
    FROM
      logged_in_prev_day)*1.00/
    (SELECT
      total_player_count
    FROM
    all_player)
  ,2) AS fraction
;

--drop tables

DROP TABLE activity;


--Q75:

CREATE TABLE activity
(
  player_id INT,
  device_id INT,
  event_date DATE,
  games_played INT,
  CONSTRAINT pk_activity PRIMARY KEY(player_id, event_date)
);

INSERT INTO activity VALUES(1, 2, '2016-03-01', 5);
INSERT INTO activity VALUES(1 ,2, '2016-03-02', 6);
INSERT INTO activity VALUES(2, 3, '2017-06-25', 1);
INSERT INTO activity VALUES(3, 1, '2016-03-02', 0);
INSERT INTO activity VALUES(3, 4, '2018-07-03', 5);

WITH logged_in_prev_day AS(
  SELECT
    count(DISTINCT player_id) AS player_count
  FROM
    activity a1
  WHERE
    EXISTS(
      SELECT
        *
      FROM
        activity a2
      WHERE
        a1.player_id = a2.player_id
        AND a1.event_date = DATE_ADD(a2.event_date, INTERVAL 1 DAY)
    )
),
all_player AS(
  SELECT
    count(DISTINCT player_id) AS total_player_count
  FROM
    activity
)
SELECT
  ROUND(
    (SELECT
      player_count
    FROM
      logged_in_prev_day)*1.00/
    (SELECT
      total_player_count
    FROM
    all_player)
  ,2) AS fraction
;

--drop tables

DROP TABLE activity;


--Q76:

CREATE TABLE salaries
(
  company_id INT,
  employee_id INT,
  employee_name VARCHAR(25),
  salary INT,
  CONSTRAINT pk_salary PRIMARY KEY(company_id, employee_id)
);

INSERT INTO salaries VALUES(1, 1, 'Tony', 2000);
INSERT INTO salaries VALUES(1, 2, 'Pronub', 21300);
INSERT INTO salaries VALUES(1, 3, 'Tyrrox', 10800);
INSERT INTO salaries VALUES(2, 1, 'Pam', 300);
INSERT INTO salaries VALUES(2, 7, 'Bassem', 450);
INSERT INTO salaries VALUES(2, 9, 'Hermione', 700);
INSERT INTO salaries VALUES(3, 7, 'Bocaben', 100);
INSERT INTO salaries VALUES(3, 2, 'Ognjen', 2200);
INSERT INTO salaries VALUES(3, 13, 'Nyan Cat', 3300);
INSERT INTO salaries VALUES(3, 15, 'Morning Cat', 7777);

WITH salaries_with_max_by_company AS (
  SELECT
    *,
    MAX(salary) OVER(PARTITION BY company_id) AS max_company_salary
  FROM
    salaries
)
SELECT
  company_id,
  employee_id,
  employee_name,
  CASE
    WHEN max_company_salary > 10000
      THEN
        CEILING(salary - (salary*0.49))
    WHEN max_company_salary >= 1000
      THEN
        CEILING(salary - (salary*0.24))
    ELSE
      salary
  END AS salary
FROM
  salaries_with_max_by_company
;

--drop tables

DROP TABLE salaries;


--Q77:

CREATE TABLE variables
(
  name VARCHAR(5),
  value INT,
  CONSTRAINT pk_variables PRIMARY KEY(name)
);

CREATE TABLE expressions
(
  left_operand VARCHAR(5),
  operator ENUM('<', '>', '='),
  right_operand VARCHAR(5),
  CONSTRAINT pk_expressions PRIMARY KEY(left_operand, operator, right_operand)
);

INSERT INTO variables VALUES('x', 66);
INSERT INTO variables VALUES('y', 77);

INSERT INTO expressions VALUES('x', '>', 'y');
INSERT INTO expressions VALUES('x', '<', 'y');
INSERT INTO expressions VALUES('x', '=', 'y');
INSERT INTO expressions VALUES('y', '>', 'x');
INSERT INTO expressions VALUES('y', '<', 'x');
INSERT INTO expressions VALUES('y', '=', 'x');

WITH variables_with_val AS(
  SELECT 
    e.left_operand,
    e.right_operand,
    e.operator,
    MAX(CASE
      WHEN e.left_operand = v.name
        THEN v.value
    END) as first_var,
    MAX(CASE
      WHEN e.right_operand = v.name
        THEN v.value
    END) as second_var
  FROM
    expressions e
    JOIN variables v 
      ON e.left_operand = v.name
        OR e.right_operand = v.name
  GROUP BY
    left_operand,
    right_operand,
    operator
)
SELECT
  left_operand,
  operator,
  right_operand,
  CASE
    WHEN operator = '<'
      THEN 
        IF(first_var < second_var, 'true', 'false')
    WHEN operator = '>'
      THEN 
        IF(first_var > second_var, 'true', 'false')
    WHEN operator = '='
      THEN 
        IF(first_var = second_var, 'true', 'false')
  END value
FROM
  variables_with_val
;

--drop tables

DROP TABLE variables;


--Q78:

CREATE TABLE person
(
  id INT,
  name VARCHAR(25),
  phone_number VARCHAR(11),
  CONSTRAINT pk_person PRIMARY KEY (id)
);

CREATE TABLE country
(
  name VARCHAR(25),
  country_code VARCHAR(3),
  CONSTRAINT pk_country PRIMARY KEY (country_code)
);

CREATE TABLE calls
(
  caller_id INT,
  callee_id INT,
  duration INT
);

INSERT INTO person VALUES(3, 'Jonathan', '051-1234567');
INSERT INTO person VALUES(12, 'Elvis', '051-7654321');
INSERT INTO person VALUES(1, 'Moncef', '212-1234567');
INSERT INTO person VALUES(2, 'Maroua', '212-6523651');
INSERT INTO person VALUES(7, 'Meir', '972-1234567');
INSERT INTO person VALUES(9, 'Rachel', '972-0011100');

INSERT INTO country VALUES('Peru', '51');
INSERT INTO country VALUES('Israel', '972');
INSERT INTO country VALUES('Morocco', '212');
INSERT INTO country VALUES('Germany', '49');
INSERT INTO country VALUES('Ethiopia', '251');

INSERT INTO calls VALUES(1, 9, 33);
INSERT INTO calls VALUES(2, 9, 4);
INSERT INTO calls VALUES(1, 2, 59);
INSERT INTO calls VALUES(3, 12, 102);
INSERT INTO calls VALUES(3, 12, 330);
INSERT INTO calls VALUES(12, 3, 5);
INSERT INTO calls VALUES(7, 9, 13);
INSERT INTO calls VALUES(7, 1, 3);
INSERT INTO calls VALUES(9, 7, 1);
INSERT INTO calls VALUES(1, 7, 7);

WITH receiver_caller_calls AS(
  SELECT
    caller_id AS caller_receiver_id,
    duration
  FROM
    calls
  UNION ALL
  SELECT
    callee_id AS caller_receiver_id,
    duration
  FROM
    calls
),
call_duration_avg AS(
  SELECT
    DISTINCT cn.name,
    avg(c.duration) OVER() as global_average,
    avg(c.duration) OVER(PARTITION BY cn.name) as country_average
  FROM 
    person p
    JOIN country cn 
      ON  CAST(SUBSTRING_INDEX(p.phone_number, '-', 1) AS UNSIGNED) =  CAST(cn.country_code AS UNSIGNED)
    JOIN receiver_caller_calls c
      ON c.caller_receiver_id = p.id
)
SELECT
  name
FROM
  call_duration_avg
WHERE
  country_average > global_average
;

--drop tables

DROP TABLE person;
DROP TABLE country;
DROP TABLE calls;


--Q79:

CREATE TABLE employee
(
  employee_id INT,
  name VARCHAR(25),
  months INT,
  salary INT,
  CONSTRAINT pk_employee PRIMARY KEY(employee_id)
);


INSERT INTO employee VALUES(12228, 'Rose', 15, 1968);
INSERT INTO employee VALUES(33645, 'Angela', 1, 3443);
INSERT INTO employee VALUES(45692, 'Frank', 17, 1608);
INSERT INTO employee VALUES(56118, 'Patrick', 7, 1345);
INSERT INTO employee VALUES(59725, 'Lisa', 11, 2330);
INSERT INTO employee VALUES(74197, 'Kimberly', 16, 4372);
INSERT INTO employee VALUES(78454, 'Bonnie', 8, 1771);
INSERT INTO employee VALUES(83565, 'Michael', 6, 2017);
INSERT INTO employee VALUES(98607, 'Todd', 5, 3396);
INSERT INTO employee VALUES(99989, 'Joe', 9, 3573);

SELECT
  name
FROM
  employee
ORDER BY
  name
;

--drop tables

DROP TABLE employee;


--Q80:

CREATE TABLE user_transactions
(
  transaction_id INT,
  product_id INT,
  spend DECIMAL(10,2),
  transaction_date DATE
);


INSERT INTO user_transactions VALUES(1341, 123424, 1500.60, '2019-12-31');
INSERT INTO user_transactions VALUES(1423, 123424, 1000.20, '2020-12-31');
INSERT INTO user_transactions VALUES(1623, 123424, 1246.44, '2021-12-31');
INSERT INTO user_transactions VALUES(1322, 123424, 2145.32, '2022-12-31');


SELECT
  DATE_FORMAT(transaction_date,'%Y') AS year,
  product_id,
  spend AS curr_year_spend,
  LAG(spend) OVER(ORDER BY DATE_FORMAT(transaction_date,'%Y')) AS prev_year_spend,
  ROUND((spend - LAG(spend) OVER(ORDER BY DATE_FORMAT(transaction_date,'%Y')))
    *100.00/LAG(spend) OVER(ORDER BY DATE_FORMAT(transaction_date,'%Y')),2) AS yoy_rate
FROM
  user_transactions
ORDER BY 
  year
;

--drop tables

DROP TABLE user_transactions;


--Q81:

CREATE TABLE inventory
(
  item_id INT,
  item_type VARCHAR(20),
  item_category VARCHAR(20),
  square_footage DECIMAL(10,2)
);

INSERT INTO inventory VALUES(1374, 'prime_eligible' , 'mini refrigerator', 68.00);
INSERT INTO inventory VALUES(4245, 'not_prime', 'standing lamp', 26.40);
INSERT INTO inventory VALUES(2452, 'prime_eligible', 'television', 85.00);
INSERT INTO inventory VALUES(3255, 'not_prime', 'side table', 22.60);
INSERT INTO inventory VALUES(1672, 'prime_eligible', 'laptop', 8.50);

WITH product_inventory_summary AS
(
  SELECT
    item_type,
    SUM(square_footage) as square_footage_required,
    COUNT(item_id) as unique_item_count,
    500000 as total_space,
    FLOOR(500000/sum(square_footage))*sum(square_footage) as space_used,
    FLOOR(500000/sum(square_footage))*COUNT(item_id) as item_count
  FROM 
    inventory
  GROUP BY 
    item_type
)
SELECT 
  t1.item_type,
  CASE
    WHEN t1.item_type = 'prime_eligible'
      THEN t1.item_count
    ELSE
      FLOOR((500000-t2.space_used)/t1.square_footage_required)*t1.unique_item_count
  END AS item_count
FROM
  product_inventory_summary t1
  JOIN product_inventory_summary t2 ON t1.item_type <> t2.item_type
ORDER BY t1.item_type DESC
;

--drop tables

DROP TABLE inventory;


--Q82:

CREATE TABLE user_actions
(
  user_id INT,
  event_id INT,
  event_type VARCHAR(20),
  event_date DATE
);

INSERT INTO user_actions VALUES(445, 7765 , 'sign-in', '2022-05-31');
INSERT INTO user_actions VALUES(742, 6458, 'sign-in', '2022-06-03');
INSERT INTO user_actions VALUES(445, 3634, 'like', '2022-06-05');
INSERT INTO user_actions VALUES(742, 1374, 'comment', '2022-06-05');
INSERT INTO user_actions VALUES(648, 3124, 'like', '2022-06-18');


SELECT
  CAST(DATE_FORMAT(curr_month_ua.event_date, '%m') AS UNSIGNED) AS month,
  count(distinct curr_month_ua.user_id) AS monthly_active_users
FROM 
  user_actions curr_month_ua
WHERE
  curr_month_ua.event_type IN ('sign-in', 'like', 'comment')
  AND DATE_FORMAT(curr_month_ua.event_date,'%Y-%m') = '2022-06'
  AND EXISTS(
    SELECT
      *
    FROM
      user_actions last_month_ua
    WHERE
      curr_month_ua.user_id = last_month_ua.user_id
      AND last_month_ua.event_type IN ('sign-in', 'like', 'comment')
      AND DATE_FORMAT(curr_month_ua.event_date, '%Y-%m') = 
        DATE_FORMAT(last_month_ua.event_date + INTERVAL '1' MONTH, '%Y-%m') 
  )
GROUP BY
  CAST(DATE_FORMAT(curr_month_ua.event_date, '%m') AS UNSIGNED)
;

--drop tables

DROP TABLE user_actions;


--Q83:

CREATE TABLE search_frequency
(
  searches INT,
  num_users INT
);

INSERT INTO search_frequency VALUES(1, 2);
INSERT INTO search_frequency VALUES(2, 2);
INSERT INTO search_frequency VALUES(3, 3);
INSERT INTO search_frequency VALUES(4, 1);

WITH cumulative_sum AS
(
  SELECT 
  *,
  SUM(num_users) OVER(ORDER BY searches) as cum_sum,
  ROW_NUMBER() OVER(ORDER BY searches) as row_num
  FROM 
    search_frequency
),
max_cumulative_sum AS
(
  SELECT
    MAX(cum_sum) as max_cum_sum
  FROM 
    cumulative_sum
),
odd_even_sum AS
(
  SELECT 
    MIN(row_num) AS row1
  FROM 
    cumulative_sum 
  WHERE 
    cum_sum >= (
      SELECT 
        CEILING((max_cum_sum)*0.5) 
      FROM
        max_cumulative_sum 
    )
),
even_sum AS
(
  SELECT 
    MIN(row_num) AS row2
  FROM 
    cumulative_sum 
  WHERE 
    cum_sum >= (
      SELECT 
        CEILING((max_cum_sum)*0.5)+1 
      FROM
        max_cumulative_sum 
    )
)
SELECT 
  ROUND(
    CASE 
      WHEN (SELECT max_cum_sum FROM max_cumulative_sum) % 2 = 0
        THEN (
          (SELECT searches FROM cumulative_sum WHERE row_num = (SELECT row1 FROM odd_even_sum)) 
          + 
          (SELECT searches FROM cumulative_sum WHERE row_num = (SELECT row2 FROM even_sum))
        )/2.0
      ELSE (SELECT searches FROM cumulative_sum WHERE row_num = (SELECT row1 FROM odd_even_sum))
    END
  ,1) as median
;

--drop tables

DROP TABLE search_frequency;


--Q84:

CREATE TABLE advertiser
(
  user_id VARCHAR(15),
  status VARCHAR(15)
);

CREATE TABLE daily_pay
(
  user_id VARCHAR(15),
  paid DECIMAL(10,2)
);

INSERT INTO advertiser VALUES('bing', 'NEW');
INSERT INTO advertiser VALUES('yahoo', 'NEW');
INSERT INTO advertiser VALUES('alibaba', 'EXISTING');

--resuccernt test
INSERT INTO advertiser VALUES('oracle', 'CHURN');

INSERT INTO daily_pay VALUES('yahoo', '45.00');
INSERT INTO daily_pay VALUES('alibaba', '100.00');
INSERT INTO daily_pay VALUES('target', '13.00');

--resuccernt test
INSERT INTO daily_pay VALUES('oracle', '13.00');



WITH full_outer_join_table AS(
  SELECT
    dp.user_id AS user_id_dp,
    dp.paid,
    a.user_id AS user_id_advertiser,
    a.status
  FROM daily_pay dp
    LEFT OUTER JOIN advertiser a ON dp.user_id = a.user_id
  UNION
  SELECT
    dp.user_id AS user_id_dp,
    dp.paid,
    a.user_id AS user_id_advertiser,
    a.status
  FROM daily_pay dp
    RIGHT OUTER JOIN advertiser a ON dp.user_id = a.user_id
)
SELECT 
  CASE
    WHEN user_id_dp IS NULL
      THEN user_id_advertiser
    ELSE user_id_dp
  END AS user_id,
  CASE
    WHEN user_id_dp is NULL
      THEN 
        'CHURN' 
    ELSE
      CASE
        WHEN status is null
            THEN  'NEW'
        WHEN status = 'CHURN'
          THEN  'RESURRECT'
        ELSE 'EXISTING'
      END
  END AS new_status
FROM full_outer_join_table full_table
;

--drop tables

DROP TABLE advertiser;
DROP TABLE daily_pay;


--Q85:

CREATE TABLE server_utilization
(
  server_id INT,
  status_time TIMESTAMP,
  session_status VARCHAR(10)
);

INSERT INTO server_utilization VALUES(1, '2022-08-02 10:00:00', 'start');
INSERT INTO server_utilization VALUES(1, '2022-08-04 10:00:00', 'stop');
INSERT INTO server_utilization VALUES(2, '2022-08-17 10:00:00', 'start');
INSERT INTO server_utilization VALUES(2, '2022-08-24 10:00:00', 'stop');

WITH up_time_by_server AS
(
  SELECT 
    server_id,
    session_status,
    status_time,
  CASE
    WHEN session_status = 'stop'
      THEN
        TIMESTAMPDIFF(SECOND, LAG(status_time) OVER(PARTITION BY server_id ORDER BY status_time), status_time)/3600
  END as up_time
  FROM server_utilization
)
SELECT
  ROUND(sum(up_time)/24)
FROM
  up_time_by_server
WHERE
  up_time is not null
;

--drop tables

DROP TABLE server_utilization;


--Q86:

CREATE TABLE transactions
(
  transaction_id INT,
  merchant_id INT,
  credit_card_id INT,
  amount INT,
  transaction_timestamp TIMESTAMP
);

INSERT INTO transactions VALUES(1, 101, 1, 100, '2022-09-25 12:00:00');
INSERT INTO transactions VALUES(2, 101, 1, 100, '2022-09-25 12:08:00');
INSERT INTO transactions VALUES(3, 101, 1, 100, '2022-09-25 12:28:00');
INSERT INTO transactions VALUES(4, 102, 2, 300, '2022-09-25 12:00:00');
INSERT INTO transactions VALUES(5, 102, 2, 400, '2022-09-25 14:00:00');

WITH trx_with_repeadted AS
(
  SELECT 
    credit_card_id,
    amount,
    transaction_timestamp,
    count(*) OVER(
        PARTITION BY credit_card_id,amount
        ORDER BY transaction_timestamp
        RANGE BETWEEN INTERVAL '10' MINUTE PRECEDING AND CURRENT ROW
    ) AS moving_count
  FROM 
    transactions
)
SELECT 
  COUNT(*) as payment_count
FROM trx_with_repeadted
WHERE 
  moving_count > 1
;

--drop tables

DROP TABLE transactions;


--Q87:

CREATE TABLE orders
(
  order_id INT,
  customer_id INT,
  trip_id INT,
  status VARCHAR(30),
  order_timestamp TIMESTAMP
);

CREATE TABLE trips
(
  dasher_id INT,
  trip_id INT,
  estimated_delivery_timestamp TIMESTAMP,
  actual_delivery_timestamp TIMESTAMP
);

CREATE TABLE customers
(
  customer_id INT,
  signup_timestamp TIMESTAMP
);

INSERT INTO orders VALUES(727424,8472, 100463, 'completed successfully', '2022-06-05 09:12:00');
INSERT INTO orders VALUES(242513, 2341, 100482, 'completed incorrectly', '2022-06-05 14:40:00');
INSERT INTO orders VALUES(141367, 1314, 100362, 'completed incorrectly', '2022-06-07 15:03:00');
INSERT INTO orders VALUES(582193, 5421, 100657, 'never_received', '2022-07-07 15:22:00');
INSERT INTO orders VALUES(253613, 1314, 100213, 'completed successfully', '2022-06-12 13:43:00');

INSERT INTO trips VALUES(101, 100463, '2022-06-05 09:42:00', '2022-06-05 09:38:00');
INSERT INTO trips VALUES(102, 100482, '2022-06-05 15:10:00', '2022-06-05 15:46:00');
INSERT INTO trips VALUES(101, 100362, '2022-06-07 15:33:00', '2022-06-07 16:45:00');
INSERT INTO trips VALUES(102, 100657, '2022-07-07 15:52:00',null);
INSERT INTO trips VALUES(103, 100213, '2022-06-12 14:13:00', '2022-06-12 14:10:00');

INSERT INTO customers VALUES(8472, '2022-05-30 00:00:00');
INSERT INTO customers VALUES(2341, '2022-06-01 00:00:00');
INSERT INTO customers VALUES(1314, '2022-06-03 00:00:00');
INSERT INTO customers VALUES(1435, '2022-06-05 00:00:00');
INSERT INTO customers VALUES(5421, '2022-06-07 00:00:00');

SELECT 
  ROUND((COUNT(
    CASE
      WHEN lower(o.status) <> 'completed successfully' 
        THEN o.order_id
    END
  )*100.00/COUNT(o.order_id)),2) as bad_experience_pct
  
FROM orders o
  JOIN customers c ON c.customer_id = o.customer_id
WHERE 
  TIMESTAMPDIFF(DAY,o.order_timestamp,c.signup_timestamp) < 14
  AND DATE_FORMAT(c.signup_timestamp,'%Y-%m') = '2022-06'
;

--drop tables

DROP TABLE orders;
DROP TABLE customers;


--Q88:

CREATE TABLE scores
(
  player_name VARCHAR(25),
  gender VARCHAR(1),
  day DATE,
  score_points INT,
  CONSTRAINT pk_scores PRIMARY KEY (gender, day)
);

INSERT INTO scores VALUES('Aron', 'F', '2020-01-01', 17);
INSERT INTO scores VALUES('Alice', 'F', '2020-01-07', 23);
INSERT INTO scores VALUES('Bajrang', 'M', '2020-01-07', 7);
INSERT INTO scores VALUES('Khali' , 'M', '2019-12-25', 11);
INSERT INTO scores VALUES('Slaman', 'M', '2019-12-30', 13);
INSERT INTO scores VALUES('Joe', 'M', '2019-12-31', 3);
INSERT INTO scores VALUES('Jose', 'M', '2019-12-18', 2);
INSERT INTO scores VALUES('Priya', 'F', '2019-12-31', 23);
INSERT INTO scores VALUES('Priyanka', 'F', '2019-12-30', 17);

SELECT
  gender,
  day,
  sum(score_points) OVER(PARTITION BY gender ORDER BY day) AS total
FROM
  scores
;

--drop tables

DROP TABLE scores;


--Q89:

CREATE TABLE person
(
  id INT,
  name VARCHAR(25),
  phone_number VARCHAR(11),
  CONSTRAINT pk_person PRIMARY KEY (id)
);

CREATE TABLE country
(
  name VARCHAR(25),
  country_code VARCHAR(3),
  CONSTRAINT pk_country PRIMARY KEY (country_code)
);

CREATE TABLE calls
(
  caller_id INT,
  callee_id INT,
  duration INT
);

INSERT INTO person VALUES(3, 'Jonathan', '051-1234567');
INSERT INTO person VALUES(12, 'Elvis', '051-7654321');
INSERT INTO person VALUES(1, 'Moncef', '212-1234567');
INSERT INTO person VALUES(2, 'Maroua', '212-6523651');
INSERT INTO person VALUES(7, 'Meir', '972-1234567');
INSERT INTO person VALUES(9, 'Rachel', '972-0011100');

INSERT INTO country VALUES('Peru', '51');
INSERT INTO country VALUES('Israel', '972');
INSERT INTO country VALUES('Morocco', '212');
INSERT INTO country VALUES('Germany', '49');
INSERT INTO country VALUES('Ethiopia', '251');

INSERT INTO calls VALUES(1, 9, 33);
INSERT INTO calls VALUES(2, 9, 4);
INSERT INTO calls VALUES(1, 2, 59);
INSERT INTO calls VALUES(3, 12, 102);
INSERT INTO calls VALUES(3, 12, 330);
INSERT INTO calls VALUES(12, 3, 5);
INSERT INTO calls VALUES(7, 9, 13);
INSERT INTO calls VALUES(7, 1, 3);
INSERT INTO calls VALUES(9, 7, 1);
INSERT INTO calls VALUES(1, 7, 7);

WITH receiver_caller_calls AS(
  SELECT
    caller_id AS caller_receiver_id,
    duration
  FROM
    calls
  UNION ALL
  SELECT
    callee_id AS caller_receiver_id,
    duration
  FROM
    calls
),
call_duration_avg AS(
  SELECT
    DISTINCT cn.name,
    avg(c.duration) OVER() as global_average,
    avg(c.duration) OVER(PARTITION BY cn.name) as country_average
  FROM 
    person p
    JOIN country cn 
      ON  CAST(SUBSTRING_INDEX(p.phone_number, '-', 1) AS UNSIGNED) =  CAST(cn.country_code AS UNSIGNED)
    JOIN receiver_caller_calls c
      ON c.caller_receiver_id = p.id
)
SELECT
  name
FROM
  call_duration_avg
WHERE
  country_average > global_average
;

--drop tables

DROP TABLE person;
DROP TABLE country;
DROP TABLE calls;


--Q90:

CREATE TABLE numbers
(
  num INT,
  frequency INT
);

INSERT INTO numbers VALUES(0, 7);
INSERT INTO numbers VALUES(1, 1);
INSERT INTO numbers VALUES(2, 3);
INSERT INTO numbers VALUES(3, 1);

WITH cumulative_sum AS
(
  SELECT 
  *,
  SUM(frequency) OVER(ORDER BY num) as cum_sum,
  ROW_NUMBER() OVER(ORDER BY num) as row_num
  FROM 
    numbers
),
max_cumulative_sum AS
(
  SELECT
    MAX(cum_sum) as max_cum_sum
  FROM 
    cumulative_sum
),
odd_even_sum AS
(
  SELECT 
    MIN(row_num) AS row1
  FROM 
    cumulative_sum 
  WHERE 
    cum_sum >= (
      SELECT 
        CEILING((max_cum_sum)*0.5) 
      FROM
        max_cumulative_sum 
    )
),
even_sum AS
(
  SELECT 
    MIN(row_num) AS row2
  FROM 
    cumulative_sum 
  WHERE 
    cum_sum >= (
      SELECT 
        CEILING((max_cum_sum)*0.5)+1 
      FROM
        max_cumulative_sum 
    )
)
SELECT 
  ROUND(
    CASE 
      WHEN (SELECT max_cum_sum FROM max_cumulative_sum) % 2 = 0
        THEN (
          (SELECT num FROM cumulative_sum WHERE row_num = (SELECT row1 FROM odd_even_sum))
          + 
          (SELECT num FROM cumulative_sum WHERE row_num = (SELECT row2 FROM even_sum ))
        )/2.0
      ELSE(
        SELECT num FROM cumulative_sum WHERE row_num = (SELECT row1 FROM odd_even_sum)
      )
    END
  ,1) as median
;

--drop tables

DROP TABLE numbers;


--Q91:

CREATE TABLE employee
(
  employee_id INT,
  department_id INT,
  CONSTRAINT pk_employee PRIMARY KEY(employee_id)
);

CREATE TABLE salary
(
  id INT,
  employee_id INT,
  amount INT,
  pay_date DATE,
  CONSTRAINT pk_salary PRIMARY KEY(id),
  CONSTRAINT fk_employee FOREIGN KEY(employee_id)
    REFERENCES employee(employee_id)
);

INSERT INTO employee VALUES(1, 1);
INSERT INTO employee VALUES(2, 2);
INSERT INTO employee VALUES(3, 2);

INSERT INTO salary VALUES(1, 1, 9000, '2017-03-31');
INSERT INTO salary VALUES(2, 2, 6000, '2017-03-31');
INSERT INTO salary VALUES(3, 3, 10000, '2017-03-31');
INSERT INTO salary VALUES(4, 1, 7000, '2017-02-28');
INSERT INTO salary VALUES(5, 2, 6000, '2017-02-28');
INSERT INTO salary VALUES(6, 3, 8000, '2017-02-28');

WITH department_company_avg_monthly AS(
  SELECT
    DISTINCT DATE_FORMAT(s.pay_date, '%Y-%m') AS pay_month,
    department_id,
    AVG(amount) OVER(PARTITION BY DATE_FORMAT(s.pay_date, '%Y-%m')) as company_avg,
    AVG(amount) OVER(PARTITION BY DATE_FORMAT(s.pay_date, '%Y-%m'), department_id) as department_avg
  FROM
    salary s
    JOIN employee e ON s.employee_id = e.employee_id
)
SELECT
  pay_month,
  department_id,
  CASE
    WHEN department_avg > company_avg
      THEN 'higher'
    WHEN department_avg < company_avg
      THEN 'lower'
    ELSE
      'same'
  END AS comparison
FROM
  department_company_avg_monthly
ORDER BY
  department_id
;

--drop tables

DROP TABLE salary;
DROP TABLE employee;


--Q92:

CREATE TABLE activity
(
  player_id INT,
  device_id INT,
  event_date DATE,
  games_played INT,
  CONSTRAINT pk_activity PRIMARY KEY(player_id, event_date)
);

INSERT INTO activity VALUES(1, 2, '2016-03-01', 5);
INSERT INTO activity VALUES(1, 2, '2016-03-02', 6);
INSERT INTO activity VALUES(2, 3, '2017-06-25', 1);
INSERT INTO activity VALUES(3, 1, '2016-03-01', 0);
INSERT INTO activity VALUES(3, 4, '2016-07-03', 5);

WITH retention_data AS(
  SELECT
    curr_day.event_date,
    COUNT(DISTINCT curr_day.player_id) AS retention_player_count
  FROM
    activity curr_day
  WHERE
    EXISTS(
      SELECT
        *
      FROM
        activity next_day
      WHERE
        curr_day.player_id = next_day.player_id
        AND next_day.event_date = curr_day.event_date + INTERVAL '1' DAY
    )
  GROUP BY
    curr_day.event_date
),
player_signup_data AS(
  SELECT
    DISTINCT player_id,
    FIRST_VALUE(event_date) OVER(PARTITION BY player_id ORDER BY event_date) as signup_date
  FROM
    activity
),
daily_player_data AS(
  SELECT
    signup_date,
    COUNT(DISTINCT player_id) AS daily_player_count
  FROM
    player_signup_data
  GROUP BY
    signup_date
)
SELECT
  dpd.signup_date AS install_dt,
  dpd.daily_player_count AS installs,
  ROUND(IFNULL(rd.retention_player_count,0)/dpd.daily_player_count,2) AS Day1_retention

FROM
  daily_player_data dpd
  LEFT JOIN retention_data rd ON dpd.signup_date = rd.event_date
;

--drop tables

DROP TABLE activity;


--Q93:

CREATE TABLE players
(
  player_id INT,
  group_id INT,
  CONSTRAINT pk_players PRIMARY KEY(player_id)
);

CREATE TABLE matches
(
  match_id INT,
  first_player INT,
  second_player INT,
  first_score INT,
  second_score INT,
  CONSTRAINT pk_matches PRIMARY KEY(match_id)
);

INSERT INTO players VALUES(15, 1);
INSERT INTO players VALUES(25, 1);
INSERT INTO players VALUES(30, 1);
INSERT INTO players VALUES(45, 1);
INSERT INTO players VALUES(10, 2);
INSERT INTO players VALUES(35, 2);
INSERT INTO players VALUES(50, 2);
INSERT INTO players VALUES(20, 3);
INSERT INTO players VALUES(40, 3);

INSERT INTO matches VALUES(1, 15, 45, 3, 0);
INSERT INTO matches VALUES(2, 30, 25, 1, 2);
INSERT INTO matches VALUES(3, 30, 15, 2, 0);
INSERT INTO matches VALUES(4, 40, 20, 5, 2);
INSERT INTO matches VALUES(5, 35, 50, 1, 1);

WITH player_score AS(
  SELECT
    p.group_id,
    p.player_id,
    SUM(CASE
      WHEN p.player_id = m.first_player
        THEN m.first_score
      WHEN p.player_id = m.second_player
        THEN m.second_score
    END) AS score
  FROM
    players p
    JOIN matches m ON p.player_id = m.first_player OR p.player_id = m.second_player
  GROUP BY
    p.group_id,
    p.player_id
),
ranked_player AS(
  SELECT
    group_id,
    player_id,
    score,
    DENSE_RANK() OVER (PARTITION BY group_id ORDER BY score DESC,player_id) AS player_rank
  FROM
    player_score
)
SELECT
  group_id,
  player_id
FROM  
  ranked_player
WHERE
  player_rank = 1
;

--drop tables

DROP TABLE players;
DROP TABLE matches;


--Q94:

CREATE TABLE student
(
  student_id INT,
  student_name VARCHAR(25),
  CONSTRAINT pk_student PRIMARY KEY(student_id)
);

CREATE TABLE exam
(
  exam_id INT,
  student_id INT,
  score INT,
  CONSTRAINT pk_exam PRIMARY KEY(exam_id, student_id)
);

INSERT INTO student VALUES(1, 'Daniel');
INSERT INTO student VALUES(2, 'Jade');
INSERT INTO student VALUES(3, 'Stella');
INSERT INTO student VALUES(4, 'Jonathan');
INSERT INTO student VALUES(5, 'Will');

INSERT INTO exam VALUES(10, 1, 70);
INSERT INTO exam VALUES(10, 2, 80);
INSERT INTO exam VALUES(10, 3, 90);
INSERT INTO exam VALUES(20, 1, 80);
INSERT INTO exam VALUES(30, 1, 70);
INSERT INTO exam VALUES(30, 3, 80);
INSERT INTO exam VALUES(30, 4, 90);
INSERT INTO exam VALUES(40, 1, 60);
INSERT INTO exam VALUES(40, 2, 70);
INSERT INTO exam VALUES(40, 4, 80);

WITH exam_highest_lowest AS(
  SELECT
    *,
    FIRST_VALUE(score) OVER(PARTITION BY exam_id ORDER BY score) as exam_lowest,
    FIRST_VALUE(score) OVER(PARTITION BY exam_id ORDER BY score DESC) as exam_highest
  FROM
    exam
),
student_highest_lowest AS(
  SELECT
    DISTINCT student_id
  FROM
    exam_highest_lowest
  WHERE 
    score = exam_lowest
    OR score = exam_highest
)
SELECT
  student_id,
  student_name
FROM
  student s
WHERE
  EXISTS(
    SELECT
      *
    FROM 
      exam e
    WHERE
      e.student_id = s.student_id
  )
  AND s.student_id NOT IN(
    SELECT
      student_id
    FROM
      student_highest_lowest
  )
;

--drop tables

DROP TABLE student;
DROP TABLE exam;


--Q95:

CREATE TABLE student
(
  student_id INT,
  student_name VARCHAR(25),
  CONSTRAINT pk_student PRIMARY KEY(student_id)
);

CREATE TABLE exam
(
  exam_id INT,
  student_id INT,
  score INT,
  CONSTRAINT pk_exam PRIMARY KEY(exam_id, student_id)
);

INSERT INTO student VALUES(1, 'Daniel');
INSERT INTO student VALUES(2, 'Jade');
INSERT INTO student VALUES(3, 'Stella');
INSERT INTO student VALUES(4, 'Jonathan');
INSERT INTO student VALUES(5, 'Will');

INSERT INTO exam VALUES(10, 1, 70);
INSERT INTO exam VALUES(10, 2, 80);
INSERT INTO exam VALUES(10, 3, 90);
INSERT INTO exam VALUES(20, 1, 80);
INSERT INTO exam VALUES(30, 1, 70);
INSERT INTO exam VALUES(30, 3, 80);
INSERT INTO exam VALUES(30, 4, 90);
INSERT INTO exam VALUES(40, 1, 60);
INSERT INTO exam VALUES(40, 2, 70);
INSERT INTO exam VALUES(40, 4, 80);

WITH exam_highest_lowest AS(
  SELECT
    *,
    FIRST_VALUE(score) OVER(PARTITION BY exam_id ORDER BY score) as exam_lowest,
    FIRST_VALUE(score) OVER(PARTITION BY exam_id ORDER BY score DESC) as exam_highest
  FROM
    exam
),
student_highest_lowest AS(
  SELECT
    DISTINCT student_id
  FROM
    exam_highest_lowest
  WHERE 
    score = exam_lowest
    OR score = exam_highest
)
SELECT
  student_id,
  student_name
FROM
  student s
WHERE
  EXISTS(
    SELECT
      *
    FROM 
      exam e
    WHERE
      e.student_id = s.student_id
  )
  AND s.student_id NOT IN(
    SELECT
      student_id
    FROM
      student_highest_lowest
  )
;

--drop tables

DROP TABLE student;
DROP TABLE exam;


--Q96:

CREATE TABLE songs_history
(
  history_id INT,
  user_id INT,
  song_id INT,
  song_plays INT
);

CREATE TABLE songs_weekly
(
  user_id INT,
  song_id INT,
  listen_time TIMESTAMP
);

INSERT INTO songs_history VALUES(10011, 777, 1238, 11);
INSERT INTO songs_history VALUES(12452, 695, 4520, 1);

INSERT INTO songs_weekly VALUES(777, 1238, '2022-08-01 12:00:00');
INSERT INTO songs_weekly VALUES(695, 4520, '2022-08-04 08:00:00');
INSERT INTO songs_weekly VALUES(125, 9630, '2022-08-04 16:00:00');
INSERT INTO songs_weekly VALUES(695, 9852, '2022-08-07 12:00:00');

WITH all_song_list AS(
  SELECT 
    sw.user_id,
    sw.song_id,
    count(*) as song_plays
  FROM 
    songs_weekly sw 
  WHERE 
    STR_TO_DATE(listen_time,'%Y-%m-%d') <= STR_TO_DATE('08/04/2022','%m/%d/%Y')
  GROUP BY 
    sw.user_id,
    sw.song_id
  
  UNION ALL
  
  SELECT
    sh.user_id,
    sh.song_id,
    sh.song_plays
  FROM 
    songs_history sh
)
SELECT
  user_id,
  song_id,
  sum(song_plays) as song_plays
FROM 
  all_song_list
GROUP BY 
  user_id,
  song_id
ORDER BY 
  song_plays DESC
;

--drop tables

DROP TABLE songs_history;
DROP TABLE songs_weekly;


--Q97:

CREATE TABLE emails
(
  email_id INT,
  user_id INT,
  signup_date TIMESTAMP
);

CREATE TABLE texts
(
  text_id INT,
  email_id INT,
  signup_action VARCHAR(20)
);

INSERT INTO emails VALUES(125, 7771, STR_TO_DATE('06/14/2022 00:00:00', '%m/%d/%Y %H:%i:%s'));
INSERT INTO emails VALUES(236, 6950, STR_TO_DATE('07/01/2022 00:00:00', '%m/%d/%Y %H:%i:%s'));
INSERT INTO emails VALUES(433, 1052, STR_TO_DATE('07/09/2022 00:00:00', '%m/%d/%Y %H:%i:%s'));

INSERT INTO texts VALUES(6878, 125, 'Confirmed');
INSERT INTO texts VALUES(6920, 236, 'Not Confirmed');
INSERT INTO texts VALUES(6994, 236, 'Confirmed');

WITH email_with_action AS(
  SELECT 
    DISTINCT e.email_id,
    t.signup_action
  FROM 
    emails e 
    LEFT JOIN texts t ON e.email_id = t.email_id
),
email_confirm_table AS(
  SELECT
    email_id,
    GROUP_CONCAT(signup_action ORDER BY signup_action)  AS action,
    position('Confirmed' in GROUP_CONCAT(signup_action ORDER BY signup_action)) as pos
  FROM 
    email_with_action
  GROUP BY 
    email_id
)
SELECT
  ROUND(
    COUNT(
      CASE
        WHEN pos = 1 
          THEN email_id
      END
    )*1.00/
    count(*)
  ,2)as confirm_rate 
FROM email_confirm_table
;

--drop tables

DROP TABLE emails;
DROP TABLE texts;


--Q98:

CREATE TABLE tweets
(
  tweet_id INT,
  user_id INT,
  tweet_date TIMESTAMP
);


INSERT INTO tweets VALUES(214252, 111, STR_TO_DATE('06/01/2022 12:00:00', '%m/%d/%Y %H:%i:%s'));
INSERT INTO tweets VALUES(739252, 111, STR_TO_DATE('06/01/2022 12:00:00', '%m/%d/%Y %H:%i:%s'));
INSERT INTO tweets VALUES(846402, 111, STR_TO_DATE('06/02/2022 12:00:00', '%m/%d/%Y %H:%i:%s'));
INSERT INTO tweets VALUES(241425, 254, STR_TO_DATE('06/02/2022 12:00:00', '%m/%d/%Y %H:%i:%s'));
INSERT INTO tweets VALUES(137374, 111, STR_TO_DATE('06/04/2022 12:00:00', '%m/%d/%Y %H:%i:%s'));


WITH tweet_per_day_by_user AS
(
  SELECT
    user_id,
    tweet_date,
    COUNT(*) as tweet_count
  FROM 
    tweets
  group by 
    user_id,
    tweet_date
)
SELECT 
  user_id,
  tweet_date,
  ROUND(
    AVG(tweet_count) OVER( PARTITION BY user_id ORDER BY tweet_date
      ROWS BETWEEN 2 PRECEDING and CURRENT ROW )
  ,2) as rolling_avg_3d
FROM tweet_per_day_by_user;

--drop tables

DROP TABLE tweets;


--Q99:

CREATE TABLE activities
(
  activity_id INT,
  user_id INT,
  activity_type VARCHAR(10),
  time_spent DECIMAL(5,2),
  activity_date TIMESTAMP
);

CREATE TABLE age_breakdown
(
  user_id INT,
  age_bucket VARCHAR(10)
);

INSERT INTO activities VALUES(7274, 123, 'open', 4.50, STR_TO_DATE('06/22/2022 12:00:00', '%m/%d/%Y %H:%i:%s'));
INSERT INTO activities VALUES(2425, 123, 'send', 3.50, STR_TO_DATE('06/22/2022 12:00:00', '%m/%d/%Y %H:%i:%s'));
INSERT INTO activities VALUES(1413, 456, 'send', 5.67, STR_TO_DATE('06/23/2022 12:00:00', '%m/%d/%Y %H:%i:%s'));
INSERT INTO activities VALUES(1414, 789, 'chat', 11.00, STR_TO_DATE('06/25/2022 12:00:00', '%m/%d/%Y %H:%i:%s'));
INSERT INTO activities VALUES(2536, 456, 'open', 3.00, STR_TO_DATE('06/25/2022 12:00:00', '%m/%d/%Y %H:%i:%s'));

INSERT INTO age_breakdown VALUES(123, '31-35');
INSERT INTO age_breakdown VALUES(456, '26-30');
INSERT INTO age_breakdown VALUES(789, '21-25');

SELECT 
  ab.age_bucket,
  ROUND(
    sum(
      CASE
        WHEN a.activity_type = 'send'
          THEN
            a.time_spent
      END
    )*100.0/sum(
      CASE
        WHEN a.activity_type in ('open','send')
          THEN
            a.time_spent
      END
    )
  ,2) AS send_perc,
  ROUND(
    sum(
      CASE
        WHEN a.activity_type = 'open'
          THEN
            a.time_spent
      END
    )*100.0/sum(
      CASE
        WHEN a.activity_type in ('open','send')
          THEN
            a.time_spent
      END
    )
  ,2) AS open_perc
FROM 
  activities a
  JOIN age_breakdown ab ON a.user_id = ab.user_id
WHERE
  a.activity_type in ('open','send')
GROUP BY
  ab.age_bucket
;

--drop tables

DROP TABLE activities;
DROP TABLE age_breakdown;


--Q100:

CREATE TABLE personal_profiles
(
  profile_id INT,
  name VARCHAR(30),
  followers INT
);

CREATE TABLE employee_company
(
  personal_profile_id INT,
  company_id INT
);

CREATE TABLE company_pages
(
  company_id INT,
  name VARCHAR(30),
  followers INT
);

INSERT INTO personal_profiles VALUES(1, 'Nick Singh', 92000);
INSERT INTO personal_profiles VALUES(2, 'Zach Wilson', 199000);
INSERT INTO personal_profiles VALUES(3, 'Daliana Liu', 171000);
INSERT INTO personal_profiles VALUES(4, 'Ravit Jain', 107000);
INSERT INTO personal_profiles VALUES(5, 'Vin Vashishta', 139000);
INSERT INTO personal_profiles VALUES(6, 'Susan Wojcicki', 39000);

INSERT INTO employee_company VALUES(1, 4);
INSERT INTO employee_company VALUES(1, 9);
INSERT INTO employee_company VALUES(2, 2);
INSERT INTO employee_company VALUES(3, 1);
INSERT INTO employee_company VALUES(4, 3);
INSERT INTO employee_company VALUES(5, 6);
INSERT INTO employee_company VALUES(6, 5);

INSERT INTO company_pages VALUES(1 , 'The Data Science Podcast', 8000);
INSERT INTO company_pages VALUES(2, 'Airbnb', 700000);
INSERT INTO company_pages VALUES(3, 'The Ravit Show', 6000);
INSERT INTO company_pages VALUES(4, 'DataLemur', 200);
INSERT INTO company_pages VALUES(5, 'YouTube', 16000000);
INSERT INTO company_pages VALUES(6, 'DataScience.Vin', 4500);
INSERT INTO company_pages VALUES(9, 'Ace The Data Science Interview', 4479);

WITH profile_with_max_company_follower AS(
  SELECT
    pp.profile_id,
    pp.name,
    pp.followers,
    cp.name AS company_name,
    cp.followers AS company_follower,
    max(cp.followers) OVER(PARTITION BY pp.profile_id) as max_company_follower
  FROM 
    personal_profiles pp
    JOIN employee_company ec ON pp.profile_id = ec.personal_profile_id
    JOIN company_pages cp ON cp.company_id = ec.company_id
  ORDER BY 
    pp.name
)
SELECT
  DISTINCT profile_id
FROM 
  profile_with_max_company_follower
WHERE 
  followers > max_company_follower
ORDER BY 
  profile_id
;

--drop tables

DROP TABLE personal_profiles;
DROP TABLE employee_company;
DROP TABLE company_pages;

















