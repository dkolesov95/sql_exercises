--https://datalemur.com/questions/top-drugs-sold
--
--CVS Health is trying to better understand its pharmacy sales, and how well different drugs are selling.
--
--Write a query to find the top 2 drugs sold, in terms of units sold, for each manufacturer. List your results in alphabetical order by manufacturer.
--
--
--pharmacy_sales Table:
--
--product_id    integer
--units_sold    integer
--total_sales   decimal
--cogs          decimal
--manufacturer	varchar
--drug          varchar


WITH t1 as (
  SELECT
    manufacturer
    , drug
    , SUM(units_sold) s
    , ROW_NUMBER() OVER(
        PARTITION BY manufacturer
        ORDER BY SUM(units_sold) DESC
    ) rn
  FROM
    pharmacy_sales
  GROUP BY
    manufacturer
    , drug
)

SELECT
    manufacturer
    , drug
FROM
    t1
WHERE
    rn <= 2
ORDER BY
    manufacturer