USE fetindb;

CREATE TABLE info (
	id INT AUTO_INCREMENT PRIMARY KEY,
    linha INT NOT NULL,
    maquina INT NOT NULL,
    numeroProdutos INT NOT NULL,
    horasTrabalhadas INT NOT NULL,
    rendimento FLOAT NOT NULL,
    falhas INT NOT NULL
);
