-- Create table + data from a subquery
CREATE TABLE customer_address(id) AS (SELECT id
                                      FROM customer c
                                                   JOIN address a
                                                        USING (address_id));

DROP TABLE customer_address;

INSERT INTO customer_address(id)
        (SELECT id
         FROM customer c
                      JOIN address a
                           USING (address_id))
RETURNING *;


SELECT COUNT(*)
FROM customer_address;
