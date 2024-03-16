SELECT name, month, ROUND((total_slots * 100 / (25 * days))::NUMERIC, 1) AS utilisation
FROM (SELECT DATE_TRUNC('month', b.starttime)                                                            AS month,
             DATE_PART('days', DATE_TRUNC('month', b.starttime) + INTERVAL '1 month' - INTERVAL '1 day') AS days,
             SUM(b.slots)                                                                                AS total_slots,
             f.name                                                                                      AS name
      FROM bookings b
                   INNER JOIN facilities f USING (facid)
      GROUP BY f.name, month
      ORDER BY f.name, month) AS days_of_months

