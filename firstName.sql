USE Normalization1;
DROP TABLE IF EXISTS firstName;
CREATE TABLE firstName (
  firstName VARCHAR(25) NOT NULL,
  PRIMARY KEY  (firstName)
) AS
	SELECT DISTINCT firstName
	FROM my_contacts
	WHERE firstName IS NOT NULL
	ORDER BY firstName;
ALTER TABLE my_contacts
	ADD COLUMN firstName VARCHAR(25);

UPDATE my_contacts
	INNER JOIN firstName
	ON firstName.firstName = my_contacts.firstName
	SET my_contacts.firstName = firstName.firstName
	WHERE firstName.firstName IS NOT NULL;
SELECT mc.first_name, mc.last_name, mc.gender, mc.gender_ID, fn.firstName
	FROM firstName AS fn
		INNER JOIN my_contacts AS mc
	ON fn.firstName = mc.firstName;

# ALTER TABLE my_contacts
# 	DROP COLUMN firstName;
