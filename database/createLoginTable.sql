USE fetindb;

CREATE TABLE login (
    username VARCHAR(100) NOT NULL,
    password VARCHAR(100) NOT NULL,
	email VARCHAR(100) UNIQUE NOT NULL,
    admin BOOL NOT NULL
);
