--https://platform.stratascratch.com/coding/10285-acceptance-rate-by-date?code_type=1
--
--What is the overall friend acceptance rate by date? Your output should have the rate of acceptances by the date the request was sent. Order by the earliest date to latest.
--
--Assume that each friend request starts by a user sending (i.e., user_id_sender) a friend request to another user (i.e., user_id_receiver) that's logged in the table with action = 'sent'. If the request is accepted, the table logs action = 'accepted'. If the request is not accepted, no record of action = 'accepted' is logged.
--
--
--fb_friend_requests Table
--
--user_id_sender:   varchar
--user_id_receiver: varchar
--date:             datetime
--action:           varchar


WITH cte AS (
    SELECT
        user_id_sender
        , user_id_receiver
        , date
        , action
        , LEAD(1, 1, 0) OVER(PARTITION BY user_id_sender ORDER BY date) l
        , ROW_NUMBER() OVER(PARTITION BY user_id_sender) r
    FROM
        fb_friend_requests
)

SELECT
    date
    , CAST(SUM(l) AS DECIMAL) / COUNT(l)
FROM
    cte
WHERE
    r = 1
GROUP BY
    date;
