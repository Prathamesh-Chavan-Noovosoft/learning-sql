-- Q1 - Find out an actor full name along with the total number of films
-- actor have worked in order by fullName of actor
SELECT fa.actor_id, first_name || ' ' || last_name AS full_name, COUNT(film_id) AS no_of_films
FROM film_actor fa
             JOIN actor a ON fa.actor_id = a.actor_id
GROUP BY fa.actor_id, full_name
ORDER BY full_name;


-- Q2 - Fetch all movies with revenue more than average revenue
WITH movie_revenue AS (SELECT f.title, SUM(amount) AS total_movie_revenue
                       FROM film f
                                    JOIN inventory i ON f.film_id = i.film_id
                                    JOIN rental r ON i.inventory_id = r.inventory_id
                                    JOIN payment p ON r.rental_id = p.rental_id
                       GROUP BY f.film_id, f.title),
     average_revenue AS (SELECT AVG(total_movie_revenue) AS avg_revenue
                         FROM movie_revenue)
SELECT title, total_movie_revenue
FROM movie_revenue,
     average_revenue AS ar
WHERE total_movie_revenue > ar.avg_revenue
ORDER BY total_movie_revenue DESC;

-- Q3 - Extract for a particular movie how much percent of revenue it made district wise order by district name
WITH total_revenue AS (SELECT SUM(payment.amount) AS total_amount
                       FROM payment
                                    JOIN rental ON payment.rental_id = rental.rental_id
                                    JOIN inventory ON rental.inventory_id = inventory.inventory_id
                       WHERE inventory.film_id = :film_id),
     district_revenue AS (SELECT address.district, SUM(payment.amount) AS district_amount
                          FROM payment
                                       JOIN rental ON payment.rental_id = rental.rental_id
                                       JOIN inventory ON rental.inventory_id = inventory.inventory_id
                                       JOIN customer ON rental.customer_id = customer.customer_id
                                       JOIN address ON customer.address_id = address.address_id
                          WHERE inventory.film_id = :film_id
                          GROUP BY address.district)
SELECT district_revenue.district,
       (district_revenue.district_amount / total_revenue.total_amount) * 100 AS revenue_percentage
FROM district_revenue,
     total_revenue
ORDER BY district_revenue.district;


-- Q4 - Find out monthly revenue of a particular movie order by highest to lowest revenue
WITH movie_revenue AS (SELECT f.title, EXTRACT(MONTH FROM p.payment_date) AS MONTH, SUM(amount) AS total_movie_revenue
                       FROM film f
                                    JOIN inventory i ON f.film_id = i.film_id
                                    JOIN rental r ON i.inventory_id = r.inventory_id
                                    JOIN payment p ON r.rental_id = p.rental_id
                       GROUP BY MONTH, f.film_id)
SELECT title, total_movie_revenue
FROM movie_revenue
ORDER BY total_movie_revenue DESC;

-- Q5 - Create a list of each customer's full name, total payment customer has done and classify them as silver, gold, platinum according to their total payment
SELECT c.first_name || ' ' || c.last_name AS full_name,
       SUM(amount)                        AS total_amount,
       CASE
               WHEN SUM(p.amount) BETWEEN 0 AND 100
                       THEN 'SILVER'
               WHEN SUM(p.amount) BETWEEN 100 AND 200
                       THEN 'GOLD'
                       ELSE
                       'PLATINUM'
               END                        AS customer_category
FROM customer c
             JOIN PUBLIC.payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, full_name
ORDER BY SUM(amount) DESC;


-- Q6 - Return the last rented film of every customer
WITH latest_rental AS (SELECT c.customer_id, MAX(r.rental_date) AS last_rental_date
                       FROM customer c
                                    JOIN PUBLIC.rental r ON r.customer_id = c.customer_id
                                    JOIN PUBLIC.inventory i ON r.inventory_id = i.inventory_id
                                    JOIN PUBLIC.film f ON i.film_id = f.film_id
                       GROUP BY c.customer_id)
SELECT c.first_name || ' ' || c.last_name AS full_name,
       f.title                            AS film_title,
       r.rental_date                      AS rental_date
FROM customer c
             JOIN PUBLIC.rental r ON r.customer_id = c.customer_id
             JOIN PUBLIC.inventory i ON r.inventory_id = i.inventory_id
             JOIN PUBLIC.film f ON i.film_id = f.film_id
             JOIN latest_rental lr ON c.customer_id = lr.customer_id AND r.rental_date = lr.last_rental_date
ORDER BY c.customer_id, r.rental_date DESC;

-- Q7 - Find the last rented film of each customer by each category
WITH latest_rental AS (SELECT c.customer_id,
                              fc.category_id,
                              MAX(r.rental_date) AS last_rental_date
                       FROM customer c
                                    JOIN rental r ON r.customer_id = c.customer_id
                                    JOIN inventory i ON r.inventory_id = i.inventory_id
                                    JOIN film f ON i.film_id = f.film_id
                                    JOIN film_category fc ON f.film_id = fc.film_id
                       GROUP BY c.customer_id,
                                fc.category_id)
SELECT c.first_name || ' ' || c.last_name AS full_name,
       f.title                            AS film_title,
       cat.name                           AS category,
       r.rental_date                      AS rental_date
FROM customer c
             JOIN rental r ON r.customer_id = c.customer_id
             JOIN inventory i ON r.inventory_id = i.inventory_id
             JOIN film f ON i.film_id = f.film_id
             JOIN film_category fc ON f.film_id = fc.film_id
             JOIN category cat ON cat.category_id = fc.category_id
             JOIN latest_rental lr ON c.customer_id = lr.customer_id AND fc.category_id = lr.category_id AND
                                      r.rental_date = lr.last_rental_date
ORDER BY c.customer_id,
         cat.category_id,
         cat.name,
         r.rental_date DESC;

-- Q8 - Calculate the total payment amount for each customer considering their entire rental history
SELECT first_name || ' ' || c.last_name AS full_name, SUM(amount) AS total_amount
FROM customer c
             JOIN payment p ON c.customer_id = p.customer_id
GROUP BY full_name, c.customer_id
ORDER BY c.customer_id;

-- Q9 - Calculate the number of rentals per day, month & year
SELECT EXTRACT(YEAR FROM r.rental_date)  AS YEAR,
       EXTRACT(MONTH FROM r.rental_date) AS MONTH,
       EXTRACT(DAY FROM r.rental_date)   AS DAY,
       COUNT(r.rental_id)
FROM rental r
GROUP BY ROLLUP (YEAR, MONTH, DAY)
ORDER BY YEAR DESC, MONTH DESC, DAY DESC;

-- Q10 - Find the staff employee & their manager who handled most customers for each store
WITH num_customers_served AS (SELECT st.store_id                        AS store_id,
                                     s.staff_id                         AS staff_id,
                                     s.first_name || ' ' || s.last_name AS full_name,
                                     COUNT(c.customer_id)               AS customers_served
                              FROM store st
                                           JOIN public.staff s
                                                ON s.staff_id = st.manager_staff_id AND st.store_id = s.store_id
                                           JOIN public.payment p ON s.staff_id = p.staff_id
                                           JOIN public.customer c ON c.customer_id = p.customer_id
                              GROUP BY st.store_id,
                                       s.staff_id,
                                       s.first_name, s.last_name)
SELECT nc.store_id, nc.staff_id, nc.full_name, MAX(customers_served)
FROM num_customers_served AS nc
GROUP BY nc.store_id, nc.staff_id, nc.full_name;


-- Q11 - Find all actors who have appeared in more than 15 films, including the titles of these films.
SELECT a.actor_id, a.first_name, a.last_name, COUNT(f.film_id) AS film_count, ARRAY_AGG(f.title) AS film_titles
FROM actor a
             JOIN film_actor fa ON a.actor_id = fa.actor_id
             JOIN film f ON fa.film_id = f.film_id
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING COUNT(f.film_id) > 15
ORDER BY a.actor_id;


-- Q12 - Find all customers who have rented films but have not made any payments since a specific date, including their customer ID and name
SELECT c.customer_id, c.first_name || ' ' || c.last_name AS full_name, ARRAY_AGG(r.rental_id)
FROM customer c
             JOIN public.rental r ON c.customer_id = r.customer_id AND rental_date > :specific_date
WHERE NOT EXISTS(SELECT payment.payment_id
                 FROM payment
                 WHERE r.rental_id = payment.rental_id)
GROUP BY c.customer_id, full_name
ORDER BY c.customer_id;


-- Q13 - Retrieve all films that have not been rented out in past 15 days or more
SELECT DISTINCT f.title, r.rental_date
FROM film f
             JOIN PUBLIC.inventory i ON f.film_id = i.film_id
             JOIN PUBLIC.rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_date <
      NOW() - INTERVAL '15 days'
ORDER BY r.rental_date DESC;

--  Extra questions
-- My Questions
-- Q1 - Write an SQL Query to return the last rented film of every customer, that has rented a movie
-- - Solved Above Q7 in solving task

-- Q2 - Can you calculate the number of films rented by them in a certain category (given as input) for a Specific user (also
-- given as input).

SELECT c.customer_id, c.first_name || ' ' || c.last_name AS full_name, c2.name AS category, COUNT(f.title) AS n_films
FROM customer AS c
             JOIN public.rental r ON c.customer_id = r.customer_id
             JOIN public.inventory i ON r.inventory_id = i.inventory_id
             JOIN public.film f ON i.film_id = f.film_id
             JOIN public.film_category fc ON f.film_id = fc.film_id
             JOIN public.category c2 ON c2.category_id = fc.category_id
WHERE c2.name = :category_name
GROUP BY c.customer_id, c2.name
ORDER BY c.customer_id;

-- Q3 - Can you calculate the percentage of total revenue each film is generating for each month
-- 1. For All years
-- 2. For an User defined year.
WITH total_revenue AS (SELECT SUM(p.amount) AS total_amount, EXTRACT(YEAR FROM r.rental_date) AS year
                       FROM payment p
                                    JOIN rental r ON p.rental_id = r.rental_id
                                    JOIN inventory i ON r.inventory_id = i.inventory_id
                                    JOIN film f ON f.film_id = i.film_id
                       WHERE EXTRACT(YEAR FROM r.rental_date) = :year
                       GROUP BY year),
     film_revenue AS (SELECT SUM(p.amount) AS total_amount, f.title, EXTRACT(YEAR FROM r.rental_date) AS year
                      FROM payment p
                                   JOIN rental r ON p.rental_id = r.rental_id
                                   JOIN inventory i ON r.inventory_id = i.inventory_id
                                   JOIN film f ON f.film_id = i.film_id
                      WHERE EXTRACT(YEAR FROM r.rental_date) = :year
                      GROUP BY f.title, year)
SELECT fr.title, (fr.total_amount * 100 / tr.total_amount) AS percentage_revenue
FROM film_revenue AS fr,
     total_revenue AS tr;

-- Q4 For Each film, Find the No of customers who rented it from
-- 1. India
-- 2. Every Country
-- 3. Find the No of staff members in country for every film rented  ??

SELECT f.film_id, f.title, c3.country, COUNT(c.customer_id)
FROM film f
             JOIN public.inventory i ON f.film_id = i.film_id
             JOIN public.store s ON i.store_id = s.store_id
             JOIN public.customer c ON s.store_id = c.store_id
             JOIN public.address a ON s.address_id = a.address_id
             JOIN public.city c2 ON c2.city_id = a.city_id
             JOIN public.country c3 ON c3.country_id = c2.country_id
-- WHERE c3.country = :country
GROUP BY f.film_id, c3.country_id;

-- Q5 - Solved Q8 in solving task
-- Can you find a way to calculate the total payment amount for each customer considering their entire rental history?

-- Q6 - Solved Q5 in solving task
-- Can you categorize customers based on their total payment amount? categorize them as A, B and C depending on their total spending

-- Q7 - Solved similar, Q9 in solving task
-- Can you calculate the number of rentals per day?
SELECT DATE_TRUNC('day', r.rental_date) AS date,
       COUNT(r.rental_id)
FROM rental r
GROUP BY date
ORDER BY date DESC;

-- Q8 - ??
-- Q9 - ??

-- Q10 - Solved Q10 in solving task

-- Shreyas's Questions

-- Q1 - Write a SQL query to retrieve all films with a rental rate higher than $2, sorted by title.
SELECT f.title
FROM film f
WHERE f.rental_rate > 2;

-- Q2 - Create a SQL query that lists customers and the number of rentals they have made, ordered by the number of rentals in descending order.
SELECT c.first_name || ' ' || c.last_name AS full_name,
       COUNT(r.rental_id)                 AS n_rentals
FROM customer c
             JOIN PUBLIC.rental r ON r.customer_id = c.customer_id
             JOIN PUBLIC.inventory i ON r.inventory_id = i.inventory_id
             JOIN PUBLIC.film f ON i.film_id = f.film_id
GROUP BY c.customer_id
ORDER BY c.customer_id;

-- Q3 - Solved, Q11 in solving task
-- Write a SQL query to find all actors who have appeared in more than 15 films, including the titles of these films.

-- Q4 - Create a SQL query that retrieves the total payment amount received by each staff member, ordered by total payment amount in descending order.
SELECT s.staff_id, SUM(amount) AS total_amount
FROM staff s
             JOIN public.payment p ON s.staff_id = p.staff_id
GROUP BY s.staff_id
ORDER BY total_amount;

-- Q5 - Write a SQL query to list all cities and their respective countries where there are more than 10 customers residing.
SELECT c2.country, COUNT(customer_id), ARRAY_AGG(c.city)
FROM country c2
             JOIN public.city c ON c2.country_id = c.country_id
             JOIN public.address a ON c.city_id = a.city_id
             JOIN public.customer c3 ON a.address_id = c3.address_id
GROUP BY c2.country_id
HAVING COUNT(customer_id) >= 10;

-- Q6 - Write a SQL query to retrieve all films that are available in more than 5 stores, including the store IDs. - ??
SELECT f.title,
       ARRAY_AGG(i.inventory_id),
       COUNT(i.inventory_id) || ' inventories' AS available_in
FROM film f
             JOIN public.inventory i ON f.film_id = i.film_id
             JOIN public.store s ON i.store_id = s.store_id
GROUP BY f.film_id
HAVING COUNT(i.inventory_id) >= 5;

-- Q7 - Create a SQL query that lists all staff members and the total number of rentals processed by each,
-- ordered by the total number of rentals in descending order.

SELECT s.staff_id, s.first_name || ' ' || s.last_name AS full_name, SUM(r.rental_id) AS total_rentals
FROM staff s
             JOIN public.rental r ON s.staff_id = r.staff_id
GROUP BY s.staff_id
ORDER BY total_rentals DESC;

-- Q8 - Solved, Q12 in solving task
-- - Write a SQL query to find all customers who have rented films but have not made any payments, including their customer ID and name.

-- Q9 - Create a SQL query that retrieves all films that have not been rented out and are not present in any inventory.
SELECT f.title, f.film_id
FROM film f
WHERE NOT EXISTS(SELECT r.rental_id
                 FROM rental r
                              JOIN public.inventory i ON i.inventory_id = r.inventory_id
                 WHERE f.film_id = i.film_id);

-- Q10 - Write a SQL query to list all countries with more than three stores operating, including the country name and number of stores.
SELECT c.country, ARRAY_AGG(s.store_id)
FROM country c
             JOIN public.city c2 ON c.country_id = c2.country_id
             JOIN public.address a ON c2.city_id = a.city_id
             JOIN public.store s ON a.address_id = s.address_id
GROUP BY c.country_id
HAVING COUNT(s.store_id) >= 1;

-- Abhishek's Questions
-- Q1 - Write a query to find out an actor full name along with the total number of films actor have worked in order by fullName of actor
SELECT a.actor_id, a.first_name || ' ' || a.last_name AS full_name, COUNT(f.film_id)
FROM actor a
             JOIN public.film_actor fa ON a.actor_id = fa.actor_id
             JOIN public.film f ON f.film_id = fa.film_id
GROUP BY a.actor_id
ORDER BY actor_id;

-- Q2 - Write a query to fetch the full name of the actor 'Penelope Guiness' along with the title of
-- movies actor have worked in and category of each movie
SELECT a.actor_id, a.first_name || ' ' || a.last_name AS full_name, f.title, c.name
FROM actor a
             JOIN public.film_actor fa ON a.actor_id = fa.actor_id
             JOIN public.film f ON f.film_id = fa.film_id
             JOIN public.film_category fc ON f.film_id = fc.film_id
             JOIN public.category c ON c.category_id = fc.category_id
WHERE a.first_name = 'Penelope'
  AND a.last_name = 'Guiness'
ORDER BY actor_id

-- Q3 - Solved, Q2 in solving task
-- Write a query to fetch all movies with revenue more than average revenue

-- Q4 - Solved, Q3 in solving task
-- Write a query to extract the for a particular movie how much percent of revenue it made district wise order by district name

-- Q5 Solved, in solving task
-- Write a query to find out monthly revenue of a particular movie order by highest to lowest revenue

-- Q6 -

-- Q7 - Solved, in Shreyas's questions
-- Write a query to calculate total revenue generated by staff and order by staff

-- Q8 -

-- Q9 - Solved, in solving task
-- Write a query to calculate total revenue generated by staff and order by staff

-- Q10 -