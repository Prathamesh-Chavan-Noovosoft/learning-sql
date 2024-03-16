-- In our previous exercises, we deleted a specific member who had never made a booking.
-- How can we make that more general, to delete all members who have never made a booking?
DELETE
FROM members AS m
WHERE m.memid NOT IN (SELECT b.memid FROM bookings AS b)