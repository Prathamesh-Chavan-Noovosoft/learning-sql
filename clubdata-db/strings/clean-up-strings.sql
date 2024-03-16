-- The telephone numbers in the database are very inconsistently formatted.
-- You'd like to print a list of member ids and numbers
-- that have had '-','(',')', and ' ' characters removed. Order by member id.

-- Answer 1

-- Translate function takes 2 strings along with our original string
-- from string & to string
-- Inside the original string it replaces
-- the occurrence of 1st character of from string with 1st character of to string and so on
-- If the from string is bigger the to string, extra characters are removed.
-- we used this behaviour here to remove '-', '(', ')' and ' ' from the string

SELECT memid, TRANSLATE(telephone, '-() ', '') AS telephone
FROM members;

-- Answer 2
-- Using Regex, removes anything that's not a digit. This solution is more robust as cleans all the formatting
SELECT memid, REGEXP_REPLACE(telephone, '[^0-9]', '', 'g') AS telephone
FROM members
ORDER BY memid;