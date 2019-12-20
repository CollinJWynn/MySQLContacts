USE Normalization1;

DROP TABLE IF EXISTS interestsholder;
DROP TABLE IF EXISTS temporary_seeking;

ALTER TABLE my_contacts
    DROP COLUMN seeking,
    DROP COLUMN temporarySeeking,
    DROP COLUMN firstSeeking,
    DROP COLUMN secondSeeking,
    DROP COLUMN interests,
    DROP COLUMN temporaryInterests,
    DROP COLUMN firstInterest,
    DROP COLUMN secondInterest,
    DROP COLUMN thirdInterest,
    DROP COLUMN fourthInterest,
    DROP COLUMN city,
    DROP COLUMN state,
    DROP COLUMN profession,
    DROP COLUMN location,
    DROP COLUMN status;

