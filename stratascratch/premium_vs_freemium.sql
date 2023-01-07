--https://platform.stratascratch.com/coding/10300-premium-vs-freemium?code_type=1
--
--Find the total number of downloads for paying and non-paying users by date. Include only records where non-paying customers have more downloads than paying customers. The output should be sorted by earliest date first and contain 3 columns date, non-paying downloads, paying downloads.
--
--
--ms_user_dimension Table
--
--user_id:int
--acc_id:int
--
--
--ms_acc_dimension Table
--
--acc_id:int
--paying_customer:varchar
--
--
--ms_download_facts Table
--
--date:datetime
--user_id:int
--downloads:int


WITH a AS (
    SELECT
        date
        , paying_customer paying
        , SUM(downloads) sum_down
    FROM
        ms_download_facts msd
    LEFT JOIN (
        SELECT *
        FROM
            ms_user_dimension msu
        LEFT JOIN ms_acc_dimension msa
        ON msu.acc_id = msa.acc_id
    ) users
    ON msd.user_id = users.user_id
    GROUP BY
        date
        , paying_customer
    ORDER BY
        date
        , paying
)

SELECT *
FROM (
    SELECT
        date
        , sum_down np
        , LEAD(sum_down) OVER(PARTITION BY date) pu
    FROM
        a
) q
WHERE
    pu IS NOT NULL
    AND np > pu
