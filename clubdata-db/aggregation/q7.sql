-- Find the count of members who have made at least one booking
SELECT COUNT(*)
FROM (SELECT DISTINCT memid FROM bookings) AS count
