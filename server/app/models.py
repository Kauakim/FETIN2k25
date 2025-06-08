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
        return {}
    cursor = connection.cursor(dictionary=True)
    try:
        query = "SELECT * FROM login"
        cursor.execute(query)
        users = cursor.fetchall()
        return {user["username"]: user for user in users}
    except mysql.connector.Error as e:
        print(f"Error fetching users data: {e}")
        return {}
    finally:
        cursor.close()
        connection.close()

def createUser(username, password, email, admin):
    connection = connectToDatabase()
    if connection is None:
        return
    cursor = connection.cursor()
    try:
        query = "INSERT INTO login (username, password, email, admin) VALUES (%s, %s, %s, %s)"
        values = (username, password, email, admin)
        cursor.execute(query, values)
        connection.commit()
    except mysql.connector.Error as e:
        print(f"Error creating user: {e}")
        connection.rollback()
    finally:
        cursor.close()
        connection.close()

def updateUser(oldUsername, newUsername, password, email, admin):
    connection = connectToDatabase()
    if connection is None:
        return
    cursor = connection.cursor()
    try:
        query = """
        UPDATE login 
        SET username= %s, password = %s, email = %s, admin = %s
        WHERE username = %s
        """
        values = (newUsername, password, email, admin, oldUsername)
        cursor.execute(query, values)
        connection.commit()
    except mysql.connector.Error as e:
        print(f"Error updating user: {e}")
        connection.rollback()
    finally:
        cursor.close()
        connection.close()

def getBeaconsData():
    connection = connectToDatabase()
    if connection is None:
        return {}
    cursor = connection.cursor(dictionary=True)
    try:
        query = "SELECT * FROM beacons"
        cursor.execute(query)
        beacons = cursor.fetchall()
        return {beacon["id"]: beacon for beacon in beacons}
    except mysql.connector.Error as e:
        print(f"Error fetching beacons data: {e}")
        return {}
    finally:
        cursor.close()
        connection.close()

def createBeacon(beacon, tipo, status, x, y):
    connection = connectToDatabase()
    if connection is None:
        return
    cursor = connection.cursor()
    try:
        query = "INSERT INTO beacons (beacon, tipo, status, x, y) VALUES (%s, %s, %s, %s, %s)"
        values = (beacon, tipo, status, x, y)
        cursor.execute(query, values)
        connection.commit()
    except mysql.connector.Error as e:
        print(f"Error creating beacon: {e}")
        connection.rollback()
    finally:
        cursor.close()
        connection.close()

def updateBeacon(beacon, tipo, status, x, y):
    connection = connectToDatabase()
    if connection is None:
        return
    cursor = connection.cursor()
    try:
        query = """
        UPDATE beacons 
        SET status = %s, x = %s, y = %s 
        WHERE beacon = %s AND tipo = %s
        """
        values = (status, x, y, beacon, tipo)
        cursor.execute(query, values)
        connection.commit()
    except mysql.connector.Error as e:
        print(f"Error updating beacon: {e}")
        connection.rollback()
    finally:
        cursor.close()
        connection.close()

def getInfoData():
    connection = connectToDatabase()
    if connection is None:
        return {}
    cursor = connection.cursor(dictionary=True)
    try:
        query = "SELECT * FROM info"
        cursor.execute(query)
        infos = cursor.fetchall()
        return {info["id"]: info for info in infos}
    except mysql.connector.Error as e:
        print(f"Error fetching info data: {e}")
        return {}
    finally:
        cursor.close()
        connection.close()

def createInfo(linha, maquina, numeroProdutos, horasTrabalhadas, rendimento, falhas):
    connection = connectToDatabase()
    if connection is None:
        return {}
    cursor = connection.cursor(dictionary=True)
    try:
        query = "INSERT INTO info (linha, maquina, numeroProdutos, horasTrabalhadas, rendimento, falhas) VALUES (%s, %s, %s, %s, %s, %s)"
        values = (linha, maquina, numeroProdutos, horasTrabalhadas, rendimento, falhas)
        cursor.execute(query, values)
        connection.commit()
    except mysql.connector.Error as e:
        print(f"Error creating info data: {e}")
    finally:
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
        connection.commit()
    except mysql.connector.Error as e:
        print(f"Error updating info: {e}")
        connection.rollback()
    finally:
        cursor.close()
        connection.close()

def getRSSI(beacon, gateway):
    connection = connectToDatabase()
    if connection is None:
        return
    cursor = connection.cursor(dictionary=True)
    try:
        column = f"rssi{gateway}"
        query = f"SELECT {column} FROM gateways WHERE beacon = %s"
        values = (beacon,)
        cursor.execute(query, values)
        result = cursor.fetchone()
        if result:
            return result[column]
        else:
            return None
    except mysql.connector.Error as e:
        print(f"Error fetching RSSI: {e}")
        return None
    finally:
        cursor.close()
        connection.close()

def createRSSI(beacon, rssi1, rssi2, rssi3, status):
    connection = connectToDatabase()
    if connection is None:
        return
    cursor = connection.cursor()
    try:
        query = "INSERT INTO gateways (beacon, rssi1, rssi2, rssi3, status) VALUES (%s, %s, %s, %s, %s)"
        values = (beacon, rssi1, rssi2, rssi3, status)
        cursor.execute(query, values)
        connection.commit()
    except mysql.connector.Error as e:
        print(f"Error updating beacon: {e}")
        connection.rollback()
    finally:
        cursor.close()
        connection.close()
    return

def updateRSSI(beacon, rssi, gateway):
    connection = connectToDatabase()
    if connection is None:
        return
    cursor = connection.cursor()
    try:
        query = "UPDATE gateways SET rssi%s = %s WHERE beacon = %s"
        values = (gateway, rssi, beacon)
        cursor.execute(query, values)
        connection.commit()
    except mysql.connector.Error as e:
        print(f"Error updating RSSI: {e}")
        connection.rollback()
    finally:
        cursor.close()
        connection.close()

print(getUsersData())
print(getBeaconsData())
print(getInfoData())
print(getRSSI(("lote1",), 1))