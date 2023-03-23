-- https://lab.karpov.courses/learning/152/module/1881/lesson/19951/57851/272088/

-- Для каждого дня в таблице orders рассчитайте следующие показатели:

-- 1. Выручку, полученную в этот день.
-- 2. Суммарную выручку на текущий день.
-- 3. Прирост выручки, полученной в этот день, относительно значения выручки за предыдущий день.
-- 4. Колонки с показателями назовите соответственно revenue, total_revenue, revenue_change. Колонку с датами назовите date.

-- Прирост выручки рассчитайте в процентах и округлите значения до двух знаков после запятой.

-- Результат должен быть отсортирован по возрастанию даты.

-- Поля в результирующей таблице: date, revenue, total_revenue, revenue_change


WITH sq1 as (SELECT t1.creation_time::date date,
                    sum(p.price) revenue
             FROM   (SELECT creation_time,
                            unnest(product_ids) product_id
                     FROM   orders
                     WHERE  order_id not in (SELECT order_id
                                             FROM   user_actions
                                             WHERE  action = 'cancel_order')) t1
                 LEFT JOIN products p
                     ON t1.product_id = p.product_id
             GROUP BY date)
SELECT date,
       revenue,
       total_revenue,
       round((revenue-rc)/rc *100, 2) revenue_change
FROM   (SELECT date,
               revenue,
               sum(revenue) OVER(ORDER BY date) total_revenue,
               lag(revenue, 1) OVER(ORDER BY date) rc
        FROM   sq1
        ORDER BY date) t1