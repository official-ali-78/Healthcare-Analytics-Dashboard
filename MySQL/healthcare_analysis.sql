USE healthcare_analysis;
--------------------------------------------------
-- BASIC DATA EXPLORATION
--------------------------------------------------

-- how many pateint records are avaliable?

SELECT COUNT(*) AS Total_patients FROM patients;

-- how many patients belongs to each gender?

SELECT Gender , COUNT(*)Patients FROM patients 
GROUP BY Gender;

-- what is the average age of patients ? 

SELECT ROUND(AVG(Age),2) AS avg_age
FROM patients;

-- what is the minimun and maximum patient age? 

SELECT MAX(Age)MAX_AGE , MIN(Age)MIN_AGE from patients;


----------------------------------------------------------
-- AGE ANALYSIS
----------------------------------------------------------

-- how many customers are in each age group?

SELECT CASE 
WHEN Age < 18 THEN 'Child' 
WHEN Age BETWEEN 18 AND 35 THEN 'Young'
WHEN Age BETWEEN 35 AND 60 THEN 'Middle Age'
ELSE 'Seniour Citizen'
END AS Age_Group , 
COUNT(*)Patients from patients 
GROUP BY Age_Group
ORDER BY Patients;
 
 -- which age group has maximum number of patients ?
 
 SELECT CASE 
WHEN Age < 18 THEN 'Child' 
WHEN Age BETWEEN 18 AND 35 THEN 'Young'
WHEN Age BETWEEN 35 AND 60 THEN 'Middle Age'
ELSE 'Seniour Citizen'
END AS Age_Group , 
COUNT(*)Patients from patients 
GROUP BY Age_Group
ORDER BY Patients DESC;

-----------------------------------------------------------
-- MEDICAL CONDITION ANALYSIS
----------------------------------------------------------

-- How many patients are suffering from each medical conditions?

SELECT `Medical Condition` , COUNT(*)Patient_Count
FROM patients
GROUP BY `Medical Condition`
ORDER BY Patient_Count ;

-- which medical condition is most common ? 


SELECT `Medical Condition` , COUNT(*)Patient_Count
FROM patients
GROUP BY `Medical Condition`
ORDER BY Patient_Count desc
LIMIT 1 ;

-- which doctors treated the most patients ? 

SELECT Doctor , COUNT(*)Total_patients FROM patients
GROUP BY Doctor 
ORDER BY Total_patients desc;

---------------------------------------------
-- BILLING ANALYSIS
---------------------------------------------
-- what is the total revenue generated?

SELECT ROUND(SUM(`Billing Amount`), 2) AS TOTAL_REVENUE 
FROM patients;

-- Which medical condition generated the highest revenue?

SELECT `Medical Condition`,
       ROUND(SUM(`Billing Amount`),2) AS revenue
FROM patients
GROUP BY `Medical Condition`
ORDER BY revenue DESC;

------------------------------------------------
-- INSURANCE ANALYSIS
-----------------------------------------------

-- How many patients are covered by each insurance provider?

SELECT `Insurance Provider`,
       COUNT(*) AS patient_count
FROM patients
GROUP BY `Insurance Provider`
ORDER BY patient_count DESC;

-- Which insurance provider contributes the highest billing amount?

SELECT `Insurance Provider`,
       ROUND(SUM(`Billing Amount`),2) AS total_claims
FROM patients
GROUP BY `Insurance Provider`
ORDER BY total_claims DESC LIMIT 1;

-----------------------------------------------
-- LENGHT OF STAY ANALYSIS
-----------------------------------------------

-- calculate hospital stay duration for each patient 

SELECT UPPER(`Name`) , 
DATEDIFF(`Discharge Date` , `Date of Admission`) AS Stay_days 
FROM patients;

--  Average length of stay by medical condition.

SELECT `Medical Condition` , 
ROUND(AVG(DATEDIFF(`Discharge Date` , `Date of Admission`)),2) AS AVG_Stay_days 
FROM patients
GROUP BY `Medical Condition`
ORDER BY AVG_Stay_days;

-- Which patients stayed the longest?

SELECT UPPER(`Name`),
       `Medical Condition`,
       DATEDIFF(`Discharge Date`, `Date of Admission`) AS stay_days
FROM patients
ORDER BY stay_days DESC
LIMIT 10;

------------------------------------
-- TEST RESULT ANALYSIS
-----------------------------------
--  Distribution of test results.

SELECT `Test Results`,
       COUNT(*) AS patient_count
FROM patients
GROUP BY `Test Results`;


--  Which medical condition has the highest abnormal test results?

SELECT `Medical Condition`,
       COUNT(*) AS abnormal_cases
FROM patients
WHERE `Test Results` = 'Abnormal'
GROUP BY `Medical Condition`
ORDER BY abnormal_cases DESC;

--------------------------------------------
-- ADVANCE BUISENESS ANALYSIS 
--------------------------------------------

-- MONTHLY REVENUE TREND

SELECT YEAR(`Discharge Date`)Years ,  monthname(`Discharge Date`)Months ,
SUM(`Billing Amount`)Revenue 
from patients
GROUP BY Years , Months
ORDER BY Years , Months;

-- Revenue by gender.

SELECT Gender,
       ROUND(SUM(`Billing Amount`),2) AS revenue
FROM patients
GROUP BY Gender;

--  Top 5 combinations of medical condition and admission type.

SELECT `Medical Condition`,
       `Admission Type`,
       COUNT(*) AS total_cases
FROM patients
GROUP BY `Medical Condition`, `Admission Type`
ORDER BY total_cases DESC
LIMIT 5;


-- Find top 3 highest billed patients in each medical condition

WITH patient_rank AS (
    SELECT 
        `Name`,
        `Medical Condition`,
        `Billing Amount`,
        ROW_NUMBER() OVER(
            PARTITION BY `Medical Condition`
            ORDER BY `Billing Amount` DESC
        ) AS rn
    FROM patients
)

SELECT *
FROM patient_rank
WHERE rn <= 3;
        