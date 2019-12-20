USE Normalization1;
DROP TABLE IF EXISTS email;

UPDATE my_contacts SET email = REPLACE(email, '\n', '');

UPDATE my_contacts SET email = REPLACE(email, ' ', '');

