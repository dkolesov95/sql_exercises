--https://datalemur.com/questions/international-call-percentage
--
--A phone call is considered an international call when the person calling is in a different country than the person receiving the call.
--
--What percentage of phone calls are international? Round the result to 1 decimal.
--
--Assumption:
--    1. The caller_id in phone_info table refers to both the caller and receiver.
--
--
--phone_calls Table:
--
--caller_id	integer
--receiver_id	integer
--call_time	timestamp
--
--
--phone_info Table:
--
--caller_id	integer
--country_id	integer
--network	integer
--phone_number	string


WITH it AS (
    SELECT
        c.caller_id,
        r.country_id as caller_country_id,
        c.receiver_id,
        c.receiver_country_id
    FROM (
        SELECT
            c.caller_id,
            c.receiver_id,
            r.country_id as receiver_country_id
        FROM
            phone_calls c
            LEFT JOIN phone_info r ON c.receiver_id = r.caller_id
    ) c
        LEFT JOIN phone_info r on c.caller_id = r.caller_id
)

SELECT
  ROUND((COUNT(1)::FLOAT / (SELECT COUNT(1) FROM it)::FLOAT * 100)::NUMERIC, 1)
FROM
  it
WHERE
  caller_country_id != receiver_country_id