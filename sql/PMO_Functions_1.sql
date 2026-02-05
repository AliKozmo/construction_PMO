USE PMO_DB;
GO

-- =========================
--1 Function: Projects by Client
-- =========================
CREATE FUNCTION fn_ProjectsByClient(@ClientID INT)
RETURNS TABLE
AS
RETURN
SELECT 
    p.project_id, p.project_code, p.name AS project_name, p.start_date, p.end_date, p.status, p.location,
    p.description
FROM PROJECT p
WHERE p.client_id = @ClientID;
GO

-- =========================
--2 Function: Tasks by Project
-- =========================
CREATE FUNCTION fn_TasksByProject(@ProjectID INT)
RETURNS TABLE
AS
RETURN
SELECT 
    t.task_id, t.description AS task_description, ph.phase_name, e.name AS assigned_employee, disc.discipline_name,
    t.start_date, t.end_date, t.status, t.completion_percentage, t.priority
FROM TASK t
JOIN PROJECT_PHASE ph ON t.phase_id = ph.phase_id
JOIN PROJECT p ON ph.project_id = p.project_id
LEFT JOIN EMPLOYEE e ON t.assigned_to = e.employee_id
JOIN DISCIPLINE disc ON t.discipline_id = disc.discipline_id
WHERE p.project_id = @ProjectID;
GO

-- =========================
--3 Function: Tasks by Employee
-- =========================
CREATE FUNCTION fn_TasksByEmployee(@EmployeeID INT)
RETURNS TABLE
AS
RETURN
SELECT 
    t.task_id, t.description AS task_description, p.name AS project_name, ph.phase_name, disc.discipline_name,
    t.start_date, t.end_date, t.status, t.completion_percentage, t.priority
FROM TASK t
JOIN PROJECT_PHASE ph ON t.phase_id = ph.phase_id
JOIN PROJECT p ON ph.project_id = p.project_id
JOIN DISCIPLINE disc ON t.discipline_id = disc.discipline_id
WHERE t.assigned_to = @EmployeeID;
GO

-- =========================
--4 Function: Milestones by Project
-- =========================
CREATE FUNCTION fn_MilestonesByProject(@ProjectID INT)
RETURNS TABLE
AS
RETURN
SELECT 
    m.milestone_id, m.name AS milestone_name, m.description, m.due_date, m.status, m.achieved_date,
    e.name AS responsible_employee
FROM MILESTONE m
LEFT JOIN EMPLOYEE e ON m.responsible_employee_id = e.employee_id
WHERE m.project_id = @ProjectID;
GO

-- =========================
--5 Function: Milestones by Employee
-- =========================
CREATE FUNCTION fn_MilestonesByEmployee(@EmployeeID INT)
RETURNS TABLE
AS
RETURN
SELECT 
    m.milestone_id, m.name AS milestone_name, p.name AS project_name, m.description, m.due_date, m.status,
    m.achieved_date
FROM MILESTONE m
JOIN PROJECT p ON m.project_id = p.project_id
WHERE m.responsible_employee_id = @EmployeeID;
GO

-- =========================
--6 Function: Budget by Project
-- =========================
CREATE FUNCTION dbo.fn_ProjectBudgetById (@ProjectId INT)
RETURNS TABLE
AS
RETURN
(
    SELECT
        p.project_id, p.project_code, p.name AS project_name, p.status, b.allocated_amount, b.spent_amount,
        (b.allocated_amount - b.spent_amount) AS remaining_amount
    FROM PROJECT p
    JOIN BUDGET b
        ON p.project_id = b.project_id
    WHERE p.project_id = @ProjectId
);
GO

-- =========================
--7 Function: Equipment by Project
-- =========================
CREATE FUNCTION fn_EquipmentByProject(@ProjectID INT)
RETURNS TABLE
AS
RETURN
SELECT 
    equipment_id, name AS equipment_name, type, location, status, purchase_date, vendor_id, cost,
    is_rented, rental_start_date, rental_end_date
FROM EQUIPMENT
WHERE project_id = @ProjectID;
GO

-- =========================
--8 Function: Safety Compliance by Project
-- =========================
CREATE FUNCTION fn_SafetyByProject(@ProjectID INT)
RETURNS TABLE
AS
RETURN
SELECT 
    safety_id, inspection_date, inspector_id, type, status, description, corrective_action, completion_date
FROM SAFETY_COMPLIANCE
WHERE project_id = @ProjectID;
GO

-- =========================
--9 Function: Maintenance by Equipment
-- =========================
CREATE FUNCTION fn_MaintenanceByEquipment(@EquipmentID INT)
RETURNS TABLE
AS
RETURN
SELECT 
    schedule_id, maintenance_type, scheduled_date, performed_by, status, remarks
FROM MAINTENANCE_SCHEDULE
WHERE equipment_id = @EquipmentID;
GO

--10 Project Dashboard Function

CREATE FUNCTION fn_ProjectDashboard (@ProjectID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT
        p.project_id, p.project_code, p.name AS project_name, p.start_date AS project_start,
        p.end_date AS project_end, p.status AS project_status, p.location, p.description AS project_description,
        
        -- Budget info
        b.allocated_amount,
        b.spent_amount,
        CASE 
            WHEN b.allocated_amount = 0 THEN 0
            ELSE CAST((b.spent_amount * 100.0 / b.allocated_amount) AS DECIMAL(5,2))
        END AS budget_used_percentage,

        -- Phase info
        ph.phase_name,
        ph.start_date AS phase_start,
        ph.end_date AS phase_end,
        ph.status AS phase_status,
        d.discipline_name AS phase_discipline,

        -- Task summary per project (cumulative)
        ISNULL(task_summary.total_tasks,0) AS total_tasks,
        ISNULL(task_summary.completed_tasks,0) AS completed_tasks,
        ISNULL(task_summary.completion_percentage,0) AS tasks_completion_percentage

    FROM PROJECT p
    LEFT JOIN BUDGET b ON b.project_id = p.project_id
    LEFT JOIN PROJECT_PHASE ph ON ph.project_id = p.project_id
    LEFT JOIN DISCIPLINE d ON d.discipline_id = ph.discipline_id
    OUTER APPLY
    (
        SELECT 
            COUNT(t.task_id) AS total_tasks,
            SUM(CASE WHEN t.status = 'Completed' THEN 1 ELSE 0 END) AS completed_tasks,
            CASE 
                WHEN COUNT(t.task_id) = 0 THEN 0
                ELSE CAST(SUM(CASE WHEN t.status = 'Completed' THEN 1 ELSE 0 END) * 100.0 / COUNT(t.task_id) AS DECIMAL(5,2))
            END AS completion_percentage
        FROM PROJECT_PHASE ph2
        LEFT JOIN TASK t ON t.phase_id = ph2.phase_id
        WHERE ph2.project_id = @ProjectID
    ) AS task_summary
    WHERE p.project_id = @ProjectID
);
GO
