from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, EmailStr, Field
from typing import Optional, Dict, Any, List
from controllers import payments  
from controllers import documents  
from controllers import risks
from pydantic import BaseModel
from typing import Optional
from controllers import sql_procedures as sql
from pydantic import BaseModel
from typing import Optional 
from datetime import date
import sys
import os
from controllers.sql_models import (
    AddProjectModel, UpdateProjectStatusModel, DeleteProjectModel, 
    AddTaskModel, UpdateTaskStatusModel, 
    AddEmployeeModel, AssignEmployeeToProjectModel, 
    AssignContractorToProjectModel, AddMaterialModel, UpdateBudgetModel, 
    AddMilestoneModel, AddSafetyInspectionModel, AddClientModel,
    AddDepartmentModel, AddDisciplineModel, AddRoleModel,
    AddProjectPhaseModel, AddContractorModel, AddProjectContractorModel,
    AddSupplierModel, AddProjectTeamModel, AddEquipmentModel,
    AddMaintenanceScheduleModel, AddSafetyComplianceModel, AddSiteEmployeeModel
)


app = FastAPI(title="PMO Project API", version="1.0")




# --- Payments ---
class   PaymentCreate(BaseModel):
    project_id: str = Field(..., example="64c1a1b2f1d2c1e123456789")
    budget_id: str = Field(..., example="64d2a2b2f1d2c1e123456789")  # ID du budget
    amount: float = Field(..., example=15000.0)
    payment_date: str = Field(..., example="2026-02-15")
    payment_type: str = Field(..., example="Bank Transfer")
    status: str = Field(..., example="Completed")
    remarks: Optional[str] = Field(None, example="First milestone payment")

class PaymentUpdate(BaseModel):
    amount: Optional[float] = None
    status: Optional[str] = None
    remarks: Optional[str] = None

class PaymentResponse(BaseModel):
    payment_id: str


class PaymentTotalResponse(BaseModel):
    project_id: str
    total_amount: float


    
# --- Documents ---
class DocumentCreate(BaseModel):
    project_id: str = Field(..., example="64c1a1b2f1d2c1e123456789")
    doc_type: str = Field(..., example="Specification")
    name: str = Field(..., example="Project Specs v1")
    version: str = Field(..., example="v1.0")
    file_path: str = Field(..., example="/files/specs_v1.pdf")
    status: str = Field(..., example="Pending")
    uploaded_by: str = Field(..., example="employee_123")
    uploaded_date: str = Field(..., example="2026-02-01")
    approved_by: Optional[str] = Field(None, example="manager_456")
    approval_date: Optional[str] = Field(None, example="2026-02-05")
    comments: Optional[str] = Field(None, example="Initial draft")

class DocumentUpdate(BaseModel):
    doc_type: Optional[str] = None
    name: Optional[str] = None
    version: Optional[str] = None
    file_path: Optional[str] = None
    status: Optional[str] = None
    approved_by: Optional[str] = None
    approval_date: Optional[str] = None
    comments: Optional[str] = None

class DocumentResponse(BaseModel):
    document_id: str

# --- Risks ---

class RiskCreate(BaseModel):
    project_id: str
    description: str
    category: str
    likelihood: str
    impact: str
    mitigation_plan: str
    status: str
    identified_by: str
    date_identified: str
    date_resolved: Optional[str] = None

class RiskUpdate(BaseModel):
    description: Optional[str] = None
    category: Optional[str] = None
    likelihood: Optional[str] = None
    impact: Optional[str] = None
    mitigation_plan: Optional[str] = None
    status: Optional[str] = None
    date_resolved: Optional[str] = None

class RiskResponse(BaseModel):
    risk_id: str

# -------------------
# ENDPOINTS New Project
# -------------------

# --- Endpoints ---



# 0 Add Client
@app.post("/sql/clients/add", tags=["New"],) 
def add_client_endpoint(data: AddClientModel):
    # Appel à la fonction qui insère le client dans la base de données
    client_id = sql.add_client(**data.dict())
    return {"client_id": client_id}   


# 1. Add Project
@app.post("/sql/projects/add" ,tags=["New"])
def add_project_endpoint(data: AddProjectModel):
    project_id = sql.add_project(**data.dict())
    return {"project_id": project_id}


#.2. AddPhase
@app.post("/sql/phases/add", tags=["New"])
def add_phase_endpoint(data: AddProjectPhaseModel):
    # # Vérification que le projet existe
    # project_exists = sql.check_project_exists(data.project_id)
    # if not project_exists:
    #     raise HTTPException(status_code=400, detail="Project ID inconnu")

    phase_id = sql.add_table("PROJECT_PHASE", **data.dict())
    return {"phase_id": phase_id}

# AddTask
@app.post("/sql/tasks/add", tags=["New"])
def add_task_endpoint(data: AddTaskModel):
    # # Vérification que la phase existe dans la table des phases
    # phase_exists = sql.check_phase_exists(data.PhaseID)
    # if not phase_exists:
    #     raise HTTPException(status_code=400, detail="Phase ID inconnu")

    task_id = sql.add_table("tasks", **data.dict())
    return {"task_id": task_id}

# AssignEmployeeToProject
@app.post("/sql/assign_employee_to_project", tags=["New"])
def assign_employee_to_project_endpoint(data: AssignEmployeeToProjectModel):
    # # Vérification que le projet existe
    # project_exists = sql.check_project_exists(data.ProjectID)
    # if not project_exists:
    #     raise HTTPException(status_code=400, detail="Project ID inconnu")

    assignment_id = sql.add_table("project_team", **data.dict())
    return {"assignment_id": assignment_id}

# 10. Update Budget
@app.put("/sql/budgets/update", tags=["New"])
def update_budget_endpoint(data: UpdateBudgetModel):
    sql.update_budget(**data.dict())
    return {"message": "Budget updated"}

# AddMilestone
@app.post("/sql/milestones/add", tags=["New"])
def add_milestone_endpoint(data: AddMilestoneModel):
    # # Vérification que le projet existe
    # project_exists = sql.check_project_exists(data.ProjectID)
    # if not project_exists:
    #     raise HTTPException(status_code=400, detail="Project ID inconnu")

    milestone_id = sql.add_table("milestones", **data.dict())
    return {"milestone_id": milestone_id}


# AddContractor
@app.post("/sql/contractors/add", tags=["New"])
def add_contractor_endpoint(data: AddContractorModel):
    # # Vérification que le contractor est valide (optionnel)
    # contractor_exists = sql.check_contractor_exists(data.contact_email)
    # if not contractor_exists:
    #     raise HTTPException(status_code=400, detail="Contractor Email inconnu")

    contractor_id = sql.add_table("contractors", **data.dict())
    return {"contractor_id": contractor_id}

@app.post("/sql/project_contractors/add", tags=["New"])
def add_project_contractor_endpoint(data: AddProjectContractorModel):
    # # Vérification que le projet existe
    # project_exists = sql.check_project_exists(data.ProjectID)
    # if not project_exists:
    #     raise HTTPException(status_code=400, detail="Project ID inconnu")

    project_contractor_id = sql.add_table("project_contractors", **data.dict())
    return {"project_contractor_id": project_contractor_id}

# AddSupplier
@app.post("/sql/suppliers/add", tags=["New"])
def add_supplier_endpoint(data: AddSupplierModel):
    supplier_id = sql.add_table("suppliers", **data.dict())
    return {"supplier_id": supplier_id}

# AddMaterial
@app.post("/sql/materials/add", tags=["New"])
def add_material_endpoint(data: AddMaterialModel):
    # # Vérification que le fournisseur existe
    # supplier_exists = sql.check_supplier_exists(data.SupplierID)
    # if not supplier_exists:
    #     raise HTTPException(status_code=400, detail="Supplier ID inconnu")

    material_id = sql.add_table("materials", **data.dict())
    return {"material_id": material_id}

# AddEquipment
@app.post("/sql/equipments/add", tags=["New"])
def add_equipment_endpoint(data: AddEquipmentModel):
    equipment_id = sql.add_table("equipment", **data.dict())
    return {"equipment_id": equipment_id}

# AddMaintenanceSchedule
@app.post("/sql/maintenance_schedules/add", tags=["New"])
def add_maintenance_schedule_endpoint(data: AddMaintenanceScheduleModel):
    maintenance_schedule_id = sql.add_table("maintenance_schedules", **data.dict())
    return {"maintenance_schedule_id": maintenance_schedule_id}

# AddSafetyInspection
@app.post("/sql/safety_inspections/add", tags=["New"])
def add_safety_inspection_endpoint(data: AddSafetyInspectionModel):
    # # Vérification que le projet existe
    # project_exists = sql.check_project_exists(data.ProjectID)
    # if not project_exists:
    #     raise HTTPException(status_code=400, detail="Project ID inconnu")

    inspection_id = sql.add_table("safety_inspections", **data.dict())
    return {"inspection_id": inspection_id}

# AddSafetyCompliance
@app.post("/sql/safety_compliance/add", tags=["New"])
def add_safety_compliance_endpoint(data: AddSafetyComplianceModel):
    safety_compliance_id = sql.add_table("safety_compliance", **data.dict())
    return {"safety_compliance_id": safety_compliance_id}

# AddSiteEmployee
@app.post("/sql/site_employees/add", tags=["New"])
def add_site_employee_endpoint(data: AddSiteEmployeeModel):
    site_employee_id = sql.add_table("site_employees", **data.dict())
    return {"site_employee_id": site_employee_id}

# -------------------
# ENDPOINTS PAYMENTS
# -------------------

@app.post("/payments/", response_model=PaymentResponse, tags=["Payments"], summary="Créer un paiement")
def create_payment_endpoint(payment: PaymentCreate):
    payment_id = payments.create_payment(**payment.dict())
    return {"payment_id": payment_id}

@app.get("/payments/{payment_id}", response_model=Dict[str, Any], tags=["Payments"], summary="Obtenir un paiement par ID")
def get_payment_endpoint(payment_id: str):
    payment_data = payments.get_payment_by_id(payment_id)
    if not payment_data:
        raise HTTPException(status_code=404, detail="Payment not found")
    return payment_data

@app.get("/payments/", response_model=List[Dict[str, Any]], tags=["Payments"])
def get_payments_endpoint(project_id: Optional[str] = None, status: Optional[str] = None):
    filter = {}
    if project_id:
        filter["project_id"] = project_id
    if status:
        filter["status"] = status
    return payments.get_payments(filter)


@app.put("/payments/{payment_id}", response_model=Dict[str, int], tags=["Payments"], summary="Mettre à jour un paiement")
def update_payment_endpoint(payment_id: str, updates: PaymentUpdate):
    updated_count = payments.update_payment(payment_id, updates.dict(exclude_unset=True))
    if updated_count == 0:
        raise HTTPException(status_code=404, detail="Payment not found or no changes applied")
    return {"updated_count": updated_count}

@app.delete("/payments/{payment_id}", response_model=Dict[str, int], tags=["Payments"], summary="Supprimer un paiement")
def delete_payment_endpoint(payment_id: str):
    deleted_count = payments.delete_payment(payment_id)
    if deleted_count == 0:
        raise HTTPException(status_code=404, detail="Payment not found")
    return {"deleted_count": deleted_count}

@app.get(
    "/payments/project/{project_id}/total",
    response_model=PaymentTotalResponse,
    tags=["Payments"],
    summary="Obtenir le total des paiements par projet"
)
def get_total_payments_by_project_endpoint(project_id: str):
    total = payments.get_total_payments_by_project(project_id)

    return {
        "project_id": project_id,
        "total_amount": total
    }


# -------------------
# ENDPOINTS DOCUMENTS
# -------------------


@app.post("/documents/", response_model=DocumentResponse, tags=["Documents"], summary="Créer un document")
def create_document_endpoint(document: DocumentCreate):
    document_id = documents.create_document(**document.dict())
    return {"document_id": document_id}


@app.get("/documents/{document_id}", response_model=Dict[str, Any], tags=["Documents"], summary="Obtenir un document par ID")
def get_document_endpoint(document_id: str):
    doc_data = documents.get_document_by_id(document_id)
    if not doc_data:
        raise HTTPException(status_code=404, detail="Document not found")
    return doc_data


@app.get("/documents/", response_model=List[Dict[str, Any]], tags=["Documents"], summary="Lister tous les documents")
def get_documents_endpoint(project_id: Optional[str] = None, client_id: Optional[str] = None, status: Optional[str] = None):
    filter = {}
    if project_id:
        filter["project_id"] = project_id
    if client_id:
        filter["client_id"] = client_id
    if status:
        filter["status"] = status
    return documents.get_documents(filter)


@app.put("/documents/{document_id}", response_model=Dict[str, int], tags=["Documents"], summary="Mettre à jour un document")
def update_document_endpoint(document_id: str, updates: DocumentUpdate):
    updated_count = documents.update_document(document_id, updates.dict(exclude_unset=True))
    if updated_count == 0:
        raise HTTPException(status_code=404, detail="Document not found or no changes applied")
    return {"updated_count": updated_count}


@app.delete("/documents/{document_id}", response_model=Dict[str, int], tags=["Documents"], summary="Supprimer un document")
def delete_document_endpoint(document_id: str):
    deleted_count = documents.delete_document(document_id)
    if deleted_count == 0:
        raise HTTPException(status_code=404, detail="Document not found")
    return {"deleted_count": deleted_count}

@app.get("/documents-by-project/{project_id}", response_model=List[Dict[str, Any]], tags=["Documents"], summary="Documents par projet")
def get_documents_by_project_endpoint(project_id: str):
    return documents.get_documents_by_project(project_id)


@app.get("/documents-by-client/{client_id}", response_model=List[Dict[str, Any]], tags=["Documents"], summary="Documents par client")
def get_documents_by_client_endpoint(client_id: str):
    return documents.get_documents_by_client(client_id)


@app.get("/recent-documents-by-project/{project_id}", response_model=List[Dict[str, Any]], tags=["Documents"], summary="Derniers documents d'un projet")
def recent_documents_by_project_endpoint(project_id: str, limit: int = 10):
    return documents.get_recent_documents_by_project(project_id, limit)


@app.get("/recent-documents-by-client/{client_id}", response_model=List[Dict[str, Any]], tags=["Documents"], summary="Derniers documents d'un client")
def recent_documents_by_client_endpoint(client_id: str, limit: int = 10):
    return documents.get_recent_documents_by_client(client_id, limit)



# -------------------
# ENDPOINTS RISKS
# -------------------

# --- Endpoints ---

@app.post("/risks/", response_model=RiskResponse, tags=["Risks"], summary="Créer un risque")
def create_risk_endpoint(risk: RiskCreate):
    risk_id = risks.create_risk(**risk.dict())
    return {"risk_id": risk_id}


@app.get("/risks/{risk_id}", response_model=dict, tags=["Risks"], summary="Obtenir un risque par ID")
def get_risk_endpoint(risk_id: str):
    risk_data = risks.get_risk_by_id(risk_id)
    if not risk_data:
        raise HTTPException(status_code=404, detail="Risk not found")
    return risk_data


@app.get("/risks/", response_model=list[dict], tags=["Risks"], summary="Lister tous les risques")
def get_risks_endpoint(project_id: Optional[str] = None, status: Optional[str] = None):
    filter = {}
    if project_id:
        filter["project_id"] = project_id
    if status:
        filter["status"] = status
    return risks.get_risks(filter)


@app.put("/risks/{risk_id}", response_model=dict, tags=["Risks"], summary="Mettre à jour un risque")
def update_risk_endpoint(risk_id: str, updates: RiskUpdate):
    updated_count = risks.update_risk(risk_id, updates.dict(exclude_unset=True))
    if updated_count == 0:
        raise HTTPException(status_code=404, detail="Risk not found or no changes applied")
    return {"updated_count": updated_count}


@app.delete("/risks/{risk_id}", response_model=dict, tags=["Risks"], summary="Supprimer un risque")
def delete_risk_endpoint(risk_id: str):
    deleted_count = risks.delete_risk(risk_id)
    if deleted_count == 0:
        raise HTTPException(status_code=404, detail="Risk not found")
    return {"deleted_count": deleted_count}


@app.get("/open-risks/{project_id}", response_model=list[dict], tags=["Risks"], summary="Risques ouverts par projet")
def open_risks_by_project_endpoint(project_id: str):
    return risks.get_open_risks_by_project(project_id)


@app.get("/recent-risks/{project_id}", response_model=list[dict], tags=["Risks"], summary="Derniers risques identifiés d'un projet")
def recent_risks_by_project_endpoint(project_id: str, limit: int = 10):
    return risks.get_recent_risks_by_project(project_id, limit)
