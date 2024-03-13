SELECT
  customer_id,
  first_name,
  last_name,
  amount,
  payment_date
FROM
  customer
  INNER JOIN payment USING(customer_id)
ORDER BY
  payment_date;
