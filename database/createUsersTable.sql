USE fetindb;

CREATE TABLE users (
    username VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
	email VARCHAR(100) UNIQUE NOT NULL,
    role VARCHAR(100) NOT NULL
);
