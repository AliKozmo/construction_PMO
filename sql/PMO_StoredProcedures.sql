USE PMO_DB;
GO

-- 1 Add Project
CREATE PROCEDURE sp_AddProject
    @project_code NVARCHAR(50),
    @name NVARCHAR(100),
    @client_id INT,
    @start_date DATE,
    @end_date DATE,
    @status NVARCHAR(20),
    @location NVARCHAR(100),
    @description NVARCHAR(MAX),
    @allocated_budget DECIMAL(18,2) = NULL,
    @budget_category NVARCHAR(50) = NULL
AS
BEGIN
    INSERT INTO PROJECT (project_code, name, client_id, start_date, end_date, status, location, description)
    VALUES (@project_code, @name, @client_id, @start_date, @end_date, @status, @location, @description);

    DECLARE @project_id INT = SCOPE_IDENTITY();

    IF @allocated_budget IS NOT NULL
    BEGIN
        INSERT INTO BUDGET (project_id, allocated_amount, spent_amount, budget_category, last_updated)
        VALUES (@project_id, @allocated_budget, 0, @budget_category, GETDATE());
    END
END;
GO

-- 2 Update Project Status
CREATE PROCEDURE sp_UpdateProjectStatus
    @ProjectID INT,
    @Status NVARCHAR(20)
AS
BEGIN
    UPDATE PROJECT
    SET status = @Status
    WHERE project_id = @ProjectID;
END;
GO

-- 3 Delete Project
CREATE PROCEDURE sp_DeleteProject
    @ProjectID INT
AS
BEGIN
    DELETE FROM TASK WHERE phase_id IN (SELECT phase_id FROM PROJECT_PHASE WHERE project_id = @ProjectID);
    DELETE FROM PROJECT_PHASE WHERE project_id = @ProjectID;
    DELETE FROM MILESTONE WHERE project_id = @ProjectID;
    DELETE FROM PROJECT_TEAM WHERE project_id = @ProjectID;
    DELETE FROM BUDGET WHERE project_id = @ProjectID;
    DELETE FROM PROJECT_CONTRACTOR WHERE project_id = @ProjectID;
    DELETE FROM PROJECT WHERE project_id = @ProjectID;
END;
GO

-- 4 Add Task
CREATE PROCEDURE sp_AddTask
    @PhaseID INT,
    @AssignedTo INT,
    @Description NVARCHAR(MAX),
    @DisciplineID INT,
    @StartDate DATE,
    @EndDate DATE,
    @Status NVARCHAR(20),
    @CompletionPercentage DECIMAL(5,2) = 0,
    @Priority NVARCHAR(20)
AS
BEGIN
    INSERT INTO TASK (phase_id, assigned_to, description, discipline_id, start_date, end_date, status, completion_percentage, priority)
    VALUES (@PhaseID, @AssignedTo, @Description, @DisciplineID, @StartDate, @EndDate, @Status, @CompletionPercentage, @Priority);
END;
GO

-- 5 Update Task Status
CREATE PROCEDURE sp_UpdateTaskStatus
    @TaskID INT,
    @Status NVARCHAR(20),
    @CompletionPercentage DECIMAL(5,2) = NULL,
    @AssignedTo INT = NULL
AS
BEGIN
    UPDATE TASK
    SET status = @Status,
        completion_percentage = COALESCE(@CompletionPercentage, completion_percentage),
        assigned_to = COALESCE(@AssignedTo, assigned_to)
    WHERE task_id = @TaskID;
END;
GO

-- 6 Add Employee
CREATE PROCEDURE sp_AddEmployee
    @Name NVARCHAR(100),
    @Email NVARCHAR(100),
    @Phone NVARCHAR(20),
    @DisciplineID INT,
    @DepartmentID INT,
    @HireDate DATE,
    @Status NVARCHAR(20)
AS
BEGIN
    INSERT INTO EMPLOYEE (name, email, phone, discipline_id, department_id, hire_date, status)
    VALUES (@Name, @Email, @Phone, @DisciplineID, @DepartmentID, @HireDate, @Status);
END;
GO

-- 7 Assign Employee to Project
CREATE PROCEDURE sp_AssignEmployeeToProject
    @ProjectID INT,
    @EmployeeID INT,
    @RoleID INT,
    @StartDate DATE,
    @EndDate DATE = NULL
AS
BEGIN
    INSERT INTO PROJECT_TEAM (project_id, employee_id, role_id, start_date, end_date)
    VALUES (@ProjectID, @EmployeeID, @RoleID, @StartDate, @EndDate);
END;
GO

-- 8 Assign Contractor to Project
CREATE PROCEDURE sp_AssignContractorToProject
    @ProjectID INT,
    @ContractorID INT,
    @ContractValue DECIMAL(18,2),
    @StartDate DATE,
    @EndDate DATE,
    @ScopeOfWork NVARCHAR(MAX)
AS
BEGIN
    INSERT INTO PROJECT_CONTRACTOR (project_id, contractor_id, contract_value, start_date, end_date, scope_of_work)
    VALUES (@ProjectID, @ContractorID, @ContractValue, @StartDate, @EndDate, @ScopeOfWork);
END;
GO

-- 9 Add Material
CREATE PROCEDURE sp_AddMaterial
    @Name NVARCHAR(100),
    @Description NVARCHAR(MAX),
    @Unit NVARCHAR(20),
    @UnitCost DECIMAL(18,2),
    @SupplierID INT,
    @StockQuantity DECIMAL(18,2)
AS
BEGIN
    INSERT INTO MATERIAL (name, description, unit, unit_cost, supplier_id, stock_quantity)
    VALUES (@Name, @Description, @Unit, @UnitCost, @SupplierID, @StockQuantity);
END;
GO

-- 10 Update Budget
CREATE PROCEDURE sp_UpdateBudget
    @BudgetID INT,
    @AllocatedAmount DECIMAL(18,2) = NULL,
    @SpentAmount DECIMAL(18,2) = NULL
AS
BEGIN
    UPDATE BUDGET
    SET allocated_amount = COALESCE(@AllocatedAmount, allocated_amount),
        spent_amount = COALESCE(@SpentAmount, spent_amount),
        last_updated = GETDATE()
    WHERE budget_id = @BudgetID;
END;
GO

-- 11 Add Milestone
CREATE PROCEDURE sp_AddMilestone
    @ProjectID INT,
    @Name NVARCHAR(100),
    @Description NVARCHAR(MAX),
    @DueDate DATE,
    @Status NVARCHAR(20),
    @ResponsibleEmployeeID INT = NULL
AS
BEGIN
    INSERT INTO MILESTONE (project_id, name, description, due_date, status, responsible_employee_id)
    VALUES (@ProjectID, @Name, @Description, @DueDate, @Status, @ResponsibleEmployeeID);
END;
GO

-- 12 Add Safety Inspection
CREATE PROCEDURE sp_AddSafetyInspection
    @ProjectID INT,
    @InspectionDate DATE,
    @InspectorID INT,
    @Type NVARCHAR(50),
    @Status NVARCHAR(20),
    @Description NVARCHAR(MAX),
    @CorrectiveAction NVARCHAR(MAX) = NULL,
    @CompletionDate DATE = NULL
AS
BEGIN
    INSERT INTO SAFETY_COMPLIANCE (project_id, inspection_date, inspector_id, type, status, description, corrective_action, completion_date)
    VALUES (@ProjectID, @InspectionDate, @InspectorID, @Type, @Status, @Description, @CorrectiveAction, @CompletionDate);
END;
GO

-- 13 Update Budget
CREATE PROCEDURE sp_UpdateBudgetaddtospentamount
    @BudgetID INT,
    @SpentAmount DECIMAL(18,2) = NULL
AS
BEGIN
    UPDATE BUDGET
    SET spent_amount = spent_amount + COALESCE(@SpentAmount, spent_amount),
        last_updated = GETDATE()
    WHERE budget_id = @BudgetID;
END;
GO

-- 14 add a client

CREATE PROCEDURE sp_AddClient
    @Name VARCHAR(100), @CompanyName VARCHAR(150), @Email VARCHAR(100), @Phone VARCHAR(50) = NULL,
    @Address VARCHAR(255) = NULL, @ContactPerson VARCHAR(100) = NULL
AS
BEGIN
    INSERT INTO CLIENT (name, company_name, email, phone, address, contact_person)
    VALUES ( @Name, @CompanyName, @Email, @Phone, @Address, @ContactPerson);
END;
GO