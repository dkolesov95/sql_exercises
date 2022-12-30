--https://platform.stratascratch.com/coding/10319-monthly-percentage-difference?code_type=1
--
--Given a table of purchases by date, calculate the month-over-month percentage change in revenue. The output should include the year-month date (YYYY-MM) and percentage change, rounded to the 2nd decimal point, and sorted from the beginning of the year to the end of the year.
--The percentage change column will be populated from the 2nd month forward and can be calculated as ((this month's revenue - last month's revenue) / last month's revenue)*100.
--
--
--sf_transactions Table
--
--id:           int
--created_at:   datetime
--value:        int
--purchase_id:  int


WITH ab AS (
    SELECT
        to_char(created_at, 'YYYY-MM') date
        , SUM(value) s
    FROM
        sf_transactions
    GROUP BY
        date
)
SELECT
    date
    , s
    , ROUND((s - lag(s) over(ORDER BY date)) / lag(s)
        OVER(ORDER BY date) * 100, 2) ch
FROM
    ab;
