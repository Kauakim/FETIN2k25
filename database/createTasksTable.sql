USE fetindb;

CREATE TABLE tasks (
	id INT AUTO_INCREMENT PRIMARY KEY,
    user VARCHAR(100),
    mensagem VARCHAR(500) NOT NULL,
    cancelamento VARCHAR(250),
    destino VARCHAR(100) NOT NULL,
    tipoDestino VARCHAR(100) NOT NULL,
    beacons JSON,
    dependencias JSON,
    tipo VARCHAR(100) NOT NULL,
	status VARCHAR(100) NOT NULL
);
