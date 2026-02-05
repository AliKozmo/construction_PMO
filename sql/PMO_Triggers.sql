USE PMO_DB;
GO

-- 1 Auto-complete Phase if all tasks completed
CREATE TRIGGER trg_UpdatePhaseStatus
ON TASK
AFTER UPDATE
AS
BEGIN
    UPDATE ph
    SET status = 'Completed'
    FROM PROJECT_PHASE ph
    WHERE ph.phase_id IN (
        SELECT t.phase_id
        FROM TASK t
        GROUP BY t.phase_id
        HAVING SUM(CASE WHEN t.status <> 'Completed' THEN 1 ELSE 0 END) = 0
    );
END;
GO

-- 2 Auto-complete Project if all phases completed
CREATE TRIGGER trg_UpdateProjectStatus
ON PROJECT_PHASE
AFTER UPDATE
AS
BEGIN
    UPDATE p
    SET status = 'Completed'
    FROM PROJECT p
    WHERE p.project_id IN (
        SELECT ph.project_id
        FROM PROJECT_PHASE ph
        GROUP BY ph.project_id
        HAVING SUM(CASE WHEN ph.status <> 'Completed' THEN 1 ELSE 0 END) = 0
    );
END;
GO

-- 3 Alert on Budget Overrun
CREATE TRIGGER trg_BudgetOverrun
ON BUDGET
AFTER UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM INSERTED i
        WHERE i.spent_amount > i.allocated_amount
    )
    BEGIN
        PRINT 'Warning: Budget exceeded for project!';
    END
END;
GO

-- 4 Update Equipment Status After Maintenance
CREATE TRIGGER trg_EquipmentMaintenance
ON MAINTENANCE_SCHEDULE
AFTER UPDATE
AS
BEGIN
    UPDATE eq
    SET eq.status = CASE WHEN ms.status = 'Completed' THEN 'Available' ELSE eq.status END
    FROM EQUIPMENT eq
    JOIN INSERTED ms ON ms.equipment_id = eq.equipment_id;
END;
GO

-- 4 inactive employye:
CREATE TRIGGER TR_TASK_ASSIGN_ACTIVE_EMPLOYEE
ON TASK
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN EMPLOYEE e ON i.assigned_to = e.employee_id
        WHERE e.status <> 'Active'
    )
    BEGIN
        RAISERROR ('Cannot assign task to inactive or suspended employee.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- rental dates

CREATE TRIGGER TR_EQUIPMENT_RENTAL_VALIDATION
ON EQUIPMENT
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE is_rented = 1
          AND (rental_start_date IS NULL)
    )
    BEGIN
        RAISERROR ('Rental equipment must have a rental start date.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO