--https://datalemur.com/questions/odd-even-measurements
--
--Assume you are given the table containing measurement values obtained from a Google sensor over several days. Measurements are taken several times within a given day.
--
--Write a query to obtain the sum of the odd-numbered and even-numbered measurements on a particular day, in two different columns. Refer to the Example Output below for the output format.
--
--Definition:
--    1. 1st, 3rd, and 5th measurements taken within a day are considered odd-numbered measurements and the 2nd, 4th, and 6th measurements are even-numbered measurements.
--
--
--measurements Table:
--
--measurement_id	integer
--measurement_value	decimal
--measurement_time	datetime


SELECT
    measurement_day::DATE
    , SUM(measurement_value) FILTER (WHERE r % 2 = 1) as odd_sum
    , SUM(measurement_value) FILTER (WHERE r % 2 = 0) as even_sum
FROM
    (
        SELECT
            to_char(measurement_time::date, 'dd/mm/yyyy') measurement_day
            , measurement_value
            , RANK() OVER(
                PARTITION BY TO_CHAR(measurement_time::date, 'dd/mm/yyyy')
                ORDER BY measurement_time
            ) r
        FROM
            measurements
    ) f
GROUP BY
    measurement_day;