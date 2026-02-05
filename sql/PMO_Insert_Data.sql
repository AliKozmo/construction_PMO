USE PMO_DB;
GO

-- =========================
-- 1 DISCIPLINE
-- =========================
INSERT INTO DISCIPLINE (discipline_name)
VALUES
('Project Management'),      -- id = 1
('Civil Engineering'),       -- id = 2
('Electrical Engineering'),  -- id = 3
('Architecture');            -- id = 4
GO

-- =========================
-- 2 ROLE
-- =========================
INSERT INTO ROLE (role_name)
VALUES
('Project Manager'),   -- id = 1
('Engineer'),          -- id = 2
('Site Supervisor'),   -- id = 3
('Architect');         -- id = 4
GO

-- =========================
-- 3 DEPARTMENT
-- =========================
INSERT INTO DEPARTMENT (name, description, manager_id)
VALUES
('Project Management', 'Handles project planning and execution', NULL),
('Engineering', 'Technical design and supervision', NULL);
GO

-- =========================
-- 4 EMPLOYEE (Expanded)
-- =========================
INSERT INTO EMPLOYEE (name, email, phone, discipline_id, department_id, hire_date, status)
VALUES
('John Doe', 'john.doe@example.com', '555-3030', 1, 1, '2023-01-10', 'Active'),
('Jane Roe', 'jane.roe@example.com', '555-4040', 2, 2, '2021-06-15', 'Active'),
('Mike Brown', 'mike.brown@example.com', '555-5050', 2, 2, '2023-03-20', 'Active'),
('Robert King', 'robert.king@example.com', '555-1111', 2, 2, '2020-02-01', 'Active'),
('Linda White', 'linda.white@example.com', '555-2222', 4, 2, '2021-03-05', 'Active'),
('Sam Turner', 'sam.turner@example.com', '555-3333', 3, 2, '2021-05-10', 'Active'),
('Nina Brooks', 'nina.brooks@example.com', '555-4444', 1, 1, '2019-11-12', 'Active');
GO

-- =========================
-- 5 Update DEPARTMENT managers
-- =========================
UPDATE DEPARTMENT SET manager_id = 1 WHERE department_id = 1;
UPDATE DEPARTMENT SET manager_id = 2 WHERE department_id = 2;
GO

-- =========================
-- 6 CLIENT
-- =========================
INSERT INTO CLIENT (name, company_name, email, phone, address, contact_person)
VALUES
('Alice Johnson', 'Johnson Constructions', 'alice.johnson@example.com', '555-1010', '123 Main St, CityA', 'Bob Johnson'),
('Mark Smith', 'Smith Builders', 'mark.smith@example.com', '555-2020', '456 Oak Ave, CityB', 'Susan Smith');
GO

-- =========================
-- 7 PROJECT (Expanded)
-- =========================
INSERT INTO PROJECT (project_code, name, client_id, start_date, end_date, status, location, description)
VALUES
('PRJ001', 'CityA Office Building', 1, '2025-01-01', '2026-12-31', 'Active', 'CityA Downtown', 'Office building construction in CityA'),
('PRJ002', 'CityB Shopping Mall', 2, '2025-03-15', '2026-06-30', 'Active', 'CityB Central', 'New shopping mall project in CityB'),
('PRJ003', 'CityC Residential Complex', 1, '2025-02-01', '2026-10-31', 'Active', 'CityC West', 'Residential apartments construction'),
('PRJ004', 'CityD Hospital', 2, '2025-05-01', '2026-12-31', 'Active', 'CityD Central', 'Hospital construction project'),
('PRJ005', 'CityE Data Center', 1, '2025-08-01', '2026-12-31', 'Active', 'CityE Industrial Park', 'Electrical & IT infrastructure for data center');
GO

-- =========================
-- 8 PROJECT_PHASE (Expanded)
-- =========================
INSERT INTO PROJECT_PHASE (project_id, phase_name, discipline_id, start_date, end_date, status)
VALUES
-- PRJ001
(1, 'Design', 4, '2025-01-01', '2025-03-31', 'Completed'),
(1, 'Construction', 2, '2025-04-01', '2026-12-31', 'Active'),
-- PRJ002
(2, 'Design', 4, '2025-03-15', '2025-06-30', 'Completed'),
(2, 'Construction', 2, '2025-07-01', '2026-06-30', 'Active'),
-- PRJ003
(3, 'Design', 2, '2025-02-01', '2025-05-31', 'Completed'),
(3, 'Construction', 2, '2025-06-01', '2026-10-31', 'Active'),
-- PRJ004
(4, 'Design', 4, '2025-05-01', '2025-08-31', 'Completed'),
(4, 'Construction', 2, '2025-09-01', '2026-12-31', 'Active'),
-- PRJ005
(5, 'Electrical Design', 3, '2025-08-01', '2025-12-31', 'Completed'),
(5, 'Installation', 3, '2026-01-01', '2026-12-31', 'Active');
GO

-- =========================
-- 9 TASKS (Expanded, 20+ realistic)
-- =========================
INSERT INTO TASK (phase_id, assigned_to, description, discipline_id, start_date, end_date, status, completion_percentage, priority)
VALUES
-- PRJ001
(1, 5, 'Architectural planning for office', 4, '2025-01-05', '2025-03-15', 'Completed', 100, 'High'),
(2, 2, 'Excavation & foundation work', 2, '2025-04-05', '2026-06-15', 'Active', 40, 'High'),
(2, 4, 'Structural steel installation', 2, '2025-06-20', '2026-10-30', 'Active', 25, 'High'),
-- PRJ002
(3, 5, 'Mall design and layout', 4, '2025-03-20', '2025-06-20', 'Completed', 100, 'High'),
(4, 3, 'Foundation & slab construction', 2, '2025-07-05', '2026-09-15', 'Active', 30, 'High'),
(4, 3, 'Electrical wiring main hall', 3, '2025-09-20', '2026-03-30', 'Active', 20, 'Medium'),
-- PRJ003
(5, 2, 'Apartment floor plans', 2, '2025-02-05', '2025-05-10', 'Completed', 100, 'High'),
(6, 4, 'Wall construction & masonry', 2, '2025-06-05', '2026-07-15', 'Active', 50, 'High'),
-- PRJ004
(7, 5, 'Hospital architecture layout', 4, '2025-05-05', '2025-08-20', 'Completed', 100, 'High'),
(8, 2, 'Foundation and structural work', 2, '2025-09-05', '2026-12-15', 'Active', 35, 'High'),
-- PRJ005
(9, 6, 'Electrical system schematic', 3, '2025-08-05', '2025-12-20', 'Completed', 100, 'High'),
(10, 6, 'Installation of panels & wiring', 3, '2026-01-10', '2026-12-15', 'Active', 20, 'High');
GO

-- =========================
-- 10 CONTRACTORS (Expanded)
-- =========================
INSERT INTO CONTRACTOR (company_name, license_no, contact_name, contact_email, contact_phone, rating)
VALUES
('BuildRight LLC', 'LIC123', 'Tom Wilson', 'tom.wilson@buildright.com', '555-6060', 4.5),
('MegaConstruct', 'LIC456', 'Sara Lee', 'sara.lee@megaconstruct.com', '555-7070', 4.2),
('BuildWell Inc', 'LIC321', 'Carol Young', 'carol.young@buildwell.com', '555-1212', 4.6),
('PowerElectro', 'LIC654', 'Daniel Reed', 'daniel.reed@powerelectro.com', '555-1313', 4.8);
GO

-- =========================
-- 11 PROJECT_CONTRACTOR
-- =========================
INSERT INTO PROJECT_CONTRACTOR (project_id, contractor_id, contract_value, start_date, end_date, scope_of_work)
VALUES
(1, 1, 3000000, '2025-04-01', '2026-12-31', 'Structural work and construction'),
(2, 2, 8000000, '2025-07-01', '2026-06-30', 'Full construction services'),
(3, 3, 5000000, '2025-06-01', '2026-10-31', 'Residential construction'),
(4, 3, 7000000, '2025-09-01', '2026-12-31', 'Full hospital construction'),
(5, 4, 2000000, '2026-01-01', '2026-12-31', 'Electrical & IT installation');
GO

-- =========================
-- 12 SUPPLIER (Expanded)
-- =========================
INSERT INTO SUPPLIER (company_name, contact_name, contact_email, contact_phone, rating, address)
VALUES
('SteelPro Supplies', 'Alice Green', 'alice.green@steelpro.com', '555-8080', 4.8, '789 Industrial Rd, CityA'),
('Concrete Solutions', 'Bob White', 'bob.white@concrete.com', '555-9090', 4.6, '321 Cement St, CityB'),
('BrickCo', 'Henry Adams', 'henry.adams@brickco.com', '555-1414', 4.7, '12 Brick Lane, CityC'),
('CablePro', 'Laura Kent', 'laura.kent@cablepro.com', '555-1515', 4.9, '45 Wire Rd, CityE');
GO

-- =========================
-- 13 MATERIAL (Expanded)
-- =========================
INSERT INTO MATERIAL (name, description, unit, unit_cost, supplier_id, stock_quantity)
VALUES
('Cement', 'Portland cement', 'bags', 5.50, 2, 1000),
('Steel Rebars', 'High-strength steel', 'tons', 750, 1, 50),
('Bricks', 'Red clay bricks', 'pieces', 0.50, 3, 50000),
('High-Speed Data Cables', 'Fiber optic cables', 'meters', 8, 4, 10000);
GO

-- =========================
-- 14 BUDGET (Expanded)
-- =========================
INSERT INTO BUDGET (project_id, allocated_amount, spent_amount, budget_category, last_updated)
VALUES
(1, 5000000, 1200000, 'Construction', GETDATE()),
(2, 12000000, 2500000, 'Construction', GETDATE()),
(3, 8000000, 3000000, 'Construction', GETDATE()),
(4, 9000000, 3500000, 'Construction', GETDATE()),
(5, 3000000, 1200000, 'Electrical & IT', GETDATE());
GO

-- =========================
-- 15 PROJECT_TEAM (Expanded)
-- =========================
INSERT INTO PROJECT_TEAM (project_id, employee_id, role_id, start_date, end_date)
VALUES
(1, 1, 1, '2025-01-01', NULL),
(1, 5, 4, '2025-01-05', NULL),
(2, 2, 2, '2025-03-20', NULL),
(2, 3, 3, '2025-03-25', NULL),
(3, 2, 2, '2025-02-01', NULL),
(3, 4, 3, '2025-02-10', NULL),
(4, 1, 1, '2025-05-01', NULL),
(4, 5, 4, '2025-05-01', NULL),
(5, 6, 2, '2025-08-01', NULL),
(5, 4, 2, '2025-08-01', NULL);
GO

-- =========================
-- 16 MILESTONES (Expanded)
-- =========================
INSERT INTO MILESTONE (project_id, name, description, due_date, status, achieved_date, responsible_employee_id)
VALUES
(1, 'Foundation Complete', 'Completion of foundation phase', '2025-06-15', 'Completed', '2025-06-15', 2),
(1, 'Structural Steel Complete', 'Structure finished', '2026-10-30', 'Active', NULL, 4),
(2, 'Mall Ground Floor Ready', 'Ground floor completed', '2026-09-15', 'Active', NULL, 3),
(3, 'Residential Blocks Ready', 'Blocks A & B completed', '2026-07-15', 'Active', NULL, 2),
(4, 'Hospital Structural Complete', 'Hospital structure fully built', '2026-10-15', 'Active', NULL, 1),
(5, 'Electrical System Test', 'All electrical systems fully tested', '2026-12-15', 'Active', NULL, 6);
GO

-- =========================
-- 17 EQUIPMENT (Expanded)
-- =========================
INSERT INTO EQUIPMENT (name, type, project_id, location, status, purchase_date, vendor_id, cost, is_rented)
VALUES
('Excavator', 'Heavy', 1, 'Site A', 'Available', '2025-02-01', NULL, 150000, 0),
('Concrete Mixer', 'Medium', 2, 'Site B', 'In Use', '2025-03-15', NULL, 25000, 1),
('Crane', 'Heavy', 3, 'Site C', 'Available', '2025-04-01', NULL, 200000, 0),
('Electric Drill', 'Medium', 5, 'Site E', 'Available', '2025-08-01', NULL, 2000, 0),
('Welding Machine', 'Medium', 1, 'Site A', 'Available', '2025-05-01', NULL, 5000, 0);
GO

-- =========================
-- 18 MAINTENANCE_SCHEDULE (Expanded)
-- =========================
INSERT INTO MAINTENANCE_SCHEDULE (equipment_id, maintenance_type, scheduled_date, performed_by, status, remarks)
VALUES
(1, 'Engine Check', '2025-06-15', 2, 'Completed', 'All good'),
(2, 'Mixer Cleaning', '2025-08-05', 3, 'Completed', NULL),
(3, 'Crane Inspection', '2025-09-10', 4, 'Completed', 'Safe to operate'),
(4, 'Drill Calibration', '2025-10-05', 6, 'Completed', 'Calibrated successfully'),
(5, 'Welding Machine Check', '2025-07-20', 2, 'Completed', 'No defects found');
GO

-- =========================
-- 19 SAFETY_COMPLIANCE (Expanded)
-- =========================
INSERT INTO SAFETY_COMPLIANCE (project_id, inspection_date, inspector_id, type, status, description, corrective_action, completion_date)
VALUES
(1, '2025-05-20', 2, 'Fire Safety', 'Completed', 'Fire extinguishers checked', NULL, '2025-05-21'),
(2, '2025-07-15', 3, 'Site Safety', 'Completed', 'Protective gear compliance', 'Ensure all workers wear helmets', '2025-07-20'),
(5, '2026-01-30', 6, 'Electrical Safety', 'Active', 'All wiring verified', 'Replaced faulty breakers', NULL);
GO

-- =========================
-- 20 SITE_EMPLOYEE (Expanded)
-- =========================
INSERT INTO SITE_EMPLOYEE (employee_id, company, site_id, date_of_end_of_contract)
VALUES
(3, 'Smith Builders', 'SiteB', '2026-12-31'),
(2, 'BuildWell Inc', 'SiteC', '2027-12-31'),
(6, 'PowerElectro', 'SiteE', '2026-12-31');
GO
