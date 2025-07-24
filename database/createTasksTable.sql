USE fetindb;

CREATE TABLE tasks (
	id INT AUTO_INCREMENT PRIMARY KEY,
    user VARCHAR(100) NOT NULL,
    mensagem VARCHAR(500) NOT NULL,
    linha INT NOT NULL,
    beacons JSON,
    dependencias JSON,
    tipo VARCHAR(100) NOT NULL,
	status VARCHAR(100) NOT NULL
);
