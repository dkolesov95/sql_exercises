--https://platform.stratascratch.com/coding/10322-finding-user-purchases?code_type=1
--
--Write a query that'll identify returning active users. A returning active user is a user that has made a second purchase within 7 days of any other of their purchases. Output a list of user_ids of these returning active users.
--
--
--amazon_transactions Table
--
--id: int
--user_id: int
--item: varchar
--created_at: datetime
--revenue: int


WITH finale AS (
    SELECT
        user_id
        , created_at
        , EXTRACT(DAY FROM created_at) - lead(EXTRACT(DAY FROM created_at))
            OVER(PARTITION BY user_id ORDER BY created_at DESC) diff
    FROM
        amazon_transactions
)

SELECT
    DISTINCT user_id
FROM
    finale
WHERE
    diff <= 7;
