import mysql.connector
import os
from dotenv import load_dotenv
from .auth import hash_password, verify_password
import json

load_dotenv()

DB_CONFIG = {
    "host": os.getenv("DATABASE_HOST", "127.0.0.1"),
    "user": os.getenv("DATABASE_USER", "root"),
    "password": os.getenv("DATABASE_PASSWORD"),
    "database": os.getenv("DATABASE_NAME", "fetindb"),
    "port": int(os.getenv("DATABASE_PORT", "3306")),
    "autocommit": False,
    "pool_name": "mypool",
    "pool_size": 5,
    "pool_reset_session": True
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
        # Hash da senha antes de armazenar
        hashed_password = hash_password(password)
        query = "INSERT INTO users (username, password, email, role) VALUES (%s, %s, %s, %s)"
        values = (username, hashed_password, email, role)
        cursor.execute(query, values)
        connection.commit()
        print(f"Usuário {username} criado com sucesso")
    except mysql.connector.Error as e:
        print(f"Error creating user: {e}")
        connection.rollback()
    finally:
        cursor.close()
        connection.close()

def authenticateUser(username, password):
    """Autentica usuário verificando senha hasheada"""
    connection = connectToDatabase()
    if connection is None:
        return None
    cursor = connection.cursor(dictionary=True)
    try:
        query = "SELECT username, password, email, role FROM users WHERE username = %s"
        cursor.execute(query, (username,))
        user = cursor.fetchone()
        
        if user and verify_password(password, user["password"]):
            # Remove a senha do retorno por segurança
            user.pop("password", None)
            return user
        return None
    except mysql.connector.Error as e:
        print(f"Error authenticating user: {e}")
        return None
    finally:
        cursor.close()
        connection.close()

def updateUser(oldUsername, newUsername, password, email, role):
    connection = connectToDatabase()
    if connection is None:
        return
    cursor = connection.cursor()
    try:
        hashed_password = hash_password(password)
        query = """
        UPDATE users 
        SET username = %s, password = %s, email = %s, role = %s
        WHERE username = %s
        """
        values = (newUsername, hashed_password, email, role, oldUsername)
        cursor.execute(query, values)
        connection.commit()
        print(f"Usuário {oldUsername} atualizado com sucesso")
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

def getBeacon(beacon):
    connection = connectToDatabase()
    if connection is None:
        return {}
    cursor = connection.cursor(dictionary=True)
    try:
        query = "SELECT * FROM beacons WHERE beacon = %s"
        cursor.execute(query, (beacon,))
        result = cursor.fetchall()
        return result if result else {}
    except mysql.connector.Error as e:
        print(f"Error fetching beacon: {e}")
        return {}
    finally:
        cursor.close()
        connection.close()

def createBeacon(utc, beacon, tipo, status, rssi1, rssi2, rssi3, x, y):
    connection = connectToDatabase()
    if connection is None:
        return
    cursor = connection.cursor()
    try:
        query = "INSERT INTO beacons (utc, beacon, tipo, status, rssi1, rssi2, rssi3, x, y) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)"
        values = (utc, beacon, tipo, status, rssi1, rssi2, rssi3, x, y)
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
        values = (x, y, beacon, utc)
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

def updateBeaconStatus(utc, beacon, status):
    connection = connectToDatabase()
    if connection is None:
        return
    cursor = connection.cursor()
    try:
        query = "UPDATE beacons SET status = %s WHERE beacon = %s AND utc = %s"
        values = (status, beacon, utc)
        cursor.execute(query, values)
        connection.commit()
    except mysql.connector.Error as e:
        print(f"Error updating beacon status: {e}")
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
        import json
        query = "SELECT * FROM tasks"
        cursor.execute(query)
        tasks = cursor.fetchall()
        # Decode JSON beacons field and handle null user
        for task in tasks:
            if task["beacons"]:
                try:
                    task["beacons"] = json.loads(task["beacons"])
                except:
                    task["beacons"] = []
            else:
                task["beacons"] = []
            
            # Ensure user is never None
            if task["user"] is None:
                task["user"] = ""
                
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
        import json
        query = "SELECT * FROM tasks WHERE user = %s"
        cursor.execute(query, (user,))
        tasks = cursor.fetchall()
        # Decode JSON beacons field and handle null user
        for task in tasks:
            if task["beacons"]:
                try:
                    task["beacons"] = json.loads(task["beacons"])
                except:
                    task["beacons"] = []
            else:
                task["beacons"] = []
            
            # Ensure user is never None
            if task["user"] is None:
                task["user"] = ""
                
        return {task["id"]: task for task in tasks} if tasks else {}
    except mysql.connector.Error as e:
        print(f"Error fetching task by user: {e}")
        return {}
    finally:
        cursor.close()
        connection.close()

def getTaskById(id):
    connection = connectToDatabase()
    if connection is None:
        return {}
    cursor = connection.cursor(dictionary=True)
    try:
        import json
        query = "SELECT * FROM tasks WHERE id = %s"
        cursor.execute(query, (id,))
        task = cursor.fetchone()
        if task and task["beacons"]:
            try:
                task["beacons"] = json.loads(task["beacons"])
            except:
                task["beacons"] = []
        elif task:
            task["beacons"] = []
            
        # Ensure user is never None
        if task and task["user"] is None:
            task["user"] = ""
            
        return task if task else {}
    except mysql.connector.Error as e:
        print(f"Error fetching task by ID: {e}")
        return {}
    finally:
        cursor.close()
        connection.close()

def createTask(mensagem, destino, tipoDestino, beacons, tipo, status):
    connection = connectToDatabase()
    if connection is None:
        return
    cursor = connection.cursor()
    try:
        import json
        beacons_json = json.dumps(beacons) if beacons else '[]'
        query = "INSERT INTO tasks (mensagem, destino, tipoDestino, beacons, tipo, status) VALUES (%s, %s, %s, %s, %s, %s)"
        values = (mensagem, destino, tipoDestino, beacons_json, tipo, status)
        cursor.execute(query, values)
        connection.commit()
    except mysql.connector.Error as e:
        print(f"Error creating task: {e}")
        connection.rollback()
    finally:
        cursor.close()
        connection.close()

def updateTask(id, user, mensagem, destino, tipoDestino, beacons, tipo, status):
    connection = connectToDatabase()
    if connection is None:
        return
    cursor = connection.cursor()
    try:
        import json
        beacons_json = json.dumps(beacons) if beacons else '[]'
        query = """
        UPDATE tasks
        SET user = %s, mensagem = %s, destino = %s, tipoDestino = %s, beacons = %s, tipo = %s, status = %s
        WHERE id = %s
        """
        values = (user, mensagem, destino, tipoDestino, beacons_json, tipo, status, id)
        cursor.execute(query, values)
        connection.commit()
    except mysql.connector.Error as e:
        print(f"Error updating task: {e}")
        connection.rollback()
    finally:
        cursor.close()
        connection.close()

def updateTaskStatus(task_id, status):
    connection = connectToDatabase()
    if connection is None:
        return
    cursor = connection.cursor()
    try:
        query = "UPDATE tasks SET status = %s WHERE id = %s"
        values = (status, task_id)
        cursor.execute(query, values)
        connection.commit()
        return cursor.rowcount > 0
    except mysql.connector.Error as e:
        print(f"Error updating task status: {e}")
        connection.rollback()
    finally:
        cursor.close()
        connection.close()

def updateTaskUser(id, user):
    connection = connectToDatabase()
    if connection is None:
        return
    cursor = connection.cursor()
    try:
        query = "UPDATE tasks SET user = %s WHERE id = %s"
        values = (user, id)
        cursor.execute(query, values)
        connection.commit()
    except mysql.connector.Error as e:
        print(f"Error updating task user: {e}")
        connection.rollback()
    finally:
        cursor.close()
        connection.close()

def deleteTask(task_id):
    connection = connectToDatabase()
    if connection is None:
        return
    cursor = connection.cursor()
    try:
        query = "DELETE FROM tasks WHERE id = %s"
        cursor.execute(query, (task_id,))
        connection.commit()
        return cursor.rowcount > 0
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
        # Converter datetime.date para string
        for info in infos:
            if info.get('data') and hasattr(info['data'], 'strftime'):
                info['data'] = info['data'].strftime('%Y-%m-%d')
        return {info["id"]: info for info in infos}
    except mysql.connector.Error as e:
        print(f"Error fetching info data: {e}")
        return {}
    finally:
        cursor.close()
        connection.close()

def createInfo(maquina, tasksConcluidas, tasksCanceladas, horasTrabalhadas, data):
    connection = connectToDatabase()
    if connection is None:
        return {}
    cursor = connection.cursor(dictionary=True)
    try:
        query = "INSERT INTO info (maquina, tasksConcluidas, tasksCanceladas, horasTrabalhadas, data) VALUES (%s, %s, %s, %s, %s)"
        values = (maquina, tasksConcluidas, tasksCanceladas, horasTrabalhadas, data)
        cursor.execute(query, values)
        connection.commit()
    except mysql.connector.Error as e:
        print(f"Error creating info data: {e}")
    finally:
        cursor.close()
        connection.close()

def updateInfo(maquina, tasksConcluidas, tasksCanceladas, horasTrabalhadas, data):
    connection = connectToDatabase()
    if connection is None:
        return None
    cursor = connection.cursor()
    try:
        query = """
        UPDATE info 
        SET tasksConcluidas = %s, tasksCanceladas = %s, horasTrabalhadas = %s
        WHERE maquina = %s AND data = %s
        """
        values = (tasksConcluidas, tasksCanceladas, horasTrabalhadas, maquina, data)
        cursor.execute(query, values)
        connection.commit()
        return cursor.rowcount > 0
    except mysql.connector.Error as e:
        print(f"Error updating info: {e}")
        connection.rollback()
        return None
    finally:
        cursor.close()
        connection.close()

def deleteInfo(maquina, data):
    connection = connectToDatabase()
    if connection is None:
        return None
    cursor = connection.cursor()
    try:
        query = "DELETE FROM info WHERE maquina = %s AND data = %s"
        values = (maquina, data)
        cursor.execute(query, values)
        connection.commit()
        return cursor.rowcount > 0
    except mysql.connector.Error as e:
        print(f"Error deleting info: {e}")
        connection.rollback()
        return None
    finally:
        cursor.close()
        connection.close()
