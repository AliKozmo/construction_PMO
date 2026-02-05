USE PMO_DB;
GO

-- =========================
-- EMPLOYEE
-- =========================
-- Unique index on email (optional, but good for fast lookup)
CREATE UNIQUE INDEX IX_EMPLOYEE_EMAIL
ON EMPLOYEE(email);

-- Index on department_id for fast joins with DEPARTMENT
CREATE INDEX IX_EMPLOYEE_DEPARTMENT
ON EMPLOYEE(department_id);

-- =========================
-- PROJECT
-- =========================
-- Lookup projects by project_code
CREATE UNIQUE INDEX IX_PROJECT_PROJECT_CODE
ON PROJECT(project_code);

-- Lookup projects by client
CREATE INDEX IX_PROJECT_CLIENT
ON PROJECT(client_id);

-- Lookup projects by status (for dashboards, reports)
CREATE INDEX IX_PROJECT_STATUS
ON PROJECT(status);
GO

-- =========================
-- PROJECT_PHASE
-- =========================
-- Lookup phases by project
CREATE INDEX IX_PROJECT_PHASE_PROJECT
ON PROJECT_PHASE(project_id);

-- Lookup phases by discipline
CREATE INDEX IX_PROJECT_PHASE_DISCIPLINE
ON PROJECT_PHASE(discipline_id);

-- Lookup phases by status
CREATE INDEX IX_PROJECT_PHASE_STATUS
ON PROJECT_PHASE(status);
GO

-- =========================
-- TASK
-- =========================
-- Lookup tasks by phase
CREATE INDEX IX_TASK_PHASE
ON TASK(phase_id);

-- Lookup tasks by assigned employee
CREATE INDEX IX_TASK_ASSIGNED_TO
ON TASK(assigned_to);

-- Lookup tasks by status
CREATE INDEX IX_TASK_STATUS
ON TASK(status);

-- Combined index for frequent query: "tasks by phase AND assigned_to"
CREATE INDEX IX_TASK_PHASE_ASSIGNED
ON TASK(phase_id, assigned_to);
GO

-- =========================
-- CONTRACTOR & PROJECT_CONTRACTOR
-- =========================
-- Lookup contractors by company_name
CREATE INDEX IX_CONTRACTOR_COMPANY
ON CONTRACTOR(company_name);

-- Lookup projects' contractors by project
CREATE INDEX IX_PROJECT_CONTRACTOR_PROJECT
ON PROJECT_CONTRACTOR(project_id);

-- Lookup projects' contractors by contractor
CREATE INDEX IX_PROJECT_CONTRACTOR_CONTRACTOR
ON PROJECT_CONTRACTOR(contractor_id);
GO

-- =========================
-- SUPPLIER & MATERIAL
-- =========================
-- Lookup suppliers by company_name
CREATE INDEX IX_SUPPLIER_COMPANY
ON SUPPLIER(company_name);

-- Lookup materials by supplier
CREATE INDEX IX_MATERIAL_SUPPLIER
ON MATERIAL(supplier_id);

-- Lookup materials by name (optional for search)
CREATE INDEX IX_MATERIAL_NAME
ON MATERIAL(name);
GO

-- =========================
-- BUDGET
-- =========================
-- Lookup budget by project
CREATE INDEX IX_BUDGET_PROJECT
ON BUDGET(project_id);
GO

-- =========================
-- PROJECT_TEAM
-- =========================
-- Lookup team members by project
CREATE INDEX IX_PROJECT_TEAM_PROJECT
ON PROJECT_TEAM(project_id);

-- Lookup team members by employee
CREATE INDEX IX_PROJECT_TEAM_EMPLOYEE
ON PROJECT_TEAM(employee_id);
GO

-- =========================
-- MILESTONE
-- =========================
-- Lookup milestones by project
CREATE INDEX IX_MILESTONE_PROJECT
ON MILESTONE(project_id);

-- Lookup milestones by status
CREATE INDEX IX_MILESTONE_STATUS
ON MILESTONE(status);
GO

-- =========================
-- EQUIPMENT
-- =========================
-- Lookup equipment by project
CREATE INDEX IX_EQUIPMENT_PROJECT
ON EQUIPMENT(project_id);

-- Lookup equipment by status
CREATE INDEX IX_EQUIPMENT_STATUS
ON EQUIPMENT(status);

-- Combined index for project AND status
CREATE INDEX IX_EQUIPMENT_PROJECT_STATUS
ON EQUIPMENT(project_id, status);
GO

-- =========================
-- MAINTENANCE_SCHEDULE
-- =========================
-- Lookup maintenance schedules by equipment
CREATE INDEX IX_MS_EQUIPMENT
ON MAINTENANCE_SCHEDULE(equipment_id);

-- Lookup maintenance schedules by performed_by employee
CREATE INDEX IX_MS_EMPLOYEE
ON MAINTENANCE_SCHEDULE(performed_by);
GO

-- =========================
-- SAFETY_COMPLIANCE
-- =========================
-- Lookup safety inspections by project
CREATE INDEX IX_SAFETY_PROJECT
ON SAFETY_COMPLIANCE(project_id);

-- Lookup safety inspections by inspector
CREATE INDEX IX_SAFETY_INSPECTOR
ON SAFETY_COMPLIANCE(inspector_id);

-- Lookup safety inspections by status
CREATE INDEX IX_SAFETY_STATUS
ON SAFETY_COMPLIANCE(status);
GO

-- =========================
-- SITE_EMPLOYEE
-- =========================
-- Lookup site employees by site_id
CREATE INDEX IX_SITE_EMPLOYEE_SITE
ON SITE_EMPLOYEE(site_id);
GO
