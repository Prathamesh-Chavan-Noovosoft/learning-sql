-- Output the facility id that has the highest number of slots booked

-- Answer 1
SELECT b.facid, SUM(b.slots) AS "Total Slots"
FROM bookings b
GROUP BY b.facid
ORDER BY SUM(b.slots) DESC
        FETCH FIRST 1 ROWS ONLY;

-- Answer 2 (Resolve)
SELECT facid, SUM(slots) AS maxSlot
FROM bookings
GROUP BY facid
HAVING SUM(slots) = (SELECT MAX(totalSlots)
                     FROM (SELECT SUM(slots) AS totalSlots
                           FROM bookings
                           GROUP BY facid) AS sum)

-- CTE