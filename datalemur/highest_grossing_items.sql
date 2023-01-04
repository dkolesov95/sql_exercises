--https://datalemur.com/questions/sql-highest-grossing
--
--Assume you are given the table containing information on Amazon customers and their spending on products in various categories.
--
--Identify the top two highest-grossing products within each category in 2022. Output the category, product, and total spend.
--
--product_spend Table:
--
--category          string
--product           string
--user_id           integer
--spend             decimal
--transaction_date  timestamp


WITH wf as
(
    SELECT
        *
        , RANK() OVER(
            PARTITION BY category
            ORDER BY s DESC
        ) rk
    FROM
        (
            SELECT
                category
                , product
                , SUM(spend) s
            FROM
                product_spend
            WHERE
                TO_CHAR(transaction_date::DATE, 'YYYY') = '2022'
            GROUP BY
                category
                , product
        ) q
)

SELECT
    category
    , product
    , s
FROM
    wf
WHERE
    rk < 3