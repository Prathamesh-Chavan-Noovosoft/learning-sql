-- List the total slots booked per facility
SELECT b.facid, SUM(b.slots) "Total Slots"
FROM bookings b
GROUP BY b.facid
ORDER BY b.facid;


