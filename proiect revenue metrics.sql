WITH mrr_cte AS (
    WITH monthly_mrr AS (
        SELECT
            DATE_TRUNC('month', payment_date)::date AS payment_month,   -- extragem luna
            SUM(revenue_amount_usd) AS mrr,  -- MRR
            COUNT(DISTINCT user_id) AS paid_users -- PAID USERS
        FROM
            project.games_payments
        WHERE
            payment_date IS NOT null AND revenue_amount_usd > 0
        GROUP BY
            payment_month
    ),
    mrr_changes AS (
        SELECT
            payment_month,
            mrr,
            paid_users,
            LAG(mrr) OVER (ORDER BY payment_month) AS previous_mrr,  -- aducem prin functia lag mrr anterior
            LAG(paid_users) OVER (ORDER BY payment_month) AS previous_paid_users  -- utilizatori anteriori
        FROM
            monthly_mrr
    )
    SELECT
        payment_month,
        mrr,
        previous_mrr,
        paid_users,
        COALESCE(paid_users - previous_paid_users, 0) AS churn_users,  -- CHURN USERS
        COALESCE(ROUND((paid_users - previous_paid_users) * 100.0 / previous_paid_users, 2), 0) AS churn_rate,  -- CHURN RATE
        mrr - COALESCE(previous_mrr, 0) AS mrr_expansion  -- MRR EXPANSION
    FROM
        mrr_changes
    ORDER BY
        payment_month
),
first_payment AS (
    WITH first_month AS (
        SELECT 
            user_id,
            game_name,
            MIN(DATE_TRUNC('month', payment_date))::date AS first_payment_month
        FROM project.games_payments
        GROUP BY user_id, game_name
    )
	SELECT
		fm.first_payment_month AS month,
		fm.user_id,
		fm.game_name,
		SUM(gp.revenue_amount_usd) AS new_mrr, -- NEW MRR
		COUNT(gp.user_id) AS new_paid_users -- NEW PAID USERS
	FROM 
		first_month fm
	JOIN project.games_payments gp
	ON fm.user_id = gp.user_id AND DATE_TRUNC('month', gp.payment_date) = fm.first_payment_month
	GROUP BY month, fm.user_id, fm.game_name
	ORDER BY month
),
lifetime_metrics AS (
	    SELECT
	        user_id,
	        MIN(DATE_TRUNC('month', payment_date))::date AS first_payment_month, -- prima luna de plata
	        MAX(DATE_TRUNC('month', payment_date))::date AS last_payment_month,  -- ultima luna de plata
	        COUNT(DISTINCT DATE_TRUNC('month', payment_date)) AS active_months,
	        sum(revenue_amount_usd) as mrr
	    FROM
	        project.games_payments
	    GROUP BY
	        user_id
),
users_metrics AS (
    SELECT
        fp.month,
        fp.user_id,
        fp.game_name,
        mc.mrr,
        fp.new_mrr,
        mc.mrr_expansion,
        mc.paid_users,
        fp.new_paid_users,
        ROUND(mc.mrr / mc.paid_users) AS arppu,  -- ARPPU
        mc.churn_users,
        mc.churn_rate,
        lm.active_months as customer_lt,  -- CUSTOMER LIFETIME
        sum(lm.mrr) OVER (PARTITION BY fp.user_id ORDER BY fp.month) AS customer_ltvalue  -- CUSTOMER LIFETIME VALUE
    FROM
        mrr_cte mc
    JOIN first_payment fp
    ON mc.payment_month = fp.month
    join lifetime_metrics lm
    on fp.user_id = lm.user_id
)
SELECT
    month,
    um.user_id,
    um.game_name,
    gpu.language,
    age,
    mrr,
    new_mrr,
    mrr_expansion,
    paid_users,
    new_paid_users,
    arppu,
    churn_users,
    churn_rate,
    customer_lt,
    customer_ltvalue
FROM
    users_metrics um
join project.games_paid_users gpu
on um.user_id = gpu.user_id
order by month;

SELECT user_id, game_name, "language", has_older_device_model, age
FROM project.games_paid_users;