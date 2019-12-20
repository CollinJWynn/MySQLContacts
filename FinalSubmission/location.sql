# modify my_contacts to normalize interests field
# ------------------------------------------------------------
use Normalization1;

UPDATE my_contacts

SET location = 'San Francisco, CA'
WHERE location = 'San Fran, CA';

ALTER TABLE my_contacts
    ADD COLUMN city VARCHAR(50),
    ADD COLUMN state VARCHAR(5),
    ADD COLUMN city_ID VARCHAR(50),
    ADD COLUMN state_ID VARCHAR(5);

UPDATE my_contacts
    SET city = SUBSTRING_INDEX(location, ',', 1);

UPDATE my_contacts
    SET state = TRIM(RIGHT(location, (LENGTH(location) - LENGTH(city) - 1)));

DROP TABLE IF EXISTS city;

CREATE TABLE city (
    city_ID INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    city VARCHAR(20)
) AS
	SELECT city FROM my_contacts
	GROUP BY city
	ORDER BY city;

DROP TABLE IF EXISTS state;

CREATE TABLE state
(
state_ID INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
state VARCHAR(2)
) AS
	SELECT state FROM my_contacts
	GROUP BY state
	ORDER BY state;

SELECT * from city;

SELECT * from state;

UPDATE my_contacts
			INNER JOIN
			city
		ON city.city = my_contacts.city
		SET my_contacts.city_ID = city.city_ID
		WHERE my_contacts.city IS NOT NULL;

UPDATE my_contacts
			INNER JOIN
			state
		ON state.state = my_contacts.state
		SET my_contacts.state_ID = state.state_ID
		WHERE my_contacts.state IS NOT NULL;

SELECT mc.first_name, mc.last_name, mc.location, c.city, s.state
FROM my_contacts AS mc
JOIN city AS c
	ON mc.city_ID = c.city_ID
JOIN state AS s
	ON mc.state_ID = s.state_ID;

# ALTER TABLE my_contacts
# DROP COLUMN location,
# DROP COLUMN city,
# DROP COLUMN state;
