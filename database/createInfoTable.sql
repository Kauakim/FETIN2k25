USE fetindb;

CREATE TABLE info (
	id INT AUTO_INCREMENT PRIMARY KEY,
    maquina VARCHAR(250) NOT NULL,
    tasksConcluidas INT NOT NULL,
    tasksCanceladas INT NOT NULL,
    horasTrabalhadas FLOAT NOT NULL,
    data date NOT NULL
);
