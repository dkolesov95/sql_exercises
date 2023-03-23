-- https://lab.karpov.courses/learning/152/module/1881/lesson/19951/57851/272089/

-- Теперь на основе данных о выручке рассчитаем несколько относительных показателей, которые покажут, сколько в среднем потребители готовы платить за услуги нашего сервиса доставки. Остановимся на следующих метриках:

-- 1. ARPU (Average Revenue Per User) — средняя выручка на одного пользователя за определённый период.

-- 2. ARPPU (Average Revenue Per Paying User) — средняя выручка на одного платящего пользователя за определённый период.

-- 3. AOV (Average Order Value) — средний чек, или отношение выручки за определённый период к общему количеству заказов за это же время.


WITH sq1 as (SELECT t1.date date,
                    sum(p.price) revenue
             FROM   (SELECT creation_time::date date,
                            unnest(product_ids) product_id
                     FROM   orders
                     WHERE  order_id not in (SELECT order_id
                                             FROM   user_actions
                                             WHERE  action = 'cancel_order')) t1
                 LEFT JOIN products p
                     ON t1.product_id = p.product_id
             GROUP BY t1.date), cancel_orders as (SELECT order_id
                                     FROM   user_actions
                                     WHERE  action = 'cancel_order')
SELECT sq1.date,
       round(sq1.revenue::decimal / ua.unq_users, 2) as arpu,
       round(sq1.revenue::decimal / ua.unq_paying_user, 2) as arppu,
       round(sq1.revenue::decimal / ua.count_orders, 2) as aov
FROM   sq1
    LEFT JOIN (SELECT time::date date,
                      count(distinct user_id) unq_users,
                      count(distinct user_id) filter(WHERE order_id not in (SELECT *
                                                                     FROM   cancel_orders)) unq_paying_user, count(order_id) filter(
               WHERE  order_id not in (SELECT *
                                       FROM   cancel_orders)) count_orders
               FROM   user_actions
               GROUP BY date) ua
        ON sq1.date = ua.date
ORDER BY date