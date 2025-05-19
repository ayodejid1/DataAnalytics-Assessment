-- Q4: Customer Lifetime Value (CLV)

WITH tenure AS (
    SELECT
        id AS customer_id,
        name,
        -- Calculate total tenure in months (years * 12 + months)
        (EXTRACT(YEAR FROM AGE(CURRENT_DATE, created_on)) * 12
         + EXTRACT(MONTH FROM AGE(CURRENT_DATE, created_on))) AS tenure_months
    FROM users_customuser
),

tx AS (
    SELECT
        owner_id AS customer_id,
        COUNT(*) AS total_transactions,
        -- Convert confirmed_amount from kobo to naira by dividing by 100
        SUM(confirmed_amount) / 100.0 AS total_amount_naira
    FROM savings_savingsaccount
    WHERE confirmed_amount > 0         -- inflow transactions only
    GROUP BY owner_id
)

SELECT
    t.customer_id,
    t.name,
    GREATEST(t.tenure_months, 1) AS tenure_months,
    COALESCE(x.total_transactions, 0) AS total_transactions,
    ROUND(
        (
            (COALESCE(x.total_transactions, 0)::numeric / GREATEST(t.tenure_months, 1)) * 12
            *
            (
                COALESCE(x.total_amount_naira, 0)::numeric * 0.001
                / NULLIF(x.total_transactions, 0)
            )
        )::numeric, 2
    ) AS estimated_clv
FROM tenure t
LEFT JOIN tx x ON x.customer_id = t.customer_id
ORDER BY total_transactions DESC;


