use Normalization1;

ALTER TABLE my_contacts
    ADD COLUMN temporarySeeking VARCHAR(100),
    ADD COLUMN firstSeeking VARCHAR(100),
    ADD COLUMN secondSeeking VARCHAR(100);

UPDATE my_contacts
SET temporarySeeking = seeking;


UPDATE my_contacts
    SET firstSeeking = SUBSTRING_INDEX(temporarySeeking, ',', 1);

UPDATE my_contacts SET temporarySeeking = TRIM(RIGHT(temporarySeeking,
    (LENGTH(temporarySeeking) - LENGTH(firstSeeking) - 1)));

UPDATE my_contacts SET secondSeeking = temporarySeeking;

DROP TABLE IF EXISTS temporary_seeking;

CREATE TABLE temporary_seeking
AS
	SELECT firstSeeking AS seeking FROM my_contacts
	GROUP BY firstSeeking
	ORDER BY firstSeeking;

SELECT * from temporary_seeking;

INSERT INTO temporary_seeking (seeking)
	SELECT secondSeeking FROM my_contacts
	GROUP BY secondSeeking;

DELETE FROM temporary_seeking
WHERE
seeking = ' ';

DELETE FROM temporary_seeking
WHERE
seeking IS NULL;

SELECT * from temporary_seeking;

DROP TABLE IF EXISTS seeking;

CREATE TABLE seeking
(
seeking_ID INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
seeking VARCHAR(100),
contact_ID INT(15)
) AS
    SELECT contact_ID from my_contacts
	SELECT seeking FROM temporary_seeking
	GROUP BY seeking
	ORDER BY seeking;


SELECT * from seeking;

DROP TABLE IF EXISTS contacts_seeking;

CREATE TABLE contacts_seeking
(
    seeking_ID INT(11) NOT NULL,
    CONSTRAINT seeking_seeking_my_contact_fk
    FOREIGN KEY (seeking_ID)
    REFERENCES seeking (seeking_ID),

    contact_ID INT(11) NOT NULL,
    CONSTRAINT my_contacts_seeking_fk
    FOREIGN KEY (contact_ID)
    REFERENCES my_contacts (contact_ID)
);

INSERT INTO contacts_seeking (contact_ID, seeking_ID)
    SELECT mc.contact_ID, se.seeking_ID FROM my_contacts AS mc
    JOIN seeking AS se
    ON mc.firstSeeking = se.seeking
    WHERE TRIM(firstSeeking) != ""
    AND firstSeeking IS NOT NULL;


INSERT INTO contacts_seeking (contact_ID, seeking_ID)
    SELECT mc.contact_ID, se.seeking_ID FROM my_contacts AS mc
    JOIN seeking AS se
    ON mc.secondSeeking = se.seeking
    WHERE TRIM(secondSeeking) != ""
    AND secondSeeking IS NOT NULL;


SELECT * FROM seeking;

SELECT contact_ID, firstSeeking, secondSeeking
    FROM my_contacts;

SELECT mc.first_name, mc.last_name, mc.contact_ID, s.seeking
    FROM my_contacts AS mc
    INNER JOIN
    seeking AS s
    ON contact_ID = seeking_ID;

ALTER TABLE my_contacts
     DROP COLUMN seeking,
     DROP COLUMN temporarySeeking,
     DROP COLUMN firstSeeking,
     DROP COLUMN secondSeeking;

DROP TABLE IF EXISTS temporary_seeking;


SELECT cs.contact_ID, cs.seeking_ID, mc.first_name, mc.last_name, se.seeking
    FROM contacts_seeking AS cs
    JOIN my_contacts AS mc
    ON cs.contact_ID = mc.contact_ID
    JOIN seeking AS se
    ON cs.seeking_ID = se.seeking_ID
    ORDER BY mc.last_name;

ALTER TABLE my_contacts
    DROP COLUMN temporarySeeking;

ALTER TABLE my_contacts
    DROP COLUMN seeking;

DROP TABLE IF EXISTS temporary_seeking;


