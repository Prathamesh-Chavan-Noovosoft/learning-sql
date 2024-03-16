-- List the total slots booked per facility per month
SELECT b.facid, EXTRACT(MONTH FROM b.starttime) AS month, SUM(b.slots) AS "Total Slots"
FROM bookings b
WHERE b.starttime::DATE >= '2012-01-01'
  AND b.starttime::DATE <= '2012-12-31'
GROUP BY b.facid, month
ORDER BY b.facid, month;
