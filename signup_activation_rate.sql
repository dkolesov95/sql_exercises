--https://datalemur.com/questions/signup-confirmation-rate
--
--New TikTok users sign up with their emails. They confirmed their signup by replying to the text confirmation to activate their accounts. Users may receive multiple text messages for account confirmation until they have confirmed their new account.
--
--Write a query to find the activation rate of the users. Round the percentage to 2 decimal places.
--
--Definitions:
--    1. emails table contain the information of user signup details.
--    2. texts table contains the users' activation information.
--
--
--emails Table:
--
--email_id      integer
--user_id       integer
--signup_date   datetime
--
--
--texts Table:
--
--text_id       integer
--email_id      integer
--signup_action varchar


SELECT
    ROUND(s::NUMERIC / c::NUMERIC, 2)
FROM
    (
        SELECT
            SUM(1) FILTER (WHERE t.signup_action = 'Confirmed') s
            , count(1) c
        FROM
            emails e
            LEFT JOIN texts t ON e.email_id = t.email_id
        WHERE
            t.text_id is not NULL
    ) d