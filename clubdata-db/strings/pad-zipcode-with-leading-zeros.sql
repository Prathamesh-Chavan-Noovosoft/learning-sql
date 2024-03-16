-- Pad zip codes with leading zeroes
-- Question
-- The zip codes in our example dataset have had leading zeroes removed from them
-- by virtue of being stored as a numeric type. Retrieve all zip codes from the members table,
-- padding any zip codes less than 5 characters long with leading zeroes. Order by the new zip code.

-- Answer 1

SELECT LPAD(CAST(zipcode AS VARCHAR), 5, '0') AS zip
FROM members
