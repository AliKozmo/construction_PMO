#controllers/sql_models.py
from pydantic import BaseModel
from typing import Optional
from datetime import date
from pydantic import BaseModel, EmailStr
# -------------------
# PROJECT
# -------------------

class AddProjectModel(BaseModel):
    project_code: str
    name: str
    client_id: int
    start_date: date
    end_date: date
    status: str
    location: str
    description: str
    allocated_budget: Optional[float] = None
    budget_category: Optional[str] = None

class UpdateProjectStatusModel(BaseModel):
    ProjectID: int
    Status: str

class DeleteProjectModel(BaseModel):
    ProjectID: int

# -------------------
# TASK
# -------------------

class AddTaskModel(BaseModel):
    PhaseID: int
    AssignedTo: int
    Description: str
    DisciplineID: int
    StartDate: date
    EndDate: date
    Status: str
    CompletionPercentage: Optional[float] = 0
    Priority: str

class UpdateTaskStatusModel(BaseModel):
    TaskID: int
    Status: str
    CompletionPercentage: Optional[float] = None
    AssignedTo: Optional[int] = None

# -------------------
# EMPLOYEE
# -------------------

class AddEmployeeModel(BaseModel):
    Name: str
    Email: str
    Phone: str
    DisciplineID: int
    DepartmentID: int
    HireDate: date
    Status: str

class AssignEmployeeToProjectModel(BaseModel):
    ProjectID: int
    EmployeeID: int
    RoleID: int
    StartDate: date
    EndDate: Optional[date] = None

# -------------------
# CONTRACTOR
# -------------------

class AssignContractorToProjectModel(BaseModel):
    ProjectID: int
    ContractorID: int
    ContractValue: float
    StartDate: date
    EndDate: date
    ScopeOfWork: str

# -------------------
# MATERIAL
# -------------------

class AddMaterialModel(BaseModel):
    Name: str
    Description: str
    Unit: str
    UnitCost: float
    SupplierID: int
    StockQuantity: float

# -------------------
# BUDGET
# -------------------

class UpdateBudgetModel(BaseModel):
    BudgetID: int
    AllocatedAmount: Optional[float] = None
    SpentAmount: Optional[float] = None

# -------------------
# MILESTONE
# -------------------

class AddMilestoneModel(BaseModel):
    ProjectID: int
    Name: str
    Description: str
    DueDate: date
    Status: str
    ResponsibleEmployeeID: Optional[int] = None

# -------------------
# SAFETY INSPECTION
# -------------------

class AddSafetyInspectionModel(BaseModel):
    ProjectID: int
    InspectionDate: date
    InspectorID: int
    Type: str
    Status: str
    Description: str
    CorrectiveAction: Optional[str] = None
    CompletionDate: Optional[date] = None

# -------------------
# Client
# -------------------

class AddClientModel(BaseModel):
    name: str
    company_name: str
    email: EmailStr
    phone: Optional[str] = None
    address: Optional[str] = None
    contact_person: Optional[str] = None


# # -------------------
# # Models
# # -------------------

# class AddPhaseModel(BaseModel):
#     project_id: int            # ID du projet auquel cette phase appartient
#     phase_name: str            # Nom de la phase
#     discipline_id: int        # ID de la discipline associée à cette phase
#     start_date: date          # Date de début de la phase
#     end_date: Optional[date]  # Date de fin de la phase (peut être nul si la phase n'est pas terminée)
#     status: str               # Statut de la phase (par exemple: "En cours", "Complété", etc.)




# ------------------- 
# DEPARTMENT
# -------------------

class AddDepartmentModel(BaseModel):
    name: str
    description: Optional[str] = None
    manager_id: Optional[int] = None

# ------------------- 
# DISCIPLINE
# -------------------

class AddDisciplineModel(BaseModel):
    discipline_name: str

# ------------------- 
# ROLE
# -------------------

class AddRoleModel(BaseModel):
    role_name: str




# ------------------- 
# PROJECT PHASE
# -------------------

class AddProjectPhaseModel(BaseModel):
    project_id: int
    phase_name: str
    discipline_id: int
    start_date: date
    end_date: Optional[date] = None
    status: str

# ------------------- 
# CONTRACTOR
# -------------------

class AddContractorModel(BaseModel):
    company_name: str
    license_no: Optional[str] = None
    contact_name: str
    contact_email: Optional[str] = None
    contact_phone: Optional[str] = None
    rating: Optional[float] = None

# ------------------- 
# PROJECT CONTRACTOR
# -------------------

class AddProjectContractorModel(BaseModel):
    project_id: int
    contractor_id: int
    contract_value: float
    start_date: date
    end_date: Optional[date] = None
    scope_of_work: Optional[str] = None

# ------------------- 
# SUPPLIER
# -------------------

class AddSupplierModel(BaseModel):
    company_name: str
    contact_name: str
    contact_email: Optional[str] = None
    contact_phone: Optional[str] = None
    rating: Optional[float] = None
    address: Optional[str] = None



# ------------------- 
# PROJECT TEAM
# -------------------

class AddProjectTeamModel(BaseModel):
    project_id: int
    employee_id: int
    role_id: int
    start_date: date
    end_date: Optional[date] = None

# ------------------- 
# EQUIPMENT
# -------------------

class AddEquipmentModel(BaseModel):
    name: str
    type: str
    project_id: int
    location: Optional[str] = None
    status: str
    purchase_date: Optional[date] = None
    vendor_id: Optional[int] = None
    cost: Optional[float] = None
    is_rented: bool = False
    rental_start_date: Optional[date] = None
    rental_end_date: Optional[date] = None

# ------------------- 
# MAINTENANCE SCHEDULE
# -------------------

class AddMaintenanceScheduleModel(BaseModel):
    equipment_id: int
    maintenance_type: str
    scheduled_date: date
    performed_by: int
    status: str
    remarks: Optional[str] = None

# ------------------- 
# SAFETY COMPLIANCE
# -------------------

class AddSafetyComplianceModel(BaseModel):
    project_id: int
    inspection_date: date
    inspector_id: int
    type: str
    status: str
    description: Optional[str] = None
    corrective_action: Optional[str] = None
    completion_date: Optional[date] = None

# ------------------- 
# SITE EMPLOYEE
# -------------------

class AddSiteEmployeeModel(BaseModel):
    employee_id: int
    company: str
    site_id: str
    date_of_end_of_contract: Optional[date] = None


