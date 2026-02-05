USE PMO_DB;
GO

----- Functions usage:

-- 1. Projects by Client
SELECT * FROM dbo.fn_ProjectsByClient(1);
GO

-- 2. Tasks by Project
SELECT * FROM dbo.fn_TasksByProject(1);
GO

-- 3. Tasks by Employee
SELECT * FROM dbo.fn_TasksByEmployee(2);
GO

-- 4. Milestones by Project
SELECT * FROM dbo.fn_MilestonesByProject(1);
GO

-- 5. Milestones by Employee
SELECT * FROM dbo.fn_MilestonesByEmployee(2);
GO

-- 6. Budget by Project
SELECT * FROM dbo.fn_ProjectBudgetById(3);
-- 7. Equipment by Project
SELECT * FROM dbo.fn_EquipmentByProject(1);
GO

-- 8. Safety Compliance by Project
SELECT * FROM dbo.fn_SafetyByProject(1);
GO

-- 9. Maintenance by Equipment
SELECT * FROM dbo.fn_MaintenanceByEquipment(1);
GO

-- 10. Project Dashboard
SELECT * FROM dbo.fn_ProjectDashboard(13);
GO
