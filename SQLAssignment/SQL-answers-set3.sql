--Q101:

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

--drop tables

DROP TABLE user_activity;


--Q102:
  
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

--drop tables

DROP TABLE user_activity;


--Q103:

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
  RIGHT(name, 3),
  id
;

--drop tables

DROP TABLE students;


--Q104:

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
  employee_id
;

--drop tables

DROP TABLE employee;


--Q105:

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
  triangles
;

--drop tables

DROP TABLE triangles;


--Q106:

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
WHERE
  salary > 1000
  AND salary < 100000
;

--drop tables

DROP TABLE employees;


--Q107:

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

--drop tables

DROP TABLE employee;


--Q108:

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

--drop tables

DROP TABLE occupations;


--Q109:

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

--drop tables

DROP TABLE occupations;


--Q110:

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
  n
;

--drop tables

DROP TABLE bst;


--Q111:

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

--drop tables

DROP TABLE company;
DROP TABLE lead_manager;
DROP TABLE senior_manager;
DROP TABLE manager;
DROP TABLE employee;


--Q112:

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


--Q113:

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
  n1.n
;

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
  multiline_star
;


--Q114:

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
  n1.n
;

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
  multiline_star
;



--Q115:

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
  RIGHT(name, 3),
  id
;

--drop tables

DROP TABLE students;


--Q116:

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
  AND f1.x <= f1.y
;

--drop tables

DROP TABLE functions;


--Q116:

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


--Q117:

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
  employee_id
;

--drop tables

DROP TABLE employee;


--Q118:

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
  triangles
;

--drop tables

DROP TABLE triangles;


--Q119:

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


--Q120:

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


--Q121:

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

--drop tables

DROP TABLE user_actions;


--Q122:

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


--Q123:

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


--Q124:

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

--drop tables

DROP TABLE server_utilization;


--Q125:

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


--Q126:

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

DROP TABLE customers;
DROP TABLE trips;
DROP TABLE orders;

--Q127:

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
  scores;

--drop tables

DROP TABLE scores;


--Q128:

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

--drop tables

DROP TABLE calls;
DROP TABLE country;
DROP TABLE person;


--Q129:

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


--Q130:

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

--drop tables

DROP TABLE salary;
DROP TABLE employee;


--Q131:

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


--Q132:

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


--Q133:

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


--Q134:

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


--Q135:

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

--drop tables

DROP TABLE user_activity;


--Q136:

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

--drop tables

DROP TABLE user_activity;


--Q137:

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
WHERE
  salary > 1000
  AND salary < 100000
;

--drop tables

DROP TABLE employees;


--Q138:

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

--drop tables

DROP TABLE employee;


--Q139:

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

--drop tables

DROP TABLE occupations;

--Q140:

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

--drop tables

DROP TABLE occupations;

--Q141:

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
  n
;

--drop tables

DROP TABLE bst;


--Q142:

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

--drop tables

DROP TABLE company;
DROP TABLE lead_manager;
DROP TABLE senior_manager;
DROP TABLE manager;
DROP TABLE employee;

--Q143:

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
  AND f1.x <= f1.y
;

--drop tables

DROP TABLE functions;


--Q144:

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

--drop tables

DROP TABLE students;
DROP TABLE friends;
DROP TABLE packages;


--Q145:

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
  h.hacker_id
LIMIT 1
;

--drop tables

DROP TABLE hackers;
DROP TABLE difficulty;
DROP TABLE challenges;
DROP TABLE submissions;


--Q146:

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

--drop tables

DROP TABLE projects;


--Q147:

CREATE TABLE transactions
(
  user_id INT,
  amount DECIMAL(10,2),
  transaction_date TIMESTAMP
);

INSERT INTO transactions VALUES(1, '9.99', '2022-08-01 10:00:00');
INSERT INTO transactions VALUES(1, '55', '2022-08-17 10:00:00');
INSERT INTO transactions VALUES(1, '149.5', '2022-08-05 10:00:00');
INSERT INTO transactions VALUES(1, '4.89', '2022-08-06 10:00:00');
INSERT INTO transactions VALUES(1, '34', '2022-08-07 10:00:00');


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

--drop tables

DROP TABLE transactions;


--Q148:

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

--drop tables

DROP TABLE payments;


--Q149:

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

--drop tables

DROP TABLE user_transactions;


--Q150:

CREATE TABLE measurements
(
  measurement_id INT,
  measurement_value DECIMAL(10,2),
  measurement_time TIMESTAMP
);

INSERT INTO measurements VALUES(131233, 1109.51, '2022-07-10 09:00:00');
INSERT INTO measurements VALUES(135211, 1662.74, '2022-07-10 11:00:00');
INSERT INTO measurements VALUES(523542, 1246.24, '2022-07-10 13:15:00');
INSERT INTO measurements VALUES(143562, 1124.50, '2022-07-11 15:00:00');
INSERT INTO measurements VALUES(346462, 1234.14, '2022-07-11 16:45:00');


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

--drop tables

DROP TABLE measurements;


--Q151:

CREATE TABLE transactions
(
  user_id INT,
  amount DECIMAL(10,2),
  transaction_date TIMESTAMP
);

INSERT INTO transactions VALUES(1, '9.99', '2022-08-01 10:00:00');
INSERT INTO transactions VALUES(1, '55', '2022-08-17 10:00:00');
INSERT INTO transactions VALUES(1, '149.5', '2022-08-05 10:00:00');
INSERT INTO transactions VALUES(1, '4.89', '2022-08-06 10:00:00');
INSERT INTO transactions VALUES(1, '34', '2022-08-07 10:00:00');


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

--drop tables

DROP TABLE transactions;


--Q152:

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
  COUNT(DISTINCT rental_id) > 1
;

--drop tables

DROP TABLE rental_amenities;


--Q153:

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

--drop tables

DROP TABLE ad_campaigns;


--Q154:

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

--drop tables

DROP TABLE employee_pay;


--Q155:

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

--drop tables

DROP TABLE payments;


--Q156:

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

--drop tables

DROP TABLE purchases;


--Q157:

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

--drop tables

DROP TABLE transactions;


--Q158:

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

--drop tables

DROP TABLE product_spend;


--Q159:

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

--drop tables

DROP TABLE users;


