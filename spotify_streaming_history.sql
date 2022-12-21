--https://datalemur.com/questions/spotify-streaming-history
--
--You're given two tables on Spotify users' streaming data. songs_history table contains the historical streaming data and songs_weekly table contains the current week's streaming data.
--
--Write a query to output the user id, song id, and cumulative count of song plays as of 4 August 2022 sorted in descending order.
--
--Definitions:
--    1. song_weekly table currently holds data from 1 August 2022 to 7 August 2022.
--    2. songs_history table currently holds data up to to 31 July 2022. The output should include the historical data in this table.
--
--Assumption:
--    1. There may be a new user or song in the songs_weekly table not present in the songs_history table.
--
--
--songs_history Table:
--
--history_id    integer
--user_id       integer
--song_id       integer
--song_plays    integer
--
--
--songs_weekly Table:
--
--user_id       integer
--song_id       integer
--listen_time   datetime


WITH cte2 as
(
  SELECT
    user_id
    , song_id
    , song_plays
  FROM
    songs_history

  UNION ALL

  SELECT
    user_id
    , song_id
    , c as song_plays
  FROM
    (
        SELECT
            user_id
            , song_id
            , count(*) c
        FROM
            songs_weekly
        WHERE
            to_char(listen_time, 'MM/DD/YYYY') <= '08/04/2022'
        GROUP BY
            user_id
            , song_id
    ) d
)

SELECT
    user_id
    , song_id
    , SUM(song_plays) as sp
FROM
    cte2
GROUP BY
    user_id
    , song_id
ORDER BY
    sp DESC