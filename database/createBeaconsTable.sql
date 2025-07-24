USE fetindb;

CREATE TABLE beacons (
    id INT AUTO_INCREMENT PRIMARY KEY,
    utc INT NOT NULL,
    beacon VARCHAR(100) NOT NULL,
    tipo VARCHAR(100) NOT NULL,
	status VARCHAR(100) NOT NULL,
    linha VARCHAR(100),
    rssi1 FLOAT,
    rssi2 FLOAT,
    rssi3 FLOAT,
    x FLOAT NOT NULL,
    y FLOAT NOT NULL
);
