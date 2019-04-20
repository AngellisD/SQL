use sakila;
-- * 1a. Display the first and last names of all actors from the table `actor`.--
SELECT first_name, last_name 
FROM ACTOR;
-- * 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`. --
SELECT UPPER(CONCAT(First_name, ' ', last_name)) AS "Actor Name" FROM ACTOR;
-- * 2a. You need to find the ID number, first name, and last name of an actor, --
--  of whom you know only the first name, "Joe."  What is one query would you use to obtain this information? --
SELECT actor_id, first_name, last_name FROM actor WHERE first_name = 'JOE';
-- * 2b. Find all actors whose last name contain the letters `GEN`---
SELECT * FROM actor WHERE last_name like '%GEN%';
-- * 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order --
SELECT last_name, count(last_name)
FROM actor GROUP BY last_name, first_name HAVING last_name LIKE '%LI%';
-- * 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China --
SELECT country_id, country FROM country WHERE country in ('Afghanistan', 'Bangladesh', 'China');
-- * 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, ---
-- so create a column in the table `actor` named `description` and use the data type `BLOB` ---
-- (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant). --
ALTER TABLE actor ADD COLUMN description BLOB;
-- * 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column --
ALTER TABLE actor DROP COLUMN description;
-- * 4a. List the last names of actors, as well as how many actors have that last name --
SELECT last_name FROM actor WHERE last_name IS NOT NULL;
-- * 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors --
SELECT last_name, COUNT(last_name) FROM actor group by last_name;
-- * 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record. --
UPDATE actor SET first_name = 'HARPO' WHERE first_name = 'GROUCHO' and last_name = ' WILLIAMS';
-- * 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, --
--  if the first name of the actor is currently `HARPO`, change it to `GROUCHO`. --
UPDATE actor SET first_name = 'GROUCHO' where first_name = 'HARPO'and last_name = 'WILLIAMS';
-- * 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it? ---
CREATE TABLE address (address_id int Not Null, address VARCHAR(50), address2 VARCHAR(50), district VARCHAR(20), city_id INT, postal_code VARCHAR(10), phone VARCHAR(20), last_update varchar(30));
-- * 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`: --
SELECT s.first_name, s.last_name, a.address FROM staff AS s JOIN address AS a on s.address_id=a.address_id;
-- * 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`. --
SELECT s.first_name, s.last_name, p.amount FROM staff AS s JOIN amount AS p ON s.staff_id=p.staff_id;
-- * 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join. --
SELECT f.title AS film, count(fa.actor_id) AS 'Actors listed for film' FROM film AS f JOIN film_actor AS fa ON f.film_id=fa.film_id GROUP BY f.title;
-- * 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system? --
SELECT f.title AS film, count(i.film_id) AS 'Copies in the inventory' from inventory AS i JOIN film AS f ON i.film_id WHERE f.title='Hunchback Impossible';
-- * 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name: --
SELECT c.first_name, c.last_name, sum(p.amount) as 'Total Paid' FROM customer AS c JOIN payment AS p ON c.customer_id=p.customer_id group by c.first_name, c.last_name order by c.last_name; 
-- * 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` --
--  have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English. --
SELECT * FROM film WHERE title LIKE '%K%' or title LIKE '%Q%' AND language_id=1;
-- * 7b. Use subqueries to display all actors who appear in the film `Alone Trip`. --
SELECT a.first_name, a.last_name, f.title FROM film AS f JOIN film_actor AS fa ON f.film_id=fa.film_id JOIN actor AS a ON fa.actor_id=a.actor_id WHERE f.title='Alone Trip' ;
-- * 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information. --
SELECT c.first_name, c.last_name, c.email FROM customer as c join address as a on c.address_id join city as ci on ci.city_id=a.address_id join country as co on co.country_id=ci.country_id where co.country='Canada';
-- * 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films. --
SELECT name as category, f.title from film as f join film_category as fc on f.film_id=fc.film_id join category as c on c.category_id=fc.category_id where c.name='Family'; 
-- * 7e. Display the most frequently rented movies in descending order. --
SELECT rental_duration, title from film order by rental_duration desc;
-- * 7f. Write a query to display how much business, in dollars, each store brought in. --
SELECT s.store_id, sum(p.amount) as 'Total $'  from payment p join staff s on (p.staff_id=s.staff_id) group by store_id;
-- * 7g. Write a query to display for each store its store ID, city, and country. --
SELECT s.store_id, c.city, co.country from store as s join address as a on s.address_id=a.address_id join city as c on a.city_id join country as co on co.country_id=c.country_id;
-- * 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)--
SELECT c.name as category, format(sum(amount),0) from payment as p join rental as r on p.rental_id=r.rental_id
join inventory as i on r.inventory_id=i.inventory_id join film_category as fc on fc.film_id=i.film_id 
join category as c on fc.category_id=c.category_id group by category order by sum(amount) desc limit 5;
-- * 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.--
SELECT c.name as category, format(sum(amount),0) as 'Total Gross Revenue'  from payment as p join rental as r on p.rental_id=r.rental_id
join inventory as i on r.inventory_id=i.inventory_id join film_category as fc on fc.film_id=i.film_id 
join category as c on fc.category_id=c.category_id group by category order by sum(amount) desc limit 5;
-- * 8b. How would you display the view that you created in 8a? --
SELECT * from top_five_genres 
-- * 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it. --
DROP VIEW top_five_genres

-- ## Appendix: List of Tables in the Sakila DB

-- * A schema is also available as `sakila_schema.svg`. Open it with a browser to view.

-- ```sql
-- 'actor'
-- 'actor_info'
-- 'address'
-- 'category'
-- 'city'
-- 'country'
-- 'customer'
-- 'customer_list'
-- 'film'
-- 'film_actor'
-- 'film_category'
-- 'film_list'
-- 'film_text'
-- 'inventory'
-- 'language'
-- 'nicer_but_slower_film_list'
-- 'payment'
-- 'rental'
-- 'sales_by_film_category'
-- 'sales_by_store'
-- 'staff'
-- 'staff_list'
-- 'store'
-- ```














