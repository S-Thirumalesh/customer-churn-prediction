SELECT VERSION();
CREATE DATABASE churn_db;
USE churn_db;
CREATE TABLE customers (
    customerID VARCHAR(20) PRIMARY KEY,
    gender VARCHAR(10),
    SeniorCitizen INT,
    Partner VARCHAR(5),
    Dependents VARCHAR(5),
    tenure INT,
    PhoneService VARCHAR(5),
    MultipleLines VARCHAR(20),
    InternetService VARCHAR(20),
    OnlineSecurity VARCHAR(20),
    OnlineBackup VARCHAR(20),
    DeviceProtection VARCHAR(20),
    TechSupport VARCHAR(20),
    StreamingTV VARCHAR(20),
    StreamingMovies VARCHAR(20),
    Contract VARCHAR(20),
    PaperlessBilling VARCHAR(5),
    PaymentMethod VARCHAR(30),
    MonthlyCharges DECIMAL(10,2),
    TotalCharges VARCHAR(20),
    Churn VARCHAR(5)
);
SELECT COUNT(*) FROM customers;
SELECT * FROM customers LIMIT 5;
SELECT 
    Churn, 
    COUNT(*) AS total_customers
FROM customers
GROUP BY Churn;

SELECT 
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_percent
FROM customers;

SELECT 
    Contract,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_percent
FROM customers
GROUP BY Contract
ORDER BY churn_rate_percent DESC;

SELECT 
    Churn,
    ROUND(AVG(tenure), 2) AS avg_tenure_months
FROM customers
GROUP BY Churn;

SELECT 
    InternetService,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_percent
FROM customers
GROUP BY InternetService
ORDER BY churn_rate_percent DESC;

SELECT 
    PaymentMethod,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_percent
FROM customers
WHERE PaymentMethod IS NOT NULL
GROUP BY PaymentMethod
ORDER BY churn_rate_percent DESC;

-- CREATING TABLE
CREATE TABLE contract_reference (
    Contract VARCHAR(20) PRIMARY KEY,
    risk_category VARCHAR(20),
    typical_commitment_months INT
);

INSERT INTO contract_reference (Contract, risk_category, typical_commitment_months)
VALUES 
    ('Month-to-month', 'High Risk', 1),
    ('One year', 'Medium Risk', 12),
    ('Two year', 'Low Risk', 24);
    
SELECT * FROM contract_reference;

SELECT 
    c.customerID,
    c.Contract,
    c.tenure,
    c.Churn,
    r.risk_category
FROM customers AS c
JOIN contract_reference AS r
    ON c.Contract = r.Contract
WHERE c.Churn = 'Yes'
LIMIT 10;

SELECT 
    customerID,
    tenure,
    Contract,
    Churn
FROM customers
WHERE Churn = 'Yes'
  AND tenure > (SELECT AVG(tenure) FROM customers)
ORDER BY tenure DESC
LIMIT 10;