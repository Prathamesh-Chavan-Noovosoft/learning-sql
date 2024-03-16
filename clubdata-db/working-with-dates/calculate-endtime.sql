-- Return a list of the start and end time of the last 10 bookings
-- (ordered by the time at which they end, followed by the time at which they start) in the system.
SELECT starttime, starttime + (INTERVAL '30 minutes') * slots AS endtime
FROM bookings
ORDER BY endtime DESC, starttime DESC
        FETCH FIRST 10 ROWS ONLY;