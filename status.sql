USE Normalization1;

DROP TABLE IF EXISTS status;
CREATE TABLE status (
    statusID INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    status varchar(20)
) AS
	SELECT DISTINCT status
	FROM my_contacts
	WHERE status IS NOT NULL
	ORDER BY status;

alter table my_contacts
    drop column statusID;

ALTER TABLE my_contacts
	ADD COLUMN statusID VARCHAR(25);

UPDATE my_contacts
	INNER JOIN status
	ON status.status = my_contacts.status
	SET my_contacts.statusID = status.statusID
	WHERE status.status IS NOT NULL;

SELECT mc.first_name, mc.last_name, mc.status, mc.statusID, st.status
	FROM status AS st
		INNER JOIN my_contacts AS mc
	ON st.status = mc.status;

# ALTER TABLE my_contacts
# 	DROP COLUMN status;
