USE Normalization1;
DROP TABLE IF EXISTS lastName;
CREATE TABLE lastName (
  lastName VARCHAR(25) NOT NULL,
  PRIMARY KEY  (lastName)
) AS
	SELECT DISTINCT lastName
	FROM my_contacts
	WHERE lastName IS NOT NULL
	ORDER BY lastName;
ALTER TABLE my_contacts
	ADD COLUMN lastName VARCHAR(25);

UPDATE my_contacts
	INNER JOIN lastName
	ON lastName.lastName = my_contacts.lastName
	SET my_contacts.lastName = lastName.lastName
	WHERE lastName.lastName IS NOT NULL;
SELECT mc.first_name, mc.last_name, mc.gender, mc.gender_ID, ln.lastName
	FROM lastName AS ln
		INNER JOIN my_contacts AS mc
	ON ln.lastName = mc.lastName;

# ALTER TABLE my_contacts
# 	DROP COLUMN lastName;
