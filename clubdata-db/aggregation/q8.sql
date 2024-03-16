-- List facilities with more than 1000 slots booked
SELECT b.facid, SUM(b.slots) "Total Slots"
FROM bookings b
GROUP BY b.facid
HAVING SUM(b.slots) > 1000
ORDER BY b.facid;
