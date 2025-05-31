import mysql.connector

DB_CONFIG = {
    "host": "127.0.0.1",
    "user": "root",
    "password": "kaua6170",
    "database": "fetindb"
}

def connectToDatabase():
    try:
        return mysql.connector.connect(**DB_CONFIG)
    except mysql.connector.Error as e:
        print(f"Database connection error: {e}")
        return None

def getUsersData():
    connection = connectToDatabase()
    if connection is None:
        return
    cursor = connection.cursor(dictionary=True)

    query = "SELECT * FROM login"
    cursor.execute(query)

    users = cursor.fetchall()
    usersData = {user["username"]: user for user in users}

    cursor.close()
    connection.close()

    return usersData

def createUser(username, password, email, admin):
    connection = connectToDatabase()
    if connection is None:
        return
    cursor = connection.cursor()

    query = "INSERT INTO login (username, password, email, admin) VALUES (%s, %s, %s, %s)"
    values = (username, password, email, admin)
    cursor.execute(query, values)

    connection.commit()
    cursor.close()
    connection.close()

def getBeaconsData():
    connection = connectToDatabase()
    if connection is None:
        return []
    cursor = connection.cursor(dictionary=True)

    query = "SELECT * FROM beacons"
    cursor.execute(query)

    beacons = cursor.fetchall()
    beaconsData = {id["id"]: id for id in beacons}

    cursor.close()
    connection.close()

    return beaconsData

def createBeacon(beacon, tipo, status, x, y):
    connection = connectToDatabase()
    if connection is None:
        return
    cursor = connection.cursor()

    query = "INSERT INTO beacons (beacon, tipo, status, x, y) VALUES (%s, %s, %s, %s, %s)"
    values = (beacon, tipo, status, x, y)
    cursor.execute(query, values)

    connection.commit()
    cursor.close()
    connection.close()

def getInfoData():
    connection = connectToDatabase()
    if connection is None:
        return
    cursor = connection.cursor(dictionary=True)

    query = "SELECT * FROM info"
    cursor.execute(query)

    infos = cursor.fetchall()
    infoData = {info["id"]: info for info in infos}

    cursor.close()
    connection.close()

    return infoData

def createInfo(linha, maquina, numeroProdutos, horasTrabalhadas, rendimento, falhas):
    connection = connectToDatabase()
    if connection is None:
        return
    cursor = connection.cursor()

    query = "INSERT INTO info (linha, maquina, numeroProdutos, horasTrabalhadas, rendimento, falhas) VALUES (%s, %s, %s, %s, %s, %s)"
    values = (linha, maquina, numeroProdutos, horasTrabalhadas, rendimento, falhas)
    cursor.execute(query, values)

    connection.commit()
    cursor.close()
    connection.close()

def updateInfo(linha, maquina, numeroProdutos, horasTrabalhadas, rendimento, falhas):
    connection = connectToDatabase()
    if connection is None:
        return
    cursor = connection.cursor()
    
    try:
        query = """
        UPDATE info 
        SET numeroProdutos = %s, horasTrabalhadas = %s, rendimento = %s, falhas = %s 
        WHERE linha = %s AND maquina = %s
        """
        values = (numeroProdutos, horasTrabalhadas, rendimento, falhas, linha, maquina)
        cursor.execute(query, values)
    except mysql.connector.Error as e:
        print(f"Error updating info: {e}")
        connection.rollback()
        cursor.close()
        connection.close()
        return
    finally:
        connection.commit()
        cursor.close()
        connection.close()

def getRSSI(beacon, gateway):
    connection = connectToDatabase()
    if connection is None:
        return
    cursor = connection.cursor(dictionary=True)

    column = f"rssi{gateway}"
    query = f"SELECT {column} FROM gateways WHERE beacon = %s"
    values = (beacon)
    cursor.execute(query, values)

    result = cursor.fetchone()
    cursor.close()
    connection.close()

    if result:
        return result[f"rssi{gateway}"]
    else:
        return

def updateRSSI(beacon, rssi, gateway):
    connection = connectToDatabase()
    if connection is None:
        return
    cursor = connection.cursor()

    try:
        query = "UPDATE beacons SET rssi%s = %s WHERE beacon = %s"
        values = (gateway, rssi, beacon)
        cursor.execute(query, values)
    except mysql.connector.Error as e:
        print(f"Error updating info: {e}")
        connection.rollback()
        cursor.close()
        connection.close()
        return
    finally:
        connection.commit()
        cursor.close()
        connection.close()

print(getUsersData())
print(getBeaconsData())
print(getInfoData())
print(getRSSI("lote1", 1))

'''
createUser("admin", "admin123", "admin@gmail.com", True)
createUser("user1", "user123", "user1@gmail.com", False)
createUser("user2", "user123", "user2@gmail.com", False)
createBeacon("lote1", "loteMacas", "100", 10.0, 20.0)
createBeacon("lote2", "loteCaixas", "20", 0.0, 50.55)
createBeacon("Chave de fenda", "ferramenta", "OK", 0.0, 0.0)
createBeacon("Pinguim", "Funcionário", "Cagado", 100.0, 20.0)
createInfo(1, 1, 100, 8, 95.5, 2)
createInfo(1, 2, 150, 7, 90.0, 1)
createInfo(2, 1, 200, 6, 85.0, 3)
'''