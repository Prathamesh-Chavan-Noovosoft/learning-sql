-- Find telephone numbers with parentheses

-- Answer 1 - Using postgreSQL's LIKE command
SELECT memid, telephone
FROM members
WHERE telephone LIKE '(%)%';

-- Answer 2 - Using SQL standard SIMILAR TO command
SELECT memid, telephone
FROM members
WHERE telephone SIMILAR TO '%[()]%';

-- Answer 3 - Using Regex
SELECT memid, telephone
FROM members
WHERE telephone ~ '[()]';
