-- DROP LEAVES FIRST THEN BRANCHES

DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS films;
DROP TABLE IF EXISTS tickets;

CREATE TABLE customers (
  id SERIAL4 PRIMARY KEY,
  name varchar(255) NOT NULL,
  funds real NOT NULL
);

CREATE TABLE films (
  id SERIAL4 PRIMARY KEY,
  title varchar(255) NOT NULL,
  price real NOT NULL
);

-- tickets join customers many-many with films
CREATE TABLE tickets (
    id SERIAL4 PRIMARY KEY,
    customer_id INT4 REFERENCES customers(id),
    films_id INT4 REFERENCES films(id)
);
