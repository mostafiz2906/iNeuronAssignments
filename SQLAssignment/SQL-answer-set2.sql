Q51:

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
  OR population >= 25000000;


Q52:

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
  OR referee_id IS NULL;


Q53:

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


Q54:

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
  employee;


Q55:

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
  country_average > global_average;


Q56:

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


Q57:

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

Follow Up:

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


Q58:

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


Q59:

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


INSERT INTO sales_person VALUES(1, 'John', 100000, 6, '4/1/2006');
INSERT INTO sales_person VALUES(2, 'Amy', 12000, 5, '5/1/2010');
INSERT INTO sales_person VALUES(3, 'Mark', 65000, 12, '12/25/2008');
INSERT INTO sales_person VALUES(4, 'Pam', 25000, 25, '1/1/2005');
INSERT INTO sales_person VALUES(5, 'Alex', 5000, 10, '2/3/2007');

INSERT INTO company VALUES(1, 'RED', 'Boston');
INSERT INTO company VALUES(2, 'ORANGE', 'New York');
INSERT INTO company VALUES(3, 'YELLOW', 'Boston');
INSERT INTO company VALUES(4, 'GREEN', 'Austin');


INSERT INTO orders VALUES(1, '1/1/2014', 3, 4, 10000);
INSERT INTO orders VALUES(2, '2/1/2014', 4, 5, 5000);
INSERT INTO orders VALUES(3, '3/1/2014', 1, 1, 50000);
INSERT INTO orders VALUES(4, '4/1/2014', 1, 4, 25000);

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


Q60:

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
  triangle;


Q61:

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
  JOIN point p2 ON p1.x <> p2.x;

Follow Up:

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
  JOIN ordered_point p2 ON p2.ordered_no > p1.ordered_no;


Q62:

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
  count(*) >= 3;


Q63:

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

CREATE TABLE product
(
  product_id INT,
  product_name VARCHAR(25),
  CONSTRAINT pk_product PRIMARY KEY (product_id)
);

INSERT INTO sales VALUES(1, 100, 2008, 10, 5000);
INSERT INTO sales VALUES(2, 100, 2009, 12, 5000);
INSERT INTO sales VALUES(7, 200, 2011, 15, 9000);

INSERT INTO product VALUES(100, 'Nokia');
INSERT INTO product VALUES(200, 'Apple');
INSERT INTO product VALUES(300, 'Samsung');

SELECT
  product_name,
  year,
  price
FROM
  product p
  JOIN sales s ON p.product_id = s.product_id;


Q64:

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
GROUP BY p.project_id;


Q65:

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
  rank_by_sales = 1;


Q66:

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
  s2.buyer_id is null;


Q67:

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
LIMIT 6,18446744073709551615;


Q68:

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
  sum(score_points)
FROM
  scores
GROUP BY
  gender,day
ORDER BY
  gender,day;

SELECT
  gender,
  day,
  sum(score_points) OVER(PARTITION BY gender ORDER BY day) AS total
FROM
  scores;


Q69:

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


Q70:

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


Q71:

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

WITH report_direct_to_boss AS(
  SELECT
    employee_id
  FROM 
    employees
  WHERE
    manager_id = (
      SELECT
        employee_id
      FROM
        employees
      WHERE
        employee_name = 'Boss'
    )
    AND employee_id <> (
      SELECT
        employee_id
      FROM
        employees
      WHERE
        employee_name = 'Boss'
    )
),
step_two_reporter AS(
  SELECT 
    employee_id 
  FROM
    employees
  WHERE
    manager_id IN (
      SELECT
        employee_id
      FROM
        report_direct_to_boss
    )
),
step_three_reporter AS(
  SELECT 
    employee_id 
  FROM
    employees
  WHERE
    manager_id IN (
      SELECT
        employee_id
      FROM
        step_two_reporter
    )
)  
SELECT
  employee_id
FROM
  report_direct_to_boss
UNION
SELECT
  employee_id
FROM
  step_two_reporter
UNION
SELECT
  employee_id
FROM
  step_three_reporter
;


Q72:

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
  country;


Q73:

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


Q74:

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


Q75:

--same question as 74


Q76:

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


Q77:

CREATE TABLE sales
(
  sale_date DATE,
  fruit ENUM('apples', 'oranges'),
  sold_num INT,
  CONSTRAINT pk_sales PRIMARY KEY(sale_date, fruit)
);

INSERT INTO sales VALUES('2020-05-01', 'apples', 10);
INSERT INTO sales VALUES('2020-05-01', 'oranges', 8);
INSERT INTO sales VALUES('2020-05-02', 'apples', 15);
INSERT INTO sales VALUES('2020-05-02', 'oranges', 15);
INSERT INTO sales VALUES('2020-05-03', 'apples', 20);
INSERT INTO sales VALUES('2020-05-03', 'oranges', 0);
INSERT INTO sales VALUES('2020-05-04', 'apples', 15);
INSERT INTO sales VALUES('2020-05-04', 'oranges', 16);

WITH daily_sales_row AS(
  SELECT 
    sale_date,
    MAX(
      CASE 
        WHEN fruit = 'apples'
          THEN sold_num 
      END
    ) AS apples_sales,
    MAX(
      CASE 
        WHEN fruit = 'oranges'
          THEN sold_num 
      END
    ) AS oranges_sales
  FROM sales
  GROUP BY
    sale_date
)
SELECT
  sale_date,
  apples_sales - oranges_sales AS diff
FROM
  daily_sales_row
ORDER BY 
  sale_date
;


Q78:

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


Q79:

CREATE TABLE movies
(
  movie_id INT,
  title VARCHAR(25),
  CONSTRAINT pk_movies PRIMARY KEY(movie_id)
);

CREATE TABLE users
(
  user_id INT,
  name VARCHAR(25),
  CONSTRAINT pk_users PRIMARY KEY(user_id)
);

CREATE TABLE movie_rating
(
  movie_id INT,
  user_id INT,
  rating INT,
  created_at DATE,
  CONSTRAINT pk_movie_rating PRIMARY KEY(movie_id, user_id)
);

INSERT INTO movies VALUES(1, 'Avengers');
INSERT INTO movies VALUES(2, 'Frozen 2');
INSERT INTO movies VALUES(3, 'Joker');

INSERT INTO users VALUES(1, 'Daniel');
INSERT INTO users VALUES(2, 'Monica');
INSERT INTO users VALUES(3, 'Maria');
INSERT INTO users VALUES(4, 'James');

INSERT INTO movie_rating VALUES(1, 1, 3, '2020-01-12');
INSERT INTO movie_rating VALUES(1, 2, 4, '2020-02-11');
INSERT INTO movie_rating VALUES(1, 3, 2, '2020-02-12');
INSERT INTO movie_rating VALUES(1, 4, 1, '2020-01-01');
INSERT INTO movie_rating VALUES(2, 1, 5, '2020-02-17');
INSERT INTO movie_rating VALUES(2, 2, 2, '2020-02-01');
INSERT INTO movie_rating VALUES(2, 3, 2, '2020-03-01');
INSERT INTO movie_rating VALUES(3, 1, 3, '2020-02-22');
INSERT INTO movie_rating VALUES(3, 2, 4, '2020-02-25');

(
  SELECT
    u.name AS result
  FROM
    movie_rating mr 
    JOIN users u on mr.user_id = u.user_id
  GROUP BY
    u.user_id,
    u.name
  ORDER BY 
    COUNT(*) DESC,
    u.name ASC
  LIMIT 1
)
UNION 
(
  SELECT
    m.title AS result
  FROM
    movie_rating mr 
    JOIN movies m on mr.movie_id = m.movie_id
  WHERE
    DATE_FORMAT(mr.created_at, '%Y-%m') = '2020-02'
  GROUP BY
    m.movie_id,
    m.title
  ORDER BY 
    AVG(rating) DESC,
    m.title ASC
  LIMIT 1
) 
;


Q80:

--same as Q55

Q81:

CREATE TABLE students
(
  id INT,
  name VARCHAR(25),
  marks INT,
  CONSTRAINT pk_students PRIMARY KEY(id)
);

INSERT INTO students VALUES(1, 'Ashley', 81);
INSERT INTO students VALUES(2, 'Samantha', 75);
INSERT INTO students VALUES(4, 'Julia', 76);
INSERT INTO students VALUES(3, 'Belvet', 84);

SELECT
  name
FROM
  students
WHERE
  marks > 75
ORDER BY
  RIGHT(name, 3),id
;


Q82:

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
  name;


Q83:

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
WHERE
  salary > 2000
  AND months < 10
ORDER BY
  employee_id;


Q84:

CREATE TABLE triangles
(
  a INT,
  b INT,
  c INT
);


INSERT INTO triangles VALUES(20, 20, 23);
INSERT INTO triangles VALUES(20, 20, 20);
INSERT INTO triangles VALUES(20, 21, 22);
INSERT INTO triangles VALUES(13, 14, 30);

SELECT
  a,
  b,
  c,
  CASE
    WHEN a + b <= c OR b + c <= a OR c + a <= b
      THEN 'Not A Triangle'
    WHEN a = b AND b = c
      THEN 'Equilateral'
    WHEN a = b
      THEN 'Isosceles'
    ELSE
      'Scalene'
  END AS triangle_type
FROM
  triangles;


Q85:

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
  year;


Q86:

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


Q87:

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
  CAST(DATE_FORMAT(curr_month_ua.event_date, '%m') AS UNSIGNED);


Q88:

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


Q89:

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


Q90:

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
        TIMESTAMPDIFF(SECOND, status_time,LAG(status_time) OVER(PARTITION BY server_id ORDER BY status_time))/3600
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


Q91:

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

Q92:

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

Q93:

--repeated Q68


Q94:

--repeated Q55


Q95:

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


Q96:

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
  department_id;


Q97:

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


Q99:

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


Q98:

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

Q100:

--same as Q99


Q96:

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
  song_plays DESC;


Q97:

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


Q98:

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


Q99:

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
  ab.age_bucket;


Q100:

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


INSERT INTO tweets VALUES(214252, 111, STR_TO_DATE('06/01/2022 12:00:00', '%m/%d/%Y %H:%i:%s'));

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











Q101:


CREATE TABLE user_activity
(
  username VARCHAR(25),
  activity VARCHAR(25),
  start_date DATE,
  end_date DATE
);

INSERT INTO user_activity VALUES('Alice', 'Travel', '2020-02-12', '2020-02-20');
INSERT INTO user_activity VALUES('Alice', 'Dancing', '2020-02-21', '2020-02-23');
INSERT INTO user_activity VALUES('Alice', 'Travel', '2020-02-24', '2020-02-28');
INSERT INTO user_activity VALUES('Bob', 'Travel', '2020-02-11', '2020-02-18');

WITH activity_stat_by_user AS(
  SELECT
    *,
    DENSE_RANK() OVER(PARTITION BY username ORDER BY start_date) AS activity_serial,
    COUNT(*) OVER(PARTITION BY username) AS total_activity_count_by_user
  FROM
    user_activity
)
SELECT
  username,
  activity,
  start_date,
  end_date
FROM
  activity_stat_by_user
WHERE
  CASE
    WHEN total_activity_count_by_user = 1
      THEN 1
    WHEN activity_serial = 2
      THEN 1
  END = 1
;


Q102:
  
--same as Q101

Q103:

Q104:

Q105:

Q106:

CREATE TABLE employees
(
  id INT,
  name VARCHAR(25),
  salary INT
);

INSERT INTO employees VALUES(1, 'Kristeen', 1420);
INSERT INTO employees VALUES(2, 'Ashley', 2006);
INSERT INTO employees VALUES(3, 'Julia', 2210);
INSERT INTO employees VALUES(4, 'Maria', 3000);

SELECT 
  ROUND(AVG(salary) -AVG(CAST(REPLACE(CAST(salary AS CHAR),'0','') AS UNSIGNED)), 2) AS diff_average
FROM
  employees
;


Q107:

CREATE TABLE employee
(
  employee_id INT,
  name VARCHAR(25),
  months INT,
  salary INT
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

WITH employee_max_sal_count AS(
  SELECT
    months * salary AS max_sal,
    count(*) AS emp_count
  FROM
    employee
  WHERE
    months * salary = (
      SELECT
        MAX(months * salary)
      FROM
        employee
    )
  GROUP BY
    months * salary
)
SELECT
  CONCAT(max_sal, ' ', emp_count)
FROM
  employee_max_sal_count
;


Q108:

CREATE TABLE occupations
(
  name VARCHAR(25),
  occupation VARCHAR(25)
);

INSERT INTO occupations VALUES('Samantha', 'Doctor');
INSERT INTO occupations VALUES('Julia', 'Actor');
INSERT INTO occupations VALUES('Maria', 'Actor');
INSERT INTO occupations VALUES('Meera', 'Singer');
INSERT INTO occupations VALUES('Ashely', 'Professor');
INSERT INTO occupations VALUES('Ketty', 'Professor');
INSERT INTO occupations VALUES('Christeen', 'Professor');
INSERT INTO occupations VALUES('Jane', 'Actor');
INSERT INTO occupations VALUES('Jenny', 'Doctor');
INSERT INTO occupations VALUES('Priya', 'Singer');

SELECT
  CONCAT(name, '(', LEFT(occupation,1), ')') AS name_with_occupation
FROM
  occupations;

WITH occupations_stat AS(
  SELECT
    occupation,
    COUNT(*) AS individual_count
  FROM
    occupations
  GROUP BY
    occupation
)
SELECT
  CONCAT('There are a total of ', individual_count, ' ', LOWER(occupation))
FROM
  occupations_stat
ORDER BY
  individual_count,
  occupation
;


Q109:

CREATE TABLE occupations
(
  name VARCHAR(25),
  occupation VARCHAR(25)
);

INSERT INTO occupations VALUES('Samantha', 'Doctor');
INSERT INTO occupations VALUES('Julia', 'Actor');
INSERT INTO occupations VALUES('Maria', 'Actor');
INSERT INTO occupations VALUES('Meera', 'Singer');
INSERT INTO occupations VALUES('Ashely', 'Professor');
INSERT INTO occupations VALUES('Ketty', 'Professor');
INSERT INTO occupations VALUES('Christeen', 'Professor');
INSERT INTO occupations VALUES('Jane', 'Actor');
INSERT INTO occupations VALUES('Jenny', 'Doctor');
INSERT INTO occupations VALUES('Priya', 'Singer');

WITH serialized_ocp AS(
  SELECT
      name,
      occupation,
      row_number() over(partition by occupation order by name) as serial
  FROM
    occupations
)
SELECT
  MAX(CASE
    WHEN occupation = 'Doctor'
      THEN
        name
  END) AS Doctor,
  MAX(CASE
    WHEN occupation = 'Professor'
      THEN
        name
  END) AS Professor,
  MAX(CASE
    WHEN occupation = 'Singer'
      THEN
        name
  END) AS Singer,
  MAX(CASE
    WHEN occupation = 'Actor'
      THEN
        name
  END) AS Actor
FROM
  serialized_ocp
GROUP BY
  serial
;


Q110:

CREATE TABLE bst
(
  n INT,
  p INT
);

INSERT INTO bst VALUES(1, 2);
INSERT INTO bst VALUES(3, 2);
INSERT INTO bst VALUES(6, 8);
INSERT INTO bst VALUES(9, 8);
INSERT INTO bst VALUES(2, 5);
INSERT INTO bst VALUES(8, 5);
INSERT INTO bst VALUES(5, null);


SELECT
  n,
  CASE
    WHEN p IS NULL
      THEN 'Root'
    WHEN n IN ( SELECT p FROM bst)
      THEN 'Inner'
    ELSE
      'Leaf'
  END as node_type
FROM
  bst
ORDER BY 
  n;


Q111:

CREATE TABLE company
(
  company_code VARCHAR(25),
  founder VARCHAR(25)
);

CREATE TABLE lead_manager
(
  lead_manager_code VARCHAR(25),
  company_code VARCHAR(25)
);

CREATE TABLE senior_manager
(
  senior_manager_code VARCHAR(25),
  lead_manager_code VARCHAR(25),
  company_code VARCHAR(25)
);

CREATE TABLE manager
(
  manager_code VARCHAR(25),
  senior_manager_code VARCHAR(25),
  lead_manager_code VARCHAR(25),
  company_code VARCHAR(25)
);

CREATE TABLE employee
(
  employee_code VARCHAR(25),
  manager_code VARCHAR(25),
  senior_manager_code VARCHAR(25),
  lead_manager_code VARCHAR(25),
  company_code VARCHAR(25)
);

INSERT INTO company VALUES('C1', 'Monika');
INSERT INTO company VALUES('C2', 'Samantha');

INSERT INTO lead_manager VALUES('LM1', 'C1');
INSERT INTO lead_manager VALUES('LM2', 'C2');

INSERT INTO senior_manager VALUES('SM1', 'LM1', 'C1');
INSERT INTO senior_manager VALUES('SM2', 'LM1', 'C1');
INSERT INTO senior_manager VALUES('SM3', 'LM2', 'C2');

INSERT INTO manager VALUES('M1', 'SM1', 'LM1', 'C1');
INSERT INTO manager VALUES('M2', 'SM3', 'LM2', 'C2');
INSERT INTO manager VALUES('M3', 'SM3', 'LM2', 'C2');

INSERT INTO employee VALUES('E1', 'M1', 'SM1', 'LM1', 'C1');
INSERT INTO employee VALUES('E2', 'M1', 'SM1', 'LM1', 'C1');
INSERT INTO employee VALUES('E3', 'M2', 'SM3', 'LM2', 'C2');
INSERT INTO employee VALUES('E4', 'M3', 'SM3', 'LM2', 'C2');


SELECT
  c.company_code,
  c.founder,
  count(distinct lm.lead_manager_code) AS lead_manager_count,
  count(distinct sm.senior_manager_code) AS senior_manager_count,
  count(distinct m.manager_code) AS manager_count,
  count(distinct e.employee_code) AS employeee_count
FROM
  lead_manager lm
  LEFT JOIN senior_manager sm ON lm.lead_manager_code = sm.lead_manager_code
  LEFT JOIN manager m ON m.senior_manager_code = sm.senior_manager_code
  LEFT JOIN employee e ON e.manager_code = m.manager_code
  LEFT JOIN company c ON c.company_code = lm.company_code
GROUP BY 
  c.company_code, 
  c.founder
ORDER BY
  c.company_code
;

Q112:

WITH RECURSIVE numbers AS(
  SELECT 1 AS n
  UNION
  SELECT n+1 FROM numbers WHERE n < 1000
),
prime_numbers AS(
  SELECT
    n1.n
  FROM
    numbers n1
    JOIN numbers n2 ON n1.n >= n2.n*2 AND n2.n <> 1
  WHERE
    n1.n > 3
  GROUP BY 
    n1.n
  HAVING
    MIN(MOD(n1.n,n2.n)) <> 0
  ORDER BY n1.n
),
all_prime AS(
SELECT 1 AS n UNION
SELECT 2 AS n UNION
SELECT 3 AS n UNION 
SELECT 
  n
FROM
  prime_numbers
ORDER BY n
)
SELECT
  GROUP_CONCAT(n SEPARATOR '&')
FROM
  all_prime

;


Q113:

WITH RECURSIVE numbers AS(
  SELECT 1 AS n, '*' AS star
  UNION
  SELECT n+1,'*' AS star FROM numbers WHERE n < 20
)
SELECT
  GROUP_CONCAT(n1.star SEPARATOR '') AS stars
FROM  
  numbers n1 
  JOIN numbers n2 ON n1.n >= n2.n
GROUP BY
  n1.n;

--print in single row

WITH RECURSIVE numbers AS(
  SELECT 1 AS n, '*' AS star
  UNION
  SELECT n+1,'*' AS star FROM numbers WHERE n < 20
),
multiline_star AS(
SELECT
  GROUP_CONCAT(n1.star SEPARATOR '') AS stars
FROM  
  numbers n1 
  JOIN numbers n2 ON n1.n >= n2.n
  --ORDER BY n1.n
GROUP BY
  n1.n
)
SELECT
  GROUP_CONCAT(stars SEPARATOR '\n') AS pattern
FROM
  multiline_star;


Q114:

WITH RECURSIVE numbers AS(
  SELECT 1 AS n, '*' AS star
  UNION
  SELECT n+1,'*' AS star FROM numbers WHERE n < 20
)
SELECT
  GROUP_CONCAT(n1.star SEPARATOR '') AS stars
FROM  
  numbers n1 
  JOIN numbers n2 ON n1.n <= n2.n
GROUP BY
  n1.n;

--print in single row

WITH RECURSIVE numbers AS(
  SELECT 1 AS n, '*' AS star
  UNION
  SELECT n+1,'*' AS star FROM numbers WHERE n < 20
),
multiline_star AS(
SELECT
  GROUP_CONCAT(n1.star SEPARATOR '') AS stars
FROM  
  numbers n1 
  JOIN numbers n2 ON n1.n <= n2.n
  --ORDER BY n1.n
GROUP BY
  n1.n
)
SELECT
  GROUP_CONCAT(stars SEPARATOR '\n') AS pattern
FROM
  multiline_star;



Q115:

--Q81

Q116:

CREATE TABLE functions
(
  x INT,
  y INT
);

INSERT INTO functions VALUES(20, 20);
INSERT INTO functions VALUES(20, 20);
INSERT INTO functions VALUES(20, 21);
INSERT INTO functions VALUES(23, 22);
INSERT INTO functions VALUES(22, 23);
INSERT INTO functions VALUES(21, 20);

WITH functions_serialized AS(
  SELECT
    *,
    ROW_NUMBER() OVER(ORDER BY x) AS serial
  FROM
    functions
)
SELECT
  DISTINCT f1.x,
  f1.y
FROM
  functions_serialized f1
WHERE
  EXISTS(
    SELECT
      *
    FROM
      functions_serialized f2
    WHERE
      f1.serial <> f2.serial
      AND f1.x = f2.y
      AND f1.y = f2.x
  )
  AND f1.x <= f1.y;


Q116:

--Q82

Q117:

--Q83


Q118:

--Q84

Q119:

--Q85

Q120:

--Q86

Q121:

--Q87

Q122:

--Q88

Q123:

--Q89

Q124:

--Q90


Q125:

--Q91

Q126:

--Q92

Q127:

--Q68

Q128:

--Q65

Q129:

--Q95

Q130:

--Q96

Q131:

--Q97

Q132:

--Q99

Q133:

--Q98

Q134:

--Q98

Q135:

--Q101

Q136:

--Q101

Q137:

--Q106

Q138:

--Q107

Q139:

--Q108

Q140:

--Q109

Q141:

--Q110

Q142:

--Q111

Q143:

--Q116



Q144:

CREATE TABLE students
(
  id INT,
  name VARCHAR(25)
);

CREATE TABLE friends
(
  id INT,
  friend_id INT
);

CREATE TABLE packages
(
  id INT,
  salary DECIMAL(10, 2)
);

INSERT INTO students VALUES(1, 'Ashley');
INSERT INTO students VALUES(2, 'Samantha');
INSERT INTO students VALUES(3, 'Julia');
INSERT INTO students VALUES(4, 'Scarlet');

INSERT INTO friends VALUES(1, 2);
INSERT INTO friends VALUES(2, 3);
INSERT INTO friends VALUES(3, 4);
INSERT INTO friends VALUES(4, 1);

INSERT INTO packages VALUES(1, 15.20);
INSERT INTO packages VALUES(2, 10.06);
INSERT INTO packages VALUES(3, 11.55);
INSERT INTO packages VALUES(4, 12.12);


SELECT
  s.name
FROM
  friends f
  JOIN packages p1 ON f.id = p1.id
  JOIN packages p2 ON p2.id = f.friend_id
  JOIN students s ON s.id = f.id
WHERE
  p2.salary > p1.salary
;


Q145:

CREATE TABLE hackers
(
  hacker_id INT,
  name VARCHAR(25)
);

CREATE TABLE difficulty
(
  difficulty_level INT,
  score INT
);

CREATE TABLE challenges
(
  challenge_id INT,
  hacker_id INT,
  difficulty_level INT
);

CREATE TABLE submissions
(
  submission_id INT,
  hacker_id INT,
  challenge_id INT,
  score INT
);

INSERT INTO hackers VALUES(5580, 'Rose');
INSERT INTO hackers VALUES(8439, 'Angela');
INSERT INTO hackers VALUES(27205, 'Frank');
INSERT INTO hackers VALUES(52243, 'Patrick');
INSERT INTO hackers VALUES(52348, 'Lisa');
INSERT INTO hackers VALUES(57645, 'Kimberly');
INSERT INTO hackers VALUES(77726, 'Bonnie');
INSERT INTO hackers VALUES(83082, 'Michael');
INSERT INTO hackers VALUES(86870, 'Todd');
INSERT INTO hackers VALUES(90411, 'Joe');

INSERT INTO difficulty VALUES(1, 20);
INSERT INTO difficulty VALUES(2, 30);
INSERT INTO difficulty VALUES(3, 40);
INSERT INTO difficulty VALUES(4, 60);
INSERT INTO difficulty VALUES(5, 80);
INSERT INTO difficulty VALUES(6, 100);
INSERT INTO difficulty VALUES(7, 120);

INSERT INTO challenges VALUES(4810, 77726, 4);
INSERT INTO challenges VALUES(21089, 27205, 1);
INSERT INTO challenges VALUES(36566, 5580, 7);
INSERT INTO challenges VALUES(66730, 52243, 6);
INSERT INTO challenges VALUES(71055, 52243, 2);

INSERT INTO submissions VALUES(68628, 77726, 36566, 30);
INSERT INTO submissions VALUES(65300, 77726, 21089, 10);
INSERT INTO submissions VALUES(40326, 52243, 36566, 77);
INSERT INTO submissions VALUES(8941, 27205, 4810, 4);
INSERT INTO submissions VALUES(83554, 77726, 66730, 30);
INSERT INTO submissions VALUES(43353, 52243, 66730, 0);
INSERT INTO submissions VALUES(55385, 52348, 71055, 20);
INSERT INTO submissions VALUES(39784, 27205, 71055, 23);
INSERT INTO submissions VALUES(94613, 86870, 71055, 30);
INSERT INTO submissions VALUES(45788, 52348, 36566, 0);
INSERT INTO submissions VALUES(93058, 86870, 36566, 30);
INSERT INTO submissions VALUES(7344, 8439, 66730, 92);
INSERT INTO submissions VALUES(2721, 8439, 4810, 36);
INSERT INTO submissions VALUES(523, 5580, 71055, 4);
INSERT INTO submissions VALUES(49105, 52348, 66730, 0);
INSERT INTO submissions VALUES(55877, 57645, 66730, 80);
INSERT INTO submissions VALUES(38355, 27205, 66730, 35);
INSERT INTO submissions VALUES(3924, 8439, 36566, 80);
INSERT INTO submissions VALUES(97397, 90411, 66730, 100);
INSERT INTO submissions VALUES(84162, 83082, 4810, 40);
INSERT INTO submissions VALUES(97431, 90411, 71055, 30);


SELECT
  h.hacker_id,
  h.name
FROM
  submissions s
  JOIN challenges c ON c.challenge_id = s.challenge_id 
  JOIN difficulty d ON d.difficulty_level = c.difficulty_level
  JOIN hackers h ON h.hacker_id = s.hacker_id
WHERE
  s.score = d.score
GROUP BY 
  h.hacker_id,
  h.name
ORDER BY 
  COUNT(*) DESC,
  xh.hacker_id
LIMIT 1
;


Q146:

CREATE TABLE projects
(
  task_id INT,
  start_date DATE,
  end_date DATE
);

INSERT INTO projects VALUES(1, '2015-10-01', '2015-10-02');
INSERT INTO projects VALUES(1, '2015-10-02', '2015-10-03');
INSERT INTO projects VALUES(1, '2015-10-03', '2015-10-04');
INSERT INTO projects VALUES(1, '2015-10-13', '2015-10-14');
INSERT INTO projects VALUES(1, '2015-10-14', '2015-10-15');
INSERT INTO projects VALUES(1, '2015-10-28', '2015-10-29');
INSERT INTO projects VALUES(1, '2015-10-30', '2015-10-31');


WITH diff_projects AS(
  SELECT
    *,
    LEAD(end_date) OVER(ORDER BY end_date) AS next_end_date,
    DATEDIFF(LEAD(end_date) OVER(ORDER BY end_date), end_date) AS diff_next_end_date,
    DATEDIFF(end_date, LAG(end_date) OVER(ORDER BY end_date)) AS diff_prev_end_date
  FROM
    projects
  ORDER BY
    end_date
),
projects_start_end AS(
  SELECT
    CASE
      WHEN diff_next_end_date = 1
        THEN start_date
      WHEN diff_next_end_date <> 1 AND diff_prev_end_date <> 1
        THEN start_date
      WHEN diff_next_end_date IS  NULL AND diff_prev_end_date <> 1
        THEN start_date
      WHEN diff_next_end_date <> 1 AND diff_prev_end_date IS NULL
        THEN start_date
    END as project_start_date,
    CASE
      WHEN LEAD(diff_prev_end_date) OVER(ORDER BY end_date) = 1
        THEN LEAD(end_date) OVER(ORDER BY end_date)
      WHEN diff_next_end_date <> 1 AND diff_prev_end_date <> 1
        THEN end_date
      WHEN diff_next_end_date IS  NULL AND diff_prev_end_date <> 1
        THEN end_date
      WHEN diff_next_end_date <> 1 AND diff_prev_end_date IS NULL
        THEN end_date
    END as project_end_date

  FROM
    diff_projects
  WHERE
    NOT (diff_next_end_date = 1 
      AND diff_prev_end_date = 1 )
    OR (
      diff_next_end_date IS NULL
      OR diff_prev_end_date IS NULL
    )
) 
SELECT
  *
FROM
  projects_start_end
WHERE
  project_end_date IS NOT NULL
ORDER BY
  DATEDIFF(project_end_date, project_start_date),
  project_start_date
;

Q147:

CREATE TABLE transactions
(
  user_id INT,
  amount DECIMAL(10,2),
  transaction_date TIMESTAMP
);

INSERT INTO transactions VALUES(1, '9.99', '2022-08-01 10:00:100');
INSERT INTO transactions VALUES(1, '55', '2022-08-17 10:00:100');
INSERT INTO transactions VALUES(1, '149.5', '2022-08-05 10:00:100');
INSERT INTO transactions VALUES(1, '4.89', '2022-08-06 10:00:100');
INSERT INTO transactions VALUES(1, '34', '2022-08-07 10:00:100');


SELECT
  *,
  DATEDIFF(LEAD(transaction_date) OVER(PARTITION BY user_id ORDER BY transaction_date), transaction_date) AS diff1,
  DATEDIFF(transaction_date, LAG(transaction_date) OVER(PARTITION BY user_id ORDER BY transaction_date)) AS diff2
FROM
  transactions;

SELECT
  distinct user_id
FROM(
  SELECT
    *,
    DATEDIFF(LEAD(transaction_date) OVER(PARTITION BY user_id ORDER BY transaction_date), transaction_date) AS diff1,
    DATEDIFF(transaction_date, LAG(transaction_date) OVER(PARTITION BY user_id ORDER BY transaction_date)) AS diff2
  FROM
    transactions
) AS trx_with_date_diff
WHERE 
  trx_with_date_diff.diff1 = 1
  AND trx_with_date_diff.diff2 = 1
;


Q148:

CREATE TABLE payments
(
  payer_id INT,
  recipient_id INT,
  amount INT
);

INSERT INTO payments VALUES(101, 201, 30);
INSERT INTO payments VALUES(201, 101, 10);
INSERT INTO payments VALUES(101, 301, 20);
INSERT INTO payments VALUES(301, 101, 80);
INSERT INTO payments VALUES(201, 301, 70);

SELECT
  ROUND(COUNT(
    distinct p1.payer_id,
    p1.recipient_id
  )/2) AS unique_relationships
FROM
  payments p1
  JOIN payments p2 ON p1. payer_id = p2.recipient_id
    AND p1.recipient_id = p2.payer_id;


Q149:

CREATE TABLE user_transactions
(
  transaction_id INT,
  user_id INT,
  spend DECIMAL(10,2),
  transaction_date TIMESTAMP
);

INSERT INTO user_transactions VALUES(759274, 111, 49.50, '2022-02-03 00:00:00');
INSERT INTO user_transactions VALUES(850371, 111, 51.00, '2022-03-15 00:00:00');
INSERT INTO user_transactions VALUES(615348, 145, 36.30, '2022-03-22 00:00:00');
INSERT INTO user_transactions VALUES(137424, 156, 151.00, '2022-04-04 00:00:00');
INSERT INTO user_transactions VALUES(248475, 156, 87.00, '2022-02-16 00:00:00');

WITH user_trx_serialized AS(
  SELECT
    *,
    DENSE_RANK() OVER(PARTITION BY user_id ORDER BY transaction_date) as serial
  FROM
    user_transactions
)
SELECT
  COUNT(*) AS users
FROM
  user_trx_serialized
WHERE
  serial = 1
  AND spend >= 50
;


Q150:

CREATE TABLE measurements
(
  measurement_id INT,
  measurement_value DECIMAL(10,2),
  measurement_time TIMESTAMP
);

INSERT INTO user_transactions VALUES(131233, 1109.51, '2022-07-10 09:00:00');
INSERT INTO user_transactions VALUES(135211, 1662.74, '2022-07-10 11:00:00');
INSERT INTO user_transactions VALUES(523542, 1246.24, '2022-07-10 13:15:00');
INSERT INTO user_transactions VALUES(143562, 1124.50, '2022-07-11 15:00:00');
INSERT INTO user_transactions VALUES(346462, 1234.14, '2022-07-11 16:45:00');


WITH daily_measurement AS(
  SELECT
    *,
    DATE_FORMAT(measurement_time, '%m/%d/%Y 00:00:00') AS measurement_day,
    DENSE_RANK() OVER(PARTITION BY DATE_FORMAT(measurement_time, 'm%/%d/%Y') ORDER BY measurement_time) AS serial

  FROM
    measurements
)
SELECT
  measurement_day,
  SUM(CASE
    WHEN serial % 2 = 1 
      THEN measurement_value
  END) as odd_sum,
  SUM(CASE
    WHEN serial % 2 = 0 
      THEN measurement_value
  END) as even_sum
FROM
  daily_measurement
GROUP BY
  measurement_day;
  
;

Q151:

-- same as Q147

Q152:

CREATE TABLE rental_amenities
(
  rental_id INT,
  amenity VARCHAR(40)
);

INSERT INTO rental_amenities VALUES(123, 'pool');
INSERT INTO rental_amenities VALUES(123, 'kitchen');
INSERT INTO rental_amenities VALUES(234, 'hit tub');
INSERT INTO rental_amenities VALUES(234, 'fireplace');
INSERT INTO rental_amenities VALUES(345, 'kitchen');
INSERT INTO rental_amenities VALUES(345, 'pool');
INSERT INTO rental_amenities VALUES(456, 'pool');

WITH rental_amenities AS(
  SELECT
    rental_id,
    GROUP_CONCAT(amenity ORDER BY amenity) AS amenities
  FROM
    rental_amenities
  GROUP BY
    rental_id
)
SELECT
  count(distinct amenities) AS matching_airbnb
FROM
  rental_amenities
GROUP BY
  amenities
HAVING
  COUNT(DISTINCT rental_id) > 1;


Q153:

CREATE TABLE ad_campaigns
(
  campaign_id INT,
  spend INT,
  revenue DECIMAL(10,2),
  advertiser_id INT
);

INSERT INTO ad_campaigns VALUES(1, 5000, 7500, 3);
INSERT INTO ad_campaigns VALUES(2, 1000, 900, 1);
INSERT INTO ad_campaigns VALUES(3, 3000, 12000, 2);
INSERT INTO ad_campaigns VALUES(1, 500, 2000, 4);
INSERT INTO ad_campaigns VALUES(1, 100, 400, 4);

WITH campaign_per_advertiser AS(
SELECT
  advertiser_id,
  SUM(spend) AS total_spend,
  SUM(revenue) AS total_revenue
FROM
  ad_campaigns
GROUP BY
  advertiser_id
)
SELECT
  advertiser_id,
  ROUND(total_revenue/total_spend, 2) AS ROAS
FROM
  campaign_per_advertiser
ORDER BY
  advertiser_id
;


Q154:

CREATE TABLE employee_pay
(
  employee_id INT,
  salary INT,
  title VARCHAR(40)
);

INSERT INTO employee_pay VALUES(101, 80000, 'Data Analyst');
INSERT INTO employee_pay VALUES(102, 90000, 'Data Analyst');
INSERT INTO employee_pay VALUES(103, 100000, 'Data Analyst');
INSERT INTO employee_pay VALUES(104, 30000, 'Data Analyst');
INSERT INTO employee_pay VALUES(105, 120000, 'Data Scientist');
INSERT INTO employee_pay VALUES(106, 100000, 'Data Scientist');
INSERT INTO employee_pay VALUES(107, 80000, 'Data Scientist');
INSERT INTO employee_pay VALUES(108, 310000, 'Data Scientist');

WITH employee_pay_avg_by_title AS(
  SELECT
    *,
    AVG(salary) OVER(PARTITION BY title) AS avg_by_title 
  FROM
    employee_pay
)
SELECT
  employee_id,
  salary,
  CASE
    WHEN salary > (2 * avg_by_title)
      THEN 'Overpaid'
    WHEN salary < (avg_by_title/2)
      THEN 'Underpaid'
  END AS status
FROM
  employee_pay_avg_by_title
WHERE 
  CASE
    WHEN salary > (2 * avg_by_title) OR  salary < (avg_by_title/2)
      THEN 1
  END = 1
;


Q155:

-- Q148


Q156:

CREATE TABLE purchases
(
  user_id INT,
  product_id INT,
  quantity INT,
  purchase_date TIMESTAMP
);

INSERT INTO purchases VALUES(536, 3223, 6, '2022-01-11 12:33:44');
INSERT INTO purchases VALUES(827, 3585, 35, '2022-02-20 14:05:26');
INSERT INTO purchases VALUES(536, 3223, 5, '2022-03-02 09:33:28');
INSERT INTO purchases VALUES(536, 1435, 10, '2022-03-2 08:40:00');
INSERT INTO purchases VALUES(827, 2452, 45, '2022-04-09 00:00:00');

SELECT
  COUNT(DISTINCT user_id) AS repeat_purchasers
FROM(
  SELECT
    user_id
  FROM
    purchases
  GROUP BY
    user_id,
    product_id
  HAVING
    COUNT(DISTINCT DATE_FORMAT(purchase_date,'%Y-%m-%d')) > 1
) repeat_purchase_product 
;


Q157:

CREATE TABLE transactions
(
  transaction_id INT,
  type VARCHAR(20),
  amount DECIMAL(10, 2),
  transaction_date TIMESTAMP
);

INSERT INTO transactions VALUES(19153, 'deposit', 65.90, '2022-07-10 10:00:00');
INSERT INTO transactions VALUES(53151, 'deposit', 178.55, '2022-07-08 10:00:00');
INSERT INTO transactions VALUES(29776, 'withdrawal', 25.90, '2022-07-08 10:00:00');
INSERT INTO transactions VALUES(16461, 'withdrawal', 45.99, '2022-07-08 10:00:00');
INSERT INTO transactions VALUES(77134, 'deposit', 32.60, '2022-07-10 10:00:00');

WITH daily_balance AS (
  SELECT
    DATE_FORMAT(transaction_date, '%Y-%m') AS transaction_month,
    DATE_FORMAT(transaction_date, '%m/%d/%Y') AS transaction_date,
    SUM(CASE
      WHEN type = 'deposit'
        THEN amount
      WHEN type = 'withdrawal'
        THEN amount * (-1)
    END) AS balance

  FROM
    transactions
  GROUP BY
    DATE_FORMAT(transaction_date, '%m/%d/%Y'),
    DATE_FORMAT(transaction_date, '%Y-%m')
)
SELECT
  CONCAT(transaction_date , ' 12:00:00') AS transaction_date,
  SUM(balance) OVER( PARTITION BY transaction_month ORDER BY transaction_date) AS balance
FROM 
  daily_balance
;


Q158:

CREATE TABLE product_spend
(
  category VARCHAR(20),
  product VARCHAR(30),
  user_id INT,
  spend DECIMAL(10, 2),
  transaction_date TIMESTAMP
);

INSERT INTO product_spend VALUES('appliance', 'refrigerator', 165, 246.00, '2021-12-26 12:00:00');
INSERT INTO product_spend VALUES('appliance', 'refrigerator', 123, 299.99, '2022-03-02 12:00:00');
INSERT INTO product_spend VALUES('appliance', 'washing machine', 123, 219.80, '2022-03-02 12:00:00');
INSERT INTO product_spend VALUES('electronics', 'vacuum', 178, 152.00, '2022-04-05 12:00:00');
INSERT INTO product_spend VALUES('electronics', 'wireless headset', 156, 249.90, '2022-07-08 12:00:00');
INSERT INTO product_spend VALUES('electronics', 'vacuum', 145, 189.00, '2022-07-15 12:00:00');

WITH category_product_spend_2022 AS(
  SELECT  
    category,
    product,
    sum(spend) AS total_spend,
    DENSE_RANK() OVER(PARTITION BY category ORDER BY sum(spend)) AS serial
  FROM
    product_spend
  WHERE
    DATE_FORMAT(transaction_date, '%Y') = '2022'
  GROUP BY
    category,
    product
)
SELECT
  category,
  product,
  total_spend
FROM
  category_product_spend_2022
WHERE 
  serial <= 2;


Q159:

CREATE TABLE users
(
  user_id INT,
  signup_date TIMESTAMP,
  last_login TIMESTAMP
);

INSERT INTO users VALUES(1001, '2022-06-01 12:00:00', '2022-07-05 12:00:00');
INSERT INTO users VALUES(1002, '2022-06-03 12:00:00', '2022-06-15 12:00:00');
INSERT INTO users VALUES(1004, '2022-06-02 12:00:00', '2022-06-15 12:00:00');
INSERT INTO users VALUES(1006, '2022-06-15 12:00:00', '2022-06-27 12:00:00');
INSERT INTO users VALUES(1012, '2022-06-16 12:00:00', '2022-07-22 12:00:00');

WITH users_churn_weekly AS (
  SELECT
    *,
    CASE
      WHEN DATEDIFF(last_login, signup_date) < 28
        THEN 'yes'
      ELSE
        'no'
    END AS churn,
    DATEDIFF(last_login, signup_date) as diff,
    WEEK(signup_date) - WEEK('2022-05-28') AS week_no
  FROM
    users
  WHERE
    DATE_FORMAT(signup_date, '%Y-%m') = '2022-06'
)
SELECT
  week_no,
  ROUND(
    COUNT(
      CASE
        WHEN churn = 'yes'
          THEN user_id
      END
    )*100.00/COUNT(*)
  , 2) AS churn_rate
FROM
  users_churn_weekly
GROUP BY
  week_no
;



Q1:


CREATE TABLE city
(
  id INT,
  name VARCHAR(17),
  country_code VARCHAR(10),
  district VARCHAR(20),
  population BIGINT
);

INSERT INTO city VALUES(6, 'Rotterdam' , 'NLD', 'Zuid-Holland', null);
INSERT INTO city VALUES(19, 'Zaanstad', 'NLD' , 'Noord-Holland', 135621);
INSERT INTO city VALUES(214, 'Porto Alegre', 'BRA', 'Rio Grande do Sul', 1314032);
INSERT INTO city VALUES(397, 'Lauro de Freitas', 'BRA', 'Bahia', 109236);
INSERT INTO city VALUES(547, 'Dobric', 'BGR', 'Varna', 100399);
INSERT INTO city VALUES(552, 'Bujumbura', 'BDI', 'Bujumbura', 300000);
INSERT INTO city VALUES(554, 'Santiago de Chile', 'CHL', 'Santiago', 4703954);
INSERT INTO city VALUES(626, 'al-Minya', 'EGY', 'al-Minya', 201360);
INSERT INTO city VALUES(646, 'Santa Ana', 'SLV', 'Santa Ana', 139389);
INSERT INTO city VALUES(762, 'Bahir' ,'Dar', 'ETH Amhara', 96140);
INSERT INTO city VALUES(796, 'Baguio', 'PHL', 'CAR', 252386);
INSERT INTO city VALUES(896, 'Malungon', 'PHL', 'Southern Mindanao', 93232);
INSERT INTO city VALUES(904, 'Banjul', 'GMB', 'Banjul', 42326);
INSERT INTO city VALUES(924, 'Villa', 'Nueva', 'GTM', 101295);
INSERT INTO city VALUES(990, 'Waru', 'IDN', 'East Java', 124300);
INSERT INTO city VALUES(1155, 'Latur', 'IND', 'Maharashtra', 197408);
INSERT INTO city VALUES(1222, 'Tenali', 'IND', 'Andhra Pradesh', 143726);
INSERT INTO city VALUES(1235, 'Tirunelveli', 'IND', 'Tamil Nadu', 135825);
INSERT INTO city VALUES(1256, 'Alandur', 'IND', 'Tamil Nadu', 125244);
INSERT INTO city VALUES(1279, 'Neyveli', 'IND', 'Tamil Nadu', 118080);
INSERT INTO city VALUES(1293, 'Pallavaram', 'IND', 'Tamil Nadu', 111866);
INSERT INTO city VALUES(1350, 'Dehri', 'IND', 'Bihar', 94526);
INSERT INTO city VALUES(1383, 'Tabriz', 'IRN', 'East Azerbaidzan', 1191043);
INSERT INTO city VALUES(1385, 'Karaj', 'IRN', 'Teheran', 940968);
INSERT INTO city VALUES(1508, 'Bolzano', 'ITA', 'Trentino-Alto Adige', 97232);
INSERT INTO city VALUES(1520, 'Cesena', 'ITA', 'Emilia-Romagna', 89852);
INSERT INTO city VALUES(1613, 'Neyagawa', 'JPN', 'Osaka', 257315);
INSERT INTO city VALUES(1630, 'Ageo', 'JPN', 'Saitama', 209442);
INSERT INTO city VALUES(1661, 'Sayama', 'JPN', 'Saitama', 162472);
INSERT INTO city VALUES(1681, 'Omuta', 'JPN', 'Fukuoka', 142889);
INSERT INTO city VALUES(1739, 'Tokuyama', 'JPN', 'Yamaguchi', 107078);
INSERT INTO city VALUES(1793, 'Novi Sad' , 'YUG' , 'Vojvodina', 179626);
INSERT INTO city VALUES(1857, 'Kelowna', 'CAN', 'British Colombia', 89442);
INSERT INTO city VALUES(1895, 'Harbin', 'CHN', 'Heilongjiang', 4289800);
INSERT INTO city VALUES(1900, 'Changchun', 'CHN', 'Jilin', 2812000);
INSERT INTO city VALUES(1913, 'Lanzhou', 'CHN', 'Gansu', 1565800);
INSERT INTO city VALUES(1947, 'Changzhou', 'CHN', 'Jiangsu', 530000);
INSERT INTO city VALUES(2070, 'Dezhou', 'CHN', 'Shandong', 195485);
INSERT INTO city VALUES(2081, 'Heze', 'CHN', 'Shandong', 189293);
INSERT INTO city VALUES(2111, 'Chenzhou', 'CHN', 'Hunan', 169400);
INSERT INTO city VALUES(2153, 'Xianning', 'CHN', 'Hubei', 136811);
INSERT INTO city VALUES(2192, 'Lhasa', 'CHN', 'Tibet', 120000);
INSERT INTO city VALUES(2193, 'Lianyuan', 'CHN', 'Hunan', 118858);
INSERT INTO city VALUES(2227, 'Xingcheng', 'CHN', 'Liaoning', 102384);
INSERT INTO city VALUES(2273, 'Villavicencio', 'COL', 'Meta', 273140);
INSERT INTO city VALUES(2384, 'Tong-yong', 'KOR', 'Kyongsangnam', 131717);
INSERT INTO city VALUES(2386, 'Yongju', 'KOR', 'Kyongsangbuk', 131097);
INSERT INTO city VALUES(2387, 'Chinhae', 'KOR', 'Kyongsangnam', 125997);
INSERT INTO city VALUES(2388, 'Sangju', 'KOR', 'Kyongsangbuk', 124116);
INSERT INTO city VALUES(2406, 'Herakleion', 'GRC', 'Crete', 116178);
INSERT INTO city VALUES(2440, 'Monrovia', 'LBR', 'Montserrado', 850000);
INSERT INTO city VALUES(2462, 'Lilongwe', 'MWI', 'Lilongwe', 435964);
INSERT INTO city VALUES(2505, 'Taza', 'MAR', 'Taza-Al Hoceima-Taou', 92700);
INSERT INTO city VALUES(2555, 'Xalapa', 'MEX', 'Veracruz', 390058);
INSERT INTO city VALUES(2602, 'Ocosingo', 'MEX', 'Chiapas',171495);
INSERT INTO city VALUES(2609, 'Nogales', 'MEX', 'Sonora', 159103);
INSERT INTO city VALUES(2670, 'San Pedro Cholula', 'MEX', 'Puebla', 99734);
INSERT INTO city VALUES(2689, 'Palikir', 'FSM', 'Pohnpei', 8600);
INSERT INTO city VALUES(2706, 'Tete', 'MOZ', 'Tete', 101984);
INSERT INTO city VALUES(2716, 'Sittwe (Akyab)', 'MMR', 'Rakhine', 137600);
INSERT INTO city VALUES(2922, 'Carolina', 'PRI', 'Carolina', 186076);
INSERT INTO city VALUES(2967, 'Grudziadz', 'POL', 'Kujawsko-Pomorskie', 102434);
INSERT INTO city VALUES(2972, ' Malabo', 'GNQ', 'Bioko', 40000);
INSERT INTO city VALUES(3073, 'Essen', 'DEU', 'Nordrhein-Westfalen', 599515);
INSERT INTO city VALUES(3169, 'Apia', 'WSM', 'Upolu', 35900);
INSERT INTO city VALUES(3198, 'Dakar', 'SEN', 'Cap-Vert', 785071);
INSERT INTO city VALUES(3253, 'Hama', 'SYR', 'Hama', 343361);
INSERT INTO city VALUES(3288, 'Luchou', 'TWN', 'Taipei', 160516);
INSERT INTO city VALUES(3309, 'Tanga', 'TZA', 'Tanga', 137400);
INSERT INTO city VALUES(3353, 'Sousse' , 'TUN', 'Sousse', 145900);
INSERT INTO city VALUES(3377, 'Kahramanmaras', 'TUR', 'Kahramanmaras', 245772);
INSERT INTO city VALUES(3430, 'Odesa', 'UKR', 'Odesa', 1011000);
INSERT INTO city VALUES(3581, 'St Petersburg', 'RUS', 'Pietari', 4694000);
INSERT INTO city VALUES(3770, 'Hanoi', 'VNM', 'Hanoi', 1410000);
INSERT INTO city VALUES(3815, 'El Paso', 'USA', 'Texas', 563662);
INSERT INTO city VALUES(3878, 'Scottsdale', 'USA', 'Arizona', 202705);
INSERT INTO city VALUES(3965, 'Corona', 'USA', 'California', 124966);
INSERT INTO city VALUES(3973, 'Concord', 'USA', 'California', 121780);
INSERT INTO city VALUES(3977, 'Cedar Rapids', 'USA', 'Iowa', 120758);
INSERT INTO city VALUES(3982, 'Coral Springs', 'USA', 'Florida', 117549);
INSERT INTO city VALUES(4054, 'Fairfield', 'USA', 'California', 92256);
INSERT INTO city VALUES(4058, 'Boulder', 'USA', 'Colorado', 91238);
INSERT INTO city VALUES(4061, 'Fall River', 'USA', 'Massachusetts', 90555);




Q1;

SELECT
  *
FROM
  city
WHERE
  country_code = 'USA'
  AND population > 100000;

Q2;

SELECT
  name AS city_name
FROM
  city
WHERE
  country_code = 'USA'
  AND population > 120000;


Q3;

SELECT
  id,
  name,
  country_code,
  district,
  population
FROM
  city
;


Q4:

SELECT
  *
FROM
  city
WHERE
  id = 1661
;


Q5;

SELECT
  id,
  name,
  country_code,
  district,
  population
FROM
  city
WHERE
  country_code = 'JPN'


Q6:

SELECT
  name AS city_name
FROM
  city
WHERE
  country_code = 'JPN'
;


CREATE TABLE station(
   id INT,
  city VARCHAR(23),
  state VARCHAR(2),
  lat_n INT,
  long_n INT 
);

INSERT INTO station VALUES (794,'Kissee Mills','MO',139,73);
INSERT INTO station VALUES (824,'Loma Mar','CA',48,130);
INSERT INTO station VALUES (603,'Sandy Hook','CT',72,148);
INSERT INTO station VALUES (478,'Tipton','IN',33,97);
INSERT INTO station VALUES (619,'Arlington','CO',75,92);
INSERT INTO station VALUES (711,'Turner','AR',50,101);
INSERT INTO station VALUES (839,'Slidell','LA',85,151);
INSERT INTO station VALUES (411,'Negreet','LA',98,105);
INSERT INTO station VALUES (588,'Glencoe','KY',46,136);
INSERT INTO station VALUES (665,'Chelsea','IA',98,59);
INSERT INTO station VALUES (342,'Chignik Lagoon','AK',103,153);
INSERT INTO station VALUES (733,'Pelahatchie','MS',38,28);
INSERT INTO station VALUES (441,'Hanna City','IL',50,136);
INSERT INTO station VALUES (811,'Dorrance','KS',102,121);
INSERT INTO station VALUES (698,'Albany','CA',49,80);
INSERT INTO station VALUES (325,'Monument','KS',70,141);
INSERT INTO station VALUES (414,'Manchester','MD',73,37);
INSERT INTO station VALUES (113,'Prescott','IA',39,65);
INSERT INTO station VALUES (971,'Graettinger','IA',94,150);
INSERT INTO station VALUES (266,'Cahone','CO',116,127);
INSERT INTO station VALUES (617,'Sturgis','MS',36,126);
INSERT INTO station VALUES (495,'Upperco','MD',114,29);
INSERT INTO station VALUES (473,'Highwood','IL',27,150);
INSERT INTO station VALUES (959,'Waipahu','HI',106,33);
INSERT INTO station VALUES (438,'Bowdon','GA',88,78);
INSERT INTO station VALUES (571,'Tyler','MN',133,58);
INSERT INTO station VALUES (92,'Watkins','CO',83,96);
INSERT INTO station VALUES (399,'Republic','MI',75,130);
INSERT INTO station VALUES (426,'Millville','CA',32,145);
INSERT INTO station VALUES (844,'Aguanga','CA',79,65);
INSERT INTO station VALUES (321,'Bowdon Junction','GA',85,33);
INSERT INTO station VALUES (606,'Morenci','AZ',104,110);
INSERT INTO station VALUES (957,'South El Monte','CA',74,79);
INSERT INTO station VALUES (833,'Hoskinston','KY',65,65);
INSERT INTO station VALUES (843,'Talbert','KY',39,58);
INSERT INTO station VALUES (166,'Mccomb','MS',74,42);
INSERT INTO station VALUES (339,'Kirk','CO',141,136);
INSERT INTO station VALUES (909,'Carlock','IL',117,84);
INSERT INTO station VALUES (829,'Seward','IL',72,90);
INSERT INTO station VALUES (766,'Gustine','CA',111,140);
INSERT INTO station VALUES (392,'Delano','CA',126,91);
INSERT INTO station VALUES (555,'Westphalia','MI',32,143);
INSERT INTO station VALUES (33,'Saint Elmo','AL',27,50);
INSERT INTO station VALUES (728,'Roy','MT',41,51);
INSERT INTO station VALUES (656,'Pattonsburg','MO',138,32);
INSERT INTO station VALUES (394,'Centertown','MO',133,93);
INSERT INTO station VALUES (366,'Norvell','MI',125,93);
INSERT INTO station VALUES (96,'Raymondville','MO',70,148);
INSERT INTO station VALUES (867,'Beaver Island','MI',81,164);
INSERT INTO station VALUES (977,'Odin','IL',53,115);
INSERT INTO station VALUES (741,'Jemison','AL',62,25);
INSERT INTO station VALUES (436,'West Hills','CA',68,73);
INSERT INTO station VALUES (323,'Barrigada','GU',60,147);
INSERT INTO station VALUES (3,'Hesperia','CA',106,71);
INSERT INTO station VALUES (814,'Wickliffe','KY',80,46);
INSERT INTO station VALUES (375,'Culdesac','ID',47,78);
INSERT INTO station VALUES (467,'Roselawn','IN',87,51);
INSERT INTO station VALUES (604,'Forest Lakes','AZ',144,114);
INSERT INTO station VALUES (551,'San Simeon','CA',37,28);
INSERT INTO station VALUES (706,'Little Rock','AR',122,121);
INSERT INTO station VALUES (647,'Portland','AR',83,44);
INSERT INTO station VALUES (25,'New Century','KS',135,79);
INSERT INTO station VALUES (250,'Hampden','MA',76,26);
INSERT INTO station VALUES (124,'Pine City','MN',119,129);
INSERT INTO station VALUES (547,'Sandborn','IN',55,93);
INSERT INTO station VALUES (701,'Seaton','IL',128,78);
INSERT INTO station VALUES (197,'Milledgeville','IL',90,113);
INSERT INTO station VALUES (613,'East China','MI',108,42);
INSERT INTO station VALUES (630,'Prince Frederick','MD',104,57);
INSERT INTO station VALUES (767,'Pomona Park','FL',100,163);
INSERT INTO station VALUES (679,'Gretna','LA',75,142);
INSERT INTO station VALUES (896,'Yazoo City','MS',95,85);
INSERT INTO station VALUES (403,'Zionsville','IN',57,36);
INSERT INTO station VALUES (519,'Rio Oso','CA',29,105);
INSERT INTO station VALUES (482,'Jolon','CA',66,52);
INSERT INTO station VALUES (252,'Childs','MD',92,104);
INSERT INTO station VALUES (600,'Shreveport','LA',136,38);
INSERT INTO station VALUES (14,'Forest','MS',120,50);
INSERT INTO station VALUES (260,'Sizerock','KY',116,112);
INSERT INTO station VALUES (65,'Buffalo Creek','CO',47,148);
INSERT INTO station VALUES (753,'Algonac','MI',118,80);
INSERT INTO station VALUES (174,'Onaway','MI',108,55);
INSERT INTO station VALUES (263,'Irvington','IL',96,68);
INSERT INTO station VALUES (253,'Winsted','MN',68,72);
INSERT INTO station VALUES (557,'Woodbury','GA',102,93);
INSERT INTO station VALUES (897,'Samantha','AL',75,35);
INSERT INTO station VALUES (98,'Hackleburg','AL',119,120);
INSERT INTO station VALUES (423,'Soldier','KS',77,152);
INSERT INTO station VALUES (361,'Arrowsmith','IL',28,109);
INSERT INTO station VALUES (409,'Columbus','GA',67,46);
INSERT INTO station VALUES (312,'Bentonville','AR',36,78);
INSERT INTO station VALUES (854,'Kirkland','AZ',86,57);
INSERT INTO station VALUES (160,'Grosse Pointe','MI',102,91);
INSERT INTO station VALUES (735,'Wilton','ME',56,157);
INSERT INTO station VALUES (608,'Busby','MT',104,29);
INSERT INTO station VALUES (122,'Robertsdale','AL',97,85);
INSERT INTO station VALUES (93,'Dale','IN',69,34);
INSERT INTO station VALUES (67,'Reeds','MO',30,42);
INSERT INTO station VALUES (906,'Hayfork','CA',35,116);
INSERT INTO station VALUES (34,'Mcbrides','MI',74,35);
INSERT INTO station VALUES (921,'Lee Center','IL',95,77);
INSERT INTO station VALUES (401,'Tennessee','IL',55,155);
INSERT INTO station VALUES (536,'Henderson','IA',77,77);
INSERT INTO station VALUES (953,'Udall','KS',112,59);
INSERT INTO station VALUES (370,'Palm Desert','CA',106,145);
INSERT INTO station VALUES (614,'Benedict','KS',138,95);
INSERT INTO station VALUES (998,'Oakfield','ME',47,132);
INSERT INTO station VALUES (805,'Tamms','IL',59,75);
INSERT INTO station VALUES (235,'Haubstadt','IN',27,32);
INSERT INTO station VALUES (820,'Chokio','MN',81,134);
INSERT INTO station VALUES (650,'Clancy','MT',45,164);
INSERT INTO station VALUES (791,'Scotts Valley','CA',119,90);
INSERT INTO station VALUES (324,'Norwood','MN',144,34);
INSERT INTO station VALUES (442,'Elkton','MD',103,156);
INSERT INTO station VALUES (633,'Bertha','MN',39,105);
INSERT INTO station VALUES (109,'Bridgeport','MI',50,79);
INSERT INTO station VALUES (780,'Cherry','IL',68,46);
INSERT INTO station VALUES (492,'Regina','KY',131,90);
INSERT INTO station VALUES (965,'Griffin','GA',38,151);
INSERT INTO station VALUES (778,'Pine Bluff','AR',60,145);
INSERT INTO station VALUES (337,'Mascotte','FL',121,146);
INSERT INTO station VALUES (259,'Baldwin','MD',81,40);
INSERT INTO station VALUES (955,'Netawaka','KS',109,119);
INSERT INTO station VALUES (752,'East Irvine','CA',106,115);
INSERT INTO station VALUES (886,'Pony','MT',99,162);
INSERT INTO station VALUES (200,'Franklin','LA',82,31);
INSERT INTO station VALUES (384,'Amo','IN',103,159);
INSERT INTO station VALUES (518,'Vulcan','MO',108,91);
INSERT INTO station VALUES (188,'Prairie Du Rocher','IL',75,70);
INSERT INTO station VALUES (161,'Alanson','MI',90,72);
INSERT INTO station VALUES (486,'Delta','LA',136,49);
INSERT INTO station VALUES (406,'Carver','MN',45,122);
INSERT INTO station VALUES (940,'Paron','AR',59,104);
INSERT INTO station VALUES (237,'Winchester','ID',38,80);
INSERT INTO station VALUES (465,'Jerome','AZ',121,34);
INSERT INTO station VALUES (591,'Baton Rouge','LA',129,71);
INSERT INTO station VALUES (570,'Greenview','CA',80,57);
INSERT INTO station VALUES (429,'Lucerne Valley','CA',35,48);
INSERT INTO station VALUES (278,'Cromwell','MN',128,53);
INSERT INTO station VALUES (927,'Quinter','KS',59,25);
INSERT INTO station VALUES (59,'Whitewater','MO',82,71);
INSERT INTO station VALUES (218,'Round Pond','ME',127,124);
INSERT INTO station VALUES (291,'Clarkdale','AZ',58,73);
INSERT INTO station VALUES (668,'Rockton','IL',116,86);
INSERT INTO station VALUES (682,'Pheba','MS',90,127);
INSERT INTO station VALUES (775,'Eleele','HI',80,152);
INSERT INTO station VALUES (527,'Auburn','IA',95,137);
INSERT INTO station VALUES (108,'North Berwick','ME',70,27);
INSERT INTO station VALUES (190,'Oconee','GA',92,119);
INSERT INTO station VALUES (232,'Grandville','MI',38,70);
INSERT INTO station VALUES (405,'Susanville','CA',128,80);
INSERT INTO station VALUES (273,'Rosie','AR',72,161);
INSERT INTO station VALUES (813,'Verona','MO',109,152);
INSERT INTO station VALUES (444,'Richland','GA',105,113);
INSERT INTO station VALUES (899,'Fremont','MI',54,150);
INSERT INTO station VALUES (738,'Philipsburg','MT',95,72);
INSERT INTO station VALUES (215,'Kensett','IA',55,139);
INSERT INTO station VALUES (743,'De Tour Village','MI',25,25);
INSERT INTO station VALUES (377,'Koleen','IN',137,110);
INSERT INTO station VALUES (727,'Winslow','IL',113,38);
INSERT INTO station VALUES (363,'Reasnor','IA',41,162);
INSERT INTO station VALUES (117,'West Grove','IA',127,99);
INSERT INTO station VALUES (420,'Frankfort Heights','IL',71,30);
INSERT INTO station VALUES (888,'Bono','AR',133,150);
INSERT INTO station VALUES (784,'Biggsville','IL',85,138);
INSERT INTO station VALUES (413,'Linthicum Heights','MD',127,67);
INSERT INTO station VALUES (695,'Amazonia','MO',45,148);
INSERT INTO station VALUES (609,'Marysville','MI',85,132);
INSERT INTO station VALUES (471,'Cape Girardeau','MO',73,90);
INSERT INTO station VALUES (649,'Pengilly','MN',25,154);
INSERT INTO station VALUES (946,'Newton Center','MA',48,144);
INSERT INTO station VALUES (380,'Crane Lake','MN',72,43);
INSERT INTO station VALUES (383,'Newbury','MA',128,85);
INSERT INTO station VALUES (44,'Kismet','KS',99,156);
INSERT INTO station VALUES (433,'Canton','ME',98,105);
INSERT INTO station VALUES (283,'Clipper Mills','CA',113,56);
INSERT INTO station VALUES (474,'Grayslake','IL',61,33);
INSERT INTO station VALUES (233,'Pierre Part','LA',52,90);
INSERT INTO station VALUES (990,'Bison','KS',132,74);
INSERT INTO station VALUES (502,'Bellevue','KY',127,121);
INSERT INTO station VALUES (327,'Ridgway','CO',77,110);
INSERT INTO station VALUES (4,'South Britain','CT',65,33);
INSERT INTO station VALUES (228,'Rydal','GA',35,78);
INSERT INTO station VALUES (642,'Lynnville','KY',25,146);
INSERT INTO station VALUES (885,'Deerfield','MO',40,35);
INSERT INTO station VALUES (539,'Montreal','MO',129,127);
INSERT INTO station VALUES (202,'Hope','MN',140,43);
INSERT INTO station VALUES (593,'Aliso Viejo','CA',67,131);
INSERT INTO station VALUES (521,'Gowrie','IA',130,127);
INSERT INTO station VALUES (938,'Andersonville','GA',141,72);
INSERT INTO station VALUES (919,'Knob Lick','KY',135,33);
INSERT INTO station VALUES (528,'Crouseville','ME',36,81);
INSERT INTO station VALUES (331,'Cranks','KY',55,27);
INSERT INTO station VALUES (45,'Rives Junction','MI',94,116);
INSERT INTO station VALUES (944,'Ledyard','CT',134,143);
INSERT INTO station VALUES (949,'Norway','ME',83,88);
INSERT INTO station VALUES (88,'Eros','LA',95,58);
INSERT INTO station VALUES (878,'Rantoul','KS',31,118);
INSERT INTO station VALUES (35,'Richmond Hill','GA',39,113);
INSERT INTO station VALUES (17,'Fredericktown','MO',105,112);
INSERT INTO station VALUES (447,'Arkadelphia','AR',98,49);
INSERT INTO station VALUES (498,'Glen Carbon','IL',60,140);
INSERT INTO station VALUES (351,'Fredericksburg','IN',44,78);
INSERT INTO station VALUES (774,'Manchester','IA',129,123);
INSERT INTO station VALUES (116,'Mc Henry','MD',93,112);
INSERT INTO station VALUES (963,'Eriline','KY',93,65);
INSERT INTO station VALUES (643,'Wellington','KY',100,31);
INSERT INTO station VALUES (781,'Hoffman Estates','IL',129,53);
INSERT INTO station VALUES (364,'Howard Lake','MN',125,78);
INSERT INTO station VALUES (777,'Edgewater','MD',130,72);
INSERT INTO station VALUES (15,'Ducor','CA',140,102);
INSERT INTO station VALUES (910,'Salem','KY',86,113);
INSERT INTO station VALUES (612,'Sturdivant','MO',93,86);
INSERT INTO station VALUES (537,'Hagatna','GU',97,151);
INSERT INTO station VALUES (970,'East Haddam','CT',115,132);
INSERT INTO station VALUES (510,'Eastlake','MI',134,38);
INSERT INTO station VALUES (354,'Larkspur','CA',107,65);
INSERT INTO station VALUES (983,'Patriot','IN',82,46);
INSERT INTO station VALUES (799,'Corriganville','MD',141,153);
INSERT INTO station VALUES (581,'Carlos','MN',114,66);
INSERT INTO station VALUES (825,'Addison','MI',96,142);
INSERT INTO station VALUES (526,'Tarzana','CA',135,81);
INSERT INTO station VALUES (176,'Grapevine','AR',92,84);
INSERT INTO station VALUES (994,'Kanorado','KS',65,85);
INSERT INTO station VALUES (704,'Climax','MI',127,107);
INSERT INTO station VALUES (582,'Curdsville','KY',84,150);
INSERT INTO station VALUES (884,'Southport','CT',59,63);
INSERT INTO station VALUES (196,'Compton','IL',106,99);
INSERT INTO station VALUES (605,'Notasulga','AL',66,115);
INSERT INTO station VALUES (430,'Rumsey','KY',70,50);
INSERT INTO station VALUES (234,'Rogers','CT',140,33);
INSERT INTO station VALUES (700,'Pleasant Grove','AR',135,145);
INSERT INTO station VALUES (702,'Everton','MO',119,51);
INSERT INTO station VALUES (662,'Skanee','MI',70,129);
INSERT INTO station VALUES (171,'Springerville','AZ',124,150);
INSERT INTO station VALUES (615,'Libertytown','MD',144,111);
INSERT INTO station VALUES (26,'Church Creek','MD',39,91);
INSERT INTO station VALUES (692,'Yellow Pine','ID',83,150);
INSERT INTO station VALUES (336,'Dumont','MN',57,129);
INSERT INTO station VALUES (464,'Gales Ferry','CT',104,37);
INSERT INTO station VALUES (315,'Ravenna','KY',79,106);
INSERT INTO station VALUES (505,'Williams','AZ',73,111);
INSERT INTO station VALUES (842,'Decatur','MI',63,161);
INSERT INTO station VALUES (982,'Holbrook','AZ',134,103);
INSERT INTO station VALUES (868,'Sherrill','AR',79,152);
INSERT INTO station VALUES (554,'Brownsdale','MN',52,50);
INSERT INTO station VALUES (199,'Linden','MI',53,32);
INSERT INTO station VALUES (453,'Sedgwick','AR',68,75);
INSERT INTO station VALUES (451,'Fort Atkinson','IA',142,140);
INSERT INTO station VALUES (950,'Peachtree City','GA',80,155);
INSERT INTO station VALUES (326,'Rocheport','MO',114,64);
INSERT INTO station VALUES (189,'West Somerset','KY',73,45);
INSERT INTO station VALUES (638,'Clovis','CA',92,138);
INSERT INTO station VALUES (156,'Heyburn','ID',82,121);
INSERT INTO station VALUES (861,'Peabody','KS',75,152);
INSERT INTO station VALUES (722,'Marion Junction','AL',53,31);
INSERT INTO station VALUES (428,'Randall','KS',47,135);
INSERT INTO station VALUES (677,'Hayesville','IA',119,42);
INSERT INTO station VALUES (183,'Jordan','MN',68,35);
INSERT INTO station VALUES (322,'White Horse  Beach','MA',54,59);
INSERT INTO station VALUES (827,'Greenville','IL',50,153);
INSERT INTO station VALUES (242,'Macy','IN',138,152);
INSERT INTO station VALUES (621,'Flowood','MS',64,149);
INSERT INTO station VALUES (960,'Deep River','IA',75,38);
INSERT INTO station VALUES (180,'Napoleon','IN',32,160);
INSERT INTO station VALUES (382,'Leavenworth','IN',100,121);
INSERT INTO station VALUES (853,'Coldwater','KS',47,26);
INSERT INTO station VALUES (105,'Weldon','CA',134,118);
INSERT INTO station VALUES (357,'Yellville','AR',35,42);
INSERT INTO station VALUES (710,'Turners Falls','MA',31,125);
INSERT INTO station VALUES (520,'Delray Beach','FL',27,158);
INSERT INTO station VALUES (920,'Eustis','FL',42,39);
INSERT INTO station VALUES (684,'Mineral Point','MO',91,41);
INSERT INTO station VALUES (355,'Weldona','CO',32,58);
INSERT INTO station VALUES (389,'Midpines','CA',106,59);
INSERT INTO station VALUES (303,'Cascade','ID',31,157);
INSERT INTO station VALUES (501,'Tefft','IN',93,150);
INSERT INTO station VALUES (673,'Showell','MD',44,163);
INSERT INTO station VALUES (834,'Bayville','ME',106,143);
INSERT INTO station VALUES (255,'Brighton','IL',107,32);
INSERT INTO station VALUES (595,'Grimes','IA',42,74);
INSERT INTO station VALUES (709,'Nubieber','CA',132,49);
INSERT INTO station VALUES (100,'North Monmouth','ME',130,78);
INSERT INTO station VALUES (522,'Harmony','MN',124,126);
INSERT INTO station VALUES (16,'Beaufort','MO',71,85);
INSERT INTO station VALUES (231,'Arispe','IA',31,137);
INSERT INTO station VALUES (923,'Union Star','MO',79,132);
INSERT INTO station VALUES (891,'Humeston','IA',74,122);
INSERT INTO station VALUES (165,'Baileyville','IL',82,61);
INSERT INTO station VALUES (757,'Lakeville','CT',59,94);
INSERT INTO station VALUES (506,'Firebrick','KY',49,95);
INSERT INTO station VALUES (76,'Pico Rivera','CA',143,116);
INSERT INTO station VALUES (246,'Ludington','MI',30,120);
INSERT INTO station VALUES (583,'Channing','MI',117,56);
INSERT INTO station VALUES (666,'West Baden Springs','IN',30,96);
INSERT INTO station VALUES (373,'Pawnee','IL',85,81);
INSERT INTO station VALUES (504,'Melber','KY',37,55);
INSERT INTO station VALUES (901,'Manchester','MN',71,84);
INSERT INTO station VALUES (306,'Bainbridge','GA',62,56);
INSERT INTO station VALUES (821,'Sanders','AZ',130,96);
INSERT INTO station VALUES (586,'Ottertail','MN',100,44);
INSERT INTO station VALUES (95,'Dupo','IL',41,29);
INSERT INTO station VALUES (524,'Montrose','CA',136,119);
INSERT INTO station VALUES (716,'Schleswig','IA',119,51);
INSERT INTO station VALUES (849,'Harbor Springs','MI',141,148);
INSERT INTO station VALUES (611,'Richmond','IL',113,163);
INSERT INTO station VALUES (904,'Ermine','KY',119,62);
INSERT INTO station VALUES (740,'Siler','KY',137,117);
INSERT INTO station VALUES (439,'Reeves','LA',35,51);
INSERT INTO station VALUES (57,'Clifton','AZ',30,135);
INSERT INTO station VALUES (155,'Casco','MI',138,109);
INSERT INTO station VALUES (755,'Sturgis','MI',117,135);
INSERT INTO station VALUES (11,'Crescent City','FL',58,117);
INSERT INTO station VALUES (287,'Madisonville','LA',112,53);
INSERT INTO station VALUES (435,'Albion','IN',44,121);
INSERT INTO station VALUES (672,'Lismore','MN',58,103);
INSERT INTO station VALUES (572,'Athens','IN',75,120);
INSERT INTO station VALUES (890,'Eufaula','AL',140,103);
INSERT INTO station VALUES (975,'Panther Burn','MS',116,164);
INSERT INTO station VALUES (914,'Hanscom Afb','MA',129,136);
INSERT INTO station VALUES (119,'Wildie','KY',69,111);
INSERT INTO station VALUES (540,'Mosca','CO',89,141);
INSERT INTO station VALUES (678,'Bennington','IN',35,26);
INSERT INTO station VALUES (208,'Lottie','LA',109,82);
INSERT INTO station VALUES (512,'Garland','ME',108,134);
INSERT INTO station VALUES (352,'Clutier','IA',61,127);
INSERT INTO station VALUES (948,'Lupton','MI',139,53);
INSERT INTO station VALUES (503,'Northfield','MN',61,37);
INSERT INTO station VALUES (288,'Daleville','AL',121,136);
INSERT INTO station VALUES (560,'Osage City','KS',110,89);
INSERT INTO station VALUES (479,'Cuba','MO',63,87);
INSERT INTO station VALUES (826,'Norris','MT',47,37);
INSERT INTO station VALUES (651,'Clopton','AL',40,84);
INSERT INTO station VALUES (143,'Renville','MN',142,99);
INSERT INTO station VALUES (240,'Saint Paul','KS',66,163);
INSERT INTO station VALUES (102,'Kirksville','MO',140,143);
INSERT INTO station VALUES (69,'Kingsland','AR',78,85);
INSERT INTO station VALUES (181,'Fairview','KS',80,164);
INSERT INTO station VALUES (175,'Lydia','LA',41,39);
INSERT INTO station VALUES (80,'Bridgton','ME',93,140);
INSERT INTO station VALUES (596,'Brownstown','IL',48,63);
INSERT INTO station VALUES (301,'Monona','IA',144,81);
INSERT INTO station VALUES (987,'Hartland','MI',136,107);
INSERT INTO station VALUES (973,'Andover','CT',51,52);
INSERT INTO station VALUES (981,'Lakota','IA',56,92);
INSERT INTO station VALUES (440,'Grand Terrace','CA',37,126);
INSERT INTO station VALUES (110,'Mesick','MI',82,108);
INSERT INTO station VALUES (396,'Dryden','MI',69,47);
INSERT INTO station VALUES (637,'Beverly','KY',57,126);
INSERT INTO station VALUES (566,'Marine On  Saint  Croix','MN',126,NULL);
INSERT INTO station VALUES (801,'Pocahontas','IL',109,83);
INSERT INTO station VALUES (739,'Fort Meade','FL',43,35);
INSERT INTO station VALUES (130,'Hayneville','AL',109,157);
INSERT INTO station VALUES (345,'Yoder','IN',83,143);
INSERT INTO station VALUES (851,'Gatewood','MO',76,145);
INSERT INTO station VALUES (489,'Madden','MS',81,99);
INSERT INTO station VALUES (223,'Losantville','IN',112,106);
INSERT INTO station VALUES (538,'Cheswold','DE',31,59);
INSERT INTO station VALUES (329,'Caseville','MI',102,98);
INSERT INTO station VALUES (815,'Pomona','MO',52,50);
INSERT INTO station VALUES (789,'Hopkinsville','KY',27,47);
INSERT INTO station VALUES (269,'Jack','AL',49,85);
INSERT INTO station VALUES (969,'Dixie','GA',27,36);
INSERT INTO station VALUES (271,'Hillside','CO',99,68);
INSERT INTO station VALUES (667,'Hawarden','IA',90,46);
INSERT INTO station VALUES (350,'Cannonsburg','MI',91,120);
INSERT INTO station VALUES (49,'Osborne','KS',70,139);
INSERT INTO station VALUES (332,'Elm Grove','LA',45,29);
INSERT INTO station VALUES (172,'Atlantic Mine','MI',131,99);
INSERT INTO station VALUES (699,'North Branford','CT',37,95);
INSERT INTO station VALUES (417,'New Liberty','IA',139,94);
INSERT INTO station VALUES (99,'Woodstock Valley','CT',117,162);
INSERT INTO station VALUES (404,'Farmington','IL',91,72);
INSERT INTO station VALUES (23,'Honolulu','HI',110,139);
INSERT INTO station VALUES (1,'Pfeifer','KS',37,65);
INSERT INTO station VALUES (127,'Oshtemo','MI',100,135);
INSERT INTO station VALUES (657,'Gridley','KS',118,55);
INSERT INTO station VALUES (261,'Fulton','KY',111,51);
INSERT INTO station VALUES (182,'Winter Park','FL',133,32);
INSERT INTO station VALUES (328,'Monroe','LA',28,108);
INSERT INTO station VALUES (779,'Del Mar','CA',59,95);
INSERT INTO station VALUES (646,'Greens Fork','IN',133,135);
INSERT INTO station VALUES (756,'Garden City','AL',96,105);
INSERT INTO station VALUES (157,'Blue River','KY',116,161);
INSERT INTO station VALUES (400,'New Ross','IN',134,120);
INSERT INTO station VALUES (61,'Brilliant','AL',86,159);
INSERT INTO station VALUES (610,'Archie','MO',40,28);
INSERT INTO station VALUES (985,'Winslow','AR',126,126);
INSERT INTO station VALUES (207,'Olmitz','KS',29,38);
INSERT INTO station VALUES (941,'Allerton','IA',61,112);
INSERT INTO station VALUES (70,'Norphlet','AR',144,61);
INSERT INTO station VALUES (343,'Mechanic Falls','ME',71,71);
INSERT INTO station VALUES (531,'North Middletown','KY',42,141);
INSERT INTO station VALUES (996,'Keyes','CA',76,85);
INSERT INTO station VALUES (167,'Equality','AL',106,116);
INSERT INTO station VALUES (750,'Neon','KY',101,147);
INSERT INTO station VALUES (410,'Calhoun','KY',95,56);
INSERT INTO station VALUES (725,'Alpine','AR',116,114);
INSERT INTO station VALUES (988,'Mullan','ID',143,154);
INSERT INTO station VALUES (55,'Coalgood','KY',57,149);
INSERT INTO station VALUES (640,'Walnut','MS',40,76);
INSERT INTO station VALUES (302,'Saint Petersburg','FL',51,119);
INSERT INTO station VALUES (387,'Ojai','CA',68,119);
INSERT INTO station VALUES (476,'Julian','CA',130,101);
INSERT INTO station VALUES (907,'Veedersburg','IN',78,94);
INSERT INTO station VALUES (294,'Orange Park','FL',59,137);
INSERT INTO station VALUES (661,'Payson','AZ',126,154);
INSERT INTO station VALUES (745,'Windom','KS',114,126);
INSERT INTO station VALUES (631,'Urbana','IA',142,29);
INSERT INTO station VALUES (356,'Ludlow','CA',110,87);
INSERT INTO station VALUES (419,'Lindsay','MT',143,67);
INSERT INTO station VALUES (494,'Palatka','FL',94,52);
INSERT INTO station VALUES (625,'Bristol','ME',87,95);
INSERT INTO station VALUES (459,'Harmony','IN',135,70);
INSERT INTO station VALUES (636,'Ukiah','CA',86,89);
INSERT INTO station VALUES (106,'Yuma','AZ',111,153);
INSERT INTO station VALUES (204,'Alba','MI',91,103);
INSERT INTO station VALUES (344,'Zachary','LA',60,152);
INSERT INTO station VALUES (599,'Esmond','IL',75,90);
INSERT INTO station VALUES (515,'Waresboro','GA',144,153);
INSERT INTO station VALUES (497,'Hills','MN',137,134);
INSERT INTO station VALUES (162,'Montgomery City','MO',70,44);
INSERT INTO station VALUES (499,'Delavan','MN',32,64);
INSERT INTO station VALUES (362,'Magnolia','MS',112,31);
INSERT INTO station VALUES (545,'Byron','CA',136,120);
INSERT INTO station VALUES (712,'Dundee','IA',61,105);
INSERT INTO station VALUES (257,'Eureka Springs','AR',72,34);
INSERT INTO station VALUES (154,'Baker','CA',31,148);
INSERT INTO station VALUES (715,'Hyde Park','MA',65,156);
INSERT INTO station VALUES (493,'Groveoak','AL',53,87);
INSERT INTO station VALUES (836,'Kenner','LA',91,126);
INSERT INTO station VALUES (82,'Many','LA',36,94);
INSERT INTO station VALUES (644,'Seward','AK',120,35);
INSERT INTO station VALUES (391,'Berryton','KS',60,139);
INSERT INTO station VALUES (696,'Chilhowee','MO',79,49);
INSERT INTO station VALUES (905,'Newark','IL',72,129);
INSERT INTO station VALUES (81,'Cowgill','MO',136,27);
INSERT INTO station VALUES (31,'Novinger','MO',108,111);
INSERT INTO station VALUES (299,'Goodman','MS',101,117);
INSERT INTO station VALUES (84,'Cobalt','CT',87,26);
INSERT INTO station VALUES (754,'South Haven','MI',144,52);
INSERT INTO station VALUES (144,'Eskridge','KS',107,63);
INSERT INTO station VALUES (305,'Bennington','KS',93,83);
INSERT INTO station VALUES (226,'Decatur','MS',71,117);
INSERT INTO station VALUES (224,'West Hyannisport','MA',58,96);
INSERT INTO station VALUES (694,'Ozona','FL',144,120);
INSERT INTO station VALUES (623,'Jackson','AL',111,67);
INSERT INTO station VALUES (543,'Lapeer','MI',128,114);
INSERT INTO station VALUES (819,'Peaks Island','ME',59,110);
INSERT INTO station VALUES (243,'Hazlehurst','MS',49,108);
INSERT INTO station VALUES (457,'Chester','CA',69,123);
INSERT INTO station VALUES (871,'Clarkston','MI',93,80);
INSERT INTO station VALUES (470,'Healdsburg','CA',111,54);
INSERT INTO station VALUES (705,'Hotchkiss','CO',69,71);
INSERT INTO station VALUES (690,'Ravenden Springs','AR',67,108);
INSERT INTO station VALUES (62,'Monroe','AR',131,150);
INSERT INTO station VALUES (365,'Payson','IL',81,92);
INSERT INTO station VALUES (922,'Kell','IL',70,58);
INSERT INTO station VALUES (838,'Strasburg','CO',89,47);
INSERT INTO station VALUES (286,'Five Points','AL',45,122);
INSERT INTO station VALUES (968,'Norris City','IL',53,76);
INSERT INTO station VALUES (928,'Coaling','AL',144,52);
INSERT INTO station VALUES (746,'Orange City','IA',93,162);
INSERT INTO station VALUES (892,'Effingham','KS',132,97);
INSERT INTO station VALUES (193,'Corcoran','CA',81,139);
INSERT INTO station VALUES (225,'Garden City','IA',54,119);
INSERT INTO station VALUES (573,'Alton','MO',79,112);
INSERT INTO station VALUES (830,'Greenway','AR',119,35);
INSERT INTO station VALUES (241,'Woodsboro','MD',76,141);
INSERT INTO station VALUES (783,'Strawn','IL',29,51);
INSERT INTO station VALUES (675,'Dent','MN',70,136);
INSERT INTO station VALUES (270,'Shingletown','CA',61,102);
INSERT INTO station VALUES (378,'Clio','IA',46,115);
INSERT INTO station VALUES (104,'Yalaha','FL',120,119);
INSERT INTO station VALUES (460,'Leakesville','MS',107,72);
INSERT INTO station VALUES (804,'Fort Lupton','CO',38,93);
INSERT INTO station VALUES (53,'Shasta','CA',99,155);
INSERT INTO station VALUES (448,'Canton','MN',123,151);
INSERT INTO station VALUES (751,'Agency','MO',59,95);
INSERT INTO station VALUES (29,'South Carrollton','KY',57,116);
INSERT INTO station VALUES (718,'Taft','CA',107,146);
INSERT INTO station VALUES (213,'Calpine','CA',46,43);
INSERT INTO station VALUES (624,'Knobel','AR',95,62);
INSERT INTO station VALUES (908,'Bullhead City','AZ',94,30);
INSERT INTO station VALUES (845,'Tina','MO',131,28);
INSERT INTO station VALUES (685,'Anthony','KS',45,161);
INSERT INTO station VALUES (731,'Emmett','ID',57,31);
INSERT INTO station VALUES (311,'South Haven','MN',30,87);
INSERT INTO station VALUES (866,'Haverhill','IA',61,109);
INSERT INTO station VALUES (598,'Middleboro','MA',108,149);
INSERT INTO station VALUES (541,'Siloam','GA',105,92);
INSERT INTO station VALUES (889,'Lena','LA',78,129);
INSERT INTO station VALUES (654,'Lee','IL',27,51);
INSERT INTO station VALUES (841,'Freeport','MI',113,50);
INSERT INTO station VALUES (446,'Mid Florida','FL',110,50);
INSERT INTO station VALUES (249,'Acme','LA',73,67);
INSERT INTO station VALUES (376,'Gorham','KS',111,64);
INSERT INTO station VALUES (136,'Bass Harbor','ME',137,61);
INSERT INTO station VALUES (455,'Granger','IA',33,102);


Q7:

SELECT
  city,
  state
FROM
  station;

Q8:

SELECT
  DISTINCT city
FROM
  station
WHERE
  id % 2 = 0;


Q9:

SELECT
  COUNT(city) - COUNT(DISTINCT city) AS diff_between_all_city_unique_city
FROM
  station;


Q10:

SELECT 
  city 
FROM
(
    (SELECT
      city,
      CHAR_LENGTH(city) as city_length
    FROM
      station
    ORDER BY 
      CHAR_LENGTH(city) DESC,
      city
    LIMIT 1)
  UNION
    (SELECT
      city,
      CHAR_LENGTH(city) as city_length
    FROM
      station
    ORDER BY 
      CHAR_LENGTH(city),
      city
    LIMIT 1)
) smallest_largest_city
;


Q11:


SELECT
  distinct city
FROM
  station
WHERE 
  LEFT(LOWER(city) , 1) IN ('a','e','i','o','u')
;


Q12:


SELECT
  distinct city
FROM
  station
WHERE 
  RIGHT(LOWER(city) , 1) IN ('a','e','i','o','u')
;


Q13:


SELECT
  distinct city
FROM
  station
WHERE 
  LEFT(LOWER(city) , 1) NOT IN ('a','e','i','o','u')
;


Q14:


SELECT
  distinct city
FROM
  station
WHERE 
  RIGHT(LOWER(city) , 1) NOT IN ('a','e','i','o','u')
;


Q15:

SELECT
  distinct city
FROM
  station
WHERE 
  LEFT(LOWER(city) , 1) NOT IN ('a','e','i','o','u')
  OR RIGHT(LOWER(city) , 1) NOT IN ('a','e','i','o','u')
;


Q16:

SELECT
  distinct city
FROM
  station
WHERE 
  LEFT(LOWER(city) , 1) NOT IN ('a','e','i','o','u')
  AND RIGHT(LOWER(city) , 1) NOT IN ('a','e','i','o','u')
;


Q17:

CREATE TABLE product
(
  product_id INT,
  product_name VARCHAR(30),
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


SELECT
  p.product_id,
  p.product_name
FROM
  sales s
  JOIN product p ON p.product_id = s.product_id
WHERE
  s.sale_date >= STR_TO_DATE('2019-01-01', '%Y-%m-%d')
  AND s.sale_date <= STR_TO_DATE('2019-03-31', '%Y-%m-%d')
  AND NOT EXISTS(
    SELECT
      *
    FROM
      sales s2
    WHERE
      s.product_id = s2.product_id
      AND (s2.sale_date < STR_TO_DATE('2019-01-01', '%Y-%m-%d')
      OR s2.sale_date > STR_TO_DATE('2019-03-31', '%Y-%m-%d'))
  )

;

Q18:

CREATE TABLE views
(
  article_id INT,
  author_id INT,
  viewer_id INT,
  viewer_date DATE
);


INSERT INTO views VALUES(1, 3, 5, '2019-08-01');
INSERT INTO views VALUES(1, 3, 6, '2019-08-02');
INSERT INTO views VALUES(2, 7, 7, '2019-08-01');
INSERT INTO views VALUES(2, 7, 6, '2019-08-02');
INSERT INTO views VALUES(4, 7, 1, '2019-07-22');
INSERT INTO views VALUES(3, 4, 4, '2019-07-21');
INSERT INTO views VALUES(3, 4, 4, '2019-07-21');

SELECT
  DISTINCT author_id AS id
FROM
  views
WHERE
  author_id = viewer_id
ORDER BY
  author_id
;

Q19:

CREATE TABLE delivery
(
  delivery_id INT,
  customer_id INT,
  order_date DATE,
  customer_pref_delivery_date DATE
);


INSERT INTO delivery VALUES(1, 1, '2019-08-01', '2019-08-02');
INSERT INTO delivery VALUES(2, 5, '2019-08-02', '2019-08-02');
INSERT INTO delivery VALUES(3, 1, '2019-08-11', '2019-08-11');
INSERT INTO delivery VALUES(4, 3, '2019-08-24', '2019-08-26');
INSERT INTO delivery VALUES(5, 4, '2019-08-21', '2019-08-22');
INSERT INTO delivery VALUES(6, 2, '2019-08-11', '2019-08-13');

SELECT
  ROUND(
    COUNT(
      CASE
        WHEN order_date = customer_pref_delivery_date
          THEN delivery_id
      END
    )*100.00/COUNT(*)
  , 2) AS immediate_percentage
FROM
  delivery
;

Q20:

CREATE TABLE ads
(
  ad_id INT,
  user_id INT,
  action ENUM('Clicked', 'Viewed', 'Ignored'),
  CONSTRAINT pk_ads PRIMARY KEY(ad_id, user_id)
);

INSERT INTO ads VALUES(1, 1, 'Clicked');
INSERT INTO ads VALUES(2, 2, 'Clicked');
INSERT INTO ads VALUES(3, 3, 'Viewed');
INSERT INTO ads VALUES(5, 5, 'Ignored');
INSERT INTO ads VALUES(1, 7, 'Ignored');
INSERT INTO ads VALUES(2, 7, 'Viewed');
INSERT INTO ads VALUES(3, 5, 'Clicked');
INSERT INTO ads VALUES(1, 4, 'Viewed');
INSERT INTO ads VALUES(2, 11, 'Viewed');
INSERT INTO ads VALUES(1, 2, 'Clicked');


WITH ad_stat AS(
  SELECT
    ad_id,
    COUNT(CASE
      WHEN action = 'Clicked'
        THEN user_id
    END) AS clicked_count,
    COUNT(CASE
      WHEN action = 'Viewed'
        THEN user_id
    END) AS viewed_count,
    COUNT(CASE
      WHEN action = 'Ignored'
        THEN user_id
    END) AS ignored_count
  FROM
    ads
  GROUP BY
    ad_id
)
SELECT
  ad_id,
  CASE
    WHEN clicked_count + viewed_count = 0
      THEN 0
    ELSE
      ROUND(
        clicked_count*100.00/(clicked_count+viewed_count)
       ,2)
  END AS ctr
FROM
  ad_stat
ORDER BY
  ctr DESC, ad_id
;

Q21:

CREATE TABLE employee
(
  employee_id INT,
  team_id INT,
  CONSTRAINT pk_employee PRIMARY KEY(employee_id)
);

INSERT INTO employee VALUES(1, 3);
INSERT INTO employee VALUES(2, 3);
INSERT INTO employee VALUES(3, 3);
INSERT INTO employee VALUES(4, 1);
INSERT INTO employee VALUES(5, 2);
INSERT INTO employee VALUES(6, 2);

SELECT
  employee_id,
  COUNT(*) OVER(PARTITION BY team_id) AS team_size
FROM
  employee;

Q22:

CREATE TABLE countries
(
  country_id INT,
  country_name VARCHAR(30),
  CONSTRAINT pk_country PRIMARY KEY(country_id)
);

CREATE TABLE weather
(
  country_id INT,
  weather_state INT,
  day DATE,
  CONSTRAINT pk_weather PRIMARY KEY(country_id, day)
);

INSERT INTO countries VALUES(2, 'USA');
INSERT INTO countries VALUES(3, 'Australia');
INSERT INTO countries VALUES(7, 'Peru');
INSERT INTO countries VALUES(5, 'China');
INSERT INTO countries VALUES(8, 'Morocco');
INSERT INTO countries VALUES(9, 'Spain');

INSERT INTO weather VALUES(2, 15, '2019-11-01');
INSERT INTO weather VALUES(2, 12, '2019-10-28');
INSERT INTO weather VALUES(2, 12, '2019-10-27');
INSERT INTO weather VALUES(3, -2, '2019-11-10');
INSERT INTO weather VALUES(3, 0, '2019-11-11');
INSERT INTO weather VALUES(3, 3, '2019-11-12');
INSERT INTO weather VALUES(5, 16, '2019-11-07');
INSERT INTO weather VALUES(5, 18, '2019-11-09');
INSERT INTO weather VALUES(5, 21, '2019-11-23');
INSERT INTO weather VALUES(7, 25 , '2019-11-28');
INSERT INTO weather VALUES(7 , 22, '2019-12-01');
INSERT INTO weather VALUES(7, 20, '2019-12-02');
INSERT INTO weather VALUES(8, 25, '2019-11-05');
INSERT INTO weather VALUES(8, 27, '2019-11-15');
INSERT INTO weather VALUES(8, 31, '2019-11-25');
INSERT INTO weather VALUES(9, 7, '2019-10-23');
INSERT INTO weather VALUES(9, 3, '2019-12-23');

SELECT
  c.country_name,
  avg(weather_state) AS avg_state,
  CASE
    WHEN avg(weather_state) <= 15
      THEN 'Cold'
    WHEN avg(weather_state) >= 25
      THEN 'Hot'
    ELSE
      'Warm'
  END AS weather_type
FROM
  weather w
  JOIN countries c ON w.country_id = c.country_id
WHERE
  DATE_FORMAT(w.day, '%Y-%m') = '2019-11'
GROUP BY
  c.country_id,
  c.country_name
;


Q23:

CREATE TABLE prices
(
  product_id INT,
  start_date DATE,
  end_date DATE,
  price INT,
  CONSTRAINT pk_prices PRIMARY KEY(product_id, start_date, end_date)
);

CREATE TABLE units_sold
(
  product_id INT,
  purchase_date DATE,
  units INT
);


INSERT INTO prices VALUES(1, '2019-02-17', '2019-02-28', 5);
INSERT INTO prices VALUES(1, '2019-03-01', '2019-03-22', 20);
INSERT INTO prices VALUES(2, '2019-02-01', '2019-02-20', 15);
INSERT INTO prices VALUES(2, '2019-02-21', '2019-03-31', 30);


INSERT INTO units_sold VALUES(1, '2019-02-25', 100);
INSERT INTO units_sold VALUES(1, '2019-03-01', 15);
INSERT INTO units_sold VALUES(2, '2019-02-10', 200);
INSERT INTO units_sold VALUES(2, '2019-03-22', 30);

SELECT
  p.product_id,
  ROUND(SUM(up.units*p.price)/SUM(up.units), 2) AS average_price
FROM
  units_sold up
  JOIN prices p ON up.product_id = p.product_id
    AND up.purchase_date BETWEEN p.start_date AND p.end_date
GROUP BY
  p.product_id
;


Q24:

CREATE TABLE activity
(
  player_id INT,
  device_id INT,
  event_date DATE,
  games_played INT,
  CONSTRAINT pk_activity PRIMARY KEY(player_id, event_date)
);

INSERT INTO activity VALUES(1, 2, '2016-03-01', 5);
INSERT INTO activity VALUES(1, 2, '2016-05-02', 6);
INSERT INTO activity VALUES(2, 3, '2017-06-25', 1);
INSERT INTO activity VALUES(3, 1, '2016-03-02', 0);
INSERT INTO activity VALUES(3, 4, '2018-07-03', 5);

SELECT
  DISTINCT player_id,
  FIRST_VALUE(event_date) OVER(PARTITION BY player_id ORDER BY event_date) AS first_login
FROM
  activity;

Q25:

SELECT
  DISTINCT player_id,
  FIRST_VALUE(device_id) OVER(PARTITION BY player_id ORDER BY event_date) AS first_login
FROM
  activity;

Q26:

CREATE TABLE products
(
  product_id INT,
  product_name VARCHAR(30),
  product_category VARCHAR(30),
  CONSTRAINT pk_products PRIMARY KEY(product_id)
);

CREATE TABLE orders
(
  product_id INT,
  order_date DATE,
  unit INT,
  CONSTRAINT fk_product FOREIGN KEY (product_id)
    REFERENCES products(product_id) 
);



INSERT INTO products VALUES(1, 'Leetcode Solutions', 'Book');
INSERT INTO products VALUES(2, 'Jewels of Stringology', 'Book');
INSERT INTO products VALUES(3, 'HP', 'Laptop');
INSERT INTO products VALUES(4, 'Lenovo', 'Laptop');
INSERT INTO products VALUES(5, 'Leetcode Kit', 'T-shirt');

INSERT INTO orders VALUES(1, '2020-02-05', 60);
INSERT INTO orders VALUES(1, '2020-02-10', 70);
INSERT INTO orders VALUES(2, '2020-01-18', 30);
INSERT INTO orders VALUES(2, '2020-02-11' ,80);
INSERT INTO orders VALUES(3, '2020-02-17', 2);
INSERT INTO orders VALUES(3, '2020-02-24', 3);
INSERT INTO orders VALUES(4, '2020-03-01', 20);
INSERT INTO orders VALUES(4, '2020-03-04', 30);
INSERT INTO orders VALUES(4, '2020-03-04', 60);
INSERT INTO orders VALUES(5, '2020-02-25', 50);
INSERT INTO orders VALUES(5, '2020-02-27', 50);
INSERT INTO orders VALUES(5, '2020-03-01', 50);

SELECT
  p.product_name,
  SUM(unit) AS unit
FROM
  products p
  JOIN orders o ON p.product_id = o.product_id
WHERE
  DATE_FORMAT(o.order_date, '%Y-%m') = '2020-02'
GROUP BY 
  p.product_id,
  p.product_name
HAVING
  SUM(unit) >= 100
;


Q27:

CREATE TABLE users
(
  user_id INT,
  name VARCHAR(30),
  mail VARCHAR(50),
  CONSTRAINT pk_users PRIMARY KEY(user_id)
);


INSERT INTO users VALUES(1, 'Winston', 'winston@leetcode.com');
INSERT INTO users VALUES(2, 'Jonathan', 'jonathanisgreat');
INSERT INTO users VALUES(3, 'Annabelle', 'bella-@leetcode.com');
INSERT INTO users VALUES(4, 'Sally', 'sally.come@leetcode.com');
INSERT INTO users VALUES(5, 'Marwan', 'quarz#2020@le etcode.com');
INSERT INTO users VALUES(6, 'David', 'david69@gmail.com');
INSERT INTO users VALUES(7, 'Shapiro','.shapo@leetco de.com');

SELECT
  user_id,
  name,
  mail
FROM
  users
WHERE
  REGEXP_LIKE(mail, '^[a-zA-Z][a-zA-Z0-9\_\.\-]*@leetcode.com');


Q28:

CREATE TABLE customers
(
  customer_id INT,
  name VARCHAR(30),
  country VARCHAR(50),
  CONSTRAINT pk_customers PRIMARY KEY(customer_id)
);


CREATE TABLE products
(
  product_id INT,
  name VARCHAR(30),
  price VARCHAR(50),
  CONSTRAINT pk_products PRIMARY KEY(product_id)
);

CREATE TABLE orders
(
  order_id INT,
  customer_id INT,
  product_id INT,
  order_date DATE,
  quantity INT,
  CONSTRAINT pk_orders PRIMARY KEY(order_id)
);


INSERT INTO customers VALUES(1, 'Winston', 'USA');
INSERT INTO customers VALUES(2, 'Jonathan', 'Peru');
INSERT INTO customers VALUES(3, 'Moustafa', 'Egypt');

INSERT INTO products VALUES(10, 'LC Phone', 300);
INSERT INTO products VALUES(20, 'LC T-Shirt', 10);
INSERT INTO products VALUES(30, 'LC Book', 45);
INSERT INTO products VALUES(40, 'LC Keychain', 2);


INSERT INTO orders VALUES(1, 1, 10, '2020-06-10', 1);
INSERT INTO orders VALUES(2, 1, 20, '2020-07-01', 1);
INSERT INTO orders VALUES(3, 1, 30, '2020-07-08', 2);
INSERT INTO orders VALUES(4, 2, 10, '2020-06-15', 2);
INSERT INTO orders VALUES(5, 2, 40, '2020-07-01', 10);
INSERT INTO orders VALUES(6, 3, 20, '2020-06-24', 2);
INSERT INTO orders VALUES(7, 3, 30, '2020-06-25', 2);
INSERT INTO orders VALUES(9, 3, 30, '2020-05-08', 3);

select 
    o.customer_id,
    c.name
from 
  orders o
  JOIN products p ON p.product_id = o.product_id
  JOIN customers c ON c.customer_id = o.customer_id
GROUP BY
  o.customer_id
HAVING 
(
    SUM(
      CASE 
        WHEN o.order_date LIKE '2020-06%' 
          THEN o.quantity*p.price 
        ELSE 0 
      END
    ) >= 100
    AND
    SUM(
      CASE 
        WHEN o.order_date LIKE '2020-07%' 
          THEN o.quantity*p.price 
        ELSE 0 
      END
    ) >= 100
);


Q29:

CREATE TABLE tv_program
(
  program_date DATE,
  content_id INT,
  channel VARCHAR(30),
  CONSTRAINT pk_tv_program PRIMARY KEY(program_date, content_id)
);

CREATE TABLE content
(
  content_id INT,
  title VARCHAR(50),
  kids_content ENUM('Y', 'N'),
  content_type VARCHAR(20),
  CONSTRAINT pk_content PRIMARY KEY(content_id)
);

INSERT INTO tv_program VALUES('2020-06-10 08:00', 1, 'LC-Channel');
INSERT INTO tv_program VALUES('2020-05-11 12:00', 2, 'LC-Channel');
INSERT INTO tv_program VALUES('2020-05-12 12:00', 3, 'LC-Channel');
INSERT INTO tv_program VALUES('2020-05-13 14:00', 4, 'Disney Ch');
INSERT INTO tv_program VALUES('2020-06-18 14:00', 4, 'Disney Ch');
INSERT INTO tv_program VALUES('2020-07-15 16:00', 5, 'Disney Ch');


INSERT INTO content VALUES(1, 'Leetcode Movie', 'N', 'Movies');
INSERT INTO content VALUES(2, 'Alg. for Kids', 'Y', 'Series');
INSERT INTO content VALUES(3, 'Database Sols', 'N', 'Series');
INSERT INTO content VALUES(4, 'Aladdin', 'Y', 'Movies');
INSERT INTO content VALUES(5, 'Cinderella', 'Y', 'Movies');

SELECT 
  DISTINCT title
FROM 
  content c
  JOIN tv_program tv ON c.content_id = tv.content_id
where c.kids_content = 'Y' 
  and c.content_type = 'Movies' 
  and DATE_FORMAT(tv.program_date, '%Y-%m') = '2020-06';



Q30:

CREATE TABLE npv
(
  id INT,
  year INT,
  npv INT,
  CONSTRAINT pk_npv PRIMARY KEY(id, year)
);

CREATE TABLE queries
(
  id INT,
  year INT,
  CONSTRAINT pk_quereis PRIMARY KEY(id,year)
);

INSERT INTO npv VALUES(1, 2018, 100);
INSERT INTO npv VALUES(7, 2020, 30);
INSERT INTO npv VALUES(13, 2019, 40);
INSERT INTO npv VALUES(1, 2019, 113);
INSERT INTO npv VALUES(2, 2008, 121);
INSERT INTO npv VALUES(3, 2009, 12);
INSERT INTO npv VALUES(11, 2020, 99);
INSERT INTO npv VALUES(7, 2019, 0);

INSERT INTO queries VALUES(1, 2019);
INSERT INTO queries VALUES(2, 2008);
INSERT INTO queries VALUES(3, 2009);
INSERT INTO queries VALUES(7, 2018);
INSERT INTO queries VALUES(7, 2019);
INSERT INTO queries VALUES(7, 2020);
INSERT INTO queries VALUES(13, 2019);

SELECT 
  q.id,
  q.year, 
  ifnull(n.npv,0) as npv
FROM 
  queries AS q
  LEFT JOIN npv AS n ON q.id = n.id AND q.year = n.year
;

Q31:

--Q30



Q32:

CREATE TABLE employees
(
  id INT,
  name VARCHAR(30),
  CONSTRAINT pk_employees PRIMARY KEY(id)
);

CREATE TABLE employee_uni
(
  id INT,
  unique_id INT,
  CONSTRAINT pk_employee_uni PRIMARY KEY(id, unique_id)
);


INSERT INTO employees VALUES(1, 'Alice');
INSERT INTO employees VALUES(7, 'Bob');
INSERT INTO employees VALUES(11, 'Meir');
INSERT INTO employees VALUES(90, 'Winston');
INSERT INTO employees VALUES(3, 'Jonathan');

INSERT INTO employee_uni VALUES(3, 1);
INSERT INTO employee_uni VALUES(11, 2);
INSERT INTO employee_uni VALUES(90, 3);

SELECT
  eu.unique_id,
  e.name
FROM
  employees e
  LEFT JOIN employee_uni eu ON e.id = eu.id
;


Q33:

CREATE TABLE users
(
  id INT,
  name VARCHAR(30),
  CONSTRAINT pk_users PRIMARY KEY(id)
);

CREATE TABLE rides
(
  id INT,
  user_id INT,
  distance INT,
  CONSTRAINT pk_rides PRIMARY KEY(id)
);



INSERT INTO users VALUES(1, 'Alice');
INSERT INTO users VALUES(2, 'Bob');
INSERT INTO users VALUES(3, 'Alex');
INSERT INTO users VALUES(4, 'Donald');
INSERT INTO users VALUES(7, 'Lee');
INSERT INTO users VALUES(13, 'Jonathan'); 
INSERT INTO users VALUES(19, 'Elvis');

INSERT INTO rides VALUES(1, 1, 120);
INSERT INTO rides VALUES(2, 2, 317);
INSERT INTO rides VALUES(3, 3, 222);
INSERT INTO rides VALUES(4, 7, 100);
INSERT INTO rides VALUES(5, 13, 312);
INSERT INTO rides VALUES(6, 19, 50);
INSERT INTO rides VALUES(7, 7, 120);
INSERT INTO rides VALUES(8, 19, 400);
INSERT INTO rides VALUES(9, 7, 230);

SELECT
  u.name,
  SUM(CASE
    WHEN r.distance IS NULL
      THEN 0
    ELSE
      r.distance
  END) AS travelled_distance
FROM
  users u
  LEFT JOIN rides r ON u.id = r.user_id
GROUP BY
  u.id,
  u.name
ORDER BY
  travelled_distance DESC,
  u.name
;

Q34:

--Q26


Q35:

--Q79

Q36:

--Q33

Q37:

--Q32


Q38:

CREATE TABLE departments
(
  id INT,
  name VARCHAR(30),
  CONSTRAINT pk_department PRIMARY KEY(id)
);

CREATE TABLE students
(
  id INT,
  name VARCHAR(30),
  department_id INT,
  CONSTRAINT pk_students PRIMARY KEY(id)
);


INSERT INTO departments VALUES(1, 'Electrical Engineering');
INSERT INTO departments VALUES(7, 'Computer Engineering');
INSERT INTO departments VALUES(13, 'Business Administration');

INSERT INTO students VALUES(23, 'Alice', 1);
INSERT INTO students VALUES(1, 'Bob', 7);
INSERT INTO students VALUES(5, 'Jennifer', 13);
INSERT INTO students VALUES(2, 'John', 14);
INSERT INTO students VALUES(4, 'Jasmine', 77);
INSERT INTO students VALUES(3, 'Steve', 74);
INSERT INTO students VALUES(6, 'Luis', 1);
INSERT INTO students VALUES(8, 'Jonathan', 7);
INSERT INTO students VALUES(7, 'Daiana', 33);
INSERT INTO students VALUES(11, 'Madelynn', 1);

SELECT
  s.id,
  s.name
FROM
  students s
  LEFT JOIN departments d ON s.department_id = d.id
WHERE
  d.id IS NULL;


Q39:

CREATE TABLE calls
(
  from_id INT,
  to_id INT,
  duration INT
);


INSERT INTO calls VALUES(1, 2, 59);
INSERT INTO calls VALUES(2, 1, 11);
INSERT INTO calls VALUES(1, 3, 20);
INSERT INTO calls VALUES(3, 4, 100);
INSERT INTO calls VALUES(3, 4, 200);
INSERT INTO calls VALUES(3, 4, 200);
INSERT INTO calls VALUES(4, 3, 499);

SELECT 
  CASE 
    WHEN from_id < to_id 
      THEN from_id 
      ELSE 
        to_id 
  END AS person1, 
  CASE 
    WHEN from_id < to_id 
      THEN to_id 
    ELSE 
      from_id
  END AS  person2, 
  COUNT(*) AS call_count,
  SUM(duration) AS duration
FROM calls 
GROUP BY 
  CASE 
    WHEN from_id < to_id 
      THEN from_id 
      ELSE 
        to_id 
  END, 
  CASE 
    WHEN from_id < to_id 
      THEN to_id 
    ELSE 
      from_id
  END
;;
 

 Q40:

 --Q23

 Q41:


CREATE TABLE warehouse
(
  name VARCHAR(30),
  product_id INT,
  units INT,
  CONSTRAINT pk_warehouse PRIMARY KEY(name, product_id)
);

CREATE TABLE products
(
  product_id INT,
  product_name VARCHAR(30),
  width INT,
  length INT,
  height INT,
  CONSTRAINT pk_products PRIMARY KEY(product_id)
);


INSERT INTO warehouse VALUES('LCHouse1', 1, 1);
INSERT INTO warehouse VALUES('LCHouse1', 2, 10);
INSERT INTO warehouse VALUES('LCHouse1', 3, 5);
INSERT INTO warehouse VALUES('LCHouse2', 1, 2);
INSERT INTO warehouse VALUES('LCHouse2', 2, 2);
INSERT INTO warehouse VALUES('LCHouse3', 4, 1);

INSERT INTO products VALUES(1, 'LC-TV', 5, 50, 40);
INSERT INTO products VALUES(2, 'LC-KeyChain', 5, 5, 5);
INSERT INTO products VALUES(3, 'LC-Phone', 2, 10, 10);
INSERT INTO products VALUES(4, 'LC-T-Shirt', 4, 10, 20);

SELECT
  w.name,
  SUM(p.height*p.width*p.length*w.units) AS volume
FROM
  warehouse w
  JOIN products p ON w.product_id = p.product_id
GROUP BY
  w.name
;


Q42:

CREATE TABLE sales
(
  sale_date DATE,
  fruit VARCHAR(10),
  sold_num INT,
  CONSTRAINT pk_sales PRIMARY KEY(sale_date, fruit)
);

INSERT INTO sales VALUES('2020-05-01', 'apples', 10);
INSERT INTO sales VALUES('2020-05-01', 'oranges', 8);
INSERT INTO sales VALUES('2020-05-02', 'apples', 15);
INSERT INTO sales VALUES('2020-05-02', 'oranges', 15);
INSERT INTO sales VALUES('2020-05-03', 'apples', 20);
INSERT INTO sales VALUES('2020-05-03', 'oranges', 0);
INSERT INTO sales VALUES('2020-05-04', 'apples', 15);
INSERT INTO sales VALUES('2020-05-04', 'oranges', 16);

SELECT 
  sale_date,
  SUM(
    CASE 
      WHEN fruit = 'apples' 
        THEN sold_num
      WHEN fruit = 'oranges' 
        THEN (-1)*sold_num 
    END
  ) AS diff
FROM 
  sales
GROUP BY
  sale_date
ORDER BY
  sale_date
;

Q43:

--Q74


Q44:

CREATE TABLE employee
(
  id INT,
  name VARCHAR(30),
  department VARCHAR(30),
  manager_id INT,
  CONSTRAINT pk_employee PRIMARY KEY(id)
);


INSERT INTO employee VALUES(101, 'John', 'A', null);
INSERT INTO employee VALUES(102, 'Dan', 'A', 101);
INSERT INTO employee VALUES(103, 'James', 'A', 101);
INSERT INTO employee VALUES(104, 'Amy', 'A', 101);
INSERT INTO employee VALUES(105, 'Anne', 'A', 101);
INSERT INTO employee VALUES(106, 'Ron', 'B', 101);



WITH RECURSIVE emp_hir AS  
(
  SELECT
    id,
    manager_id, 
    1 as lvl 
  FROM 
    employee 
  WHERE
    manager_id is null
  UNION
  SELECT 
    em.id,
    em.manager_id, 
    eh.lvl + 1 as lvl 
  FROM
    emp_hir eh 
    JOIN employee em ON eh.id = em.manager_id
)
SELECT 
  emp.name 
FROM 
  emp_hir eh1
  JOIN employee emp ON emp.id = eh1.manager_id
GROUP BY 
  eh1.lvl,
  eh1.manager_id,
  emp.name
HAVING 
  COUNT(*) >= 5
;




Q45:

CREATE TABLE department
(
  dept_id INT,
  dept_name VARCHAR(30),
  CONSTRAINT pk_department PRIMARY KEY(dept_id)
);

CREATE TABLE student
(
  student_id INT,
  student_name VARCHAR(30),
  gender VARCHAR(1),
  dept_id INT,
  CONSTRAINT pk_student PRIMARY KEY(student_id),
  CONSTRAINT fk_department FOREIGN KEY (dept_id)
    REFERENCES department(dept_id) 
);

INSERT INTO department VALUES(1, 'Engineering');
INSERT INTO department VALUES(2, 'Science');
INSERT INTO department VALUES(3, 'Law');

INSERT INTO student VALUES(1, 'Jack', 'M', 1);
INSERT INTO student VALUES(2, 'Jane', 'F', 1);
INSERT INTO student VALUES(3, 'Mark', 'M', 2);

SELECT
  d.dept_name,
  count(
    CASE
      WHEN s.dept_id IS NOT NULL
        THEN d.dept_id
    END
  ) AS student_number
FROM
  department d
  LEFT JOIN student s ON d.dept_id = s.dept_id
GROUP BY
  d.dept_id,
  d.dept_name
ORDER BY
  student_number DESC,
  dept_name
;

Q46:

CREATE TABLE customer
(
  customer_id INT,
  product_key INT
);

CREATE TABLE product
(
  product_key INT,
  CONSTRAINT pk_product PRIMARY KEY(product_key)
);

INSERT INTO customer VALUES(1, 5);
INSERT INTO customer VALUES(2, 6);
INSERT INTO customer VALUES(3, 5);
INSERT INTO customer VALUES(3, 6);
INSERT INTO customer VALUES(1, 6);

INSERT INTO product VALUES(5);
INSERT INTO product VALUES(6);


SELECT 
  customer_id
FROM 
  customer 
GROUP BY 
    customer_id
HAVING 
  COUNT(distinct product_key) = (SELECT COUNT(*) FROM product)
;


Q47:

CREATE TABLE project
(
  project_id INT,
  employee_id INT,
  CONSTRAINT pk_project PRIMARY KEY(project_id, employee_id)
);

CREATE TABLE employee
(
  employee_id INT,
  name VARCHAR(30),
  experience_years INT,
  CONSTRAINT pk_employee PRIMARY KEY(employee_id)
);

INSERT INTO project VALUES(1, 1);
INSERT INTO project VALUES(1, 2);
INSERT INTO project VALUES(1, 3);
INSERT INTO project VALUES(2, 1);
INSERT INTO project VALUES(2, 4);

INSERT INTO employee VALUES(11, 'Khaled', 3);
INSERT INTO employee VALUES(2, 'Ali', 2);
INSERT INTO employee VALUES(3, 'John', 3);
INSERT INTO employee VALUES(4, 'Doe', 2);

SELECT
  *,
  DENSE_RANK() OVER(PARTITION BY p.project_id ORDER BY e.experience_years DESC) as experience_serial
FROM
  employee e
  JOIN project p ON p.employee_id = e.employee_id
;


Q48:
--No Orders data
CREATE TABLE books
(
  book_id INT,
  name VARCHAR(30),
  avaialable_from DATE,
  CONSTRAINT pk_books PRIMARY KEY(book_id)
);

CREATE TABLE orders
(
  order_id INT,
  book_id INT,
  quantity INT,
  dispatch_date DATE,
  CONSTRAINT pk_orders PRIMARY KEY(order_id),
  CONSTRAINT fk_orders FOREIGN KEY (book_id)
    REFERENCES books(book_id) 
);

INSERT INTO books VALUES(1, 'Kalila And Demna', '2010-01-01');
INSERT INTO books VALUES(2, '28 Letters', '2012-05-12');
INSERT INTO books VALUES(3, 'The Hobbit', '2019-06-10');
INSERT INTO books VALUES(4, '13 Reasons Why', '2019-06-01');
INSERT INTO books VALUES(5, 'The Hunger Games', '2008-09-21');

WITH last_year_sales AS(
  SELECT
    o.book_id,
    sum(quantity) AS total_sold
  FROM
    orders o
  WHERE
    o.dispatch_date >= DATE_SUB("2019-06-23", INTERVAL 1 YEAR)
  GROUP BY
    o.book_id
)
SELECT 
  b.name
FROM
  books b
  LEFT JOIN last_year_sales l_y_sales ON b.book_id = l_y_sales.book_id
WHERE
  (
    l_y_sales.total_sold < 10
    OR l_y_sales.total_sold is NULL
  )
  AND b.avaialable_from <= DATE_SUB("2019-06-23", INTERVAL 1 MONTH)
;

Q49:

CREATE TABLE enrollments
(
  student_id INT,
  course_id INT,
  grade INT,
  CONSTRAINT pk_enrollments PRIMARY KEY(student_id, course_id)
);

INSERT INTO enrollments VALUES(2, 2, 95);
INSERT INTO enrollments VALUES(2, 3, 95);
INSERT INTO enrollments VALUES(1, 1, 90);
INSERT INTO enrollments VALUES(1, 2, 99);
INSERT INTO enrollments VALUES(3, 1, 80);
INSERT INTO enrollments VALUES(3, 2, 75);
INSERT INTO enrollments VALUES(3, 3, 82);

WITH serailized_enrollments AS(
  SELECT
    *,
    DENSE_RANK()
      OVER(PARTITION BY student_id ORDER BY grade DESC, course_id) AS serial
  FROM
    enrollments
)
SELECT
  student_id,
  course_id,
  grade
FROM
  serailized_enrollments
WHERE
  serial = 1;


Q50:

--Q99






