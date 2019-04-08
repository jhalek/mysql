use sakila;
-- Display the first and last names of all actors from the table actor.
# select first_name, last_name from actor;

-- Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
# select upper(concat(first_name,' ',last_name)) as 'Actor Name' from actor;

-- You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
# select actor_id, first_name, last_name from actor where first_name = 'Joe'

-- Find all actors whose last name contain the letters GEN:
# select first_name, last_name from actor where last_name like '%GEN%'

-- Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
# select first_name, last_name from actor where last_name like '%LI%' order by last_name, first_name asc

-- Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
# select country_id, country from country where country in ('Afghanistan','Bangladesh','China')

-- You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
# ALTER TABLE actor add COLUMN description blob AFTER last_name

-- Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
# ALTER TABLE actor DROP COLUMN description;

-- List the last names of actors, as well as how many actors have that last name.
# select last_name, count(last_name) as 'Count' from actor group by last_name asc

-- List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
# select last_name, count(last_name) as cnt from actor group by last_name having cnt > 1 order by cnt desc

-- The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
# UPDATE actor SET first_name = 'HARPO', last_name = 'WILLIAMS' WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

-- Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
# SET SQL_SAFE_UPDATES = 0; UPDATE actor SET first_name = 'GROUCHO' WHERE first_name = 'HARPO';

-- You cannot locate the schema of the address table. Which query would you use to re-create it? Hint: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html
			/* CREATE TABLE IF NOT EXISTS address (
			address_id smallint(5) UNSIGNED PRIMARY KEY AUTO_INCREMENT,
			address varchar(50),
			address2 varchar(50), 
			district varchar(20),
			city_id smallint(5) Unsigned, 
			postal_code varchar(10), 
			phone varchar(20), 
			location geometry,
			last_update timestamp
			 ); */
-- Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
	/*select s.first_name, s.last_name, a.address, a.address2, a.district, a.postal_code from staff s
	inner join address a ON s.address_id = a.address_id*/

-- Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
	/*select s.first_name, s.last_name, sum(p.amount) as total FROM sakila.payment p
	join staff s on p.staff_id = s.staff_id
	where payment_date >= '2005-08-01' and payment_date <= '2005-08-31' 
	group by s.first_name*/
    
-- List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
	/*select distinct f.title, count(fa.film_id) as actor_cnt from film_actor fa 
	inner join film f ON fa.film_id = f.film_id
	group by f.title*/
    
-- How many copies of the film Hunchback Impossible exist in the inventory system?
	/*SELECT count(i.film_id) FROM sakila.inventory i 
	join film f on i.film_id = f.film_id
	where f.title = 'Hunchback Impossible'*/
    
-- Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
	/*select c.first_name, c.last_name, sum(p.amount) as total_pmts from payment p
	join customer c on p.customer_id = c.customer_id
	group by c.last_name order by c.last_name asc */
    
-- The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
	/*select title from film f
	join language l on f.language_id = l.language_id
	where (title like 'K%' or title like 'Q%') and l.name = 'English'*/

-- Use subqueries to display all actors who appear in the film Alone Trip.
	/*select a.first_name, a.last_name from film_actor fa
	join actor a on fa.actor_id = a.actor_id
	join film f on fa.film_id = f.film_id
	where f.title = 'Alone Trip'*/

-- You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
	/*select c.first_name, c.last_name, c.email from customer c
	join address a on a.address_id = c.address_id
	join city on a.city_id = city.city_id
	join country on city.country_id = country.country_id
	where country.country = 'Canada'*/

-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
	/*select f.title from film f
	join film_category fc on f.film_id = fc.film_id
	join category c on fc.category_id = c.category_id
	where c.name = 'Family'*/
    
-- Display the most frequently rented movies in descending order.
	/*select f.title, count(r.rental_id) as rental_count from rental r
	join inventory i on r.inventory_id = i.inventory_id
	join film f on i.film_id = f.film_id
	group by f.title order by rental_count desc*/
    
-- Write a query to display how much business, in dollars, each store brought in.
	/*select s.store_id as Store, sum(p.amount) as Total_Dollars from payment p
	join staff s on p.staff_id = s.staff_id
	group by s.store_id*/
    
-- Write a query to display for each store its store ID, city, and country.
	/*select distinct s.store_id, c.city, co.country from store s
	join address a on a.address_id = s.address_id
	join city c on a.city_id = c.city_id
	join country co on c.country_id = co.country_id*/

-- List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
	/*select c.name, sum(p.amount) as total_rental_amount from payment p
	join rental r on p.rental_id = r.rental_id
	join inventory i on r.inventory_id = i.inventory_id
	join film_category f on i.film_id = f.film_id
	join category c on f.category_id = c.category_id
	group by c.name asc order by total_rental_amount desc LIMIT 5*/
    
-- In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
	/*CREATE 
		ALGORITHM = UNDEFINED 
		DEFINER = `root`@`localhost` 
		SQL SECURITY DEFINER
	VIEW `sakila`.`top_five_genres` AS
		SELECT 
			`c`.`name` AS `name`,
			SUM(`p`.`amount`) AS `total_rental_amount`
		FROM
			((((`sakila`.`payment` `p`
			JOIN `sakila`.`rental` `r` ON ((`p`.`rental_id` = `r`.`rental_id`)))
			JOIN `sakila`.`inventory` `i` ON ((`r`.`inventory_id` = `i`.`inventory_id`)))
			JOIN `sakila`.`film_category` `f` ON ((`i`.`film_id` = `f`.`film_id`)))
			JOIN `sakila`.`category` `c` ON ((`f`.`category_id` = `c`.`category_id`)))
		GROUP BY `c`.`name`
			ORDER BY `total_rental_amount` DESC
		LIMIT 5*/
        
-- How would you display the view that you created in 8a?
	-- SELECT * FROM sakila.top_five_genres;

-- You find that you no longer need the view top_five_genres. Write a query to delete it.
	-- DROP VIEW sakila.top_five_genres