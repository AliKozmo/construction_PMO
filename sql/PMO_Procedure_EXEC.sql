USE PMO_DB;
GO

-- 1 Add a new project
EXEC sp_AddProject
    @project_code = 'PRJ001',
    @name = 'New Office Construction',
    @client_id = 1,
    @start_date = '2026-03-01',
    @end_date = '2026-12-31',
    @status = 'Active',
    @location = 'New York',
    @description = 'Construction of a new corporate office',
    @allocated_budget = 1000000,
    @budget_category = 'Construction';
GO

-- 2 Update project status
EXEC sp_UpdateProjectStatus
    @ProjectID = 1,
    @Status = 'In Progress';
GO

-- 3 Delete a project
-- EXEC sp_DeleteProject @ProjectID = 2; -- Uncomment to test
GO

-- 4 Add a new task
EXEC sp_AddTask
    @PhaseID = 1,
    @AssignedTo = 2,
    @Description = 'Install electrical wiring',
    @DisciplineID = 3,
    @StartDate = '2026-03-05',
    @EndDate = '2026-03-20',
    @Status = 'In Progress',
    @CompletionPercentage = 10,
    @Priority = 'High';
GO

-- 5 Update task status
EXEC sp_UpdateTaskStatus
    @TaskID = 1,
    @Status = 'Completed',
    @CompletionPercentage = 100;
GO

-- 6 Add a new employee
EXEC sp_AddEmployee
    @Name = 'John Doe',
    @Email = 'john.doe@example.com',
    @Phone = '1234567890',
    @DisciplineID = 2,
    @DepartmentID = 1,
    @HireDate = '2026-01-15',
    @Status = 'Active';
GO

-- 7 Assign employee to project
EXEC sp_AssignEmployeeToProject
    @ProjectID = 1,
    @EmployeeID = 2,
    @RoleID = 1,
    @StartDate = '2026-03-01',
    @EndDate = '2026-12-31';
GO

-- 8 Assign contractor to project
EXEC sp_AssignContractorToProject
    @ProjectID = 1,
    @ContractorID = 1,
    @ContractValue = 500000,
    @StartDate = '2026-03-01',
    @EndDate = '2026-12-31',
    @ScopeOfWork = 'Electrical and plumbing works';
GO

-- 9 Add a new material
EXEC sp_AddMaterial
    @Name = 'Cement',
    @Description = 'Portland cement 50kg bags',
    @Unit = 'Bag',
    @UnitCost = 12.5,
    @SupplierID = 1,
    @StockQuantity = 1000;
GO

-- 10 Update budget
EXEC sp_UpdateBudget
    @BudgetID = 1,
    @AllocatedAmount = 1200000,
    @SpentAmount = 300000;
GO

-- 11 Add a new milestone
EXEC sp_AddMilestone
    @ProjectID = 1,
    @Name = 'Foundation Complete',
    @Description = 'Complete the building foundation',
    @DueDate = '2026-04-30',
    @Status = 'In Progress',
    @ResponsibleEmployeeID = 2;
GO

-- 12 Add safety inspection
EXEC sp_AddSafetyInspection
    @ProjectID = 1,
    @InspectionDate = '2026-03-10',
    @InspectorID = 3,
    @Type = 'Electrical Safety',
    @Status = 'Pending',
    @Description = 'Check wiring safety in construction site';
GO
