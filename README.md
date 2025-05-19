# Data Analytics SQL Assessment - README

This repository contains solutions to four SQL questions for a Data Analyst assessment. The solutions were developed using **PostgreSQL** managed via **Docker** and tested in **pgAdmin4**. Below are the explanations, approaches, and challenges encountered for each question.

---

## **Question 1: High-Value Customers with Multiple Products**  
**Objective**: Identify customers with both funded savings and investment plans, sorted by total deposits.  

**Approach**:  
- Used CTEs (`savings_plans`, `investment_plans`) to count valid savings/investment plans (filtered by `is_regular_savings` and `is_a_fund` flags).  
- Calculated `total_deposits` by summing `confirmed_amount` from the `savings_savingsaccount` table and converted values from kobo to naira.  
- Joined the results with the `users_customuser` table to fetch customer details.  
- Filtered customers with `savings_count >= 1` and `investment_count >= 1` implicitly via `JOIN`.  

**Challenges**:  
- Ensuring `amount > 0` in CTEs to exclude unfunded plans.  
- Properly handling `LEFT JOIN` for `total_deposits` to include customers with no deposits.  

---

## **Question 2: Transaction Frequency Analysis**  
**Objective**: Categorize customers by transaction frequency (High/Medium/Low).  

**Approach**:  
- Aggregated monthly transactions per customer using `DATE_TRUNC('month', created_on)`.  
- Computed average monthly transactions per customer in a CTE (`avg_transactions`).  
- Applied a `CASE` statement to categorize customers based on thresholds.  
- Grouped results by category and ordered them logically using `CASE` in `ORDER BY`.  

**Challenges**:  
- Avoiding division errors by ensuring valid averages.  
- Mapping frequency categories to a custom sort order for the final output.  

---

## **Question 3: Account Inactivity Alert**  
**Objective**: Flag active accounts with no transactions in the last 365 days.  

**Approach**:  
- Identified the `last_transaction_date` for each plan using `MAX(created_on)`.  
- Joined `plans_plan` with transaction dates, defaulting to `1900-01-01` for plans with no transactions (`COALESCE`).  
- Calculated `inactivity_days` as the difference between `CURRENT_DATE` and `last_transaction_date`.  
- Filtered results where `inactivity_days > 365` and categorized plan types using `CASE`.  

**Challenges**:  
- Handling `NULL` values for plans with no transactions by setting a default date.  
- Distinguishing between savings (`is_regular_savings`) and investment (`is_a_fund`) plans.  

---

## **Question 4: Customer Lifetime Value (CLV) Estimation**  
**Objective**: Estimate CLV based on tenure, transactions, and profit (0.1% per transaction).  

**Approach**:  
- Calculated customer tenure in months using `EXTRACT` and `AGE` functions.  
- Aggregated total transactions and converted `confirmed_amount` from kobo to naira.  
- Derived CLV using the formula:  
  ```sql
  (total_transactions / tenure_months) * 12 * (total_amount_naira * 0.001 / total_transactions)

- Used GREATEST(tenure_months, 1) to avoid division by zero for new customers.

**Challenges**: 

- Handling edge cases where tenure_months = 0 (new signups).

- Ensuring proper division and rounding for monetary values.

##General Challenges

### **Data Type Conversions**:
Converted amounts from kobo to naira by dividing by 100 (e.g., ROUND((... / 100.0)::numeric, 2)).

### **Edge Cases**:
Addressed NULL values using COALESCE (e.g., default dates or zero deposits).

### **Performance**:
Optimized CTEs and joins to reduce query runtime.

### **Tools & Setup**
**PostgreSQL**: Database management system.

**Docker**: Containerized environment for running PostgreSQL.

**pgAdmin4**: GUI for query development and testing.

Data dump was loaded into PostgreSQL, and table relationships were validated before query design.
