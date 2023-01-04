--https://platform.stratascratch.com/coding/10156-number-of-units-per-nationality?code_type=1
--
--Find the number of apartments per nationality that are owned by people under 30 years old.
--Output the nationality along with the number of apartments.
--Sort records by the apartments count in descending order.
--
--
--airbnb_hosts Table
--
--host_id:      int
--nationality:  varchar
--gender:       varchar
--age:          int
--
--
--airbnb_units Table
--
--host_id:      int
--unit_id:      varchar
--unit_type:    varchar
--n_beds:       int
--n_bedrooms:   int
--country:      varchar
--city:         varchar


WITH cte AS (
    SELECT
        h.host_id
        , h.nationality
        , h.age
        , u.host_id
        , u.unit_id
        , u.unit_type
    FROM
        airbnb_hosts h
        JOIN airbnb_units u ON h.host_id = u.host_id
    WHERE
        u.unit_type = 'Apartment'
        AND h.age < 30
)

SELECT
    nationality
    , count(c)
FROM (
        SELECT
            nationality
            , count(unit_type) c
        FROM
            cte
        GROUP BY
            nationality
            , unit_id
) foo
GROUP BY
    nationality;
