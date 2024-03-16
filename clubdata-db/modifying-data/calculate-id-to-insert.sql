-- Calculate Next id to insert based on last id

-- Answer 1
INSERT INTO facilities
        (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
        (SELECT (SELECT MAX(facid) FROM facilities) + 1, 'Spa', 20, 30, 100000, 800);


-- Answer 2
INSERT INTO facilities(facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
VALUES ((SELECT COUNT(facid) FROM facilities), 'Spa', 20, 30, 100000, 800);