use Normalization1;


ALTER TABLE my_contacts
ADD COLUMN temporaryInterests VARCHAR(250),
ADD COLUMN firstInterest VARCHAR(75),
ADD COLUMN secondInterest VARCHAR(75),
ADD COLUMN thirdInterest VARCHAR(75),
ADD COLUMN fourthInterest VARCHAR(75);


UPDATE my_contacts
SET temporaryInterests = interests;


UPDATE my_contacts
SET firstInterest = SUBSTRING_INDEX(temporaryInterests, ',', 1);


UPDATE my_contacts SET temporaryInterests = TRIM(RIGHT(temporaryInterests,
(LENGTH(temporaryInterests) - LENGTH(firstInterest) - 1)));


UPDATE my_contacts
SET secondInterest = SUBSTRING_INDEX(temporaryInterests, ',', 1);


UPDATE my_contacts SET temporaryInterests = TRIM(RIGHT(temporaryInterests,
(LENGTH(temporaryInterests) - LENGTH(secondInterest) - 1)));


UPDATE my_contacts
SET thirdInterest = SUBSTRING_INDEX(temporaryInterests, ',', 1);
UPDATE my_contacts SET temporaryInterests = TRIM(RIGHT(temporaryInterests,
(LENGTH(temporaryInterests) - LENGTH(thirdInterest) - 1)));


UPDATE my_contacts SET fourthInterest = temporaryInterests;


DROP TABLE IF EXISTS interestsHolder;


CREATE TABLE interestsHolder
AS
	SELECT firstInterest AS interest FROM my_contacts
	GROUP BY interest
	ORDER BY interest;


SELECT * from interestsHolder;


INSERT INTO interestsHolder (interest)
	SELECT secondInterest FROM my_contacts
	GROUP BY secondInterest;


INSERT INTO interestsHolder (interest)
	SELECT thirdInterest FROM my_contacts
	GROUP BY thirdInterest;


INSERT INTO interestsHolder (interest)
	SELECT fourthInterest FROM my_contacts
	GROUP BY fourthInterest;


DELETE FROM interestsHolder
    WHERE TRIM(interest) = '';


DELETE FROM interestsHolder
    WHERE interest IS NULL;


SELECT * from interestsHolder;


DROP TABLE IF EXISTS interests;


CREATE TABLE interests
(
interest_ID INT(15) NOT NULL AUTO_INCREMENT PRIMARY KEY,
interest VARCHAR(25),
contact_ID INT(15)
) AS
    SELECT contact_ID from my_contacts
	SELECT interest FROM interestsHolder
	GROUP BY interest
	ORDER BY interest;


SELECT * from interests;


DROP TABLE IF EXISTS contacts_interests;


CREATE TABLE contacts_interests (
    interest_ID INT(15) NOT NULL,
    CONSTRAINT interests_contact_interest_fk
    FOREIGN KEY (interest_ID)
    REFERENCES interests (interest_ID),
    contact_ID INT(15) NOT NULL,
    CONSTRAINT my_contacts_contact_interest_fk
    FOREIGN KEY (contact_ID)
    REFERENCES my_contacts (contact_ID)
);

INSERT INTO contacts_interests (contact_ID, interest_ID)
    SELECT mc.contact_ID, intr.interest_ID FROM my_contacts AS mc
    JOIN interests AS intr
    ON mc.firstInterest = intr.interest
    WHERE firstInterest != ""
    AND firstInterest IS NOT NULL;



INSERT INTO contacts_interests (contact_ID, interest_ID)
    SELECT mc.contact_ID, intr.interest_ID FROM my_contacts AS mc
    JOIN interests AS intr
    ON mc.secondInterest = intr.interest
    WHERE secondInterest != ""
    AND secondInterest IS NOT NULL;



INSERT INTO contacts_interests (contact_ID, interest_ID)
    SELECT mc.contact_ID, intr.interest_ID FROM my_contacts AS mc
    JOIN interests AS intr
    ON mc.thirdInterest = intr.interest
    WHERE thirdInterest != ""
    AND thirdInterest IS NOT NULL;



INSERT INTO contacts_interests (contact_ID, interest_ID)
    SELECT mc.contact_ID, intr.interest_ID FROM my_contacts AS mc
    JOIN interests AS intr
    ON mc.fourthInterest = intr.interest
    WHERE fourthInterest != ""
    AND fourthInterest IS NOT NULL;


SELECT * FROM interests;


SELECT contact_ID, firstInterest, secondInterest, thirdInterest
    FROM my_contacts;


SELECT mc.first_name, mc.last_name, mc.contact_ID, it.interest
    FROM my_contacts AS mc
    INNER JOIN
    interests AS it
    ON contact_ID = interest_ID;

SELECT co.contact_ID, co.interest_ID, mc.first_name, mc.last_name, intrest.interest
    FROM contacts_interests AS co
    JOIN my_contacts AS mc
    ON co.contact_ID = mc.contact_ID
    JOIN interests AS intrest
    ON co.interest_ID = intrest.interest_ID+
    ORDER BY mc.last_name;

ALTER TABLE my_contacts
    DROP COLUMN interests,
    DROP COLUMN temporaryInterests,
    DROP COLUMN firstInterest,
    DROP COLUMN secondInterest,
    DROP COLUMN thirdInterest,
    DROP COLUMN fourthInterest;

DROP TABLE IF EXISTS interestsHolder;