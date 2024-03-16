SELECT f.facid                              AS facid,
       f.name                               AS name,
       ROUND((SUM(b.slots) * 0.5)::NUMERIC) AS total_hours
FROM bookings b
             INNER JOIN facilities f USING (facid)
GROUP BY f.name, f.facid
ORDER BY f.facid, f.name;
