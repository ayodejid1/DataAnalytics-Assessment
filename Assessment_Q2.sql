-- Q2: Calculate average transactions per customer per month and categorize frequency.

WITH transactions_per_customer AS (
    SELECT
        owner_id,
        DATE_TRUNC('month', created_on) AS month,
        COUNT(*) AS transactions_in_month
    FROM savings_savingsaccount
    GROUP BY owner_id, DATE_TRUNC('month', created_on)
),
avg_transactions AS (
    SELECT
        owner_id,
        AVG(transactions_in_month) AS avg_tx_per_month
    FROM transactions_per_customer
    GROUP BY owner_id
),
categorized AS (
    SELECT
        CASE
            WHEN avg_tx_per_month >= 10 THEN 'High Frequency'
            WHEN avg_tx_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        owner_id,
        avg_tx_per_month
    FROM avg_transactions
)
SELECT
    frequency_category,
    COUNT(owner_id) AS customer_count,
    ROUND(AVG(avg_tx_per_month), 2) AS avg_transactions_per_month
FROM categorized
GROUP BY frequency_category
ORDER BY     CASE frequency_category
        WHEN 'High Frequency' THEN 1
        WHEN 'Medium Frequency' THEN 2
        WHEN 'Low Frequency' THEN 3
    END;