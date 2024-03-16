WITH RECURSIVE search_parents
                       AS (SELECT f.parent_id AS parent_id, f.name, f.id
                           FROM family f
                           --                            WHERE f.id IN (:ids)
--                              AND f.parent_id IS NOT NULL
                           WHERE f.name = 'H'
                           
                           UNION ALL
                           
                           SELECT p.id, p.name, p.parent_id
                           FROM family p
                                        JOIN search_parents r
                                             ON r.parent_id = p.id)
SELECT *
FROM search_parents;