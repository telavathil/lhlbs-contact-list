drop table contacts;

CREATE TABLE contacts (
id    serial NOT NULL PRIMARY KEY,
first_name   varchar(40) NOT NULL,
last_name   varchar(40) NOT NULL,
phone1    varchar(40) NOT NULL,
phone2    varchar(40) NOT NULL,
email varchar(40) NOT NULL

);

COPY contacts (first_name, last_name, phone1, phone2, email)
FROM '/home/tobin/Projects/lighthouse/contact-list/contacts.csv'
WITH (
  FORMAT CSV,
  HEADER true
);
