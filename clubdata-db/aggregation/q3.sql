-- Count the number of recommendations each member makes.
SELECT recommendedby, COUNT(*)
FROM members
WHERE recommendedby IS NOT NULL
GROUP BY recommendedby
ORDER BY recommendedby;
