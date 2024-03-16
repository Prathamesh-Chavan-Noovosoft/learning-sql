SELECT facid, EXTRACT(MONTH FROM starttime) AS month, SUM(slots) AS slots
FROM bookings
WHERE EXTRACT(YEAR FROM starttime) = '2012'
GROUP BY ROLLUP (facid, month)
ORDER BY facid, MONTH;