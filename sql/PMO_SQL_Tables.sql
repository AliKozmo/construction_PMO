-- =========================
-- DROP & CREATE DATABASE
-- =========================
USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'PMO_DB')
BEGIN
    ALTER DATABASE PMO_DB
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE PMO_DB;
END
GO

CREATE DATABASE PMO_DB;
GO

USE PMO_DB;
GO

-- =========================
-- MASTER TABLES
-- =========================

CREATE TABLE CLIENT (
    client_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    name VARCHAR(100) NOT NULL,
    company_name VARCHAR(150) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(50) NULL,
    address VARCHAR(255) NULL,
    contact_person VARCHAR(100) NULL
);
GO

CREATE TABLE DEPARTMENT (
    department_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255) NULL,
    manager_id INT NULL
);
GO

CREATE TABLE DISCIPLINE (
    discipline_id INT IDENTITY(1,1) PRIMARY KEY,
    discipline_name VARCHAR(100) NOT NULL UNIQUE
);
GO

CREATE TABLE ROLE (
    role_id INT IDENTITY(1,1) PRIMARY KEY,
    role_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE EMPLOYEE (
    employee_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(50) NULL,
    discipline_id INT NOT NULL,
    department_id INT NOT NULL,
    hire_date DATE NOT NULL,
    status VARCHAR(50) NOT NULL,
    CONSTRAINT FK_EMPLOYEE_DEPARTMENT
        FOREIGN KEY (department_id) REFERENCES DEPARTMENT(department_id),
    CONSTRAINT CK_EMPLOYEE_STATUS
        CHECK (status IN ('Active','Inactive','Suspended')),
    CONSTRAINT FK_EMPLOYEE_DISCIPLINE
        FOREIGN KEY (discipline_id) REFERENCES DISCIPLINE(discipline_id)
);
GO

ALTER TABLE DEPARTMENT
ADD CONSTRAINT FK_DEPARTMENT_MANAGER
FOREIGN KEY (manager_id) REFERENCES EMPLOYEE(employee_id);
GO

-- =========================
-- PROJECT STRUCTURE
-- =========================

CREATE TABLE PROJECT (
    project_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    project_code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(150) NOT NULL,
    client_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NULL,
    status VARCHAR(50) NOT NULL,
    location VARCHAR(150) NULL,
    description VARCHAR(255) NULL,
    embedding VARBINARY(MAX) NULL,
    CONSTRAINT FK_PROJECT_CLIENT
        FOREIGN KEY (client_id) REFERENCES CLIENT(client_id)
);
GO

CREATE TABLE PROJECT_PHASE (
    phase_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    project_id INT NOT NULL,
    phase_name VARCHAR(100) NOT NULL,
    discipline_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NULL,
    status VARCHAR(50) NOT NULL,
    CONSTRAINT FK_PHASE_PROJECT
        FOREIGN KEY (project_id) REFERENCES PROJECT(project_id),
    CONSTRAINT FK_PHASE_DISCIPLINE
        FOREIGN KEY (discipline_id) REFERENCES DISCIPLINE(discipline_id) 
);
GO

CREATE TABLE TASK (
    task_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    phase_id INT NOT NULL,
    assigned_to INT NULL,
    description VARCHAR(255) NOT NULL,
    discipline_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NULL,
    status VARCHAR(50) NOT NULL,
    completion_percentage DECIMAL(5,2) NULL,
    priority VARCHAR(50) NULL,
    embedding VARBINARY(MAX) NULL,
    CONSTRAINT FK_TASK_PHASE
        FOREIGN KEY (phase_id) REFERENCES PROJECT_PHASE(phase_id),
    CONSTRAINT FK_TASK_EMPLOYEE
        FOREIGN KEY (assigned_to) REFERENCES EMPLOYEE(employee_id),
    CONSTRAINT FK_TASK_DISCIPLINE
        FOREIGN KEY (discipline_id) REFERENCES DISCIPLINE(discipline_id)
);
GO

-- =========================
-- CONTRACTORS & SUPPLIERS
-- =========================

CREATE TABLE CONTRACTOR (
    contractor_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    company_name VARCHAR(150) NOT NULL,
    license_no VARCHAR(100) NULL,
    contact_name VARCHAR(100) NOT NULL,
    contact_email VARCHAR(100) NULL,
    contact_phone VARCHAR(50) NULL,
    rating DECIMAL(3,2) NULL,
    CONSTRAINT CK_CONTRACTOR_RATING CHECK (rating IS NULL OR rating BETWEEN 0 AND 5)
);
GO

CREATE TABLE PROJECT_CONTRACTOR (
    project_id INT NOT NULL,
    contractor_id INT NOT NULL,
    contract_value DECIMAL(15,2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NULL,
    scope_of_work VARCHAR(255) NULL,
    CONSTRAINT PK_PROJECT_CONTRACTOR PRIMARY KEY (project_id, contractor_id),
    CONSTRAINT FK_PC_PROJECT
        FOREIGN KEY (project_id) REFERENCES PROJECT(project_id),
    CONSTRAINT FK_PC_CONTRACTOR
        FOREIGN KEY (contractor_id) REFERENCES CONTRACTOR(contractor_id)
);
GO

CREATE TABLE SUPPLIER (
    supplier_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    company_name VARCHAR(150) NOT NULL,
    contact_name VARCHAR(100) NOT NULL,
    contact_email VARCHAR(100) NULL,
    contact_phone VARCHAR(50) NULL,
    rating DECIMAL(3,2) NULL,
    address VARCHAR(255) NULL,
    CONSTRAINT CK_SUPPLIER_RATING CHECK (rating IS NULL OR rating BETWEEN 0 AND 5)
);
GO

CREATE TABLE MATERIAL (
    material_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255) NULL,
    unit VARCHAR(50) NOT NULL,
    unit_cost DECIMAL(15,2) NOT NULL,
    supplier_id INT NOT NULL,
    stock_quantity DECIMAL(15,2) NULL,
    CONSTRAINT FK_MATERIAL_SUPPLIER
        FOREIGN KEY (supplier_id) REFERENCES SUPPLIER(supplier_id)
);
GO

-- =========================
-- FINANCIALS
-- =========================

CREATE TABLE BUDGET (
    budget_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    project_id INT NOT NULL,
    allocated_amount DECIMAL(15,2) NOT NULL,
    spent_amount DECIMAL(15,2) NOT NULL,
    budget_category VARCHAR(100) NULL,
    last_updated DATE NOT NULL,
    CONSTRAINT FK_BUDGET_PROJECT
        FOREIGN KEY (project_id) REFERENCES PROJECT(project_id)
);
GO

-- =========================
-- TEAM & PROGRESS
-- =========================

CREATE TABLE PROJECT_TEAM (
    project_team_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    project_id INT NOT NULL,
    employee_id INT NOT NULL,
    role_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NULL,
    CONSTRAINT FK_PT_PROJECT
        FOREIGN KEY (project_id) REFERENCES PROJECT(project_id),
    CONSTRAINT FK_PT_EMPLOYEE
        FOREIGN KEY (employee_id) REFERENCES EMPLOYEE(employee_id),
    CONSTRAINT FK_PT_ROLE
        FOREIGN KEY (role_id) REFERENCES ROLE(role_id)
);
GO

-- =========================
-- RISK, DOCUMENTS, MILESTONES
-- =========================

CREATE TABLE MILESTONE (
    milestone_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    project_id INT NOT NULL,
    name VARCHAR(150) NOT NULL,
    description VARCHAR(255) NULL,
    due_date DATE NOT NULL,
    status VARCHAR(50) NOT NULL,
    achieved_date DATE NULL,
    responsible_employee_id INT NULL,
    embedding VARBINARY(MAX) NULL,
    CONSTRAINT FK_MILESTONE_PROJECT
        FOREIGN KEY (project_id) REFERENCES PROJECT(project_id),
    CONSTRAINT FK_MILESTONE_EMPLOYEE
        FOREIGN KEY (responsible_employee_id) REFERENCES EMPLOYEE(employee_id)
);
GO

-- =========================
-- EQUIPMENT
-- =========================

CREATE TABLE EQUIPMENT (
    equipment_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(100) NOT NULL,
    project_id INT NOT NULL,
    location VARCHAR(100) NULL,
    status VARCHAR(50) NOT NULL,
    purchase_date DATE NULL,
    vendor_id INT NULL,
    cost DECIMAL(15,2) NULL,
    is_rented BIT NOT NULL DEFAULT 0,
    rental_start_date DATE NULL,
    rental_end_date DATE NULL,
    CONSTRAINT FK_EQUIPMENT_PROJECT
        FOREIGN KEY (project_id) REFERENCES PROJECT(project_id),
    CONSTRAINT CK_EQUIPMENT_STATUS
        CHECK (status IN ('Available','In Use','Maintenance','Retired')),
    CONSTRAINT CK_EQUIPMENT_RENTAL_DATES
        CHECK (rental_end_date IS NULL OR rental_start_date IS NOT NULL AND rental_end_date >= rental_start_date)
);
GO

CREATE TABLE MAINTENANCE_SCHEDULE (
    schedule_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    equipment_id INT NOT NULL,
    maintenance_type VARCHAR(100) NOT NULL,
    scheduled_date DATE NOT NULL,
    performed_by INT NOT NULL,
    status VARCHAR(50) NOT NULL,
    remarks VARCHAR(255) NULL,
    CONSTRAINT FK_MS_EQUIPMENT
        FOREIGN KEY (equipment_id) REFERENCES EQUIPMENT(equipment_id),
    CONSTRAINT FK_MS_EMPLOYEE
        FOREIGN KEY (performed_by) REFERENCES EMPLOYEE(employee_id)
);
GO

CREATE TABLE SAFETY_COMPLIANCE (
    safety_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    project_id INT NOT NULL,
    inspection_date DATE NOT NULL,
    inspector_id INT NOT NULL,
    type VARCHAR(100) NOT NULL,
    status VARCHAR(50) NOT NULL,
    description VARCHAR(255) NULL,
    corrective_action VARCHAR(255) NULL,
    completion_date DATE NULL,
    CONSTRAINT FK_SAFETY_PROJECT
        FOREIGN KEY (project_id) REFERENCES PROJECT(project_id),
    CONSTRAINT FK_SAFETY_EMPLOYEE
        FOREIGN KEY (inspector_id) REFERENCES EMPLOYEE(employee_id)
);
GO

-- =========================
-- SITE EMPLOYEE (Inheritance)
-- =========================

CREATE TABLE SITE_EMPLOYEE (
    employee_id INT PRIMARY KEY NOT NULL,
    company VARCHAR(150) NOT NULL,
    site_id VARCHAR(100) NOT NULL,
    date_of_end_of_contract DATE NULL,
    CONSTRAINT FK_SITE_EMPLOYEE_EMPLOYEE
        FOREIGN KEY (employee_id) REFERENCES EMPLOYEE(employee_id)
        ON DELETE CASCADE,
    CONSTRAINT CK_SITE_EMPLOYEE_CONTRACT_DATE
        CHECK (date_of_end_of_contract IS NULL OR date_of_end_of_contract >= GETDATE())
);
GO
