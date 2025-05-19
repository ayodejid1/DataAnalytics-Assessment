-- Q1: Find customers who have at least one funded savings plan and one funded investment plan,
-- sorted by total deposits.

WITH savings_plans AS (
    SELECT
        owner_id,
        COUNT(*) AS savings_count
    FROM plans_plan
    WHERE is_regular_savings = true
      AND amount > 0
    GROUP BY owner_id
),
investment_plans AS (
    SELECT
        owner_id,
        COUNT(*) AS investment_count
    FROM plans_plan
    WHERE is_a_fund = true
      AND amount > 0
    GROUP BY owner_id
),
total_deposits AS (
    SELECT
        owner_id,
        SUM(confirmed_amount) AS total_deposits
    FROM savings_savingsaccount
    GROUP BY owner_id
)
SELECT
    u.id AS owner_id,
    u.name,
    sp.savings_count,
    ip.investment_count,
    ROUND((COALESCE(td.total_deposits, 0) / 100.0)::numeric, 2) AS total_deposits  -- convert kobo to naira
FROM users_customuser u
JOIN savings_plans sp ON u.id = sp.owner_id
JOIN investment_plans ip ON u.id = ip.owner_id
LEFT JOIN total_deposits td ON u.id = td.owner_id
ORDER BY total_deposits DESC;
