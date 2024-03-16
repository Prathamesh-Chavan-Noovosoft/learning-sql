-- Update a row based on the contents of another row
UPDATE facilities AS newf
SET membercost = oldf.membercost * 1.1,
    guestcost  = oldf.guestcost * 1.1
FROM (SELECT membercost, guestcost FROM facilities WHERE facid = 0) AS oldf
WHERE newf.facid = 1