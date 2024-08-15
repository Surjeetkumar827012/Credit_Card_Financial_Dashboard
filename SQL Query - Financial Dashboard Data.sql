-- SQL Query to create and import data from csv files:

-- 0. Create a database 
CREATE DATABASE ccdb;

-- 1. Create cc_detail table

CREATE TABLE cc_detail (
    Client_Num INT,
    Card_Category VARCHAR(20),
    Annual_Fees INT,
    Activation_30_Days INT,
    Customer_Acq_Cost INT,
    Week_Start_Date DATE,
    Week_Num VARCHAR(20),
    Qtr VARCHAR(10),
    current_year INT,
    Credit_Limit DECIMAL(10,2),
    Total_Revolving_Bal INT,
    Total_Trans_Amt INT,
    Total_Trans_Ct INT,
    Avg_Utilization_Ratio DECIMAL(10,3),
    Use_Chip VARCHAR(10),
    Exp_Type VARCHAR(50),
    Interest_Earned DECIMAL(10,3),
    Delinquent_Acc VARCHAR(5)
);


-- 2. Create cc_detail table

CREATE TABLE cust_detail (
    Client_Num INT,
    Customer_Age INT,
    Gender VARCHAR(5),
    Dependent_Count INT,
    Education_Level VARCHAR(50),
    Marital_Status VARCHAR(20),
    State_cd VARCHAR(50),
    Zipcode VARCHAR(20),
    Car_Owner VARCHAR(5),
    House_Owner VARCHAR(5),
    Personal_Loan VARCHAR(5),
    Contact VARCHAR(50),
    Customer_Job VARCHAR(50),
    Income INT,
    Cust_Satisfaction_Score INT
);


-- 3. Copy csv data into SQL (remember to update the file name and file location in below query)

-- copy cc_detail table

COPY cc_detail
FROM 'D:\credit_card.csv' 
DELIMITER ',' 
CSV HEADER;


-- copy cust_detail table

COPY cust_detail
FROM 'D:\customer.csv' 
DELIMITER ',' 
CSV HEADER;


select * from cc_detail

--#Total Revenue from Annual Fees
--Reason: To determine the total revenue generated from annual fees.
	
select sum(annual_fees) as Total_Annual_Fees
from cc_detail

--#Average Customer Acquisition Cost
--Reason:To calculate the average cost of acquiring a customer.

select avg(customer_acq_cost) as Total_acq_cost
from cc_detail


--#Number of Cards Activated Within 30 Days
--Reason: To know which card are more in used. So we promote that that card more in the market.

select card_category, sum(activation_30_days) as No_of_Times_card_used_in_a_month
from cc_detail
group by(card_category);

--#Average Transaction Cost by Per Card Category
--Reason:To analyze average transaction Cost across different card categories.

select card_category, avg(total_trans_ct) as Earn_Money_per_Card_per_Transaction
from cc_detail
group by(card_category)

--#Total Transactions in which Quarter
--Reason: To get the ideas of more transaction in festival season.

select qtr,sum(total_trans_amt)as total_trans_amt
from cc_detail
group by(qtr)
order by total_trans_amt desc

--#Number of Delinquent Accounts by Card Category
SELECT Card_Category, COUNT(*) AS Delinquent_Count 
FROM cc_detail
GROUP BY Card_Category;

select * from cc_detail
	
--#TO find total transaction of which card using which mode.

SELECT 
    card_category,
    use_chip,
    COUNT(*) AS Transaction_Count
FROM 
    cc_detail
GROUP BY 
    card_category, 
    use_chip
ORDER BY 
    card_category, 
    use_chip;

--#To determine which mode people used more for transaction

select  use_chip,sum(total_trans_amt)as total_trans_amt,count(*)as total_trans_cnt
from cc_detail
group by use_chip
order by total_trans_amt

--#To determine where people spend the most Amount

select exp_type, sum(total_trans_amt) as total_trans_amt
from cc_detail
group by exp_type
order by total_trans_amt desc


SELECT c.Customer_Name 
FROM customer c 
LEFT JOIN credit_card cc ON c.Client_Num = cc.Client_Num 
WHERE cc.Client_Num IS NULL;


SELECT cust.client_num, cust.education_level, cc.card_category
FROM cust_detail AS cust
INNER JOIN cc_detail AS cc ON cust.client_num = cc.client_num
WHERE cust.education_level = 'Graduate' AND cc.card_category = 'Platinum';


SELECT 
    CASE 
        WHEN Customer_Age BETWEEN 1 AND 20 THEN '1-20'
        WHEN Customer_Age BETWEEN 21 AND 60 THEN '21-60'
        ELSE '61+'
    END AS Age_Group,
    COUNT(*) AS Number_of_Customers
FROM 
    customer
GROUP BY 
    Age_Group;


SELECT client_num 
FROM cust_detail 
WHERE car_owner = 'yes' AND house_owner = 'no';


SELECT Card_Category 
FROM credit_card 
WHERE Client_Num IN (SELECT Client_Num FROM credit_card GROUP BY Client_Num HAVING COUNT(Client_Num) > 1);


SELECT Client_Num 
FROM customer 
WHERE state_cd = (SELECT state_cd FROM customer WHERE Income = (SELECT MAX(Income) FROM customer));


SELECT Client_Num 
FROM customer 
WHERE Cust_Satisfaction_Score > (SELECT AVG(Cust_Satisfaction_Score) FROM customer);


SELECT
    employee_id,
    AVG(sale_amount) OVER (PARTITION BY employee_id) AS avg_sale_amount
FROM
    sales;

SELECT
    sale_id,
    employee_id,
    sale_amount,
    RANK() OVER (PARTITION BY employee_id ORDER BY sale_amount DESC) AS sale_rank
FROM
    sales;