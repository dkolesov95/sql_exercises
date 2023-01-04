--https://platform.stratascratch.com/coding/10077-income-by-title-and-gender?code_type=1
--
--Find the average total compensation based on employee titles and gender. Total compensation is calculated by adding both the salary and bonus of each employee. However, not every employee receives a bonus so disregard employees without bonuses in your calculation. Employee can receive more than one bonus.
--Output the employee title, gender (i.e., sex), along with the average total compensation.
--
--
--sf_employee Table
--
--id:               int
--first_name:       varchar
--last_name:        varchar
--age:              int
--sex:              varchar
--employee_title:   varchar
--department:       varchar
--salary:           int
--target:           int
--email:            varchar
--city:             varchar
--address:          varchar
--manager_id:       int
--
--
--sf_bonus Table
--
--worker_ref_id:    int
--bonus:            int


WITH salary AS (
    SELECT
        e.id
        , e.employee_title
        , e.sex
        , AVG(e.salary) a
        , SUM(b.bonus) s
    FROM
        sf_employee e
        LEFT JOIN sf_bonus b ON e.id = b.worker_ref_id
    WHERE
        b.bonus IS NOT NULL
    GROUP BY
        e.id
        , e.employee_title
        , e.sex
)

SELECT
    employee_title
    , sex
    , AVG(a + s)
FROM
    salary
GROUP BY
    employee_title
    , sex