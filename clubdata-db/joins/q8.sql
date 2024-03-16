SELECT member, facility, cost
FROM (SELECT m.firstname || ' ' || m.surname AS member,
             f.name                          AS facility,
             CASE
                     WHEN m.memid = 0 THEN
                             f.guestcost * b.slots
                                      ELSE
                             f.membercost * b.slots
                     END                     AS cost
      FROM members AS m
                   INNER JOIN bookings AS b
                              ON m.memid = b.memid
                   INNER JOIN facilities AS f
                              ON b.facid = f.facid
      WHERE b.starttime::DATE = '2012-09-14') AS bookings
WHERE cost > 30
ORDER BY cost DESC;