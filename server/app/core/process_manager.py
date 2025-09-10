import threading
from .position import calculateBeaconsPositions, gateways
from .infos import calculateBeaconsStatus
from .tasks import atributeUser
import time
import logging

logger = logging.getLogger(__name__)

def run_position_loop():
    while True:
        try:
            calculateBeaconsPositions(gateways)
            time.sleep(10)
        except Exception as e:
            logger.error(f"Position error: {e}")

def run_status_loop():
    while True:
        try:
            calculateBeaconsStatus()
            time.sleep(10)
        except Exception as e:
            logger.error(f"Status error: {e}")

def run_tasks_loop():
    while True:
        try:
            atributeUser()
            time.sleep(10)
        except Exception as e:
            logger.error(f"Tasks error: {e}")

class ProcessManager:
    def __init__(self):
        self.threads = []
    
    def start(self):
        position_thread = threading.Thread(target=run_position_loop, daemon=True)
        status_thread = threading.Thread(target=run_status_loop, daemon=True)
        tasks_thread = threading.Thread(target=run_tasks_loop, daemon=True)
        
        position_thread.start()
        status_thread.start()
        tasks_thread.start()

        self.threads = [position_thread, status_thread, tasks_thread]
        logger.info("Background processes started")

process_manager = ProcessManager()