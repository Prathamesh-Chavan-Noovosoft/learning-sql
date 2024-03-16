-- Count the number of members whose surname starts with each letter of the alphabet
SELECT SUBSTR(surname, 1, 1) AS letter, COUNT(SUBSTR(surname, 1, 1))
FROM members
GROUP BY SUBSTR(surname, 1, 1)
ORDER BY letter