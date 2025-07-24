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

#---------------------------------------------------------------------------------------------------------------------------

def getUsersData():
    connection = connectToDatabase()
    if connection is None:
        return {}
    cursor = connection.cursor(dictionary=True)
    try:
        query = "SELECT * FROM users"
        cursor.execute(query)
        users = cursor.fetchall()
        return {user["username"]: user for user in users}
    except mysql.connector.Error as e:
        print(f"Error fetching users data: {e}")
        return {}
    finally:
        cursor.close()
        connection.close()

def createUser(username, password, email, role):
    connection = connectToDatabase()
    if connection is None:
        return
    cursor = connection.cursor()
    try:
        query = "INSERT INTO users (username, password, email, role) VALUES (%s, %s, %s, %s)"
        values = (username, password, email, role)
        cursor.execute(query, values)
        connection.commit()
    except mysql.connector.Error as e:
        print(f"Error creating user: {e}")
        connection.rollback()
    finally:
        cursor.close()
        connection.close()

def updateUser(oldUsername, newUsername, password, email, role):
    connection = connectToDatabase()
    if connection is None:
        return
    cursor = connection.cursor()
    try:
        query = """
        UPDATE users 
        SET username= %s, password = %s, email = %s, role = %s
        WHERE username = %s
        """
        values = (newUsername, password, email, role, oldUsername)
        cursor.execute(query, values)
        connection.commit()
    except mysql.connector.Error as e:
        print(f"Error updating user: {e}")
        connection.rollback()
    finally:
        cursor.close()
        connection.close()

def deleteUser(username):
    connection = connectToDatabase()
    if connection is None:
        return
    cursor = connection.cursor()
    try:
        query = "DELETE FROM users WHERE username = %s"
        cursor.execute(query, (username,))
        connection.commit()
    except mysql.connector.Error as e:
        print(f"Error deleting user: {e}")
        connection.rollback()
    finally:
        cursor.close()
        connection.close()

#---------------------------------------------------------------------------------------------------------------------------

def getAllBeaconsData():
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

def getLastBeaconsData(time):
    connection = connectToDatabase()
    if connection is None:
        return {}
    cursor = connection.cursor(dictionary=True)
    try:
        query = """
        SELECT * FROM beacons 
        WHERE utc >= UNIX_TIMESTAMP(NOW() - INTERVAL %s SECOND)
        """
        cursor.execute(query, (time,))
        beacons = cursor.fetchall()
        return {beacon["id"]: beacon for beacon in beacons}
    except mysql.connector.Error as e:
        print(f"Error fetching last minute beacons data: {e}")
        return {}
    finally:
        cursor.close()
        connection.close()

def createBeacon(utc, beacon, tipo, status, linha, rssi1, rssi2, rssi3, x, y):
    connection = connectToDatabase()
    if connection is None:
        return
    cursor = connection.cursor()
    try:
        query = "INSERT INTO beacons (utc, beacon, tipo, status, linha, rssi1, rssi2, rssi3, x, y) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
        values = (utc, beacon, tipo, status, linha, rssi1, rssi2, rssi3, x, y)
        cursor.execute(query, values)
        connection.commit()
    except mysql.connector.Error as e:
        print(f"Error creating beacon: {e}")
        connection.rollback()
    finally:
        cursor.close()
        connection.close()

def updateBeaconPosition(utc, beacon, x, y):
    connection = connectToDatabase()
    if connection is None:
        return
    cursor = connection.cursor()
    try:
        query = """
        UPDATE beacons 
        SET x = %s, y = %s 
        WHERE beacon = %s AND utc = %s
        """
        values = (x, y, beacon, beacon, utc)
        cursor.execute(query, values)
        connection.commit()
    except mysql.connector.Error as e:
        print(f"Error updating beacon: {e}")
        connection.rollback()
    finally:
        cursor.close()
        connection.close()

def updateBeaconRssi(beacon, rssi1, rssi2, rssi3):
    connection = connectToDatabase()
    if connection is None:
        return
    cursor = connection.cursor()
    try:
        if rssi2 is None and rssi3 is None: 
            query = "UPDATE beacons SET rssi1 = %s WHERE beacon = %s AND utc >= UNIX_TIMESTAMP(NOW() - INTERVAL 10 SECOND)"
            values = (rssi1, beacon)
        elif rssi1 is None and rssi3 is None: 
            query = "UPDATE beacons SET rssi2 = %s WHERE beacon = %s AND utc >= UNIX_TIMESTAMP(NOW() - INTERVAL 10 SECOND)"
            values = (rssi2, beacon)
        elif rssi1 is None and rssi2 is None: 
            query = "UPDATE beacons SET rssi3 = %s WHERE beacon = %s AND utc >= UNIX_TIMESTAMP(NOW() - INTERVAL 10 SECOND)"
            values = (rssi3, beacon)

        cursor.execute(query, values)
        connection.commit()
    except mysql.connector.Error as e:
        print(f"Error updating beacon RSSI: {e}")
        connection.rollback()
    finally:
        cursor.close()
        connection.close()

def getBeaconRssi(beacon):
    connection = connectToDatabase()
    if connection is None:
        return None
    cursor = connection.cursor(dictionary=True)
    try:
        query = "SELECT rssi1, rssi2, rssi3 FROM beacons WHERE beacon = %s"
        cursor.execute(query, (beacon,))
        result = cursor.fetchone()
        return result
    except mysql.connector.Error as e:
        print(f"Error fetching beacon RSSI: {e}")
        return None
    finally:
        cursor.close()
        connection.close()

def updateBeaconType(utc, beacon, tipo):
    connection = connectToDatabase()
    if connection is None:
        return
    cursor = connection.cursor()
    try:
        query = "UPDATE beacons SET tipo = %s WHERE beacon = %s AND utc = %s"
        values = (tipo, beacon, utc)
        cursor.execute(query, values)
        connection.commit()
    except mysql.connector.Error as e:
        print(f"Error updating beacon tipo: {e}")
        connection.rollback()
    finally:
        cursor.close()
        connection.close()

def updateBeaconStatusAndLine(utc, beacon, status, linha):
    connection = connectToDatabase()
    if connection is None:
        return
    cursor = connection.cursor()
    try:
        query = "UPDATE beacons SET status = %s, linha = %s WHERE beacon = %s AND utc = %s"
        values = (status, linha, beacon, utc)
        cursor.execute(query, values)
        connection.commit()
    except mysql.connector.Error as e:
        print(f"Error updating beacon status and line: {e}")
        connection.rollback()
    finally:
        cursor.close()
        connection.close()

def deleteBeacon(beacon):
    connection = connectToDatabase()
    if connection is None:
        return
    cursor = connection.cursor()
    try:
        query = "DELETE FROM beacons WHERE beacon = %s"
        cursor.execute(query, (beacon,))
        connection.commit()
    except mysql.connector.Error as e:
        print(f"Error deleting beacon: {e}")
        connection.rollback()
    finally:
        cursor.close()
        connection.close()

#---------------------------------------------------------------------------------------------------------------------------

def getTasksData():
    connection = connectToDatabase()
    if connection is None:
        return {}
    cursor = connection.cursor(dictionary=True)
    try:
        query = "SELECT * FROM tasks"
        cursor.execute(query)
        tasks = cursor.fetchall()
        return {task["id"]: task for task in tasks}
    except mysql.connector.Error as e:
        print(f"Error fetching tasks data: {e}")
        return {}
    finally:
        cursor.close()
        connection.close()

def getTaskByUser(user):
    connection = connectToDatabase()
    if connection is None:
        return {}
    cursor = connection.cursor(dictionary=True)
    try:
        query = "SELECT * FROM tasks WHERE user = %s"
        cursor.execute(query, (user,))
        task = cursor.fetchone()
        return task if task else {}
    except mysql.connector.Error as e:
        print(f"Error fetching task by user: {e}")
        return {}
    finally:
        cursor.close()
        connection.close()

def createTask(user, mensagem, linha , beacons, dependencias, tipo, status):
    connection = connectToDatabase()
    if connection is None:
        return
    cursor = connection.cursor()
    try:
        query = "INSERT INTO tasks (user, mensagem, linha, beacons, dependencias, tipo, status) VALUES (%s, %s, %s, %s, %s, %s, %s)"
        values = (user, mensagem, linha, beacons, dependencias, tipo, status)
        cursor.execute(query, values)
        connection.commit()
    except mysql.connector.Error as e:
        print(f"Error creating task: {e}")
        connection.rollback()
    finally:
        cursor.close()
        connection.close()

def updateTask(id, user, mensagem, linha , beacons, dependencias, tipo, status):
    connection = connectToDatabase()
    if connection is None:
        return
    cursor = connection.cursor()
    try:
        query = """
        UPDATE tasks
        SET user = %s, mensagem = %s, linha = %s, beacons = %s, dependencias = %s, tipo = %s, status = %s
        WHERE id = %s
        """
        values = (user, mensagem, linha, beacons, dependencias, tipo, status, id)
        cursor.execute(query, values)
        connection.commit()
    except mysql.connector.Error as e:
        print(f"Error updating task status: {e}")
        connection.rollback()
    finally:
        cursor.close()
        connection.close()

def updateStatus(id, status):
    connection = connectToDatabase()
    if connection is None:
        return
    cursor = connection.cursor()
    try:
        query = "UPDATE tasks SET status = %s WHERE id = %s"
        values = (status, id)
        cursor.execute(query, values)
        connection.commit()
    except mysql.connector.Error as e:
        print(f"Error cancelling task: {e}")
        connection.rollback()
    finally:
        cursor.close()
        connection.close()

def deleteTask(id):
    connection = connectToDatabase()
    if connection is None:
        return
    cursor = connection.cursor()
    try:
        query = "DELETE FROM tasks WHERE id = %s"
        cursor.execute(query, (id,))
        connection.commit()
    except mysql.connector.Error as e:
        print(f"Error deleting task: {e}")
        connection.rollback()
    finally:
        cursor.close()
        connection.close()

#---------------------------------------------------------------------------------------------------------------------------

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

def createInfo(linha, maquina, numeroProdutos, horasTrabalhadas, falhas):
    connection = connectToDatabase()
    if connection is None:
        return {}
    cursor = connection.cursor(dictionary=True)
    try:
        query = "INSERT INTO info (linha, maquina, numeroProdutos, horasTrabalhadas, falhas) VALUES (%s, %s, %s, %s, %s)"
        values = (linha, maquina, numeroProdutos, horasTrabalhadas, falhas)
        cursor.execute(query, values)
        connection.commit()
    except mysql.connector.Error as e:
        print(f"Error creating info data: {e}")
    finally:
        cursor.close()
        connection.close()

def updateInfo(linha, maquina, numeroProdutos, horasTrabalhadas, falhas):
    connection = connectToDatabase()
    if connection is None:
        return
    cursor = connection.cursor()
    try:
        query = """
        UPDATE info 
        SET numeroProdutos = %s, horasTrabalhadas = %s, falhas = %s 
        WHERE linha = %s AND maquina = %s
        """
        values = (numeroProdutos, horasTrabalhadas, falhas, linha, maquina)
        cursor.execute(query, values)
        connection.commit()
    except mysql.connector.Error as e:
        print(f"Error updating info: {e}")
        connection.rollback()
    finally:
        cursor.close()
        connection.close()

def deleteInfo(linha, maquina):
    connection = connectToDatabase()
    if connection is None:
        return
    cursor = connection.cursor()
    try:
        query = "DELETE FROM info WHERE linha = %s AND maquina = %s"
        cursor.execute(query, (linha, maquina))
        connection.commit()
    except mysql.connector.Error as e:
        print(f"Error deleting info: {e}")
        connection.rollback()
    finally:
        cursor.close()
        connection.close()
