from . import models
import json

def calcularDistancia(x1, y1, x2, y2):
    return ((x2 - x1) ** 2 + (y2 - y1) ** 2) ** 0.5

def calcularDistanciaMedia(user_x, user_y, beacons_list):
    if not beacons_list:
        return float('inf')
    
    distancias = []
    all_beacons = models.getAllBeaconsData()
    
    for beacon_nome in beacons_list:
        beacon_coords = None
        for beacon_id, beacon_data in all_beacons.items():
            if beacon_data['beacon'] == beacon_nome:
                beacon_coords = (beacon_data['x'], beacon_data['y'])
                break
        
        if beacon_coords:
            dist = calcularDistancia(user_x, user_y, beacon_coords[0], beacon_coords[1])
            distancias.append(dist)
    
    return sum(distancias) / len(distancias) if distancias else float('inf')

def getUsersWithActiveTasks():
    tasks = models.getTasksData()
    users_with_tasks = set()
    
    for task_id, task in tasks.items():
        if task.get('user') and task.get('status') in ['pendente', 'em andamento']:
            users_with_tasks.add(task['user'])
    
    return users_with_tasks

def findBestUserForTask(task_beacons):
    all_beacons = models.getAllBeaconsData()
    funcionarios = []
    
    for beacon_id, beacon_data in all_beacons.items():
        if beacon_data.get('tipo') == 'funcionario':
            funcionarios.append(beacon_data)
    
    if not funcionarios:
        return None
    
    users_with_tasks = getUsersWithActiveTasks()
    
    if isinstance(task_beacons, str):
        try:
            task_beacons = json.loads(task_beacons)
        except:
            task_beacons = []
    
    candidatos = []
    
    for funcionario in funcionarios:
        user_x = funcionario.get('x', 0)
        user_y = funcionario.get('y', 0)
        username = funcionario.get('beacon')
        
        if not username:
            continue
            
        distancia_media = calcularDistanciaMedia(user_x, user_y, task_beacons)
        taskAtiva = username in users_with_tasks
        
        candidatos.append({
            'username': username,
            'distancia': distancia_media,
            'taskAtiva': taskAtiva,
            'x': user_x,
            'y': user_y
        })
    
    if not candidatos:
        return None
    
    candidatos.sort(key=lambda x: (x['tem_task_ativa'], x['distancia']))
    
    usuarios_sem_task = [c for c in candidatos if not c['tem_task_ativa']]
    if usuarios_sem_task:
        return usuarios_sem_task[0]['username']
    
    return candidatos[0]['username']

def atributeUser():
    tasks = models.getTasksData()
    
    for task_id, task in tasks.items():
        user = task.get("user")
        beacons = task.get("beacons", [])
        status = task.get("status", "")
        
        if (user is None or user == "" or user.strip() == "") and status in ['pendente', 'em andamento']:
            print(f"Processando task {task_id} sem usuário atribuído...")
            
            melhorUsuario = findBestUserForTask(beacons)
            
            if melhorUsuario:
                try:
                    models.updateTaskUser(task_id, melhorUsuario)
                    print(f"Task {task_id} atribuída ao usuário: {melhorUsuario}")
                except Exception as e:
                    print(f"Erro ao atribuir task {task_id} ao usuário {melhorUsuario}: {e}")
            else:
                print(f"Nenhum funcionário disponível encontrado para task {task_id}")