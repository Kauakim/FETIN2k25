import mysql.connector

BEACONS_DB_CONFIG = {
    "host": "localhost",
    "user": "FETIN",
    "password": "2k25",
    "database": "beacons"
}

LOGIN_DB_CONFIG = {
    "host": "localhost",
    "user": "FETIN",
    "password": "2k25",
    "database": "login"
}

def connectToBeaconsDatabase():
    try:
        return mysql.connector.connect(**BEACONS_DB_CONFIG)
    except mysql.connector.Error as e:
        print(f"Beacons database connection error: {e}")
        return None

def connectToLoginDatabase():
    try:
        return mysql.connector.connect(**LOGIN_DB_CONFIG)
    except mysql.connector.Error as e:
        print(f"Login database connection error: {e}")
        return None

def getBeaconsData():
    connection = connectToBeaconsDatabase()
    if connection is None:
        return []
    cursor = connection.cursor(dictionary=True)

    query = "SELECT * FROM beacons"
    cursor.execute(query)

    beaconsData = cursor.fetchall()

    cursor.close()
    connection.close()

    return beaconsData

def getUsersData():
    connection = connectToLoginDatabase()
    if connection is None:
        return
    cursor = connection.cursor(dictionary=True)

    query = "SELECT username FROM login"
    cursor.execute(query)

    users = cursor.fetchall()
    usersData = {user["username"]: user for user in users}

    cursor.close()
    connection.close()

    return usersData