SELECT EXTRACT(MONTH FROM months_list.month)                        AS month,
       (months_list.month + INTERVAL '1 month') - months_list.month AS length
FROM (SELECT GENERATE_SERIES(TIMESTAMP '2012-01-01', TIMESTAMP '2012-12-01',
                             INTERVAL '1 month') AS month) AS months_list