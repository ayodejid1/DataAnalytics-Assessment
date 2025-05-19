-- Q3: Find active accounts (plans) with no transactions in the last 365 days.

WITH last_tx_dates AS (
    SELECT
        sa.owner_id,
        sa.plan_id,
        MAX(sa.created_on) AS last_transaction_date
    FROM savings_savingsaccount sa
    GROUP BY sa.owner_id, sa.plan_id
),
inactive_accounts AS (
    SELECT
        p.id AS plan_id,
        p.owner_id,
        CASE 
            WHEN p.is_regular_savings = true THEN 'Savings'
            WHEN p.is_a_fund = true THEN 'Investment'
            ELSE 'Other'
        END AS type,
        COALESCE(ltd.last_transaction_date, '1900-01-01'::date) AS last_transaction_date,
        CURRENT_DATE - COALESCE(ltd.last_transaction_date, CURRENT_DATE) AS inactivity_days
    FROM plans_plan p
    LEFT JOIN last_tx_dates ltd ON p.id = ltd.plan_id
    WHERE p.is_regular_savings = true OR p.is_a_fund = true
)
SELECT
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    inactivity_days
FROM inactive_accounts
WHERE inactivity_days > 365
ORDER BY inactivity_days DESC;
