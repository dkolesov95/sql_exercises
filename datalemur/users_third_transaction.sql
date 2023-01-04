--https://datalemur.com/questions/sql-third-transaction
--
--Assume you are given the table below on Uber transactions made by users. Write a query to obtain the third transaction of every user. Output the user id, spend and transaction date.
--
--transactions Table:
--
--user_id           integer
--spend             decimal
--transaction_date  timestamp


WITH t as
(
    SELECT
        user_id
        , spend
        , transaction_date
        , ROW_NUMBER() OVER(
            PARTITION BY user_id
            ORDER BY transaction_date
        ) as rn
    FROM transactions
)

SELECT
    user_id
    , spend
    , transaction_date
FROM
    t
WHERE
    rn = 3;