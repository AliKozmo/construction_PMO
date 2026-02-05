import pyodbc
from typing import List, Dict, Any
import os
from dotenv import load_dotenv

load_dotenv()  

# Get SQL Server connection settings from environment
SQL_SERVER = os.getenv("SQL_SERVER")
SQL_DATABASE = os.getenv("SQL_DATABASE")
SQL_TRUSTED_CONNECTION = os.getenv("SQL_TRUSTED_CONNECTION")

# Connection to SQL Server
def get_db_connection():
    conn = pyodbc.connect(
        f'DRIVER={{ODBC Driver 17 for SQL Server}};'
        f'SERVER={SQL_SERVER};'
        f'DATABASE={SQL_DATABASE};'
        f'Trusted_Connection={SQL_TRUSTED_CONNECTION};'
    )
    return conn


# Fonction pour appeler la procédure sp_AddProject
def add_project(project_code: str, name: str, client_id: int, start_date: str, 
                end_date: str, status: str, location: str, description: str, 
                allocated_budget: float = None, budget_category: str = None):
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("""
        EXEC sp_AddProject ?, ?, ?, ?, ?, ?, ?, ?, ?
    """, (project_code, name, client_id, start_date, end_date, status, location, description, allocated_budget))

    conn.commit()
    conn.close()


# Fonction pour appeler la procédure sp_UpdateProjectStatus
def update_project_status(project_id: int, status: str):
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("""
        EXEC sp_UpdateProjectStatus ?, ?
    """, (project_id, status))

    conn.commit()
    conn.close()


# Fonction pour appeler la procédure sp_DeleteProject
def delete_project(project_id: int):
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("""
        EXEC sp_DeleteProject ?
    """, (project_id,))

    conn.commit()
    conn.close()


# Fonction pour ajouter une tâche via sp_AddTask
def add_task(phase_id: int, assigned_to: int, description: str, discipline_id: int, 
             start_date: str, end_date: str, status: str, completion_percentage: float = 0, 
             priority: str = 'Normal'):
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("""
        EXEC sp_AddTask ?, ?, ?, ?, ?, ?, ?, ?, ?
    """, (phase_id, assigned_to, description, discipline_id, start_date, end_date, 
          status, completion_percentage, priority))

    conn.commit()
    conn.close()


# Fonction pour mettre à jour le statut d'une tâche via sp_UpdateTaskStatus
def update_task_status(task_id: int, status: str, completion_percentage: float = None, 
                       assigned_to: int = None):
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("""
        EXEC sp_UpdateTaskStatus ?, ?, ?, ?
    """, (task_id, status, completion_percentage, assigned_to))

    conn.commit()
    conn.close()


# Fonction pour ajouter un employé via sp_AddEmployee
def add_employee(name: str, email: str, phone: str, discipline_id: int, department_id: int, 
                 hire_date: str, status: str):
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("""
        EXEC sp_AddEmployee ?, ?, ?, ?, ?, ?, ?
    """, (name, email, phone, discipline_id, department_id, hire_date, status))

    conn.commit()
    conn.close()


# Fonction pour assigner un employé à un projet via sp_AssignEmployeeToProject
def assign_employee_to_project(project_id: int, employee_id: int, role_id: int, 
                                start_date: str, end_date: str = None):
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("""
        EXEC sp_AssignEmployeeToProject ?, ?, ?, ?, ?
    """, (project_id, employee_id, role_id, start_date, end_date))

    conn.commit()
    conn.close()


# Fonction pour assigner un entrepreneur à un projet via sp_AssignContractorToProject
def assign_contractor_to_project(project_id: int, contractor_id: int, contract_value: float, 
                                 start_date: str, end_date: str, scope_of_work: str):
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("""
        EXEC sp_AssignContractorToProject ?, ?, ?, ?, ?, ?
    """, (project_id, contractor_id, contract_value, start_date, end_date, scope_of_work))

    conn.commit()
    conn.close()


# Fonction pour ajouter un matériau via sp_AddMaterial
def add_material(name: str, description: str, unit: str, unit_cost: float, 
                 supplier_id: int, stock_quantity: float):
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("""
        EXEC sp_AddMaterial ?, ?, ?, ?, ?, ?
    """, (name, description, unit, unit_cost, supplier_id, stock_quantity))

    conn.commit()
    conn.close()


# Fonction pour mettre à jour le budget via sp_UpdateBudget
def update_budget(budget_id: int, allocated_amount: float = None, spent_amount: float = None):
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("""
        EXEC sp_UpdateBudget ?, ?, ?
    """, (budget_id, allocated_amount, spent_amount))

    conn.commit()
    conn.close()


# Fonction pour ajouter une étape via sp_AddMilestone
def add_milestone(project_id: int, name: str, description: str, due_date: str, 
                  status: str, responsible_employee_id: int = None):
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("""
        EXEC sp_AddMilestone ?, ?, ?, ?, ?, ?
    """, (project_id, name, description, due_date, status, responsible_employee_id))

    conn.commit()
    conn.close()

# Fonction pour mettre à jour le budget via sp_UpdateBudget
def update_budget_add_to_spent_amount(budget_id: int, spent_amount: float = None):
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("""
        EXEC sp_UpdateBudgetaddtospentamount ?, ?
    """, (budget_id, spent_amount))

    conn.commit()
    conn.close()

# Fonction pour ajouter un client
def add_client(name: str, company_name: str, email: str, phone: str = None, 
               address: str = None, contact_person: str = None):
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("""
        EXEC sp_AddClient ?, ?, ?, ?, ?, ?
    """, (name, company_name, email, phone, address, contact_person))

    conn.commit()
    conn.close()


def add_client(name: str, company_name: str, email: str, phone: str = None, 
               address: str = None, contact_person: str = None):
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("""
        EXEC sp_AddClient ?, ?, ?, ?, ?, ?
    """, (name, company_name, email, phone, address, contact_person))

    conn.commit()
    conn.close()




def add_table(table_name: str, **kwargs): 
    conn = get_db_connection() 
    cursor = conn.cursor()
    columns = ', '.join(kwargs.keys())  
    values = ', '.join(['?'] * len(kwargs))  
    query = f"""
        INSERT INTO {table_name} ({columns})
        VALUES ({values})
    """    
    cursor.execute(query, tuple(kwargs.values())) 
    conn.commit() 
    conn.close()


