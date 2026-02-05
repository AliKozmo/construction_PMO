USE PMO_DB;
GO

-- =========================
--1 VIEW: All Projects
-- =========================
CREATE VIEW vw_AllProjects AS
SELECT 
    p.project_id, p.project_code, p.name AS project_name, c.name AS client_name, p.start_date, p.end_date,
    p.status, p.location, p.description
FROM PROJECT p
JOIN CLIENT c ON p.client_id = c.client_id;
GO

-- =========================
--2 VIEW: All Employees
-- =========================
CREATE VIEW vw_AllEmployees AS
SELECT 
    e.employee_id, e.name AS employee_name, e.email, e.phone,
    d.name AS department_name, disc.discipline_name, e.hire_date, e.status
FROM EMPLOYEE e
JOIN DEPARTMENT d ON e.department_id = d.department_id
JOIN DISCIPLINE disc ON e.discipline_id = disc.discipline_id;
GO

-- =========================
--3 VIEW: All Project Teams
-- =========================
CREATE VIEW vw_AllProjectTeams AS
SELECT 
    pt.project_team_id, p.name AS project_name, e.name AS employee_name, r.role_name, pt.start_date,
    pt.end_date
FROM PROJECT_TEAM pt
JOIN PROJECT p ON pt.project_id = p.project_id
JOIN EMPLOYEE e ON pt.employee_id = e.employee_id
JOIN ROLE r ON pt.role_id = r.role_id;
GO

-- =========================
--4 VIEW: All Tasks
-- =========================
CREATE VIEW vw_AllTasks AS
SELECT 
    t.task_id, t.description AS task_description, ph.phase_name, p.name AS project_name, t.assigned_to,
    e.name AS assigned_employee, disc.discipline_name, t.start_date, t.end_date, t.status,
    t.completion_percentage, t.priority
FROM TASK t
JOIN PROJECT_PHASE ph ON t.phase_id = ph.phase_id
JOIN PROJECT p ON ph.project_id = p.project_id
LEFT JOIN EMPLOYEE e ON t.assigned_to = e.employee_id
JOIN DISCIPLINE disc ON t.discipline_id = disc.discipline_id;
GO

-- =========================
--5 VIEW: All Milestones
-- =========================
CREATE VIEW vw_AllMilestones AS
SELECT 
    m.milestone_id, m.name AS milestone_name, p.name AS project_name, m.description, m.due_date, m.status,
    m.achieved_date, e.name AS responsible_employee
FROM MILESTONE m
JOIN PROJECT p ON m.project_id = p.project_id
LEFT JOIN EMPLOYEE e ON m.responsible_employee_id = e.employee_id;
GO

-- =========================
--6 VIEW: All Budgets
-- =========================
CREATE VIEW vw_AllBudgets AS
SELECT 
    b.budget_id, p.name AS project_name, b.allocated_amount, b.spent_amount, b.budget_category, b.last_updated
FROM BUDGET b
JOIN PROJECT p ON b.project_id = p.project_id;
GO

-- =========================
--7 VIEW: All Contractors
-- =========================
CREATE VIEW vw_AllContractors AS
SELECT *
FROM CONTRACTOR;
GO

-- =========================
--8 VIEW: All Project Contractors
-- =========================
CREATE VIEW vw_AllProjectContractors AS
SELECT 
    pc.project_id, p.name AS project_name, pc.contractor_id, c.company_name AS contractor_name,
    pc.contract_value, pc.start_date, pc.end_date, pc.scope_of_work
FROM PROJECT_CONTRACTOR pc
JOIN PROJECT p ON pc.project_id = p.project_id
JOIN CONTRACTOR c ON pc.contractor_id = c.contractor_id;
GO

-- =========================
--9 VIEW: All Suppliers
-- =========================
CREATE VIEW vw_AllSuppliers AS
SELECT *
FROM SUPPLIER;
GO

-- =========================
--10 VIEW: All Materials
-- =========================
CREATE VIEW vw_AllMaterials AS
SELECT 
    m.material_id, m.name AS material_name, m.description, m.unit, m.unit_cost,
    s.company_name AS supplier_name, m.stock_quantity
FROM MATERIAL m
JOIN SUPPLIER s ON m.supplier_id = s.supplier_id;
GO

-- =========================
--11 VIEW: All Equipment
-- =========================
CREATE VIEW vw_AllEquipment AS
SELECT 
    eq.equipment_id, eq.name AS equipment_name, eq.type, p.name AS project_name, eq.location,
    eq.status, eq.purchase_date, eq.vendor_id, eq.cost, eq.is_rented, eq.rental_start_date,
    eq.rental_end_date
FROM EQUIPMENT eq
JOIN PROJECT p ON eq.project_id = p.project_id;
GO

-- =========================
--12 VIEW: All Safety Compliance
-- =========================
CREATE VIEW vw_AllSafetyCompliance AS
SELECT 
    sc.safety_id, p.name AS project_name, sc.inspection_date, e.name AS inspector_name, sc.type,
    sc.status, sc.description, sc.corrective_action, sc.completion_date
FROM SAFETY_COMPLIANCE sc
JOIN PROJECT p ON sc.project_id = p.project_id
JOIN EMPLOYEE e ON sc.inspector_id = e.employee_id;
GO

-- =========================
--13 VIEW: All Maintenance Schedules
-- =========================
CREATE VIEW vw_AllMaintenanceSchedules AS
SELECT 
    ms.schedule_id, eq.name AS equipment_name, ms.maintenance_type, ms.scheduled_date,
    e.name AS performed_by_name, ms.status, ms.remarks
FROM MAINTENANCE_SCHEDULE ms
JOIN EQUIPMENT eq ON ms.equipment_id = eq.equipment_id
JOIN EMPLOYEE e ON ms.performed_by = e.employee_id;
GO

-- =========================
--14 VIEW: All Site Employees
-- =========================
CREATE VIEW vw_AllSiteEmployees AS
SELECT 
    se.employee_id, e.name AS employee_name, se.company, se.site_id, se.date_of_end_of_contract
FROM SITE_EMPLOYEE se
JOIN EMPLOYEE e ON se.employee_id = e.employee_id;
GO

--15 View: Project Progress Summary

CREATE VIEW vw_ProjectProgressSummary AS
SELECT 
    p.project_id, p.project_code, p.name AS project_name,
    COUNT(t.task_id) AS total_tasks,
    SUM(CASE WHEN t.status = 'Completed' THEN 1 ELSE 0 END) AS completed_tasks,
    CASE 
        WHEN COUNT(t.task_id) = 0 THEN 0
        ELSE CAST(SUM(CASE WHEN t.status = 'Completed' THEN 1 ELSE 0 END) * 100.0 / COUNT(t.task_id) AS DECIMAL(5,2))
    END AS completion_percentage
FROM PROJECT p
LEFT JOIN PROJECT_PHASE ph ON ph.project_id = p.project_id
LEFT JOIN TASK t ON t.phase_id = ph.phase_id
GROUP BY p.project_id, p.project_code, p.name;
GO

--16 View: Contractor Engagements Summary

CREATE VIEW vw_ContractorEngagements AS
SELECT 
    c.contractor_id, c.company_name AS contractor_name, p.project_code, p.name AS project_name,
    pc.contract_value, pc.start_date AS contract_start, pc.end_date AS contract_end, pc.scope_of_work
FROM CONTRACTOR c
INNER JOIN PROJECT_CONTRACTOR pc ON pc.contractor_id = c.contractor_id
INNER JOIN PROJECT p ON p.project_id = pc.project_id;
GO

--17 View: Materials Stock Status

CREATE VIEW vw_MaterialsStock AS
SELECT 
    m.material_id, m.name AS material_name, m.description, m.unit, m.unit_cost,
    s.company_name AS supplier_name, m.stock_quantity
FROM MATERIAL m
INNER JOIN SUPPLIER s ON s.supplier_id = m.supplier_id;
GO

--18 View: Project Phase Status Summary

CREATE VIEW vw_ProjectPhaseStatus AS
SELECT 
    ph.phase_id, ph.phase_name, p.project_code, p.name AS project_name, ph.discipline_id, d.discipline_name,
    ph.start_date, ph.end_date, ph.status
FROM PROJECT_PHASE ph
INNER JOIN PROJECT p ON p.project_id = ph.project_id
INNER JOIN DISCIPLINE d ON d.discipline_id = ph.discipline_id;
GO

-- 19 view clients

CREATE VIEW vw_AllClients
AS
SELECT
    client_id, name, company_name, email, phone, address, contact_person
FROM CLIENT;
GO