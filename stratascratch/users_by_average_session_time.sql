--https://platform.stratascratch.com/coding/10352-users-by-avg-session-time?code_type=1
--
--Calculate each user's average session time. A session is defined as the time difference between a page_load and page_exit. For simplicity, assume a user has only 1 session per day and if there are multiple of the same events on that day, consider only the latest page_load and earliest page_exit. Output the user_id and their average session time.
--
--
--facebook_web_log Table
--
--user_id:      int
--timestamp:    datetime
--action:       varchar


WITH a AS (
    SELECT
        user_id
        , EXTRACT(DAY FROM timestamp) dd
        , action
        , MAX(timestamp) m
    FROM
        facebook_web_log
    WHERE
        action = 'page_exit'
        OR action = 'page_load'
    GROUP BY
        user_id
        , dd
        , action
    ORDER BY
        user_id
)

SELECT
    user_id
    , avg(s - m)
FROM (
    SELECT
        *
        , LEAD(m) OVER(PARTITION BY user_id, dd ORDER BY m) s
    FROM
        a
) q
WHERE
    s IS NOT NULL
GROUP BY
    user_id
