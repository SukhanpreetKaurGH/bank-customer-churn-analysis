-- 1. Check how many rows were imported
SELECT COUNT(*) AS total_customers
FROM customers;

-- 2. Preview the data
SELECT *
FROM customers
LIMIT 10;

-- 3. Check that customer IDs are unique
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM customers;


-- Business Question 1: How many customers have churned?
SELECT COUNT(*)
FROM customers
WHERE exited = 1;

SELECT
    COUNT(*) AS total_customers,
    SUM(
        CASE
            WHEN exited = 1 THEN 1
            ELSE 0
        END
    ) AS churned_customers
FROM customers;

-- Business Question 2: What is the overall customer churn rate?
SELECT
    COUNT(*) AS total_customers,
    SUM(
        CASE
            WHEN exited = 1 THEN 1
            ELSE 0
        END
    ) AS churned_customers,
    ROUND(
        SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS churn_rate_pct
FROM customers;

-- Business Question 3:
-- Which geography has the highest customer churn rate?

SELECT
    geography,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS churn_rate_pct
FROM customers
GROUP BY geography
ORDER BY churn_rate_pct DESC;

-- Business Question 4:
-- How does churn differ by gender?

SELECT
    gender,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS churn_rate_pct
FROM customers
GROUP BY gender
ORDER BY churn_rate_pct DESC;

-- Business Question 5:
-- Are inactive customers more likely to churn?

SELECT
    CASE
        WHEN is_active_member = 1 THEN 'Active'
        ELSE 'Inactive'
    END AS activity_status,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS churn_rate_pct
FROM customers
GROUP BY is_active_member
ORDER BY churn_rate_pct DESC;

-- Business Question 6:
-- Which age groups have the highest churn rates?

SELECT
    CASE
        WHEN age < 30 THEN 'Under 30'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        WHEN age BETWEEN 50 AND 59 THEN '50-59'
        ELSE '60+'
    END AS age_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_pct
FROM customers
GROUP BY age_group
ORDER BY churn_rate_pct DESC;

-- Business Question 7:
-- How does the number of bank products relate to churn?

SELECT
    num_of_products,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_pct
FROM customers
GROUP BY num_of_products
ORDER BY num_of_products;

-- Business Question 8:
-- Does account balance relate to customer churn?

SELECT
    CASE
        WHEN balance = 0 THEN 'Zero Balance'
        WHEN balance < 50000 THEN 'Under 50K'
        WHEN balance < 100000 THEN '50K-99K'
        WHEN balance < 150000 THEN '100K-149K'
        ELSE '150K+'
    END AS balance_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_pct
FROM customers
GROUP BY balance_group
ORDER BY churn_rate_pct DESC;

-- Business Question 9:
-- How does credit score relate to churn?

SELECT
    CASE
        WHEN credit_score < 500 THEN 'Below 500'
        WHEN credit_score < 600 THEN '500-599'
        WHEN credit_score < 700 THEN '600-699'
        WHEN credit_score < 800 THEN '700-799'
        ELSE '800+'
    END AS credit_score_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_pct
FROM customers
GROUP BY credit_score_group
ORDER BY churn_rate_pct DESC;

-- Business Question 10:
-- Does customer tenure affect churn?

SELECT
    tenure,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_pct
FROM customers
GROUP BY tenure
ORDER BY tenure;

-- Business Question 11:
-- Does credit card ownership relate to churn?

SELECT
    CASE
        WHEN has_credit_card = 1 THEN 'Has Credit Card'
        ELSE 'No Credit Card'
    END AS credit_card_status,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_pct
FROM customers
GROUP BY has_credit_card
ORDER BY churn_rate_pct DESC;

-- Business Question 12:
-- How does churn vary across customer risk segments?

WITH customer_risk AS (
    SELECT
        customer_id,
        exited,
        CASE
            WHEN age >= 40
                 AND is_active_member = 0
                 AND num_of_products <> 2
                THEN 'High Risk'

            WHEN age >= 40
                 OR is_active_member = 0
                THEN 'Medium Risk'

            ELSE 'Low Risk'
        END AS risk_segment
    FROM customers
)

SELECT
    risk_segment,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS churn_rate_pct
FROM customer_risk
GROUP BY risk_segment
ORDER BY churn_rate_pct DESC;