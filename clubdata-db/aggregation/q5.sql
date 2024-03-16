-- List the total slots booked per facility in a given month
SELECT b.facid, SUM(b.slots) "Total Slots"
FROM bookings b
WHERE b.starttime::DATE >= '2012-09-01'
  AND b.starttime::DATE <= '2012-09-30'
GROUP BY b.facid
ORDER BY SUM(b.slots);
