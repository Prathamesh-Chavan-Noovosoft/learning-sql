-- Find the total revenue of each facility
SELECT f.name,
       SUM(b.slots * CASE
                             WHEN b.memid = 0 THEN f.guestcost
                                              ELSE f.membercost
               END) AS revenue
FROM bookings AS b
             INNER JOIN facilities AS f
                        ON b.facid = f.facid
GROUP BY f.name
ORDER BY revenue;