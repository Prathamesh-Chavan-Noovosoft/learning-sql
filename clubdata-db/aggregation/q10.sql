-- Find facilities with a total revenue less than 1000
SELECT *
FROM (SELECT f.name,
             SUM(b.slots *
                 CASE
                         WHEN b.memid = 0 THEN f.guestcost
                                          ELSE f.membercost
                         END) AS revenue
      FROM bookings AS b
                   INNER JOIN facilities AS f
                              ON b.facid = f.facid
      GROUP BY f.name
      HAVING SUM(b.slots *
                 CASE
                         WHEN b.memid = 0 THEN f.guestcost
                                          ELSE f.membercost
                         END) < 1000) nr
ORDER BY revenue;