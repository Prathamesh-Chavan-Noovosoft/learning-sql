-- Work out the number of days remaining in the month
SELECT (DATE_TRUNC('month', sub.ts) + INTERVAL '1 month')
               - DATE_TRUNC('day', sub.ts) AS remaining
FROM (SELECT TIMESTAMP '2012-02-11 01:00:00' AS ts) AS sub


-- Work no. of days in a month a given month